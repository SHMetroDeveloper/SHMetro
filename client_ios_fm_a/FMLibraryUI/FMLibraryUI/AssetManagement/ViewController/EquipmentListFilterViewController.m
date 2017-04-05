//
//  EquipmentListFilterViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentListFilterViewController.h"
#import "REFrostedViewController.h"
#import "BaseDataEntity.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "FMUtilsPackages.h"
#import "FilterSelectView.h"
#import "FMUtilsPackages.h"
#import "UIButton+Bootstrap.h"
#import "FilterSelectView.h"
#import "SeperatorView.h"
#import "AssetManagementConfig.h"
#import "BaseLabelView.h"
#import "InfoSelectViewController.h"
#import "FMTheme.h"

typedef NS_ENUM(NSInteger, TextFieldType) {
    TEXT_FIELD_CODE,  //设备编码
    TEXT_FIELD_BASEINFO,  //基本信息
    TEXT_FIELD_LOCATION,  //位置
    TEXT_FIELD_CLASSIFICATION,  //系统分类
};


typedef NS_ENUM(NSInteger, EquipmentFilterSectionType) {
    EQUIPMENT_FILTER_SECTION_UNKNOW,    //未知
    EQUIPMENT_FILTER_SECTION_CODE,      //设备编码
    EQUIPMENT_FILTER_SECTION_BASE,      //基本信息
    EQUIPMENT_FILTER_SECTION_LOCATION,  //位置
    EQUIPMENT_FILTER_SECTION_SYSTEM,    //系统分类
    EQUIPMENT_FILTER_SECTION_STATUS     //设备状态
};

@interface EquipmentListFilterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UIView * controlView;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITextField * codeField;
@property (nonatomic, strong) UITextField * baseInfoField;
@property (nonatomic, strong) BaseLabelView * locationLbl;
@property (nonatomic, strong) UITextField * classifyField;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * selectedArray;

@property (nonatomic, strong) Position * location;
@property (nonatomic, strong) NSString * strLocation;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;


@end

