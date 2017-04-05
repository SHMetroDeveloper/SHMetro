//
//  RequirementDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/24.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementDetailViewController.h"
#import "PullTableView.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "UIButton+Bootstrap.h"
#import "RequirementDetailEntity.h"
#import "SeperatorView.h"
#import "ServiceCenterNetRequest.h"
#import "RequirementDetailBaseInfoView.h"
#import "MarkedListHeaderView.h"
#import "BaseLabelView.h"
#import "RequirementDetailRequestorView.h"
#import "RequireDetailAddContentViewController.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailViewController.h"
#import "RequirementDetailRecordView.h"
#import "PhotoItem.h"
#import "ServiceCenterServerConfig.h"
#import "MWPhotoBrowser.h"
#import "MediaViewController.h"
#import "RequirementOperationEntity.h"
#import "TaskAlertView.h"
#import "RequirementEvaluateView.h"
#import "BaseDataDbHelper.h"
#import "HorizontalDisplayView.h"
#import "AudioPlayAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "RequirementManagerBusiness.h"
#import "MenuAlertContentView.h"
#import "NewReportViewController.h"
#import "PhotoShowHelper.h"
#import "BasePhotoView.h"
#import "CellForAudioRecordView.h"
#import "RequirementAudioRecordView.h"
#import "PhoneListAlertContentView.h"
#import "BaseAlertView.h"
#import "WorkOrderServerConfig.h"
#import "BaseItemView.h"

#import "AttachmentViewController.h"  //附件查看
#import "RequirementDetailEvaluateViewController.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

#import "PowerManager.h"
#import "ReportFunctionPermission.h"
#import "QuickReportEquipmentTableViewCell.h"


typedef void (^ActionHandler) (UIAlertAction * action);

typedef NS_ENUM(NSInteger, RequirementDetailSectionType) {
    REQUIREMENT_DETAIL_SECTION_UNKNOW,      //
    REQUIREMENT_DETAIL_SECTION_BASE,        //基本信息
    REQUIREMENT_DETAIL_SECTION_CONTENT,     //处理内容
    REQUIREMENT_DETAIL_SECTION_RECORD,      //需求记录
    REQUIREMENT_DETAIL_SECTION_ORDER,       //需求工单
    REQUIREMENT_DETAIL_SECTION_EQUIPMENT,   //故障设备
    REQUIREMENT_DETAIL_SECTION_ATTACHMENT,       //附件
};

typedef NS_ENUM(NSInteger, BaseInfoPositionType) {
    BASEINFO_POSITION_UNKNOW,
    BASEINFO_POSITION_BASEINFO,
    BASEINFO_POSITION_IMAGE,
    BASEINFO_POSITION_AUDIO,
    BASEINFO_POSITION_VIDEO,
};

typedef NS_ENUM(NSInteger, DisplayType) {
    DISPLAY_TYPE_UNKNOW,
    DISPLAY_TYPE_IMAGE,
    DISPLAY_TYPE_AUDIO,
    DISPLAY_TYPE_VIDEO
};

@interface RequirementDetailViewController () <UITableViewDataSource, UITableViewDelegate, OnClickListener, OnMessageHandleListener, OnItemClickListener, AVAudioPlayerDelegate>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;


@property (nonatomic, strong) BasePhotoView *photoItemView;  //照片展示
@property (nonatomic, strong) PhotoShowHelper *photoHelper;
@property (nonatomic, strong) NSMutableArray *photoArray;  //用于存放照片


@property (nonatomic, strong) RequirementAudioRecordView * audioItemView;  //录音展示
@property (nonatomic, strong) NSMutableArray *audioDuriationTimesArray;
@property (nonatomic, strong) NSMutableArray *audioArray;


@property (nonatomic, strong) BasePhotoView *videoItemView;  //视频展示
@property (nonatomic, strong) NSMutableArray *videoPhotoArray; //视频缩略图及视频资源URL


@property (readwrite, nonatomic, strong) BaseLabelView * contentItemView;
@property (readwrite, nonatomic, strong) RequirementDetailRequestorView * requestorView;


@property (readwrite, nonatomic, strong) TaskAlertView *infoView;  //弹窗界面
@property (readwrite, nonatomic, assign) CGFloat infoViewHeight;

@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) RequirementEvaluateView * evaluateContentView;            //评分 操作界面
@property (readwrite, nonatomic, strong) AudioPlayAlertView * audioPlayAlertView; //提醒弹出View (录音播放界面)

@property (readwrite, nonatomic, strong) BaseAlertView * centerAlertView; //用于在屏幕中先弹出的提示框
@property (readwrite, nonatomic, strong) PhoneListAlertContentView * phoneContentView;              //手机号操作界面

@property (readwrite, nonatomic, assign) BOOL isWorking;    //是否正在处理任务
@property (readwrite, nonatomic, assign) BOOL hasBeenLoaded;
@property (readwrite, nonatomic, assign) BOOL isBackFromReport;

@property (nonatomic, strong) RequirementManagerBusiness *business;

//用于播放音频
@property (nonatomic, strong) AVPlayer *audioPalyer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSURL *playFileURL;

@property (readwrite, nonatomic, strong) RequirementDetailEntity * detailInfo;
@property (readwrite, nonatomic, strong) NSNumber * reqId;
@property (readwrite, nonatomic, strong) NSNumber * gradeId;//评分ID
@property (readwrite, nonatomic, strong) NSString * gradeDesc;//评分内容
@property (readwrite, nonatomic, strong) NSString* comment;

@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;
@property (readwrite, nonatomic, strong) NSMutableArray * satisfactionArray; //存放满意度项的数组

@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;
@property (readwrite, nonatomic, assign) CGFloat photoItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat audioItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat requestorItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat recordItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat orderItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat equipmentItemHeight;   //
@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, assign) BOOL commentable;
@property (readwrite, nonatomic, strong) PowerManager * manager;
@end

@implementation RequirementDetailViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _editable = YES;
        _commentable = NO;
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement_detail" inTable:nil]];
    [self setBackAble:YES];
    
    if (_editable) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[FMTheme getInstance] getImageByName:@"menu_more"], nil];
        [self setMenuWithArray:menus];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPermission];
    [self initFunctionPermissionUpdateHandler];
    [self initAlertView];
    [self updateLayout];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateList];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_infoView close];
    [self work];
}

- (void) initPermission {
    _manager = [PowerManager getInstance];
}

- (void) initFunctionPermissionUpdateHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FunctionPermissionUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateFunctionPermission)
                                                 name: @"FunctionPermissionUpdate"
                                               object: nil];
}

