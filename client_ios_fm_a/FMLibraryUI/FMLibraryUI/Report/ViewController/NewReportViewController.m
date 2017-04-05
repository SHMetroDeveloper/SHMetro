//
//  NewReportViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/7/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "NewReportViewController.h"
//协议、配置
#import "FMUtilsPackages.h"
#import "OnMessageHandleListener.h"
#import "PatrolServerConfig.h"
#import "FileUploadService.h"
#import "OnItemClickListener.h"
#import "BaseDataDbHelper.h"
#import "ReportServerConfig.h"
#import "SystemConfig.h"
#import "CameraHelper.h"
#import "PhotoShowHelper.h"
#import "IQKeyboardManager.h"
#import "PatrolServerConfig.h"
#import "ReportBaseInfoModel.h"
#import "ReportNetRequest.h"

//View
#import "ReportBaseInfoView2.h"
#import "SeperatorView.h"
#import "DeviceItemView.h"
#import "BaseTextView.h"
#import "BasePhotoView.h"
#import "InfoSelectViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"

//model



typedef NS_ENUM(NSInteger, ReportType) {
    REPORT_TYPE_COMMON,         //默认类型
    REPORT_TYPE_PATROL_EXCEPTION,      //巡检异常报障
};

typedef NS_ENUM(NSInteger, ReportSectionType) {
    REPORT_SECTION_TYPE_UNKNOW,
    REPORT_SECTION_TYPE_BASEINFO,  //基本信息
    REPORT_SECTION_TYPE_EQUIPMENT,  //故障设备
    REPORT_SECTION_TYPE_DESCRIPTION,  //报障描述
};

typedef NS_ENUM(NSInteger, DescriptionType) {
    DESCRIPTION_TYPE_TEXT = 0,   //描述信息
    DESCRIPTION_TYPE_PHOTO = 1,  //照片
    
};


@interface NewReportViewController ()<OnItemClickListener,UITableViewDelegate,UITableViewDataSource,OnMessageHandleListener,FileUploadListener,OnViewResizeListener>

@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *addDeviceBtn;
@property (nonatomic, strong) ReportBaseInfoView2 *baseInfoView;
@property (nonatomic, strong) BaseTextView *descTXView;
@property (nonatomic, strong) BasePhotoView *photoView;

@property (readwrite, nonatomic, strong) CameraHelper *cameraHelper;
@property (readwrite, nonatomic, strong) PhotoShowHelper *photoHelper;

@property (nonatomic, strong) NSMutableArray *selectedPhotos; //用于保存照片
@property (nonatomic, strong) NSMutableArray *devices;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong) NSNumber *curDeviceIndex;

//参数
@property (readwrite, nonatomic, assign) ReportType reportType;
@property (readwrite, nonatomic, strong) NSNumber *reportId;
@property (readwrite, nonatomic, strong) Report *report;
@property (readwrite, nonatomic, strong) Org *org;
@property (readwrite, nonatomic, strong) ServiceType *stype;
@property (readwrite, nonatomic, strong) Position *position;
@property (readwrite, nonatomic, strong) Priority *priority;
@property (readwrite, nonatomic, strong) NSNumber *flowId;
@property (readwrite, nonatomic, strong) NSMutableArray *imgIds;   //图片上传之后的ID数组
@property (readwrite, nonatomic, strong) NSMutableArray *imgOnlineIds;   //线上图片的ID数组，用来存储从巡检和需求传递过来的图片信息
@property (readwrite, nonatomic, assign) BOOL isUploading;
@property (readwrite, nonatomic, strong) BaseDataDbHelper *dbHelper;
@property (readwrite, nonatomic, strong) ReportBaseInfoModel *baseInfoModel;



@end

@implementation NewReportViewController

- (instancetype) init {
    self = [super init];
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];
    [self initUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_report" inTable:nil]];
    [self setBackAble:YES];
    NSArray * menuTextArray = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"function_report_uploaded" inTable:nil], nil];
    [self setMenuWithArray:menuTextArray];
}

