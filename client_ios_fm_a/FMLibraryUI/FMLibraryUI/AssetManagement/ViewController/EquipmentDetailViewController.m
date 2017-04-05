//
//  EquipmentDetailViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentDetailViewController.h"
#import "AssetEquipmentDetailEntity.h"
#import "AssetManagementBusiness.h"
#import "EquipmentDetailHelper.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import "TaskAlertView.h"
#import "PhotoItemContentView.h"
#import "PhotoItemModel.h"
#import "ImageItemView.h"
#import "WorkOrderDetailViewController.h"
#import "PhotoShowHelper.h"
#import "FMTheme.h"
#import "EquipmentCoreComponentDetailViewController.h"
#import "PatrolDBHelper.h"
#import "SystemConfig.h"
#import "EquipmentUndoPatrolModel.h"
#import "PatrolCheckViewController.h"
#import "QuickReportViewController.h"
#import "UserBusiness.h"
#import "AttendanceRecordEntity.h"
#import "BaseDataDbHelper.h"
#import "ContractDetailViewController.h"
#import "WorkOrderDetailViewController.h"
#import "PatrolTaskHistoryDetailViewController.h"

@interface EquipmentDetailViewController ()<OnClickListener, OnItemClickListener,OnMessageHandleListener>

@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) PullTableView *tableView;
@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, strong) TaskAlertView * alertView;
@property (nonatomic, strong) PhotoItemContentView * photoContentView;
@property (nonatomic, assign) BOOL isWorking;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, assign) CGFloat alertViewHeight;
@property (nonatomic, assign) CGFloat photoContentHeight;

@property (nonatomic, strong) __block NSNumber *equipmentId;
@property (nonatomic, strong) __block NSNumber *eqId;
@property (nonatomic, strong) __block NSString *uuid;

@property (nonatomic, strong) EquipmentDetailHelper * tableViewHelper;
@property (nonatomic, strong) PhotoShowHelper *photoHelper; //图片展示
@property (nonatomic, strong) PatrolDBHelper *dbHelper;

@property (nonatomic, strong) AssetManagementBusiness * business;
@property (nonatomic, strong) __block NSMutableArray *undoPatrolArray;
@property (nonatomic, strong) __block NSMutableArray *undoWorkorderArray;

@property (nonatomic, strong) DBPatrolSpot * spot;
@property (nonatomic, assign) __block BOOL needUpdate;
@property (nonatomic, assign) __block BOOL editable;

@property (nonatomic, assign) __block AssetManagementDetailShowType showType;  //展示类型
@property (nonatomic, strong) AttendanceRecordEntity * attendanceRecord; // 最后一次签到记录
@end