- (void) updateFunctionPermission {
    
}

- (BOOL) canReport {
    BOOL res = YES;
//    FunctionPermission * permission = [_manager getFunctionPermissionByKey:REPORT_FUNCTION];
//    if(permission) {
//        res = [permission getPermissionType] != FUNCTION_ACCESS_PERMISSION_NONE;
//    }
    return res;
}

- (void) onBackButtonPressed {
    if(_isWorking) {
        [self resetWorking];
    } else {
        [super onBackButtonPressed];
    }
}

- (void) initAlertView {
    _infoView = [[TaskAlertView alloc] init];
    [_infoView setFrame:CGRectMake(0, 0, _realWidth, self.view.frame.size.height)];
    [_infoView setHidden:YES];
    [_infoView setOnClickListener:self];
    [self.view addSubview:_infoView];
    
    _centerAlertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, self.view.frame.size.height)];
    [_centerAlertView setOnClickListener:self];
    [_centerAlertView setPadding:[FMSize getInstance].defaultPadding];
    [_centerAlertView setContentView:_phoneContentView];
    [_centerAlertView setHidden:YES];
    [self.view addSubview:_centerAlertView];


    [_infoView setContentView:_audioPlayAlertView withKey:@"audioPlay" andHeight:0 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_infoView setContentView:_evaluateContentView withKey:@"evaluate" andHeight:0 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_infoView setContentView:_menuContentView  withKey:@"menu" andHeight:0  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void) initLayout {
    if(!_mainContainerView) {
    
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        if (!_business) {
            _business = [RequirementManagerBusiness getInstance];
        }
        if (!_photoHelper) {
            _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        }
        if (!_photoArray) {
            _photoArray = [NSMutableArray new];
        }
        if (!_videoPhotoArray) {
            _videoPhotoArray = [NSMutableArray new];
        }
        if (!_audioArray) {
            _audioArray = [NSMutableArray new];
        }
        if (!_audioDuriationTimesArray) {
            _audioDuriationTimesArray = [NSMutableArray new];
        }
        if (!_satisfactionArray) {
            _satisfactionArray = [NSMutableArray new];
        }
        
        
        _controlHeight = 0;
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        _padding = [FMSize getInstance].defaultPadding;
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = [FMSize getInstance].listFooterHeight;
        _photoItemHeight = 105;
        _requestorItemHeight = 120;
        _orderItemHeight = 50;
        _equipmentItemHeight = [QuickReportEquipmentTableViewCell getItemHeightByShowLocation:NO];
        _recordItemHeight = 120;
        _infoViewHeight = _realHeight;
        _audioItemHeight = 70;
        
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        
        _evaluateContentView = [[RequirementEvaluateView alloc] init];
        [_evaluateContentView setOnItemClickListener:self];
        _evaluateContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        //录音播放界面
        _audioPlayAlertView = [[AudioPlayAlertView alloc] init];
        _audioPlayAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_audioPlayAlertView setOnItemClickListener:self];
        _audioPlayAlertView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _audioPlayAlertView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        _phoneContentView = [[PhoneListAlertContentView alloc] init];
        _phoneContentView.clipsToBounds = YES;
        _phoneContentView.layer.cornerRadius = 3;
        [_phoneContentView setOnPhoneDelegate:self];


        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.delaysContentTouches = NO;
        
        
        [_mainContainerView addSubview:_tableView];
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    
}


- (void) onMenuItemClicked:(NSInteger)position {
    switch (_detailInfo.status) {
        case REQUIREMENT_STATUS_CREATE:
            [self showApprovalMenu];
            break;
            
        case REQUIREMENT_STATUS_PROCESS:
            [self showProcessMenu];
            break;
            
        case REQUIREMENT_STATUS_FINISH:
            [self showEvaluateMenu];
            break;
            
        case REQUIREMENT_STATUS_EVALUATED:
            NSLog(@"暂无操作");
            break;
    }
}

- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers {
    _isWorking = YES;
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_infoView setContentHeight:height withKey:@"menu"];
    [_infoView showType:@"menu"];
    [_infoView show];
}


- (void) showApprovalMenu {
    NSMutableArray * menus = [[NSMutableArray alloc] init];
    NSMutableArray * handlers = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    ActionHandler orderCreateHandler = ^(UIAlertAction * action) {
        [weakSelf onCreateOrderClicked];
    };
    ActionHandler approvalPassHandler = ^(UIAlertAction * action) {
        [weakSelf onApprovalSuccessClicked];
    };
    if([self canReport]) {
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"requirement_create_order" inTable:nil]];
        [handlers addObject:orderCreateHandler];
    }
    
    [menus addObject:[[BaseBundle getInstance] getStringByKey:@"requirement_pass" inTable:nil]];
    [handlers addObject:approvalPassHandler];
    
    
    [self showControlWithMenuTexts:menus handlers:handlers];
}

- (void) showProcessMenu {
    if ([_detailInfo.orders count] > 0) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:
                                  [[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil],
                                  [[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil], nil];
        __weak typeof(self) weakSelf = self;
        ActionHandler saveContentHandler = ^(UIAlertAction * action) {
            [weakSelf onSaveClicked];
        };
        
        ActionHandler finishRequirementHandler = ^(UIAlertAction * action) {
            [weakSelf onFinishClicked];
        };
        
        NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects: saveContentHandler, finishRequirementHandler, nil];
        
        [self showControlWithMenuTexts:menus handlers:handlers];
    } else {
        NSMutableArray * menus = [[NSMutableArray alloc] init];
        NSMutableArray * handlers = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        ActionHandler orderCreateHandler = ^(UIAlertAction * action) {
            [weakSelf onProductOrderClicked];
        };
        
        ActionHandler saveContentHandler = ^(UIAlertAction * action) {
            [weakSelf onSaveClicked];
        };
        
        ActionHandler finishRequirementHandler = ^(UIAlertAction * action) {
            [weakSelf onFinishClicked];
        };
        
        if([self canReport]) {
            [menus addObject:[[BaseBundle getInstance] getStringByKey:@"requirement_create_order" inTable:nil]];
            [handlers addObject:orderCreateHandler];
        }
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]];
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil]];
        
        [handlers addObject:saveContentHandler];
        [handlers addObject:finishRequirementHandler];
        
        
        [self showControlWithMenuTexts:menus handlers:handlers];
    }
}