- (void) initUserInfo {
    if(!_report) {
        _report = [[Report alloc] init];
    }
    if (!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    if(!_devices) {
        _devices = [[NSMutableArray alloc] init];
    }
    if (!_position) {
        _position = [_dbHelper getDefaultPosition];
    }
    if (!_baseInfoModel) {
        _baseInfoModel = [[ReportBaseInfoModel alloc] init];
    }
    if([FMUtils isStringEmpty:_report.name]) {
        NSInteger userId = [[SystemConfig getOauthFM] getUserInfo].userId;
        NSString * userName;
        UserInfo * user = [_dbHelper queryUserById:[NSNumber numberWithInteger:userId]];
        
        if(user) {
            userName = user.name;
            if([FMUtils isStringEmpty:userName]) {
                userName = user.loginName;
            }
            if(!userName) {
                userName = @"";
            }
            _baseInfoModel.name = [userName copy];
            _baseInfoModel.phone = user.phone;
            _baseInfoModel.location = [_dbHelper getLocationBy:_position];
            _baseInfoModel.orderType =  _report.orderType;
        }
    } else {
        _baseInfoModel.name = _report.name;
        _baseInfoModel.phone = _report.phone;
        _baseInfoModel.location = [_dbHelper getLocationBy:_position];
        _baseInfoModel.orderType = _report.orderType;
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = YES;
        manager.shouldResignOnTouchOutside = YES;
        manager.shouldToolbarUsesTextFieldTintColor = YES;
        manager.enableAutoToolbar = YES;
        manager.shouldShowTextFieldPlaceholder = NO;
        
        
        _footerHeight = 20;
        _headerHeight = [FMSize getInstance].selectHeaderHeight;
        
        
        //容器
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        //tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        //添加按钮
        CGFloat btnWidth = [FMSize getInstance].filterWidth;
        CGFloat padding = [FMSize getInstance].defaultPadding;
        _addDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-btnWidth-padding, _realHeight-btnWidth-padding, btnWidth, btnWidth)];
        [_addDeviceBtn addTarget:self action:@selector(onDeviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addDeviceBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_normal"] forState:UIControlStateNormal];
        [_addDeviceBtn setBackgroundImage:[[FMTheme getInstance] getImageByName:@"add_highlight"] forState:UIControlStateHighlighted];
        _addDeviceBtn.layer.cornerRadius = btnWidth/2;
        _addDeviceBtn.layer.masksToBounds = YES;
        
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_addDeviceBtn];
        
        [self.view addSubview:_mainContainerView];
    }
}


#pragma mark - Instance Method