@implementation EquipmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBusiness];
    [self requestData];
    [self initAlertView];
    [self requestLastRecord];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        _needUpdate = NO;
        [self queryUndoPatrolTask];
        [self updateList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(_spot.finish && _spot.finish.boolValue) {
        if(!_spot.finishEndDateTime || [_spot.finishEndDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            _spot.finishEndDateTime = [FMUtils getTimeLongNow];
            [_dbHelper updatePatrolSpotById:_spot.id patrolSpot:_spot];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithEquipmentID:(NSNumber * ) equID {
    self = [super init];
    if (self) {
        _equipmentId = [equID copy];
    }
    return self;
}

- (void) setUuid:(NSString *)uuid {
    _uuid = uuid;
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _btnWidth = 60;
//    _photoContentHeight = 180;
    _photoContentHeight = [PhotoItemContentView getContentHeightByModelCount:6];
    _alertViewHeight = CGRectGetHeight(self.view.frame);
    _noticeHeight = [FMSize getInstance].noticeHeight;
    
    _tableViewHelper = [[EquipmentDetailHelper alloc] initWithContext:self];
    [_tableViewHelper setOnMessageHandleListener:self];
    
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
    _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = _tableViewHelper;
    _tableView.dataSource = _tableViewHelper;
    _tableView.pullDelegate = self;
    _tableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
    _tableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _tableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    
    
    _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
    [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"maintenance_notice_no_order" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
    
    [_noticeLbl setHidden:YES];
    [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
    [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-padding-_btnWidth, _realHeight-padding-_btnWidth, _btnWidth, _btnWidth)];
    [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_more_normal"] forState:UIControlStateNormal];
    [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_more_highlight"] forState:UIControlStateHighlighted];
    [_moreBtn addTarget:self action:@selector(onMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.layer.cornerRadius = _btnWidth/2;
    
    
    _photoContentView = [[PhotoItemContentView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _photoContentHeight)];
    [_photoContentView setOnItemClickListener:self];
    
    
    [_mainContainerView addSubview:_tableView];
    [_mainContainerView addSubview:_noticeLbl];
    [_mainContainerView addSubview:_moreBtn];
    
    [self.view addSubview:_mainContainerView];
}

- (void) initBusiness {
    _business = [AssetManagementBusiness getInstance];
    _dbHelper = [PatrolDBHelper getInstance];
    _undoPatrolArray = [NSMutableArray new];
    _undoWorkorderArray = [NSMutableArray new];
}

- (void) initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat contentHeight = _photoContentHeight;
    [_alertView setContentView:_photoContentView withKey:@"type" andHeight:contentHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"asset_equipment_detail" inTable:nil]];
    [self setBackAble:YES];
    if (_editable) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"function_quick_report" inTable:nil]]];
    } else {
        [self setMenuWithArray:nil];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    [self gotoQucikReport];
}

- (void) workWithShowType:(AssetRecordQueryType) type {
    [self showLoadingDialog];
    if(!_tableView.pullTableIsRefreshing) {
        _tableView.pullTableIsRefreshing = YES;
    }
    [self queryListByType:type];
}

- (void)queryUndoPatrolTask {
    NSNumber *userId = [SystemConfig getUserId];
    NSMutableArray *deviceArray = [_dbHelper queryAllValidDBPatrolDevicesById:_eqId andUserId:userId];
    NSMutableArray *undoPatrolModelArray = [NSMutableArray new];
    NSMutableArray *undoPatrolSpotArray = [NSMutableArray new];
    for (DBPatrolDevice *device in deviceArray) {
        EquipmentUndoPatrolModel *patrolModel = [[EquipmentUndoPatrolModel alloc] init];
        patrolModel.projectId = device.projectId;
        patrolModel.userId = device.userId;
        patrolModel.taskId = device.patrolTask.patrolTaskId;
        patrolModel.taskName = device.patrolTask.patrolTaskName;
        patrolModel.deviceId = device.deviceId;
        patrolModel.deviceName = device.name;
        patrolModel.finished = device.finish.boolValue;
        
        undoPatrolSpotArray = [_dbHelper queryAllDBPatrolSpotsOf:device.patrolTask.patrolTaskId andUserId:userId];
        for (DBPatrolSpot *spot in undoPatrolSpotArray) {
            if ([device.spotId isEqualToNumber:spot.id]) {
                patrolModel.spotId = spot.spotId;
                patrolModel.spotName = spot.name;
                
                [undoPatrolModelArray addObject:patrolModel];
                [_undoPatrolArray addObject:spot];
            }
        }
    }
    [_tableViewHelper setUndoPatrol:undoPatrolModelArray];
}

- (void)canBeEaitableByprojectId:(NSNumber *)projectId {
    NSNumber *curProjectId = [SystemConfig getCurrentProjectId];
    if (![FMUtils isNumberNullOrZero:projectId]) {
        if (![curProjectId isEqualToNumber:projectId]) {
            _editable = NO;
        } else {
            _editable = YES;
        }
    } else {
        _editable = NO;
    }
    if (_editable) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"function_quick_report" inTable:nil]]];
    } else {
        [self setMenuWithArray:nil];
    }
    [self updateNavigationBar];
}

#pragma mark - Net Working
//获取设备全部参数
- (void) requestData {
    if (_equipmentId) {
        [self requestDataByEquipmentId];
    } else if (_uuid) {
        [self requestDataByUuid];
    }
}