- (void) showEvaluateMenu {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:
                              [[BaseBundle getInstance] getStringByKey:@"requirement_satisfaction" inTable:nil], nil];
    __weak typeof(self) weakSelf = self;
    ActionHandler evaluateHandler = ^(UIAlertAction * action) {
        [weakSelf evaluateRequirement];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects: evaluateHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}


- (void) updateList {
    [self updateLayout];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void) setInforWith:(NSNumber *) reqId {
    _reqId = [reqId copy];
}

- (void) setCommentable:(BOOL) commentable {
    _commentable = commentable;
    [self updateList];
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
    [self updateList];
}

- (void) work {
    [self requestData];
    [self requestSatisfactions];
}

#pragma mark - NetWorking
- (void) requestData {
    [self showLoadingDialog];
    RequirementDetailRequestParam * param = [[RequirementDetailRequestParam alloc] initWithReqId:_reqId];
    [_business getRequirementDetailByParam:param Success:^(NSInteger key, id object) {
        if(!_detailInfo) {
            _detailInfo = [[RequirementDetailEntity alloc] init];
        }
        _detailInfo = object;
        
        if (!_photoArray) {
            _photoArray = [NSMutableArray new];
        } else {
            [_photoArray removeAllObjects];
        }
        if (!_videoPhotoArray) {
            _videoPhotoArray = [NSMutableArray new];
        } else {
            [_videoPhotoArray removeAllObjects];
        }
        if (!_audioArray) {
            _audioArray = [NSMutableArray new];
        } else {
            [_audioArray removeAllObjects];
        }
        if (!_audioDuriationTimesArray) {
            _audioDuriationTimesArray = [NSMutableArray new];
        } else {
            [_audioDuriationTimesArray removeAllObjects];
        }
        
        
        if (_detailInfo.images && _detailInfo.images.count > 0) {
            for (NSInteger i = 0; i < _detailInfo.images.count ; i ++) {
                NSURL *url = [FMUtils getUrlOfImageById:_detailInfo.images[i]];
                PhotoItem * item = [[PhotoItem alloc] init];
                [item setUrl:url];
                [_photoArray addObject:item];
            }
        }
        
        
        if (_detailInfo.audios && _detailInfo.audios.count > 0) {
            for (NSInteger i = 0; i < _detailInfo.audios.count; i ++) {
                NSURL *url = [FMUtils getUrlOfAudioById:_detailInfo.audios[i]];
                [_audioArray addObject:url];
            }
            if (_audioArray.count > 0) {
                for (NSURL *url in  _audioArray) {
                    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                    CMTime audioDuration = audioAsset.duration;
                    CGFloat audioDurationSeconds = CMTimeGetSeconds(audioDuration);
                    [_audioDuriationTimesArray addObject:[NSNumber numberWithFloat:audioDurationSeconds]];
                }
            }
        }
        
        if (_detailInfo.videos && _detailInfo.videos.count > 0) {
//            for (NSInteger i = 0; i < _detailInfo.videos.count; i ++) {
//                NSURL *url = [FMUtils getUrlOfVideoById:_detailInfo.videos[i]];
//                UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
//                PhotoItem * item = [[PhotoItem alloc] init];
//                //存放用于上传视频的url
//                [item setImage:img];
//                [item setOrigin:PHOTO_ORIGIN_VIDEO];
//                [item setOriginUrl:url];
//                [_videoPhotoArray addObject:item];
//            }
            _videoPhotoArray = [self getVideoPhotosArray];
        }
        
        [self hideLoadingDialog];
        [self updateList];
    } fail:^(NSInteger key, NSError * error) {
        [self hideLoadingDialog];
    }];
}

- (void) requestSatisfactions {
    BaseDataDbHelper * dbHelper = [BaseDataDbHelper getInstance];
    if (!_satisfactionArray) {
        _satisfactionArray = [NSMutableArray new];
    } else {
        [_satisfactionArray removeAllObjects];
    }
    _satisfactionArray = [dbHelper queryAllSatisfactionTypesOfCurrentProject];
    [_evaluateContentView setInfoWithSatisfactionArray:_satisfactionArray];
}

- (BOOL) needShowContent {
    BOOL show = NO;
    if (_detailInfo.status == REQUIREMENT_STATUS_PROCESS) {
        show = YES;
    }
    return show;
}

- (BOOL) needShowOrder {
    BOOL show = NO;
    if (_detailInfo.orders.count > 0) {
        show = YES;
    }
    return show;
}

- (BOOL) needShowEquipment {
    BOOL show = NO;
    if (_detailInfo.equipment.count > 0) {
        show = YES;
    }
    return show;
}

- (BOOL) needShowAttachment {
    BOOL show = NO;
    if (_detailInfo.attachment.count > 0) {
        show = YES;
    }
    return show;
}

- (NSURL *) getVideoUrl:(NSNumber *) videoId {
    NSString * accessToken = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * strUrl = [ServiceCenterServerConfig wrapVideoUrlById:accessToken videoId:videoId];
    //TODO: 测试代码
    //    strUrl = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

- (NSMutableArray *) getVideoPhotosArray {
    NSMutableArray * photoArray = [[NSMutableArray alloc] init];
    if(_detailInfo) {
        NSInteger tag = 0;
        for(NSNumber * videoId in _detailInfo.videos) {
            NSURL * url = [self getVideoUrl:videoId];
            //                        UIImage * img = [FMUtils thumbnailWithAssetUrl:url time:1];
            PhotoItem * item = [[PhotoItem alloc] init];
            //                        [item setImage:img];
            [self getVideoImageAsyn:url time:1 tag:tag];
            [item setOrigin:PHOTO_ORIGIN_VIDEO];
            [item setOriginUrl:url];
            [photoArray addObject:item];
            tag++;
        }
    }
    return photoArray;
}

- (void) getVideoImageAsyn:(NSURL *) url time:(CGFloat) time tag:(NSInteger) tag{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        CMTime thumbTime = CMTimeMakeWithSeconds(time,600);
        
        AVAssetImageGeneratorCompletionHandler handler =
        ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
            if (result != AVAssetImageGeneratorSucceeded) {
                NSLog(@"截取图片失败。");
            } else {
                NSLog(@"截取图片成功。");
                UIImage *thumbImg = [UIImage imageWithCGImage:im];
                if(thumbImg) {
                    [self getVideoImageSuccess:thumbImg tag:tag];
                }
            }
        };
        
        [generator generateCGImagesAsynchronouslyForTimes:
         [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    });
}

- (void) getVideoImageSuccess:(UIImage *) image tag:(NSInteger) tag {
    PhotoItem * item = _videoPhotoArray[tag];
    
    [item setImage:image];
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO];
}