- (void) setInforWithLocation:(Position *) location
                    equipment:(NSNumber *) equipId
                      content:(NSNumber *) contentId
                         desc:(NSString *) desc
                         imgs:(NSMutableArray *) imageIds {
    if(!_report) {
        _report = [[Report alloc] init];
    }
    
    _report.patrolItemDetailId = contentId;
    
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    if (!_devices) {
        _devices = [NSMutableArray new];
    }
    
    _report.desc = desc;
    _position = location;
    _reportType = REPORT_TYPE_PATROL_EXCEPTION;
    _report.orderType = REPORT_ORDER_TYPE_SELF_CHECK;
    
//    if(equipId && ![FMUtils isNumberNullOrZero:equipId]) {
    if(equipId) {
        Device *dev = [_dbHelper queryDeviceById:equipId];
        if(dev) {
            [_devices addObject:dev];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
    
    if(!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    } else {
        [_selectedPhotos removeAllObjects];
    }
    if(!_imgOnlineIds) {
        _imgOnlineIds = [[NSMutableArray alloc] init];
    } else {
        [_imgOnlineIds removeAllObjects];
    }
    //TODO：目前后台图片只能在一个位置使用，传过来之后巡检项就看不见图片了，所以此功能暂时屏蔽
//    if([imageIds count] > 0) {
//        NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
//        for(NSNumber * imgId in imageIds) {
//            NSString * path = [PatrolServerConfig wrapPictureUrlById:token id:imgId];
//            NSURL * url = [NSURL URLWithString:path];
//            [_selectedPhotos addObject:url];
//        }
//        [_imgOnlineIds addObjectsFromArray:imageIds];
//    }
    
}

- (void) setInfoWithRequestorId:(NSNumber *) requestorId
                           name:(NSString *) name
                          telno:(NSString *) telno
                  requirementId:(NSNumber *) reqId
                 andDescContent:(NSString *) content
                      andPhotos:(NSMutableArray *) photos {
    
    if(!_report) {
        _report = [[Report alloc] init];
    }
    
    _reportType = REPORT_TYPE_COMMON;
    
    if(!_dbHelper) {
        _dbHelper = [BaseDataDbHelper getInstance];
    }
    
    _report.userId = requestorId;
    _report.name = name;
    _report.phone = telno;
    _report.orderType = REPORT_ORDER_TYPE_MAINTENANCE;
    _reportType = REPORT_TYPE_COMMON;
    _report.reqId = reqId;
    
    _report.desc = content;
    
    //TODO:如果以后需要从需求详情那边把图片带过来的话就取消此注释
//    if(!_selectedPhotos) {
//        _selectedPhotos = [NSMutableArray new];
//    } else {
//        [_selectedPhotos removeAllObjects];
//    }
//    if (!_imgIds) {
//        _imgIds = [NSMutableArray new];
//    }
//
//    [_selectedPhotos addObjectsFromArray:photos];
//
//    for(PhotoItem * imgItem in photos) {
//        NSURL *imgUrl = [imgItem.url copy];
//        NSString *urlStr = imgUrl.absoluteString;
//        NSArray *urlStrArray = [urlStr componentsSeparatedByString:@"/"];
//        NSUInteger index = [urlStrArray indexOfObject:[NSString stringWithFormat:@"id"]];
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        NSNumber *photoId = [numberFormatter numberFromString:[urlStrArray objectAtIndex:index+1]];
//        [_imgIds addObject:photoId];
//    }
}





#pragma mark - UITableView DataSource & Delegate

- (ReportSectionType) getSectionTypeBySection:(NSInteger) section {
    ReportSectionType sectionType = REPORT_SECTION_TYPE_UNKNOW;
    if (section >= 1 && _devices.count == 0) {
        section += 1;
    }
    switch (section) {
        case 0:
            sectionType = REPORT_SECTION_TYPE_BASEINFO;
            break;
        case 1:
            sectionType = REPORT_SECTION_TYPE_EQUIPMENT;
            break;
        case 2:
            sectionType = REPORT_SECTION_TYPE_DESCRIPTION;
            break;
    }
    return sectionType;
}


- (DescriptionType) getDescriptionTypeByPosition:(NSInteger) position {
    DescriptionType descType = DESCRIPTION_TYPE_TEXT;
    switch (position) {
        case 0:
            descType = DESCRIPTION_TYPE_TEXT;
            break;
        case 1:
            descType = DESCRIPTION_TYPE_PHOTO;
            break;
    }
    return descType;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 2;
    if (_devices && _devices.count > 0) {
        count += 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case REPORT_SECTION_TYPE_BASEINFO:
            count = 1;
            break;
        case REPORT_SECTION_TYPE_EQUIPMENT:
            count = _devices.count;   //测试阶段为一个
            break;
        case REPORT_SECTION_TYPE_DESCRIPTION:
            count = 2;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    ReportSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch (sectionType) {
        case REPORT_SECTION_TYPE_BASEINFO:
            height = [ReportBaseInfoView2 calculateHeightByItemCount:7];
            break;
        case REPORT_SECTION_TYPE_EQUIPMENT:
            height = [DeviceItemView calculateHeight];
            break;
        case REPORT_SECTION_TYPE_DESCRIPTION:
            {
                switch (indexPath.row) {
                    case DESCRIPTION_TYPE_TEXT:
                        height = CGRectGetHeight(_descTXView.frame);
                        break;
                    
                    case DESCRIPTION_TYPE_PHOTO:
                        height = [BasePhotoView calculateHeightByCount:_selectedPhotos.count width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
                        break;
                }
            }
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    UILabel * titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 320, 30)];//此处数据都是根据carrie的设计稿来的
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = @"";
    titleLbl.font = [FMFont getInstance].listCodeFont;
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    [headerView addSubview:titleLbl];
    
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case REPORT_SECTION_TYPE_BASEINFO:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"report_baseInfo_header_title" inTable:nil];
            break;
        case REPORT_SECTION_TYPE_EQUIPMENT:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"report_device_header_title" inTable:nil];
            break;
        case REPORT_SECTION_TYPE_DESCRIPTION:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"report_description_header_title" inTable:nil];
            break;
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case REPORT_SECTION_TYPE_DESCRIPTION:
            height = _footerHeight;
            break;
        default:
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    UIView * seperatorView = nil;
    switch (sectionType) {
        case REPORT_SECTION_TYPE_DESCRIPTION:
            seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _footerHeight)];
            seperatorView.backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }
    return seperatorView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    SeperatorView *seperator = nil;
    SeperatorView *topSeperator = nil;
    DeviceItemView *deviceItemView = nil;
    
    
    CGFloat itemHeight = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    
    switch (sectionType) {
        case REPORT_SECTION_TYPE_BASEINFO: {
            cellIdentifier = @"CellBaseInfo";
            itemHeight = [ReportBaseInfoView2 calculateHeightByItemCount:7];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray *subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[ReportBaseInfoView2 class]]) {
                        _baseInfoView = (ReportBaseInfoView2 *)view;
                    }
                }
            }
            if (cell && !_baseInfoView) {
                _baseInfoView = [[ReportBaseInfoView2 alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [_baseInfoView setOnItemLickListener:self];
                [cell addSubview:_baseInfoView];
            }
            if (_baseInfoView) {
                [_baseInfoView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [_baseInfoView setUserName:_baseInfoModel.name];
                [_baseInfoView setPhone:_baseInfoModel.phone];
                [_baseInfoView setOrg:_baseInfoModel.org];
                [_baseInfoView setServiceType:_baseInfoModel.stype];
                [_baseInfoView setLocation:_baseInfoModel.location];
                [_baseInfoView setPriority:_baseInfoModel.priority];
                [_baseInfoView setOrderType:_baseInfoModel.orderType];
            }
        }
            break;
            
        case REPORT_SECTION_TYPE_EQUIPMENT: {
            cellIdentifier = @"CellEquipment";
            itemHeight = [DeviceItemView calculateHeight];
            Device * dev = _devices[position];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray *subView = [cell subviews];
                for (id view in subView) {
                    if ([view isKindOfClass:[DeviceItemView class]]) {
                        deviceItemView = (DeviceItemView *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !deviceItemView) {
                deviceItemView = [[DeviceItemView alloc] init];
                [cell addSubview:deviceItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (position == _devices.count - 1) {
                    [seperator setFrame:CGRectMake(0, itemHeight - seperatorHeight, _realWidth, seperatorHeight)];
                } else {
                    [seperator setFrame:CGRectMake(padding, itemHeight - seperatorHeight, _realWidth - padding*2, seperatorHeight)];
                }
                
            }
            if (deviceItemView) {
                [deviceItemView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [deviceItemView setInfoWithCode:dev.code name:dev.name location:[_dbHelper getLocationBy:dev.position]];
            }
        }
            break;
            
        case REPORT_SECTION_TYPE_DESCRIPTION: {
            switch (position) {
                case DESCRIPTION_TYPE_TEXT:{
                    cellIdentifier = @"CellDescriptionText";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        NSArray *subView = [cell subviews];
                        for (id view in subView) {
                            if ([view isKindOfClass:[BaseTextView class]]) {
                                _descTXView = (BaseTextView *) view;
                            }
                        }
                    }
                    if (cell && !_descTXView) {
                        _descTXView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, 150)];  //初始化的时候先给设置一个minHeight;
                        _descTXView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                        [_descTXView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"report_question_desc" inTable:nil]];
                        [_descTXView setMaxTextLength:1000];
                        [_descTXView setContentFont:[FMFont setFontByPX:38]];
                        [_descTXView setPaddingLeft:11];
                        [_descTXView setPaddingRight:11];
                        [_descTXView setOnViewResizeListener:self];
                        [_descTXView setMinHeight:150];
                        [_descTXView setContentWith:_report.desc];
                        [cell addSubview:_descTXView];
                    }
                    if (_descTXView) {
                        itemHeight = CGRectGetHeight(_descTXView.frame);
                        [_descTXView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                    }
                }
                    break;
                    
                case DESCRIPTION_TYPE_PHOTO:{
                    cellIdentifier = @"CellDescriptionPhoto";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    itemHeight = [BasePhotoView calculateHeightByCount:_selectedPhotos.count width:_realWidth addAble:YES showType:PHOTO_SHOW_TYPE_ALL_LINES];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        NSArray *subView = [cell subviews];
                        for (id view in subView) {
                            if ([view isKindOfClass:[BasePhotoView class]]) {
                                _photoView = (BasePhotoView *) view;
                            } else if ([view isKindOfClass:[SeperatorView class]]) {
                                SeperatorView *tmpSeperator = (SeperatorView *) view;
                                if (tmpSeperator.tag == 100) {
                                    topSeperator = (SeperatorView *) view;
                                } else if (tmpSeperator.tag == 200) {
                                    seperator = (SeperatorView *) view;
                                }
                            }
                        }
                    }
                    if (cell && !_photoView) {
                        _photoView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                        [_photoView setEditable:YES];
                        [_photoView setEnableAdd:YES];
                        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                        [_photoView setOnMessageHandleListener:self];
                        [cell addSubview:_photoView];
                    }
                    if (cell && !topSeperator) {
                        topSeperator = [[SeperatorView alloc] init];
                        topSeperator.tag = 100;
                        [cell addSubview:topSeperator];
                    }
                    if (cell && !seperator) {
                        seperator = [[SeperatorView alloc] init];
                        seperator.tag = 200;
                        [cell addSubview:seperator];
                    }
                    if (topSeperator) {
                        [topSeperator setFrame:CGRectMake(0, 0, _realWidth, seperatorHeight)];
                    }
                    if (seperator) {
                        [seperator setFrame:CGRectMake(0, itemHeight - seperatorHeight, _realWidth, seperatorHeight)];
                    }
                    
                    if (_photoView) {
                        [_photoView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                        [_photoView setPhotosWithArray:_selectedPhotos];
                    }
                    
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canEditable = NO;
    ReportSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    if (sectionType == REPORT_SECTION_TYPE_EQUIPMENT) {
        canEditable = YES;
    }
    return canEditable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSArray *actionArray = nil;
    ReportSectionType sectionType = [self getSectionTypeBySection:section];
    if (sectionType == REPORT_SECTION_TYPE_EQUIPMENT) {
        UITableViewRowAction * delectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [_devices removeObjectAtIndex:position];
            if (_devices.count > 0) {
                NSIndexPath * deleteIndex = [NSIndexPath indexPathForRow:position inSection:section];
                [_tableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [_tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        
        delectAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        actionArray = @[delectAction];
    }

    return actionArray;
}


#pragma mark - Private Method

- (void) prepareToupLoadData {
    [self getReportInfo];
    
    if (!_report.phone || [FMUtils isStringEmpty:_report.phone]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_phone" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    if(!_report.stypeId || [_report.stypeId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_service_type" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    if(!_report.priorityId || [_report.priorityId isEqualToNumber:[NSNumber numberWithLong:0]]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_priority" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    if(!_report.position || [_report.position isNull]) {
        [self noticeDownloadBaseData];
        return;
    }
    [self uploadDataRightNow];
}

- (void) uploadDataRightNow {
    [self showLoadingDialog];
    if([self hasImage]) {
        [self uploadReportImage];
    } else {
        [self uploadReportData];
    }
}

- (void) uploadReportImage {
    
    NSMutableArray * files = [NSMutableArray new];
    for(id imgItem in _selectedPhotos) {
        if ([imgItem isKindOfClass:[UIImage class]]) {
            [files addObject:imgItem];
        }
    }
    if([files count] > 0) {
        [[FileUploadService getInstance] uploadImageFiles:files listener:self];
    } else {
        [self uploadReportData];
    }
}

- (NSMutableArray *) getImageIds {
    NSMutableArray * array = nil;
    if([_imgIds count] > 0 || [_imgOnlineIds count] > 0) {
        array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:_imgIds];
        [array addObjectsFromArray:_imgOnlineIds];
    }
    return array;
}

- (void) uploadReportData {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * deviceId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    ReportNetRequest * netRequest = [ReportNetRequest getInstance];
    ReportUploadRequest * wr = [[ReportUploadRequest alloc] initWith:_report];
    wr.pictures = [self getImageIds];
    [netRequest request:wr token:accessToken deviceId:deviceId projectId:projectId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        NSNumber * reportId = [data valueForKeyPath:@"workOrderId"];
        if([reportId isKindOfClass:[NSNull class]]) {
            reportId = nil;
        }
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_upload_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self notifyReportSuccess];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_upload_fail_check_internet" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) goToPickPhoto {
    [_descTXView resignFirstResponder];
    [_cameraHelper getPhotoWithWaterMark:_baseInfoModel.location];
}

- (BOOL) isDeviceExist:(NSNumber *) deviceId {
    BOOL res = NO;
    for(Device * dev in _devices) {
        if(dev.eqId && [deviceId isEqualToNumber:dev.eqId]) {
            res= YES;
            break;
        }
    }
    return res;
}


- (BOOL) hasImage {
    BOOL res = NO;
    if(_selectedPhotos && [_selectedPhotos count] > 0) {
        res = YES;
    }
    return res;
}

- (BOOL) hasDevice {
    BOOL isExist = NO;
    if (_devices.count > 0) {
        isExist = YES;
    }
    return isExist;
}

- (void) getReportInfo {
    if(!_report) {
        _report = [[Report alloc] init];
    }
    if([FMUtils isStringEmpty:_report.name]) {
        _report.userId = [SystemConfig getUserId];
        UserInfo * user = [_dbHelper queryUserById:[SystemConfig getUserId]];
        _report.name = user.name;
    }
    _report.phone = [_baseInfoView getPhone];
    _report.orgId = _org.orgId;
    _report.stypeId = _stype.serviceTypeId;
    _report.priorityId = _priority.priorityId;
    _report.desc = [_descTXView getContent];
    _report.position = _position;
    _report.orderType = [_baseInfoView getOrderType];
    
    if(!_report.devices) {
        _report.devices = [[NSMutableArray alloc] init];
    } else {
        [_report.devices removeAllObjects];
    }
    if (_devices && _devices.count > 0) {
        _report.devices = _devices;
    }
    _report.processId = _flowId;
}

- (void) noticeDownloadBaseData {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"download_notice_download" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}


#pragma mark - Click Event Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    _curDeviceIndex = [NSNumber numberWithInteger:indexPath.row];  //替换标记
//    
//    InfoSelectViewController * infoSelectVC;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    [param setValue:_position forKeyPath:@"position"];
//    infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_DEVICE_INFO_SELECT andParam:param];
//    [infoSelectVC setOnMessageHandleListener:self];
//    [self gotoViewController:infoSelectVC];
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        if(!_isUploading) {
            [self prepareToupLoadData];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"upload_uploading" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (void) onDeviceBtnClick {
    InfoSelectViewController * infoSelectVC;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:_position forKeyPath:@"position"];
    infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_DEVICE_INFO_SELECT andParam:param];
    
    [infoSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:infoSelectVC];
}

- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[ReportBaseInfoView2 class]]) {
        ReportBaseItemType type = subView.tag;
        InfoSelectViewController * infoSelectVC;
        NSMutableDictionary * param;
        switch (type) {
            case REPORT_BASE_ITEM_TYPE_ORG:
                infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_ORG_INFO_SELECT];
                [infoSelectVC setOnMessageHandleListener:self];
                [self gotoViewController:infoSelectVC];
                break;
            case REPORT_BASE_ITEM_TYPE_SERVICE_TYPE:
                infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT];
                [infoSelectVC setOnMessageHandleListener:self];
                [self gotoViewController:infoSelectVC];
                break;
            case REPORT_BASE_ITEM_TYPE_ORDER_TYPE:
                if(_reportType == REPORT_TYPE_COMMON) {
                    infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_ORDER_TYPE_INFO_SELECT];
                    [infoSelectVC setOnMessageHandleListener:self];
                    [self gotoViewController:infoSelectVC];
                }
                break;
            case REPORT_BASE_ITEM_TYPE_LOCATION:
                infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_LOCATION_INFO_SELECT];
                [infoSelectVC setOnMessageHandleListener:self];
                [self gotoViewController:infoSelectVC];
                break;
            case REPORT_BASE_ITEM_TYPE_PRIORITY:
                if(_stype && _stype.serviceTypeId && ![_stype.serviceTypeId isEqualToNumber:[NSNumber numberWithInteger:0]]) {
                    param = [[NSMutableDictionary alloc] init];
                    [param setValue:_org.orgId forKey:@"orgId"];
                    [param setValue:_stype.serviceTypeId forKey:@"stypeId"];
                    [param setValue:_position forKey:@"position"];
                    [param setValue:[NSNumber numberWithInteger:_report.orderType] forKey:@"orderType"];
                    infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_PRIORITY_INFO_SELECT andParam:param];
                    [infoSelectVC setOnMessageHandleListener:self];
                    [self gotoViewController:infoSelectVC];
                } else {
                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_request_service_type" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                }
                break;
        }
    }
}