- (void) requestDataByEquipmentId {
    [self showLoadingDialog];
    AssetEquipmentDetailRequestParam * param = [[AssetEquipmentDetailRequestParam alloc] initWithEquipmentId:_equipmentId];
    __weak typeof(self) weakSelf = self;
    [_business getEquipmentDetail:param Success:^(NSInteger key, id object) {
        AssetEquipmentDetailEntity *entity = object;
        [weakSelf canBeEaitableByprojectId:entity.projectId];
        weakSelf.eqId = entity.eqId;
        [weakSelf.tableViewHelper setEquipmentDetailInfo:entity];
        [weakSelf queryUndoPatrolTask];
        [weakSelf getUndoWorkorderList];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) requestDataByUuid {
    [self showLoadingDialog];
    AssetEquipmentDetailQrcodeRequestParam * param = [[AssetEquipmentDetailQrcodeRequestParam alloc] initWithUUID:_uuid];
    __weak typeof(self) weakSelf = self;
    [_business getEquipmentDetailByQrCode:param Success:^(NSInteger key, id object) {
        AssetEquipmentDetailEntity * entity = object;
        if (![FMUtils isNumberNullOrZero:entity.eqId]) {
            weakSelf.eqId = entity.eqId;
            [weakSelf.tableViewHelper setEquipmentDetailInfo:entity];
            [weakSelf queryUndoPatrolTask];
            [weakSelf getUndoWorkorderList];
            [weakSelf updateList];
            [weakSelf hideLoadingDialog];
        } else {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_no_match_notice" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf finish];
            });
        }
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_no_match_notice" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf finish];
        });
    }];
}

//查询待处理工单
- (void)getUndoWorkorderList {
    AssetUndoWorkOrderRequestParam *param = [[AssetUndoWorkOrderRequestParam alloc] init];
    param.eqId = _eqId;
    __weak typeof(self) weakSelf = self;
    [_business getUndoWorkOrderListByParam:param Success:^(NSInteger key, id object) {
        weakSelf.undoWorkorderArray = object;
        [weakSelf.tableViewHelper setUndoWorkOder:weakSelf.undoWorkorderArray];
        [weakSelf updateList];
    } fail:^(NSInteger key, NSError *error) {
        
    }];
}