- (NSInteger) getSectionCount {
    NSInteger count = 2;  //基本信息，历史记录
    if(_detailInfo.status == REQUIREMENT_STATUS_PROCESS) {    //待审核的不需要处理内容
        count += 1;
    }
    if (_detailInfo.orders.count > 0) {
        count += 1;
    }
    if (_detailInfo.equipment.count > 0) {
        count += 1;
    }
    if (_detailInfo.attachment.count > 0) {
        count += 1;
    }
    return count;
}

- (RequirementDetailSectionType) getSectionTypeBy:(NSInteger) section {
    RequirementDetailSectionType sectionType = REQUIREMENT_DETAIL_SECTION_UNKNOW;

    if (section >=1 && ![self needShowContent]) {
        section += 1;
    }
    if (section >= 2 && ![self needShowOrder]) {
        section += 1;
    }
    if (section >= 3 && ![self needShowEquipment]) {
        section += 1;
    }
    if (section >= 4 && ![self needShowAttachment]) {
        section += 1;
    }
    
    switch(section) {
        case 0:
            sectionType = REQUIREMENT_DETAIL_SECTION_BASE;
            break;
        case 1:
            sectionType = REQUIREMENT_DETAIL_SECTION_CONTENT;
            break;
        case 2:
            sectionType = REQUIREMENT_DETAIL_SECTION_ORDER;
            break;
        case 3:
            sectionType = REQUIREMENT_DETAIL_SECTION_EQUIPMENT;
            break;
        case 4:
            sectionType = REQUIREMENT_DETAIL_SECTION_ATTACHMENT;
            break;
        case 5:
            sectionType = REQUIREMENT_DETAIL_SECTION_RECORD;
            break;
    }
    
    return sectionType;
}