@implementation EquipmentListFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLayout {
    if (!_statusArray) {
        _statusArray = [NSMutableArray new];
    } else {
        [_statusArray removeAllObjects];
    }
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_IDLE]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_STOP]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_USING]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_SCRAPING]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_SCRAP]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_REPAIRING]];
    [_statusArray addObject:[NSNumber numberWithInteger:EQUIP_STATUS_LOCKED]];
    
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    } else {
        [_selectedArray removeAllObjects];
    }
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];    //不限
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];    //
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];

    
    
    CGFloat controlHeight = [FMSize getInstance].bottomControlHeight;
    controlHeight = 60;
    CGRect frame = [self getContentFrame];
    CGFloat originX = 0;
    CGFloat originY = 0;
    frame.size.width -= 80.0f;
    frame.size.height -= [FMSize getInstance].statusbarHeight + [FMSize getInstance].navigationbarHeight;
    
    _headerHeight = [FMSize getInstance].selectHeaderHeight;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    //tableView的初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-controlHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //按钮控制View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-controlHeight, frame.size.width, controlHeight)];
    _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    CGFloat btnHeight = [FMSize getInstance].selectListItemHeight;;
    CGFloat sepHeight = (controlHeight - btnHeight)/2;
    CGFloat btnWidth = (_controlView.frame.size.width - sepHeight*3)/2;
    originY = sepHeight;
    originX = sepHeight;
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
    [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_reset" inTable:nil] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    [_cancelBtn grayStyle];
    _cancelBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.masksToBounds = YES;
    
    [_cancelBtn addTarget:self action:@selector(onResetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX + sepHeight + btnWidth, originY, btnWidth, btnHeight)];
    [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
    [_doneBtn setBackgroundColor:[UIColor colorWithRed:97/255.0 green:184/255.0 blue:41/255.0 alpha:1]];
    [_doneBtn successStyle];
    _doneBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    _doneBtn.layer.cornerRadius = 3;
    _doneBtn.layer.masksToBounds = YES;
    [_doneBtn addTarget:self action:@selector(onOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_controlView addSubview:_cancelBtn];
    [_controlView addSubview:_doneBtn];
    
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    
    [_mainContainerView addSubview:_tableView];
    [_mainContainerView addSubview:_controlView];
    
    [self.view addSubview:_mainContainerView];
}

- (EquipmentFilterSectionType) getSectionTypeBySection:(NSInteger) section {
    EquipmentFilterSectionType sectionType = EQUIPMENT_FILTER_SECTION_UNKNOW;
    switch(section) {
        case 0:
            sectionType = EQUIPMENT_FILTER_SECTION_CODE;
            break;
        case 1:
            sectionType = EQUIPMENT_FILTER_SECTION_BASE;
            break;
        case 2:
            sectionType = EQUIPMENT_FILTER_SECTION_LOCATION;
            break;
        case 3:
            sectionType = EQUIPMENT_FILTER_SECTION_SYSTEM;
            break;
        case 4:
            sectionType = EQUIPMENT_FILTER_SECTION_STATUS;
            break;
    }
    return sectionType;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    EquipmentFilterSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case EQUIPMENT_FILTER_SECTION_CODE:
            count = 1;
            break;
        case EQUIPMENT_FILTER_SECTION_BASE:
            count = 1;
            break;
        case EQUIPMENT_FILTER_SECTION_LOCATION:
            count = 1;
            break;
        case EQUIPMENT_FILTER_SECTION_SYSTEM:
            count = 1;
            break;
        case EQUIPMENT_FILTER_SECTION_STATUS:
            count = [_selectedArray count];  //多了一个不限
            break;
    }
    return  count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    EquipmentFilterSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch(sectionType) {
        case EQUIPMENT_FILTER_SECTION_CODE:
            height = [FMSize getInstance].selectListItemHeight;  //设备编码
            break;
        case EQUIPMENT_FILTER_SECTION_BASE:
            height = [FMSize getInstance].selectListItemHeight;  //基本信息
            break;
        case EQUIPMENT_FILTER_SECTION_LOCATION:
            height = [FMSize getInstance].selectListItemHeight;  //安装位置
            break;
        case EQUIPMENT_FILTER_SECTION_SYSTEM:
            height = [FMSize getInstance].selectListItemHeight;  //系统分类
            break;
        case EQUIPMENT_FILTER_SECTION_STATUS:
            height = [FMSize getInstance].selectListItemHeight;  //设备状态
            break;
    }
    return height;
}

#pragma mark - UITableView Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    CGFloat width = tableView.frame.size.width;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 0;
    
    static NSString * cellIdentifier = @"CellIdentifer";
    UITableViewCell * cell = nil;
    SeperatorView * seperator = nil;
    FilterSelectView * statusSelectItemView = nil;
//    _codeField = nil;
//    _baseInfoField = nil;
//    _locationField = nil;
//    _classifyField = nil;
    
    
    NSString * title = nil;
    
    
    EquipmentFilterSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case EQUIPMENT_FILTER_SECTION_CODE:
            cellIdentifier = @"codeCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                        break;
                    }
                }
            }
            if (cell && !_codeField) {
                _codeField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 0, width-padding, itemHeight)];
                _codeField.font = [FMFont getInstance].font38;
                _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _codeField.placeholder = [[BaseBundle getInstance] getStringByKey:@"textfield_placeholder_code" inTable:nil];
                _codeField.tag = TEXT_FIELD_CODE;
                [cell addSubview:_codeField];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            break;
        case EQUIPMENT_FILTER_SECTION_BASE:
            cellIdentifier = @"baseinfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                        break;
                    }
                }
            }
            if (cell && !_baseInfoField) {
                _baseInfoField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 0, width-padding, itemHeight)];
                _baseInfoField.font = [FMFont getInstance].font38;
                _baseInfoField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _baseInfoField.placeholder = [[BaseBundle getInstance] getStringByKey:@"textfield_placeholder_baseinfo" inTable:nil];
                _baseInfoField.tag = TEXT_FIELD_BASEINFO;
                [cell addSubview:_baseInfoField];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            break;
        case EQUIPMENT_FILTER_SECTION_LOCATION:
            cellIdentifier = @"locationCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if (cell && !_locationLbl) {
                _locationLbl = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [_locationLbl setContent:[[BaseBundle getInstance] getStringByKey:@"textfield_placeholder_location" inTable:nil]];
                [_locationLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
                [cell addSubview:_locationLbl];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            break;
        case EQUIPMENT_FILTER_SECTION_SYSTEM:
            cellIdentifier = @"classificationCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                        break;
                    }
                }
            }
            if (cell && !_classifyField) {
                _classifyField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 0, width-padding, itemHeight)];
                _classifyField.font = [FMFont getInstance].font38;
                _classifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _classifyField.placeholder = [[BaseBundle getInstance] getStringByKey:@"textfield_placeholder_classification" inTable:nil];
                _classifyField.tag = TEXT_FIELD_CLASSIFICATION;
                [cell addSubview:_classifyField];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            break;
        case EQUIPMENT_FILTER_SECTION_STATUS:
            cellIdentifier = @"statusSelect";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (position == 0) {
                title = [[BaseBundle getInstance] getStringByKey:@"filter_no_limits" inTable:nil];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                NSNumber * nstatus = _statusArray[position-1];
                EquipmentStatus status = nstatus.integerValue;
                title = [AssetManagementConfig getEquipmentStatusStrByStatus:status];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[FilterSelectView class]]) {
                        statusSelectItemView = (FilterSelectView *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !statusSelectItemView) {
                statusSelectItemView = [[FilterSelectView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [cell addSubview:statusSelectItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (position == _statusArray.count) {
                    [seperator setDotted:NO];
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                } else {
                    [seperator setDotted:YES];
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                }
            }
            if (statusSelectItemView) {
                [statusSelectItemView setTitleInfoWith:title];
                NSNumber * tmpNumber = _selectedArray[position];
                [statusSelectItemView setChecked:tmpNumber.boolValue];
            }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = _headerHeight;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _headerHeight)];
    titleView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    UILabel * titleLbl = [[UILabel alloc] init];
    CGFloat padding = [FMSize getInstance].padding50;
    
    titleLbl.font = [FMFont getInstance].font44;
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    [titleLbl setFrame:CGRectMake(padding, [FMSize getInstance].padding70, 80, 19)];
    
    EquipmentFilterSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case EQUIPMENT_FILTER_SECTION_CODE:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_filter_code" inTable:nil];
            break;
        case EQUIPMENT_FILTER_SECTION_BASE:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_filter_base_info" inTable:nil];
            break;
        case EQUIPMENT_FILTER_SECTION_LOCATION:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_filter_location" inTable:nil];
            break;
        case EQUIPMENT_FILTER_SECTION_SYSTEM:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_filter_classification" inTable:nil];
            break;
        case EQUIPMENT_FILTER_SECTION_STATUS:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"asset_filter_status" inTable:nil];
            break;
    }
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01;
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    EquipmentFilterSectionType sectionType = [self getSectionTypeBySection:section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch(sectionType) {
        case EQUIPMENT_FILTER_SECTION_STATUS:
            if(position == 0) {
                _selectedArray[0] = [NSNumber numberWithBool:YES];
                for(NSInteger index = 1;index<[_selectedArray count];index++) {
                    _selectedArray[index] = [NSNumber numberWithBool:NO];
                }
            } else {
                NSNumber * selected = _selectedArray[position];
                _selectedArray[0] = [NSNumber numberWithBool:NO];
                _selectedArray[position] = [NSNumber numberWithBool:!selected.boolValue];
            }
            [_tableView reloadData];
            break;
        case EQUIPMENT_FILTER_SECTION_LOCATION:
            [self gotoSelectLocation];
            break;
            
        default:
            break;
    }
    
}