//查抄设备绑定的合同
- (void) getEquipmentContractData {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    ContractQueryParam *param = [self getContractParam];
    [_business getEquipmentContract:param Success:^(NSInteger key, id object) {
        ContractQueryResponseData *response = object;
        NetPage *page = [response page];
        if([page isFirstPage]) {
            [weakSelf.tableViewHelper removeAllOrders];
        }
        [weakSelf.tableViewHelper addDataRecordInfo:response.contents andPage:response.page byType:ASSET_CONTRACT_RECORD];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

/**
 * 获取合同查询条件
 */
- (ContractQueryParam *) getContractParam {
    ContractQueryCondition *condition = [[ContractQueryCondition alloc] init];
    condition.equipmentId = _eqId;
    
    ContractQueryParam *param = [[ContractQueryParam alloc] initWithCondition:condition andPage:[_tableViewHelper getPage]];
    return param;
}

//查找设备工单记录
- (void) queryListByType:(AssetRecordQueryType) type {
    [self showLoadingDialog];
    AssetWorkOrderQueryRequestParam * param = [[AssetWorkOrderQueryRequestParam alloc] init];
    param.eqId = _eqId;
    param.page.pageSize = [_tableViewHelper getPage].pageSize;
    param.page.pageNumber = [_tableViewHelper getPage].pageNumber;
    param.type = type;
    
    [_business getAssetOrderRecord:param Success:^(NSInteger key, id object) {
        switch (type) {
            case ASSET_WORK_ORDER_RECORD_QUERY_FIXED:{
                AssetFixedRecordResponseData * data = object;
                NetPage * page = [data page];
                if([page isFirstPage]) {
                    [_tableViewHelper removeAllOrders];
                }
                [_tableViewHelper addDataRecordInfo:data.contents andPage:data.page byType:ASSET_ORDER_RECORD_TYPE_FIXED];
                [self updateList];
                [self hideLoadingDialog];
            }
                break;
            case ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN:{
                AssetMaintainRecordResponseData * data = object;
                NetPage * page = [data page];
                if([page isFirstPage]) {
                    [_tableViewHelper removeAllOrders];
                }
                [_tableViewHelper addDataRecordInfo:data.contents andPage:data.page byType:ASSET_ORDER_RECORD_TYPE_MAINTAIN];
                [self updateList];
                [self hideLoadingDialog];
            }
                break;
        }
    } fail:^(NSInteger key, NSError *error) {
        [self updateList];
        [self hideLoadingDialog];
    }];
}

//查找设备巡检记录
- (void) getEquipmentPatrolHistory {
    [self showLoadingDialog];
    AssetPatrolRecordRequestParam *param = [[AssetPatrolRecordRequestParam alloc] init];
    param.eqId = _eqId;
    param.page.pageSize = [_tableViewHelper getPage].pageSize;
    param.page.pageNumber = [_tableViewHelper getPage].pageNumber;
    
    __weak typeof(self) weakSelf = self;
    [_business getEquipmentPatrolRecordByParam:param Success:^(NSInteger key, id object) {
        AssetPatrolRecordResponseData *response = object;
        NetPage *page = [response page];
        if([page isFirstPage]) {
            [weakSelf.tableViewHelper removeAllOrders];
        }
        [weakSelf.tableViewHelper addDataRecordInfo:response.contents andPage:response.page byType:ASSET_PATROL_RECORD];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

//获取核心组件列表
- (void) getEquipmentCoreComponentList {
    [self showLoadingDialog];
    AssetCoreComponentListParam *param = [[AssetCoreComponentListParam alloc] init];
    param.eqId = _eqId;
    __weak typeof(self) weakSelf = self;
    [_business getCoreComponentListByParam:param Success:^(NSInteger key, id object) {
        NSMutableArray *array = object;
        [weakSelf.tableViewHelper addDataRecordInfo:array andPage:nil byType:ASSET_CORE_COMPONENT];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) onMoreBtnClicked:(id) btn {
    AssetManagementDetailShowType type = [_tableViewHelper getShowType];
    [self updateMoreAlertView:type];
    [self showAlertView];
}


- (void) updateMoreAlertView:(AssetManagementDetailShowType) type {
    NSMutableArray * models = [[NSMutableArray alloc] init];
    PhotoItemModel * model1 = [[PhotoItemModel alloc] init];
    PhotoItemModel * model2 = [[PhotoItemModel alloc] init];
    PhotoItemModel * model3 = [[PhotoItemModel alloc] init];
    PhotoItemModel * model4 = [[PhotoItemModel alloc] init];
    PhotoItemModel * model5 = [[PhotoItemModel alloc] init];
    PhotoItemModel * model6 = [[PhotoItemModel alloc] init];
    
    switch (type) {
        case ASSET_MANAGEMENT_DETAIL_BASIC_INFO:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;
            
            model6.name = [[BaseBundle getInstance] getStringByKey:@"core_component_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"core_component_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            model1.name = [[BaseBundle getInstance] getStringByKey:@"equipment_target" inTable:nil];
            model1.img = [[FMTheme getInstance] getImageByName:@"equipment_target"];
            model1.key = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
            
            model2.name = [[BaseBundle getInstance] getStringByKey:@"factory_target" inTable:nil];
            model2.img = [[FMTheme getInstance] getImageByName:@"factory_target"];
            model2.key = ASSET_MANAGEMENT_DETAIL_MANUFACTURER;
            
            model3.name = [[BaseBundle getInstance] getStringByKey:@"contract_target" inTable:nil];
            model3.img = [[FMTheme getInstance] getImageByName:@"contract_target"];
            model3.key = ASSET_MANAGEMENT_DETAIL_CONTRACT;
            
            model4.name = [[BaseBundle getInstance] getStringByKey:@"maintain_target" inTable:nil];
            model4.img = [[FMTheme getInstance] getImageByName:@"maintain_target"];
            model4.key = ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD;
            
            model5.name = [[BaseBundle getInstance] getStringByKey:@"fixed_target" inTable:nil];
            model5.img = [[FMTheme getInstance] getImageByName:@"fixed_target"];
            model5.key = ASSET_MANAGEMENT_DETAIL_FIXED_RECORD;

            model6.name = [[BaseBundle getInstance] getStringByKey:@"patrol_target" inTable:nil];
            model6.img = [[FMTheme getInstance] getImageByName:@"patrol_target"];
            model6.key = ASSET_MANAGEMENT_DETAIL_PATROL;
            break;
    }
    [models addObject:model1];
    [models addObject:model2];
    [models addObject:model3];
    [models addObject:model4];
    [models addObject:model5];
    [models addObject:model6];
    [_photoContentView setInfoWith:models];
}

- (void) showAlertView {
    _isWorking = YES;
    [_alertView showType:@"type"];
    [_alertView show];
}

- (void) resetWorking {
    if(_isWorking) {
        _isWorking = NO;
        [_alertView close];
    }
}

#pragma mark - 点击
- (void) onClick:(UIView *)view {
    if(_isWorking) {
        [self resetWorking];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _photoContentView) {
        [self resetWorking];
        if(subView) {
            NSInteger tag = subView.tag;
            PhotoItemModel * model = [_photoContentView getModelByTag:tag];
            switch(model.key) {
                case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD: //查询维修工单
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_FIXED_RECORD];
                    [_tableViewHelper resetPage];
                    [self queryListByType:ASSET_WORK_ORDER_RECORD_QUERY_FIXED];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_FIXED_RECORD];
                    break;
                    
                case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD];
                    [_tableViewHelper resetPage];
                    [self queryListByType:ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD];
                    break;
                    
                case ASSET_MANAGEMENT_DETAIL_BASIC_INFO:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_BASIC_INFO];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_BASIC_INFO];
                    break;
                    
                case ASSET_MANAGEMENT_DETAIL_CONTRACT:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_CONTRACT];
                    [_tableViewHelper resetPage];
                    [self getEquipmentContractData];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_CONTRACT];
                    break;
                    
                case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_MANUFACTURER];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_MANUFACTURER];
                    break;
                
                case ASSET_MANAGEMENT_DETAIL_PATROL:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_PATROL];
                    [_tableViewHelper resetPage];
                    [self getEquipmentPatrolHistory];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_PATROL];
                    break;
                    
                case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
                    [_tableViewHelper setShowType:ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT];
                    [_tableViewHelper resetPage];
                    [self getEquipmentCoreComponentList];
                    [self updateNaivTitleBy:ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT];
                    break;
            }
            [self updateList];
        }
    }
}