- (BaseInfoPositionType) getPositionTypeBy:(NSInteger) position {
    BaseInfoPositionType positionType = BASEINFO_POSITION_UNKNOW;
    switch (position) {
        case 0:
            positionType = BASEINFO_POSITION_BASEINFO;
            break;
            
        case 1: {
            if (_photoArray.count > 0) {
                positionType = BASEINFO_POSITION_IMAGE;
                break;
            }
            if (_audioArray.count > 0) {
                positionType = BASEINFO_POSITION_AUDIO;
                break;
            }
            if (_videoPhotoArray.count > 0) {
                positionType = BASEINFO_POSITION_VIDEO;
                break;
            }
            break;
        }
            
        case 2: {
            if (_photoArray.count > 0) {
                if (_audioArray.count > 0) {
                    positionType = BASEINFO_POSITION_AUDIO;
                } else if(_videoPhotoArray.count > 0){
                    positionType = BASEINFO_POSITION_VIDEO;
                }
            } else {
                if ((_audioArray.count > 0) && (_videoPhotoArray.count > 0)) {
                    positionType = BASEINFO_POSITION_VIDEO;
                    break;
                }
            }
            break;
        }
            
        case 3:
            if(_photoArray.count > 0 && _audioArray.count > 0 && _videoPhotoArray.count > 0) {
                positionType = BASEINFO_POSITION_VIDEO;
            }
            break;
            
        default:
            positionType = BASEINFO_POSITION_UNKNOW;
            break;
    }
    
    return positionType;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    RequirementDetailSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case REQUIREMENT_DETAIL_SECTION_BASE:
            count = 1 ;
            if(_photoArray.count > 0) {
                count += 1;
            }
            if (_audioArray.count > 0) {
                count += 1;
            }
            if (_videoPhotoArray.count > 0) {
                count += 1;
            }
            count += 1;//footer
            break;
        case REQUIREMENT_DETAIL_SECTION_CONTENT:
            if(![FMUtils isStringEmpty:_comment]) {
                count = 1;
            }
            count += 1; //footer
            break;
        case REQUIREMENT_DETAIL_SECTION_ORDER:
            if(_detailInfo.orders) {
                count = [_detailInfo.orders count];
            }
            count += 1; //footer
            break;
        case REQUIREMENT_DETAIL_SECTION_EQUIPMENT:
            if(_detailInfo.equipment) {
                count = [_detailInfo.orders count];
            }
            count += 1; //footer
            break;
        case REQUIREMENT_DETAIL_SECTION_ATTACHMENT:
            if(_detailInfo.attachment) {
                count = [_detailInfo.attachment count];
            }
            count += 1; //footer
            break;
        case REQUIREMENT_DETAIL_SECTION_RECORD:
            if(_detailInfo.records) {
                count = [_detailInfo.records count];
            }
            count += 1; //footer
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger position = indexPath.row;
    CGFloat width = CGRectGetWidth(tableView.frame);
    RequirementDetailSectionType sectionType = [self getSectionTypeBy:indexPath.section];
    BOOL isFooter = NO;
    switch(sectionType) {
        case REQUIREMENT_DETAIL_SECTION_BASE: {
            BaseInfoPositionType positionType = [self getPositionTypeBy:position];
            switch (positionType) {
                case BASEINFO_POSITION_BASEINFO:
                    itemHeight = [RequirementDetailBaseInfoView calculateHeightByDesc:_detailInfo.desc width:_realWidth];
                    break;
                case BASEINFO_POSITION_IMAGE:
                    itemHeight = _photoItemHeight;
                    break;
                case BASEINFO_POSITION_AUDIO:
                    itemHeight = [RequirementAudioRecordView calculateAudioRecordViewHeightByCount:_audioArray.count];
                    break;
                case BASEINFO_POSITION_VIDEO:
                    itemHeight = [BasePhotoView calculateHeightByCount:[_videoPhotoArray count] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                    break;
                default:
                    isFooter = YES;
            }
        }
            break;
        case REQUIREMENT_DETAIL_SECTION_CONTENT:
            if(![FMUtils isStringEmpty:_comment] && position == 0) {
                itemHeight = [BaseLabelView calculateHeightByInfo:_comment font:[FMFont getInstance].font38 desc:nil labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:_realWidth];
                itemHeight += [FMSize getInstance].defaultPadding;
            } else {
                isFooter = YES;
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_ORDER:
            if([_detailInfo.orders count] > 0 && position < [_detailInfo.orders count]) {
                itemHeight = _orderItemHeight;
            } else {
                isFooter = YES;
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_EQUIPMENT:
            if([_detailInfo.equipment count] > 0 && position < [_detailInfo.equipment count]) {
                itemHeight = _equipmentItemHeight;
            } else {
                isFooter = YES;
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_ATTACHMENT:
            if([_detailInfo.attachment count] > 0 && position < [_detailInfo.attachment count]) {
                itemHeight = _orderItemHeight;
            } else {
                isFooter = YES;
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_RECORD:
            if([_detailInfo.records count] > 0 && position < [_detailInfo.records count]) {
                RequirementRecord * record = _detailInfo.records[position];
                itemHeight = [RequirementDetailRecordView calculateHeightByContent:record.content andWidth:_realWidth];
            } else {
                isFooter = YES;
            }
            break;
        default:
            break;
    }
    if(isFooter) {
        itemHeight = _footerHeight;
    }
    return itemHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSString *cellIdentifier = @"Cell";
    RequirementDetailSectionType sectionType = [self getSectionTypeBy:indexPath.section];
    RequirementDetailBaseInfoView * baseItemView = nil;
    RequirementDetailRecordView * recordItemView = nil;
    BaseItemView *orderItemView = nil;
    QuickReportEquipmentTableViewCell *equipmentItemView = nil;
    SeperatorView *seperator = nil;
    
    CGFloat width = _realWidth;
    CGFloat itemHeight = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    BOOL isFooter = NO;
    UITableViewCell* cell;
    switch(sectionType) {
        case REQUIREMENT_DETAIL_SECTION_BASE:{
            BaseInfoPositionType positionType = [self getPositionTypeBy:position];
            switch (positionType) {
                case BASEINFO_POSITION_BASEINFO:{
                    itemHeight = [RequirementDetailBaseInfoView calculateHeightByDesc:_detailInfo.desc width:_realWidth];
                    cellIdentifier = @"CellBase";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        NSArray * subViews = [cell subviews];
                        for(id view in subViews) {
                            if([view isKindOfClass:[RequirementDetailBaseInfoView class]]) {
                                baseItemView = view;
                            }
                        }
                    }
                    if(cell && !baseItemView) {
                        baseItemView = [[RequirementDetailBaseInfoView alloc] initWithFrame:CGRectMake(padding, 0, width, itemHeight)];
                        [baseItemView setOnItemClickListener:self];
                        [cell addSubview:baseItemView];
                    }
                    if(baseItemView) {
                        [baseItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                        
                        [baseItemView setInfoWith:_detailInfo.code
                                           status:_detailInfo.status
                                             type:_detailInfo.serviceType
                                             desc:_detailInfo.desc
                                           origin:[_detailInfo getOriginDescription]
                                         location:_detailInfo.location
                                        requestor:_detailInfo.requester
                                       createDate:_detailInfo.createDate];
                        baseItemView.tag = position;
                    }
                }
                    break;
                    
                case BASEINFO_POSITION_IMAGE:{
                    //图片
                    itemHeight = _photoItemHeight;
                    cellIdentifier = @"CellPhoto";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    if(cell && !_photoItemView) {
                        _photoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, _photoItemHeight)];
                        [_photoItemView setEditable:NO];
                        [_photoItemView setEnableAdd:NO];
                        [_photoItemView setOnMessageHandleListener:self];
                        _photoItemView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                        _photoItemView.tag = DISPLAY_TYPE_IMAGE;
                        [cell addSubview:_photoItemView];
                    }
                    if(_photoItemView) {
                        [_photoItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                        [_photoItemView setPhotosWithArray:_photoArray];
                    }
                }
                    break;
                    
                case BASEINFO_POSITION_AUDIO: {
                    //录音
                    itemHeight = [RequirementAudioRecordView calculateAudioRecordViewHeightByCount:_audioArray.count];
                    cellIdentifier = @"CellAudio";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                    }
                    if (cell && !_audioItemView) {
                        _audioItemView = [[RequirementAudioRecordView alloc] init];
                        [_audioItemView setOnItemClickListener:self];
                        [cell addSubview:_audioItemView];
                    }
                    if (_audioItemView) {
                        [_audioItemView setDurationTimesArray:_audioDuriationTimesArray];
                        [_audioItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    }
                }
                    break;
                    
                case BASEINFO_POSITION_VIDEO:
                    //视频
                    itemHeight = [BasePhotoView calculateHeightByCount:[_videoPhotoArray count] width:width addAble:NO showType:PHOTO_SHOW_TYPE_ALL_LINES];
                    cellIdentifier = @"CellVideo";
                    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if(!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    if (cell && !_videoItemView) {
                        _videoItemView = [[BasePhotoView alloc] initWithFrame:CGRectMake(0, 0, width, _photoItemHeight)];
                        [_videoItemView setEditable:NO];
                        [_videoItemView setEnableAdd:NO];
                        [_videoItemView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
                        [_videoItemView setOnMessageHandleListener:self];
                        _videoItemView.tag = DISPLAY_TYPE_VIDEO;
                        [self getVideoPhotosArray];
                        [cell addSubview:_videoItemView];
                    }
                    if (_videoItemView) {
                        [_videoItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                        [_videoItemView setPhotosWithArray:_videoPhotoArray];
                    }
                    break;
                    
                case BASEINFO_POSITION_UNKNOW:
                    isFooter = YES;
                    break;
            }
        }
            break;
        
        case REQUIREMENT_DETAIL_SECTION_CONTENT:
            if(![FMUtils isStringEmpty:_comment] && position == 0) {
                //处理内容
                itemHeight = [BaseLabelView calculateHeightByInfo:_comment font:[FMFont getInstance].font38 desc:nil labelFont:[FMFont getInstance].font38 andLabelWidth:0 andWidth:_realWidth];
                cellIdentifier = @"CellContent";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                }
                if(cell && !_contentItemView) {
                    _contentItemView = [[BaseLabelView alloc] init];
                    [_contentItemView setContentFont:[FMFont getInstance].font38];
                    [_contentItemView setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]];
                    [cell addSubview:_contentItemView];
                }
                if(_contentItemView) {
                    [_contentItemView setFrame:CGRectMake(0, padding/2, _realWidth, itemHeight)];
                    [_contentItemView setContent:_comment];
                }
            } else {
                isFooter = YES;
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_RECORD:
            if(_detailInfo.records && position < [_detailInfo.records count]) {
                //需求记录
                RequirementRecord * record = _detailInfo.records[position];
                itemHeight = [RequirementDetailRecordView calculateHeightByContent:record.content andWidth:_realWidth];
                cellIdentifier = @"CellRecord";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[RequirementDetailRecordView class]]) {
                            recordItemView = view;
                            break;
                        }
                    }
                }
                if(cell && !recordItemView) {
                    recordItemView = [[RequirementDetailRecordView alloc] init];
                    [cell addSubview:recordItemView];
                }
                if(recordItemView) {
                    NSString * titleStr = [NSString stringWithFormat:@"%@",record.handler];
                    [recordItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [recordItemView setInfoWithTitle:titleStr content:record.content type:record.recordType time:record.date];
                    if(position > 0) {
                        [recordItemView setShowTopTimeLine:YES];
                    } else {
                        [recordItemView setShowTopTimeLine:NO];
                    }
                    recordItemView.tag = position;
                }
            } else {
                isFooter = YES;
            }
            break;
            
        case REQUIREMENT_DETAIL_SECTION_ORDER:
            if(_detailInfo.orders && position < [_detailInfo.orders count]) {
                //需求工单
                itemHeight = _orderItemHeight;
                RequirementOrder * order = _detailInfo.orders[position];
                cellIdentifier = @"CellOrder";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    CGFloat imgWidth = 18;
                    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
                    UIImageView * moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(width-imgWidth-paddingLeft, (cell.frame.size.height - imgWidth)/2, imgWidth, imgWidth)];
                    moreImg.image = [[FMTheme getInstance] getImageByName:@"slim_more"];
                    
                    [cell addSubview:moreImg];
                } else {
                    NSArray *subViews = [cell subviews];
                    for (UIView *view in subViews) {
                        if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if (cell) {
                    [cell.textLabel setText:order.code];
                    cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
                    cell.textLabel.font = [FMFont getInstance].font42;
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if (seperator) {
                    if (position < _detailInfo.orders.count - 1) {
                        [seperator setHidden:NO];
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake([FMSize getInstance].defaultPadding, itemHeight-[FMSize getInstance].seperatorHeight, width-[FMSize getInstance].defaultPadding*2, [FMSize getInstance].seperatorHeight)];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
            } else {
                isFooter = YES;
            }
            break;
        
        case REQUIREMENT_DETAIL_SECTION_EQUIPMENT:
            if(_detailInfo.equipment && position < [_detailInfo.equipment count]) {
                cellIdentifier = @"CellEquipment";
                equipmentItemView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!equipmentItemView) {
                    equipmentItemView = [[QuickReportEquipmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    equipmentItemView.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (equipmentItemView) {
                    [equipmentItemView setShowLocation:NO];
                    if (position == _detailInfo.equipment.count-1) {
                        [equipmentItemView setSeperatorGapped:NO];
                    } else {
                        [equipmentItemView setSeperatorGapped:YES];
                    }
                    RequirementEquipment *equipment = _detailInfo.equipment[position];
                    [equipmentItemView setInfoWithCode:equipment.eqCode name:equipment.eqName location:nil];
                }
            } else {
                isFooter = YES;
            }
            break;
            
        case REQUIREMENT_DETAIL_SECTION_ATTACHMENT:
            if(_detailInfo.attachment && position < [_detailInfo.attachment count]) {
                //附件
                RequirementAttachment * attachment = _detailInfo.attachment[position];
                cellIdentifier = @"CellAttachment";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } else {
                    NSArray *subViews = [cell subviews];
                    for (UIView *view in subViews) {
                        if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if (cell) {
                    [cell.textLabel setText:attachment.fileName];
                    cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
                    cell.textLabel.font = [FMFont getInstance].font42;
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if (seperator) {
                    if (position < _detailInfo.attachment.count - 1) {
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake([FMSize getInstance].defaultPadding, _orderItemHeight-[FMSize getInstance].seperatorHeight, width-[FMSize getInstance].defaultPadding*2, [FMSize getInstance].seperatorHeight)];
                    } else {
                        [seperator setDotted:NO];
                        [seperator setFrame:CGRectMake(0, _orderItemHeight-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
                    }
                }
            } else {
                isFooter = YES;
            }
        default:
            break;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        SeperatorView * footerView;
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[SeperatorView class]]) {
                    footerView = subView;
                }
            }
        }
        if(cell && !footerView) {
            footerView = [[SeperatorView alloc] init];
            [cell addSubview:footerView];
        }
        if(footerView) {
            [footerView setFrame:CGRectMake(0, 0, width, _footerHeight)];
            if(position > 0) {
                [footerView setShowTopBound:YES];
            } else {
                [footerView setShowTopBound:NO];
            }
        }
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RequirementDetailSectionType sectionType = [self getSectionTypeBy:section];
    CGFloat width = _realWidth;
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    
    switch(sectionType) {
        case REQUIREMENT_DETAIL_SECTION_BASE:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_info" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        case REQUIREMENT_DETAIL_SECTION_CONTENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_content" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowEdit:NO];
            
            if(_detailInfo && (_detailInfo.status == REQUIREMENT_STATUS_PROCESS || _detailInfo.status == REQUIREMENT_STATUS_FINISH)) {
                if(_editable && !_commentable) {
                    [headerView setShowEdit:YES];
                    [headerView setOnClickListener:self];
                } else {
                    [headerView setShowEdit:NO];
                    [headerView setOnClickListener:nil];
                }
            }
            break;
        case REQUIREMENT_DETAIL_SECTION_ORDER:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_order" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
            
        case REQUIREMENT_DETAIL_SECTION_EQUIPMENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_section_title_equipment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
            
        case REQUIREMENT_DETAIL_SECTION_ATTACHMENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_attachment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
            
        case REQUIREMENT_DETAIL_SECTION_RECORD:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_record" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
//            if(_editable) {
//                [headerView setShowAdd:YES];
//                [headerView setOnClickListener:self];
//            }
            break;
        
        default:
            break;
    }
    headerView.tag = sectionType;
    return headerView;
}


#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    RequirementDetailSectionType sectionType = [self getSectionTypeBy:indexPath.section];
    if(_detailInfo) {
        switch (sectionType) {
            case REQUIREMENT_DETAIL_SECTION_CONTENT:
                if(_detailInfo.status == REQUIREMENT_STATUS_PROCESS || _detailInfo.status == REQUIREMENT_STATUS_FINISH) {
                    if(_editable && !_commentable) {
                        [self gotoEditContent];
                    }
                }
                break;
            case REQUIREMENT_DETAIL_SECTION_ORDER:
                if(position < [_detailInfo.orders count]) {
                    [self gotoWorkOrderDetail:position];
                }
                break;
                
            case REQUIREMENT_DETAIL_SECTION_ATTACHMENT:
                if(position < [_detailInfo.attachment count]) {
                    [self gotoAttachmentDetail:position];
                }
                break;
            default:
                break;
        }
    }
}

- (void) onOrderClicked:(UIButton *) sender {
    NSInteger position = sender.tag;
    if(position < [_detailInfo.orders count]) {
        [self gotoWorkOrderDetail:position];
    }
}

- (void) onClick:(UIView *)view {
    if ([view isKindOfClass:[BaseAlertView class]]) {
        [_centerAlertView close];
    } else if([view isKindOfClass:[TaskAlertView class]]) {
        if(_isWorking) {
            [self resetWorking];
        }
    } else if([view isKindOfClass:[MarkedListHeaderView class]]) {
        RequirementDetailSectionType sectionType = view.tag;
        switch (sectionType) {
            case REQUIREMENT_DETAIL_SECTION_CONTENT:
                [self gotoEditContent];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 监听点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    
    if ([view isKindOfClass:[RequirementEvaluateView class]]) {
        if(subView) {
            RequirementEvaluateType type = subView.tag;
            switch(type) {
                case REQUIREMENT_EVALUATE_TYPE_OK:
                    _gradeDesc = [_evaluateContentView getCommentOfSelectedSatisfaction];
                    _gradeId = [_evaluateContentView getSelectedSatisfaction].sdId;
//                    [self submitEvaluateInfo];
                    [self resetWorking];
                    break;
                default:
                    [self resetWorking];
                    break;
            }
        }
    }
    else if ([view isKindOfClass:[RequirementAudioRecordView class]]) {
        NSInteger index = subView.tag;
        NSInteger count = _detailInfo.audios.count;
        if (index >= 0 && index < count) {
            [self gotoPlayAudio:index];
        }
    }
    else if ([view isKindOfClass:[AudioPlayAlertView class]]) {
        NSInteger tag = subView.tag;
        PlayBtnType type = tag;
        switch (type) {
            case PLAY_BUTTON_TYPE_PLAY:
                NSLog(@"你点击了语音控制界面的播放按钮");
                [self playAudioWith:_playFileURL];
                break;
            case PLAY_BUTTON_TYPE_STOP:
                NSLog(@"你点击了语音控制界面的暂停按钮");
                [self pauseRecord];
                break;
            default:
                break;
        }
    }
    else if ([view isKindOfClass:[RequirementDetailBaseInfoView class]]) {
        if (subView.tag == Requirement_EVENT_PHONE) {
            [self tryToTakeCall];
        }
    }
}



//创建工单
- (void) onCreateOrderClicked {
    [self gotoCreateOrder];
}

//审核通过
- (void) onApprovalSuccessClicked {
    NSLog(@"审核通过");
    [self showLoadingDialog];
    RequirementOperateRequestParam * param = [[RequirementOperateRequestParam alloc] initWithReqId: _detailInfo.reqId
                                                                                             grade: nil
                                                                                              desc: _detailInfo.desc
                                                                                       operateType: REQUIREMENT_OPERAITON_TYPE_PASS];
    [_business passApprovalOperateTypeByparam:param Success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self finish];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//生成工单
- (void) onProductOrderClicked {
    [self gotoCreateOrder];
}



//检测需求相关工单是否都已经完成
- (BOOL) checkOrdersFinished {
    BOOL res = YES;
    if([_detailInfo.orders count] > 0) {
        for(RequirementOrder * order in _detailInfo.orders) {
            if(order.status != ORDER_STATUS_VALIDATATION && order.status != ORDER_STATUS_CLOSE) {
                res = NO;
                break;
            }
        }
    }
    return res;
}

//保存
- (void) onSaveClicked {
    [self showLoadingDialog];
    RequirementOperateRequestParam * param = [[RequirementOperateRequestParam alloc] initWithReqId:_detailInfo.reqId
                                                                                             grade:nil
                                                                                              desc:_comment
                                                                                       operateType:REQUIREMENT_OPERAITON_TYPE_SAVE];
    [_business saveOperateTypeByparam:param Success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self finish];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//完成
- (void) onFinishClicked {
    _isWorking = NO;
    [_infoView close];
    if([self checkOrdersFinished]) {
        [self showLoadingDialog];
        RequirementOperateRequestParam * param = [[RequirementOperateRequestParam alloc] initWithReqId: _detailInfo.reqId
                                                                                                 grade: nil
                                                                                                  desc: _comment
                                                                                           operateType: REQUIREMENT_OPERAITON_TYPE_FINISH];
        [_business finishOperateTypeByparam:param Success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            [self finish];
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"requirement_order_unfinished" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    
}

//评价
//- (void) submitEvaluateInfo {
//    [self showLoadingDialog];
//    RequirementOperateRequestParam * param = [[RequirementOperateRequestParam alloc] initWithReqId:_detailInfo.reqId
//                                                                                             grade:_gradeId
//                                                                                              desc:_gradeDesc
//                                                                                       operateType:REQUIREMENT_OPERAITON_TYPE_SATISFACTION];
//    [_business evaluateOperateTypeByparam:param Success:^(NSInteger key, id object) {
//        [self hideLoadingDialog];
//        [self finish];
//    } fail:^(NSInteger key, NSError *error) {
//        [self hideLoadingDialog];
//        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//    }];
//}

#pragma mark - 处理信息
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        
        if([strOrigin isEqualToString:NSStringFromClass([RequireDetailAddContentViewController class])]) {
            NSString * content = [msg valueForKeyPath:@"result"];
            if(!(content == _comment || (_comment && content && [_comment isEqualToString:content]))) {
                _comment = content;
            }
        }
        else if([strOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"menuType"];
            MenuAlertViewType type = [tmpNumber integerValue];
            NSInteger position;
            switch(type) {
                case MENU_ALERT_TYPE_NORMAL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    position = tmpNumber.integerValue;
                    if(position < [_actionHandlerArray count]) {
                        
                        ActionHandler handler = _actionHandlerArray[position];
                        handler(nil);
                    }
                    break;
                case MENU_ALERT_TYPE_CANCEL:
                    _isWorking = NO;
                    [_infoView close];
                    break;
            }
        }
        else if ([strOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            tmpNumber = [msg valueForKeyPath:@"tag"];
            NSInteger tag = tmpNumber.integerValue;
            if(tag == DISPLAY_TYPE_IMAGE) {
                switch (type) {
                    case PHOTO_ACTION_SHOW_DETAIL:
                        tmpNumber = [msg valueForKeyPath:@"result"];
                        [_photoHelper setPhotos:_photoArray];
                        [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                        break;
                    default:
                        break;
                }
            } else if(tag == DISPLAY_TYPE_VIDEO) {
                PhotoItem * item = [[PhotoItem alloc] init];
                switch (type) {
                    case PHOTO_ACTION_SHOW_DETAIL:
                        tmpNumber = [msg valueForKeyPath:@"result"];
                        item = _videoPhotoArray[tmpNumber.integerValue];
                        [self gotoPlayVideo:item];
                        break;
                    default:
                        break;
                }
            }
        }
        else if ([strOrigin isEqualToString:NSStringFromClass([BaseRequest class])]) {
            
        }
        else if ([strOrigin isEqualToString:@"RequirementDetailEvaluateViewController"]) {
            NSNumber *tmpNumber = [msg valueForKeyPath:@"result"];
            if (tmpNumber.boolValue) {
                //刷新页面并且设置editable为NO
                _editable = NO;
                [self setMenuWithArray:nil];
                [self updateNavigationBar];
            }
        }
        
    }
}

- (void) pauseRecord{
    [self stopPlaying];
}


//停止播放，释放资源，取消监听
- (void) stopPlaying {
    if(_playerItem) {
        if(_playerItem) {
            [_playerItem removeObserver:self forKeyPath:@"status"];
        }
        _playerItem = nil;
    }
    [_audioPalyer replaceCurrentItemWithPlayerItem:nil];
}


//用于录音界面展示中的播放暂停
- (void) playAudioWith:(NSURL*) url {
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        if(_playerItem) {
            [_playerItem removeObserver:self forKeyPath:@"status"];
        }
        _playerItem = [AVPlayerItem playerItemWithURL:url];
        
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
        
        if(_audioPalyer) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        }
        _audioPalyer = [AVPlayer playerWithPlayerItem:_playerItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        
        [_audioPalyer play];
    });
}

- (void) audioDidEnd:(id) obj {
    NSLog(@"音频播放完成");
    [_playerItem removeObserver:self forKeyPath:@"status"];
    _playerItem = nil;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            //            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
//            CGFloat totalSecond = _playerItem.duration.value / _playerItem.duration.timescale;// 转换成秒
            //            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    }
}

#pragma --- 跳转
//编辑处理内容
- (void) gotoEditContent {
    RequireDetailAddContentViewController * contentVC;
    contentVC = [[RequireDetailAddContentViewController alloc] init];
    [contentVC setContent:_comment];
    [contentVC setOnMessageHandleListener:self];
    [self gotoViewController:contentVC];
}

//跳转到工单查看
- (void) gotoWorkOrderDetail:(NSInteger) position {
    RequirementOrder * order = _detailInfo.orders[position];
    WorkOrderDetailViewController * detailVC = [[WorkOrderDetailViewController alloc] init];
    [detailVC setWorkOrderWithId:order.woId];
    [detailVC setReadOnly:YES];
    [self gotoViewController:detailVC];
}

//跳转到附件查看
- (void) gotoAttachmentDetail:(NSInteger) position {
    RequirementAttachment *attachment = _detailInfo.attachment[position];
    NSURL *attachmentURL = [FMUtils getUrlOfAttachmentById:attachment.fileId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentURL];
    [attachmentVC setTitleByFileName:attachment.fileName];
    [self gotoViewController:attachmentVC];
}

//播放音视频
- (void) gotoPlayVideo:(PhotoItem *) item {
    MediaViewController * mediaVC = [[MediaViewController alloc] init];
    [mediaVC setUrl:item.originUrl];
    [self gotoViewController:mediaVC];
}

- (void) tryToTakeCall {
    NSMutableArray * phones = [NSMutableArray new];
    if (![FMUtils isStringEmpty:_detailInfo.telephone]) {
        [phones addObject:_detailInfo.telephone];
    }
    
    [_phoneContentView setPhones:phones];
    [_centerAlertView setContentHeight:[_phoneContentView getSuitableHeight]];
    [_centerAlertView show];
}

//播放音频
- (void) gotoPlayAudio:(NSInteger) position {
//    NSString * strUrl = @"http://www.w3school.com.cn/i/song.mp3";
//    NSURL *url = [NSURL URLWithString:strUrl];
    _isWorking = YES;
    _playFileURL = _audioArray[position];
    NSNumber *durationSeconds = _audioDuriationTimesArray[position];
    
    [self showLoadingDialog];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(durationSeconds.floatValue == 0) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"load_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [self hideLoadingDialog];
            [_audioPlayAlertView clearAll];
            [_audioPlayAlertView setDurationTime:durationSeconds.floatValue];
            [_infoView setContentHeight:self.view.frame.size.height*2/5 withKey:@"audioPlay"];
            [_infoView showType:@"audioPlay"];
            [_infoView show];
        }
    });
}

//创建工单
- (void) gotoCreateOrder {
    _isBackFromReport = YES;
    NewReportViewController * reportVC = [[NewReportViewController alloc] init];
    [reportVC setInfoWithRequestorId:_detailInfo.requester.userId
                                name:_detailInfo.requester.name
                               telno:_detailInfo.telephone
                       requirementId:_detailInfo.reqId
                      andDescContent:_detailInfo.desc
                           andPhotos:_photoArray];
    [self gotoViewController:reportVC];
}

#pragma mark - 评分
- (void) evaluateRequirement {
//    _isWorking = YES;
//    if (_satisfactionArray.count == 0) {
//        [self resetWorking];
//        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"requirement_satisfaction_no_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//    } else {
//        CGFloat evaluateHeight = [RequirementEvaluateView calculateHeightBySatisfactionArrayCount:_satisfactionArray.count];
//        [_infoView setContentHeight:evaluateHeight withKey:@"evaluate"];
//        [_infoView showType:@"evaluate"];
//        [_infoView show];
//    }
    
    RequirementDetailEvaluateViewController *evaluateVC = [[RequirementDetailEvaluateViewController alloc] init];
    [evaluateVC setInfoWithRequirementId:_reqId];
    [evaluateVC setOnMessageHandleListener:self];
    [self gotoViewController:evaluateVC];
}

- (void) resetWorking {
    if(_isWorking) {
        _isWorking = NO;
        if(_audioPalyer) {
            [self stopPlaying];
        }
        [_infoView close];
    }
}


#pragma --- 键盘显示和隐藏
- (void)keyboardWasShown:(NSNotification*)aNotification {
    if(_isWorking) {
        NSDictionary *info = [aNotification userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;
        if(keyboardSize.height > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = CGRectMake(0, 0, _realWidth, self.view.frame.size.height-keyboardSize.height);
                [_infoView setFrame:frame];
            }];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if(_isWorking) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            _infoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
}

@end