- (void) handleResult {
    NSString * code = nil;
    NSString * baseinfo = nil;
    NSString * classification = nil;
    if (![FMUtils isStringEmpty:_codeField.text]) {
        code = _codeField.text;
    }
    if (![FMUtils isStringEmpty:_baseInfoField.text]) {
        baseinfo = _baseInfoField.text;
    }
    if (![FMUtils isStringEmpty:_classifyField.text]) {
        classification = _classifyField.text;
    }
    
    NSMutableArray * statusArray = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSNumber * tmpNumber = _selectedArray[0];
    
    if(!tmpNumber.boolValue) {
        for (index=0; index<[_selectedArray count]; index++) {
            tmpNumber = _selectedArray[index];
            if (tmpNumber.boolValue) {
                [statusArray addObject:_statusArray[index -1]];
            }
        }
    }
    
    if (_handler) {
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    NSString * strOrigin = NSStringFromClass([self class]);
    [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
    
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    [result setValue:code forKeyPath:@"code"];
    [result setValue:baseinfo forKeyPath:@"baseinfo"];
    [result setValue:_location forKeyPath:@"location"];
    [result setValue:classification forKeyPath:@"classification"];
    [result setValue:statusArray forKeyPath:@"statusArray"];
    
    [msg setValue:result forKeyPath:@"result"];
    
    [_handler handleMessage:msg];
        
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) onResetBtnClick {
    for (NSInteger i = 0; i < _selectedArray.count; i ++) {
        [_selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    [_codeField setText:nil];
    [_baseInfoField setText:nil];
    [_classifyField setText:nil];
    [_locationLbl setContent:[[BaseBundle getInstance] getStringByKey:@"textfield_placeholder_location" inTable:nil]];
    [_locationLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7]];
    _location = nil;
    [_tableView reloadData];
}

- (void) onOkBtnClick {
    [self handleResult];
    [self.frostedViewController hideMenuViewController];
}


- (void) gotoSelectLocation {
    InfoSelectViewController * infoVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_LOCATION_INFO_SELECT];
    [infoVC setOnMessageHandleListener:self];
    [self gotoViewController:infoVC];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            NSDictionary * res = [msg valueForKeyPath:@"result"];
            _location = [res valueForKeyPath:@"position"];
            _strLocation = [res valueForKeyPath:@"positionName"];
            [_locationLbl setContent:_strLocation];
            [_locationLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        }
    }
}
@end