- (void) updateNaivTitleBy:(AssetManagementDetailShowType ) sourceType {
    NSString *navigationTitle = nil;
    [self setMenuWithArray:nil];
    switch (sourceType) {
        case ASSET_MANAGEMENT_DETAIL_UNKNOW:
            break;
        case ASSET_MANAGEMENT_DETAIL_BASIC_INFO:
            if (_editable) {
                [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"快速报障" inTable:nil]]];
            } else {
                [self setMenuWithArray:nil];
            }
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_equipment_target" inTable:nil];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_fixed_target" inTable:nil];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_maintain_target" inTable:nil];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_contract_target" inTable:nil];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_factory_target" inTable:nil];
            break;
        
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_patrol" inTable:nil];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            navigationTitle = [[BaseBundle getInstance] getStringByKey:@"navi_title_core_component" inTable:nil];
            break;
    }
    
    [self setTitleWith:navigationTitle];
    [self updateNavigationBar];
}


- (void) updateList {
    
    [self refreshTable];
    [self loadMoreDataToTable];
    
    [self updateNoticeView];
    
    [_tableView reloadData];
}

- (void) updateNoticeView {
    [_noticeLbl setHidden:YES]; //noticeLbl默认是隐藏的，所以每次刷新状态的时候总是要先初始化一下隐藏状态
    
    AssetManagementDetailShowType type = [_tableViewHelper getShowType];
    NSString * noticeStr = nil;
    UIImage * logoImg = nil;
    switch (type) {
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            if([_tableViewHelper hasData]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_fixed_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            if([_tableViewHelper hasData]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_maintain_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
            if([_tableViewHelper hasData]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_contract_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            if([_tableViewHelper hasFactory]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_factory_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            if([_tableViewHelper hasData]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_patrol_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            if([_tableViewHelper hasData]) {
                [_noticeLbl setHidden:YES];
            } else {
                [_noticeLbl setHidden:NO];
                noticeStr = [[BaseBundle getInstance] getStringByKey:@"asset_record_core_component_none" inTable:nil];
                logoImg = [[FMTheme getInstance] getImageByName:@"no_data"];
            }
            break;
    }
    
    [_noticeLbl setInfoWithName:noticeStr andLogo:logoImg andHighlightLogo:logoImg];

}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if(msgOrigin && [msgOrigin isEqualToString:NSStringFromClass([_tableViewHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            AssetDetailEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            switch (eventType) {
                case ASSET_EVENT_ORDER_RECORD_FIXED:{
                    NSNumber * woId = [result valueForKeyPath:@"eventData"];
                    [self gotoShowWorkOrderDetailByWoId:woId];
                }
                    break;
                case ASSET_EVENT_ORDER_RECORD_MAINTAIN:{
                    NSNumber * woId = [result valueForKeyPath:@"eventData"];
                    [self gotoShowWorkOrderDetailByWoId:woId];
                }
                    break;
                    
                case ASSET_EVENT_SHOW_PHOTO:{
                    NSMutableDictionary * photoParam = [result valueForKeyPath:@"eventData"];
                    NSMutableArray * photoArray = [photoParam valueForKeyPath:@"PhotosArray"];
                    NSNumber * position = [photoParam valueForKeyPath:@"position"];
                    [self showPhotoByArray:photoArray andPosition:position];
                }
                    break;
                    
                case ASSET_EVENT_CONTRACT:{
                    NSNumber *contractId = [result valueForKeyPath:@"eventData"];
                    [self gotoShowContractDetail:contractId];
                }
                    break;
                    
                case ASSET_EVENT_FlEX_BASEINFO:
                    [_tableView reloadData];
                    break;
                case ASSET_EVENT_FlEX_PAREMETER: {
                    [_tableView reloadData];
                }
                    break;
                case ASSET_EVENT_FlEX_SERVICEAREA: {
                    [_tableView reloadData];
                }
                    break;
                    
                case ASSET_EVENT_PATROL_SYC: {
                    DLog(@"同步巡检数据");
                }
                    break;
                    
                case ASSET_EVENT_PATROL_UNDO: {
                    NSNumber *position = [result valueForKeyPath:@"eventData"];
                    [self gotoCheck:position.integerValue];
                }
                    break;
                    
                case ASSET_EVENT_WORK_ORDER_UNDO: {
                    NSNumber *position = [result valueForKeyPath:@"eventData"];
                    [self gotoOperateWorkOrder:position.integerValue];
                }
                    break;
                    
                case ASSET_EVENT_CORE_COMPONENT: {
                    NSNumber *eqCoreId = [result valueForKeyPath:@"eventData"];
                    [self gotoCoreComponentDetail:eqCoreId];
                }
                    break;
                    
                case ASSET_EVENT_PATROL_HISTORY: {
                    
                    AssetPatrolRecordEntity *entity = [result valueForKeyPath:@"eventData"];
                    PatrolTaskHistoryDetailViewController * taskDetailVC = [[PatrolTaskHistoryDetailViewController alloc] init];
                    [taskDetailVC setPatrolTaskWithId:entity.patrolTaskId andTaskName:entity.patrolName];
                    [self gotoViewController:taskDetailVC];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - Refresh and load more methods
- (void) refreshTable {
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    _tableView.pullTableIsLoadingMore = NO;
}


#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    AssetManagementDetailShowType type = [_tableViewHelper getShowType];
    if (type == ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD) {
        [_tableViewHelper removeAllOrders];
        [self updateList];
        [self workWithShowType:ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN];
    } else if (type == ASSET_MANAGEMENT_DETAIL_FIXED_RECORD) {
        [_tableViewHelper removeAllOrders];
        [self updateList];
        [self workWithShowType:ASSET_WORK_ORDER_RECORD_QUERY_FIXED];
    } else if (type == ASSET_MANAGEMENT_DETAIL_CONTRACT) {
        [_tableViewHelper removeAllOrders];
        [self updateList];
        if(!_tableView.pullTableIsRefreshing) {
            _tableView.pullTableIsRefreshing = YES;
        }
        [self getEquipmentContractData];
    } else if (type == ASSET_MANAGEMENT_DETAIL_PATROL) {
        [_tableViewHelper removeAllOrders];
        [self updateList];
        if(!_tableView.pullTableIsRefreshing) {
            _tableView.pullTableIsRefreshing = YES;
        }
        [self getEquipmentPatrolHistory];
    } else if (type == ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT) {
        [_tableViewHelper removeAllOrders];
        [self updateList];
        if(!_tableView.pullTableIsRefreshing) {
            _tableView.pullTableIsRefreshing = YES;
        }
        [self getEquipmentCoreComponentList];
    } else {
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    AssetManagementDetailShowType type = [_tableViewHelper getShowType];
    if (type == ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD) {
        NetPage * page = [_tableViewHelper getPage];
        if([page haveMorePage]) {
            [page nextPage];
            [_tableViewHelper setPage:page];
            [self workWithShowType:ASSET_WORK_ORDER_RECORD_QUERY_MAINTAIN];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
        }
    } else if (type == ASSET_MANAGEMENT_DETAIL_FIXED_RECORD) {
        NetPage * page = [_tableViewHelper getPage];
        if([page haveMorePage]) {
            [page nextPage];
            [_tableViewHelper setPage:page];
            [self workWithShowType:ASSET_WORK_ORDER_RECORD_QUERY_FIXED];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
        }
    } else if (type == ASSET_MANAGEMENT_DETAIL_CONTRACT) {
        NetPage * page = [_tableViewHelper getPage];
        if([page haveMorePage]) {
            [page nextPage];
            [_tableViewHelper setPage:page];
            [self getEquipmentContractData];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
        }
    } else if (type == ASSET_MANAGEMENT_DETAIL_PATROL) {
        NetPage * page = [_tableViewHelper getPage];
        if([page haveMorePage]) {
            [page nextPage];
            [_tableViewHelper setPage:page];
            [self getEquipmentPatrolHistory];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
        }
    } else if (type == ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT) {
        NetPage * page = [_tableViewHelper getPage];
        if([page haveMorePage]) {
            [page nextPage];
            [_tableViewHelper setPage:page];
            [self getEquipmentCoreComponentList];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
        }
    } else {
        [self performSelectorOnMainThread:@selector(loadMoreDataToTable) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - 点击相应事件
- (void) gotoShowWorkOrderDetailByWoId:(NSNumber *) woId {
    WorkOrderDetailViewController * viewController = [[WorkOrderDetailViewController alloc] init];
    [viewController setWorkOrderWithId:woId];
    [viewController setReadOnly:YES];
    [self gotoViewController:viewController];
}

- (void) showPhotoByArray:(NSMutableArray *) photos andPosition:(NSNumber *) position {
    [_photoHelper setPhotos:photos];
    [_photoHelper showPhotoWithIndex:position.integerValue];
}

- (void)gotoCoreComponentDetail:(NSNumber *)eqId {
    EquipmentCoreComponentDetailViewController *vc = [[EquipmentCoreComponentDetailViewController alloc] init];
    [vc setEqCoreId:eqId];
    [self gotoViewController:vc];
}

//前往处理巡检点位
- (void)gotoCheck:(NSInteger)position {
    _needUpdate = YES;
    PatrolCheckViewController *checkVC = [[PatrolCheckViewController alloc] init];
//    DBPatrolSpot *spot = _undoPatrolArray[position];
    _spot = _undoPatrolArray[position];
    [checkVC setPatrolTaskSpot:_spot withPosition:position];
    [checkVC setShowOneDevice:YES]; // 只显示一个设备，不显示上一项和下一项按钮
    
    /* 判断是否签到 */
    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
    if (user && [user.type isEqualToNumber:@(USER_TYPE_OUTSOURCE)] && ![self canHandleSpot:_spot]) {
        
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_need_check" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    else {
        
        [self gotoViewController:checkVC];
    }
}


//操作工单
- (void)gotoOperateWorkOrder:(NSInteger)position {
    WorkOrderDetailViewController *workorderVC = [[WorkOrderDetailViewController alloc] init];
    AssetUndoWorkOrderEntity *workorderEntity = _undoWorkorderArray[position];
    [workorderVC setReadOnly:NO];
    [workorderVC setWorkOrderWithId:workorderEntity.woId];
    [self gotoViewController:workorderVC];
}


/**
 请求最后一次签到记录
 */
- (void)requestLastRecord {
    
    [[UserBusiness getInstance] getLastAttendanceRecordSuccess:^(NSInteger key, id object) {
        
        _attendanceRecord = object;
        
    } fail:^(NSInteger key, NSError *error) {
        
        DLog(@"请求签到记录失败");
    }];
}


/**
 判断是否允许处理点位
 
 @param spot 点位
 @return 是否允许
 */
- (BOOL)canHandleSpot:(DBPatrolSpot *)spot {
    
    BOOL res = NO;
    if(_attendanceRecord) {
        
        if(spot) {
            
            Position * pos = [[Position alloc] init];
            pos.buildingId = spot.buildingId;
            pos.floorId = spot.floorId;
            pos.roomId = spot.roomId;
            
            /* 如果点位属于签到站点 */
            if([pos isBelongTo:_attendanceRecord.location]) {
                
                res = YES;
            }
        }
    }
    return res;
}

//快速报障
- (void)gotoQucikReport {
    QuickReportViewController *viewController = [[QuickReportViewController alloc] init];
    [viewController setEquipmentId:_eqId];
    [self gotoViewController:viewController];
}

//查看合同详情
- (void)gotoShowContractDetail:(NSNumber *)contractId {
    ContractDetailViewController *contractVC = [[ContractDetailViewController alloc] init];
    [contractVC setContractWithId:contractId];
    [contractVC setEditable:NO];
    [self gotoViewController:contractVC];
}



@end