#pragma mark - OnViewResizeListener Delegate

- (void)onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if (view == _descTXView) {
        CGRect frame = view.frame;
        if (frame.size.width != newSize.width || frame.size.height != newSize.height) {
            frame.size = newSize;
            [view setFrame:frame];
            [_tableView beginUpdates];
            [_tableView endUpdates];
        }
    }
}

#pragma mark - FileUploadListener Delegate
- (void)onUploadFileFinished:(NSURLResponse *)response object:(id)responseObject {
    if (!_imgIds) {
        _imgIds = [NSMutableArray new];
    }
    for (NSNumber *photoId in responseObject) {
        [_imgIds addObject:photoId];
    }
    [self uploadReportData];
}

- (void)onUploadFileError:(NSURLResponse *)response error:(NSError *)error {
    [self hideLoadingDialog];
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

#pragma mark - OnMessageHandleListener Delegate
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKey:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            NSString * tmp;
            id result;
            switch (requestType) {
                case REQUEST_TYPE_ORG_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        NSDictionary * dorg = [result valueForKeyPath:@"org"];
                        if(dorg) {
                            NSString * fullName = [result valueForKeyPath:@"fullName"];
                            if(!_org || ![_org.orgId isEqualToNumber:[dorg valueForKeyPath:@"orgId"]]) {
                                _org = (Org *) dorg;
                                _baseInfoModel.org = fullName;
                                _priority = nil;
                                _baseInfoModel.priority = @"";
                            }
                        } else {
                            _org = nil;
                            _priority = nil;
                            _baseInfoModel.org = @"";
                            _baseInfoModel.priority = @"";
                        }
                    } else {
                        _org = nil;
                        _priority = nil;
                        _baseInfoModel.org = @"";
                        _baseInfoModel.priority = @"";
                    }
                    break;
                case REQUEST_TYPE_SERVICE_TYPE_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        ServiceType * serviceType = [result valueForKeyPath:@"serviceType"];
                        if(serviceType) {
                            NSString * fullName = [result valueForKeyPath:@"fullName"];
                            if(!_stype || ![_stype.serviceTypeId isEqualToNumber:[serviceType valueForKeyPath:@"serviceTypeId"]]) {
                                _stype = serviceType;
                                _baseInfoModel.stype = fullName;
                                _priority = nil;
                                _baseInfoModel.priority = @"";
                            }
                        } else {
                            _stype = nil;
                            _priority = nil;
                            _baseInfoModel.stype = @"";
                            _baseInfoModel.priority = @"";
                        }
                    } else {
                        _stype = nil;
                        _priority = nil;
                        _baseInfoModel.stype = @"";
                        _baseInfoModel.priority = @"";
                    }
                    break;
                case REQUEST_TYPE_ORDER_TYPE_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        NSNumber * orderType = result;
                        if(orderType) {
                            if(!_report.orderType || _report.orderType != orderType.integerValue) {
                                _report.orderType = orderType.integerValue;
                                _baseInfoModel.orderType = orderType.integerValue;
                                _baseInfoModel.priority = @"";
                            }
                        } else {
                            _report.orderType = REPORT_ORDER_TYPE_SELF_CHECK;
                            _priority = nil;
                            _baseInfoModel.stype = @"";
                            _baseInfoModel.priority = @"";
                        }
                    } else {
                        _report.orderType = REPORT_ORDER_TYPE_SELF_CHECK;
                        _priority = nil;
                        _baseInfoModel.stype = @"";
                        _baseInfoModel.priority = @"";
                    }
                    break;
                case REQUEST_TYPE_LOCATION_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        Position * pos = [result valueForKeyPath:@"position"];
                        if(!pos || [pos isNull]) {
                            pos = [_dbHelper getDefaultPosition];
                        }
                        if(pos) {
                            if(!_position || ![_position isEqual:pos]) {
                                _position = pos;
                                tmp = [_dbHelper getLocationBy:pos];
                                _baseInfoModel.location = tmp;
                                _priority = nil;
                                _baseInfoModel.priority = @"";
                            }
                        } else {
                            [self noticeDownloadBaseData];
                            _position = nil;
                            _priority = nil;
                            _baseInfoModel.location = @"";
                            _baseInfoModel.priority = @"";
                        }
                    } else {
                        _position = nil;
                        _priority = nil;
                        _baseInfoModel.location = @"";
                        _baseInfoModel.priority = @"";
                    }
                    break;
                case REQUEST_TYPE_PRIORITY_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        _priority = [result valueForKeyPath:@"priority"];
                        _flowId = [result valueForKeyPath:@"flowId"];
                        _baseInfoModel.priority = _priority.name;
                    } else {
                        _priority = nil;
                        _flowId = nil;
                        _baseInfoModel.priority = @"";
                    }
                    break;
                case REQUEST_TYPE_DEVICE_INFO_SELECT:{
                    Device * device;
                    device = [msg valueForKeyPath:@"result"];
                    if(device) {
                        if(device.eqId) {
                            if(![self isDeviceExist:device.eqId]) {
                                if (![FMUtils isNumberNullOrZero:_curDeviceIndex]) {
                                    [_devices replaceObjectAtIndex:_curDeviceIndex.unsignedIntegerValue withObject:device];
                                } else {
                                    [_devices addObject:device];
                                }
                            } else {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_equipment_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                                });
                            }
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        } else if ([strOrigin isEqualToString:NSStringFromClass([_photoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_photoHelper setPhotos:_selectedPhotos];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case PHOTO_ACTION_DELETE:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [_selectedPhotos removeObjectAtIndex:tmpNumber.integerValue];
                    if(tmpNumber.integerValue >= 0 && tmpNumber.integerValue < [_imgOnlineIds count]) {
                        [_imgOnlineIds removeObjectAtIndex:tmpNumber.integerValue];
                    }
                    [_photoView setPhotosWithArray:_selectedPhotos];
                    [_tableView reloadData];
                    break;
                case PHOTO_ACTION_TAKE_PHOTO:
                    [self goToPickPhoto];
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
            NSArray *imgPaths = [msg valueForKeyPath:@"result"];
            for (NSString *path in imgPaths) {
                UIImage * img = [FMUtils getImageWithName:path];
                [_selectedPhotos addObject:img];
            }
            [_photoView setPhotosWithArray:_selectedPhotos];
            [_tableView reloadData];
        }
    }
}


#pragma mark - 发送通知
- (void) notifyReportSuccess {
    if(_report.reqId) { //需求报障
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FMRequirementReportSuccess" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self backToParentWithLevel:2];
        });
    } else if(_report.patrolItemDetailId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FMPatrolReportSuccess" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self backToParentWithLevel:2];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self finish];
        });
    }
}

#pragma - mark 键盘的显示与隐藏
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    if(keyboardSize.height > 0) {
//        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//            CGRect frame = CGRectMake(0, 0, _realWidth, _realHeight-keyboardSize.height);
//            _tableView.frame = frame;
//
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//        _tableView.frame = CGRectMake(0, 0, _realWidth, _realHeight);
//    }];
//}


@end

