//
//  InventoryStorageOutViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageOutViewController.h"
#import "BaseTabbarView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "ReservationListTableHelper.h"
#import "InventoryBusiness.h"
#import "InventoryDeliveryDirectView.h"
#import "InfoSelectViewController.h"
#import "WarehouseEntity.h"
#import "MaterialEntity.h"
#import "DXAlertView.h"
#import "InventoryDeliveryEntity.h"

#import "QrCodeViewController.h"
#import "InventoryDeliveryMaterialDetailViewController.h"
#import "ReservationDetailViewController.h"
#import "InventoryMaterialQrcode.h"
#import "DXAlertView.h"

#import "FMLoadMoreFooterView.h"
#import "MJRefresh.h"
#import "ImageItemView.h"
#import "UserBusiness.h"
#import "WorkOrderBusiness.h"
#import "WorkTeamSupervisorEntity.h"

typedef NS_ENUM(NSInteger, InventoryStorageOutType) {
    INVENTORY_STORAGE_OUT_TYPE_RESERVED,    //预定出库
    INVENTORY_STORAGE_OUT_TYPE_DIRECT,      //直接出库
};

typedef NS_ENUM(NSInteger, InventoryStorageOutSelectType) {
    INVENTORY_STORAGE_OUT_SELECT_TYPE_UNKNOW,
    INVENTORY_STORAGE_OUT_SELECT_TYPE_ADMINISTRATOR,
    INVENTORY_STORAGE_OUT_SELECT_TYPE_SUPERVISOR,
    INVENTORY_STORAGE_OUT_SELECT_TYPE_RECEIVING_PERSON
};

@interface InventoryStorageOutViewController () <OnItemClickListener, OnQrCodeScanFinishedListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) UIView * filterContainerView;
@property (readwrite, nonatomic, strong) UIView * contentContainerView;

@property (readwrite, nonatomic, strong) BaseTabbarView * typeTabbar;

@property (readwrite, nonatomic, strong) UITableView * reservedTableView;   //预定单号列表
@property (readwrite, nonatomic, strong) ReservationListTableHelper *reservationHelper;    //

@property (readwrite, nonatomic, strong) InventoryDeliveryDirectView *directView;  //直接出库

@property (readwrite, nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat filterHeight;

@property (readwrite, nonatomic, strong) InventoryBusiness * business;
@property (readwrite, nonatomic, strong) __block NetPage * page;
@property (readwrite, nonatomic, strong) __block NSMutableArray *dataArray;

@property (readwrite, nonatomic, strong) WarehouseEntity * warehouse;   //仓库
@property (readwrite, nonatomic, strong) __block NSMutableArray * materials;    //物料数组
@property (readwrite, nonatomic, strong) __block NSMutableArray * batchArray;   //存储物料出库批次数组

@property (readwrite, nonatomic, assign) NSInteger administratorIndex;  //仓库管理员
@property (readwrite, nonatomic, strong) NSMutableArray * supervisorArray;  //主管
@property (readwrite, nonatomic, assign) NSInteger curSupervisor;
@property (readwrite, nonatomic, strong) NSMutableArray * personArray;  //
@property (readwrite, nonatomic, assign) NSInteger curPerson;

@property (readwrite, nonatomic, assign) InventoryStorageOutSelectType selectType;

@property (readwrite, nonatomic, strong) InventoryMaterialQrcode * materialQrcode;

@property (readwrite, nonatomic, assign) NSInteger curPosition;
@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法
@property (readwrite, nonatomic, assign) InventoryStorageOutType operationType; //出库类型

@property (readwrite, nonatomic, strong) UserBusiness * userBusiness;
@end

@implementation InventoryStorageOutViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_out" inTable:nil]];
    NSMutableArray * menus = [[NSMutableArray alloc] init];
    switch (_operationType) {
        case INVENTORY_STORAGE_OUT_TYPE_RESERVED:
            break;
            
        case INVENTORY_STORAGE_OUT_TYPE_DIRECT:
            [menus addObject:[[FMTheme getInstance]  getImageByName:@"icon_home_add"]];
            [menus addObject:[[FMTheme getInstance]  getImageByName:@"patrol_qrcode_scanner"]];
            break;
            
        default:
            break;
    }
    [self setMenuWithArray:menus];
    
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        _btnHeight = [FMSize getInstance].btnHeight;
        _filterHeight = 45;
        
        
        _reservationHelper = [[ReservationListTableHelper alloc] init];
        [_reservationHelper setOnMessageHandleListener:self];
        _business = [[InventoryBusiness alloc] init];
        _userBusiness = [[UserBusiness alloc] init];
        _page = [[NetPage alloc] init];
        _dataArray = [NSMutableArray new];
        
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        _typeTabbar = [[BaseTabbarView alloc] initWithFrame:CGRectMake(0, 0, realWidth, _filterHeight)];
        [_typeTabbar setStyle:BASE_TABBAR_STYLE_BOTTOM_LINE];
        [_typeTabbar setInfoWithArray:[[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_out_type_reservation" inTable:nil],  [[BaseBundle getInstance] getStringByKey:@"inventory_out_type_direct" inTable:nil], nil]];
        [_typeTabbar setOnItemClickListener:self];
        _typeTabbar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, _filterHeight, realWidth, realHeight-_filterHeight)];
        
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (realHeight-_filterHeight-_noticeHeight)/2, realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_storage_out_empty" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        
        _reservedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, realWidth, realHeight-_filterHeight)];
        _reservedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reservedTableView.dataSource = _reservationHelper;
        _reservedTableView.delegate = _reservationHelper;
        _reservedTableView.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        _reservedTableView.mj_footer.automaticallyChangeAlpha = YES;
        _reservedTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshData)];
        
        
        _directView = [[InventoryDeliveryDirectView alloc] initWithFrame:CGRectMake(0, 0, realWidth, realHeight-_filterHeight)];
        _directView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_directView setOnMessageHandleListener:self];
        
        
        [_contentContainerView addSubview:_reservedTableView];
        [_contentContainerView addSubview:_noticeLbl];
        [_contentContainerView addSubview:_directView];
        
        [_mainContainerView addSubview:_typeTabbar];
        [_mainContainerView addSubview:_contentContainerView];
        
        [self.view addSubview:_mainContainerView];
    }
}


- (void) updateContentView {
    switch(_operationType) {
        case INVENTORY_STORAGE_OUT_TYPE_RESERVED:
            [self showReserved];
            break;
        case INVENTORY_STORAGE_OUT_TYPE_DIRECT:
            [self showDirect];
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStatusChangeHandler];
    _operationType = INVENTORY_STORAGE_OUT_TYPE_RESERVED;   //默认为直接出库
    [_typeTabbar setSelected:0];
    [self updateContentView];
    [self requestPersonList];
    [self requestReservationList];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_backFromQrcode) {
        _backFromQrcode = NO;
        if (_isValidQrcode) {
            _isValidQrcode = NO;
            NSString * code = [_materialQrcode getMaterialCode];
            NSString * warehouseId = [_materialQrcode getWarehouseId];
            [self gotoMaterialDetailByMaterialCode:code warehouseId:warehouseId];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        if(_needUpdate) {
            _needUpdate = NO;
            switch(_operationType) {
                case INVENTORY_STORAGE_OUT_TYPE_RESERVED:
                    [self requestReservationList];
                    break;
                case INVENTORY_STORAGE_OUT_TYPE_DIRECT:
                    [self updateDeliveryInfo];
                    [_directView updateList];
                    break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger) position {
    switch (position) {
        case 0:
            [self gotoSelectMaterial];
            break;
        case 1:
            [self gotoScanQrcode];
            break;
        default:
            break;
    }
}

#pragma mark - 初始化监听预定单状态变化
- (void) initStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMReservationStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

//更新菜单
- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[BaseTabbarView class]]) {
        NSInteger index = subView.tag;
        switch(index) {
            case 0:
                _operationType = INVENTORY_STORAGE_OUT_TYPE_RESERVED;
                break;
            case 1:
                _operationType = INVENTORY_STORAGE_OUT_TYPE_DIRECT;
                break;
        }
        [self updateContentView];
    }
}

//展示预定出库
- (void) showReserved {
    [self updateTitle];
    
    [_reservedTableView setHidden:NO];
    [_directView setHidden:YES];
}

//展示直接出库
- (void) showDirect {
    [self updateTitle];
    
    [_reservedTableView setHidden:YES];
    [_directView setHidden:NO];
}

- (void) updateReservationList {
    if (_reservedTableView.mj_footer.isRefreshing && ![_page haveMorePage]) {
        [_reservedTableView.mj_footer endRefreshingWithNoMoreData];
    } else if (_reservedTableView.mj_footer.isRefreshing && [_page haveMorePage]) {
        [_reservedTableView.mj_footer endRefreshing];
    }
    
    if (_reservedTableView.mj_header.isRefreshing) {
        [_reservedTableView.mj_header endRefreshing];
        [_reservedTableView.mj_footer endRefreshing];
    }
    
    if (_dataArray.count > 0) {
        [self.noticeLbl setHidden:YES];
    } else {
        [self.noticeLbl setHidden:NO];
    }
    
    [_reservedTableView reloadData];
}

//初始化出库信息
- (void) updateDeliveryInfo {
    if(_warehouse) {
        [_directView setInfoWithWarehouse:_warehouse.name];
        if(_administratorIndex >= 0 && _administratorIndex < [_warehouse.administrator count]) {
            WarehouseAdministrator * admin = _warehouse.administrator[_administratorIndex];
            [_directView setInfoWithAdministrator:admin.name];
        }
    } else {
        [_directView setInfoWithWarehouse:nil];
        [_directView setInfoWithAdministrator:nil];
    }
    
    if(_personArray && _curPerson >= 0 && _curPerson < [_personArray count]) {
        SimpleUserEntity * user = _personArray[_curPerson];
        [_directView setInfoWithReceivingPerson:user.name];
    } else {
        [_directView setInfoWithReceivingPerson:nil];
    }
    if(_supervisorArray && _curSupervisor >= 0 && _curSupervisor < [_supervisorArray count]) {
        WorkTeamSupervisorEntity * supervisor = _supervisorArray[_curSupervisor];
        [_directView setInfoWithSupervisor:supervisor.name];
    } else {
        [_directView setInfoWithSupervisor:nil];
    }
    
}

- (InventoryDeliveryParam *)getDeliveryParam {
    InventoryDeliveryParam * param = [[InventoryDeliveryParam alloc] init];
    switch (_operationType) {
        case INVENTORY_STORAGE_OUT_TYPE_RESERVED://预定出库在预定详情部分处理
            break;
        case INVENTORY_STORAGE_OUT_TYPE_DIRECT:
            param.type = INVENTORY_DELIVERY_TYPE_DIRECT;
            break;
        default:
            break;
    }
    param.activityId = nil;
    param.warehouseId = _warehouse.warehouseId;
    param.targetWarehouseId = nil;
    if(_administratorIndex >= 0 && _administratorIndex < [_warehouse.administrator count]) {
        WarehouseAdministrator * admin = _warehouse.administrator[_administratorIndex];
        param.administrator = admin.administratorId;
    }
    if(_supervisorArray && _curSupervisor >= 0 && _curSupervisor < [_supervisorArray count]) {
        WorkTeamSupervisorEntity * supervisor = _supervisorArray[_curSupervisor];
        param.supervisor = supervisor.supervisorId;
    }
    if(_curPerson >= 0 && _curPerson < [_personArray count]) {
        SimpleUserEntity * user = _personArray[_curPerson];
        param.receivingPersonId = user.emId;
    }
    NSInteger index = 0;
    for(MaterialEntity * obj in _materials) {
        InventoryDeliveryMaterialEntity *material = [[InventoryDeliveryMaterialEntity alloc] init];
        material.inventoryId = [obj.inventoryId copy];
        if(index >= 0 && index < [_batchArray count]) {
            NSMutableArray *batchArray = _batchArray[index];
            material.batch = batchArray;
            if([batchArray count] > 0) {    //如果预定的有批次
                [param.inventory addObject:material];
            }
            index ++;
        }
    }
    return param;
}

- (void)RefreshData {
    [_page reset];
    [self requestReservationList];
}

- (void)LoadMoreToTableView {
    if ([_page haveMorePage]) {
        [_page nextPage];
        [self requestReservationList];
    } else {
        [self updateReservationList];
    }
}

#pragma mark - 网络请求
- (void) requestReservationList {
    NSNumber * userId = [SystemConfig getEmployeeId];
    ReservationQueryType queryType = RESERVATION_QUERY_TYPE_APPROVALED;
    GetReservationListParam * param = [[GetReservationListParam alloc] initWithUserId:userId queryType:queryType page:_page];
    
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getReservationList:param success:^(NSInteger key, id object) {
        GetReservationListResponseData *data = object;
        [weakSelf.page setPage:data.page];
        
        if ([weakSelf.page haveMorePage]) {
            [weakSelf.dataArray addObjectsFromArray:data.contents];
        } else {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:data.contents];
        }
        [weakSelf.reservationHelper setDataWithArray:weakSelf.dataArray];
        [weakSelf updateReservationList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateReservationList];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) requestDeliveryMaterial {
    if ([FMUtils isNumberNullOrZero:_warehouse.warehouseId]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (!_batchArray || _batchArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if ([self isBatchAmountEmpty]){
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_out_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if(!_warehouse.administrator || [_warehouse.administrator count] == 0 || _administratorIndex <0 || _administratorIndex >= [_warehouse.administrator count]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if(!_personArray || [_personArray count] == 0 || _curPerson <0 || _curPerson >= [_personArray count]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_receiving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        __weak typeof(self) weakSelf = self;
        [weakSelf showLoadingDialog];
        InventoryDeliveryParam *param = [self getDeliveryParam];
        [_business requestDelivery:param success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
}

- (BOOL) isMaterialExist:(NSNumber *) materialId {
    BOOL res = NO;
    for(MaterialEntity * material in _materials) {
        if([material.inventoryId isEqualToNumber:materialId]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (NSNumber *) getAmountByBatchArray:(NSMutableArray *) array {
    NSNumber * count = 0;
    double sum = 0;
    for(InventoryDeliveryMaterialBatchEntity * batch in array) {
        sum += batch.amount.doubleValue;
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

- (BOOL) isBatchAmountEmpty {
    BOOL isEmpty = NO;
    double count = 0;
    for (NSMutableArray *batchArray in _batchArray) {
        for(InventoryDeliveryMaterialBatchEntity * batch in batchArray) {
            count = batch.amount.doubleValue;
            if(count == 0) {
                break;
            };
        }
        if(count == 0) {
            break;
        };
    }
    if(count == 0) {
        isEmpty = YES;
    }
    return isEmpty;
}

- (NSInteger) getMaterialPosition:(NSNumber *) inventoryId {
    NSInteger position = -1;
    NSInteger index = 0;
    for(MaterialEntity * material in _materials) {
        if([material.inventoryId isEqualToNumber:inventoryId]) {
            position = index;
            break;
        }
        index++;
    }
    return position;
}


//请求员工信息列表
- (void) requestPersonList {
    [_userBusiness getUsersOfCurrentProjectSuccess:^(NSInteger key, id object) {
        _personArray = object;
        _curPerson = -1;
        [self updateDeliveryInfo];
        [self requestSupervisors];
    } fail:^(NSInteger key, NSError *error) {
        _personArray = nil;
        _supervisorArray = nil;
        [self updateDeliveryInfo];
    }];
}

//请求主管信息列表
- (void) requestSupervisors {
    if(_personArray && _curPerson >= 0 && _curPerson < [_personArray count]) {
        WorkOrderBusiness * business = [WorkOrderBusiness getInstance];
        SimpleUserEntity * user = _personArray[_curPerson];
        NSNumber * emId = user.emId;
        [business getWorkGroupSupervisors:emId success:^(NSInteger key, id object) {
            _supervisorArray = object;
            _curSupervisor = -1;
            [self updateDeliveryInfo];
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"获取主管信息失败");
            _supervisorArray = nil;
            [self updateDeliveryInfo];
        }];
    }
    
}

#pragma mark - 处理消息
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_directView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryDeliveryDirectEventType eventType = [tmpNumber integerValue];
            NSMutableDictionary * data = [result valueForKeyPath:@"eventData"];
            MaterialEntity * material;
            
            switch(eventType) {
                case INVENTORY_DELIVERY_EVENT_SELECT_WAREHOUSE:
                    [self gotoSelectWarehouse];
                    break;
                case INVENTORY_DELIVERY_EVENT_SELECT_ADMINISTRATOR:
                    if([_warehouse.administrator count] > 1) {
                        [self gotoSelectAdministrator];
                    }
                    break;
                case INVENTORY_DELIVERY_EVENT_SELECT_SUPERVISOR:
                    if([_supervisorArray count] > 0) {
                        [self gotoSelectSupervisor];
                    }
                    break;
                case INVENTORY_DELIVERY_EVENT_SELECT_RECEIVING_PERSON:
                    if([_personArray count] > 0) {
                        [self gotoSelectReceinvingPerson];
                    }
                    break;
                case INVENTORY_DELIVERY_EVENT_SHOW_MATERIAL:
                    material = [data valueForKeyPath:@"material"];
                    tmpNumber = [data valueForKeyPath:@"position"];
                    [self gotoMaterialDetail:tmpNumber.integerValue];
                    break;
                case INVENTORY_DELIVERY_EVENT_DELETE_MATERIAL:
                    [self tryToDeleteMaterial:data];
                    break;
                case INVENTORY_DELIVERY_EVENT_DELIVERY:
                    [self requestDeliveryMaterial];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            MaterialEntity * material;
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            NSNumber * tmpNumber;
            switch (requestType) {
                case REQUEST_TYPE_MATERIAL_INFO_SELECT:
                    material = [msg valueForKeyPath:@"result"];
                    if(material) {
                        if([self isMaterialExist:material.inventoryId]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        } else if(material.totalNumber.doubleValue <= 0){
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_more_than_inventory" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        } else {
                            //物料选择成功
                            if(!_materials) {
                                _materials = [[NSMutableArray alloc] init];
                            }
                            if(!_batchArray) {
                                _batchArray = [[NSMutableArray alloc] init];
                            }
                            [_materials addObject:material];
                            [_batchArray addObject:[[NSMutableArray alloc] init]];
                            [_directView addMaterial:material];
                        }
                    }
                    break;
                case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
                    _warehouse = [msg valueForKeyPath:@"result"];
                    _administratorIndex = 0;
                    _needUpdate = YES;
                    
                    break;
                case REQUEST_TYPE_COMMON_INFO_SELECT:
                    if(_selectType == INVENTORY_STORAGE_OUT_SELECT_TYPE_ADMINISTRATOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _administratorIndex = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if(_selectType == INVENTORY_STORAGE_OUT_SELECT_TYPE_SUPERVISOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _curSupervisor = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if(_selectType == INVENTORY_STORAGE_OUT_SELECT_TYPE_RECEIVING_PERSON) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _curPerson = tmpNumber.integerValue;
                            _needUpdate = YES;
                            [self requestSupervisors];
                        }
                    }
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([InventoryDeliveryMaterialDetailViewController class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryDeliveryMaterialDetailEventType eventType = [tmpNumber integerValue];
            NSMutableArray * batchs;
            MaterialEntity * material;
            NSMutableDictionary * data;
            switch (eventType) {
                case INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_OK:
                    batchs = [result valueForKeyPath:@"eventData"];
                    material = _materials[_curPosition];
                    _batchArray[_curPosition] = [batchs copy];
                    _needUpdate = YES;
                    [_directView setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
                    break;
                case INVENTORY_DELIVERY_MATERIAL_QRCODE_OK:
                    data = [result valueForKeyPath:@"eventData"];
                    if(!_warehouse) {
                        _warehouse = [data valueForKeyPath:@"warehouse"];
                        [_directView setInfoWithWarehouse:_warehouse.name];
                        if (_warehouse.administrator.count > 0) {
                            WarehouseAdministrator *admin = _warehouse.administrator[0];
                            NSString *name = admin.name;
                            _administratorIndex = 0;
                            [_directView setInfoWithAdministrator:name];
                        }
                    } else {
                        WarehouseEntity *tmpWareHouse = [data valueForKeyPath:@"warehouse"];
                        if (![tmpWareHouse.warehouseId isEqualToNumber:_warehouse.warehouseId]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                            break;
                        }
                    }
                    material = [data valueForKeyPath:@"material"];
                    batchs = [data valueForKeyPath:@"batch"];
                    
                    if(![self isMaterialExist:material.inventoryId]) {
                        if(!_materials) {
                            _materials = [[NSMutableArray alloc] init];
                        }
                        if(!_batchArray) {
                            _batchArray = [[NSMutableArray alloc] init];
                        }
                        if(![self isMaterialExist:material.inventoryId]) {
                            [_materials addObject:material];
                            [_batchArray addObject:batchs];
                            [_directView addMaterial:material];
                            [_directView setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
                        } else {
                            _curPosition = [self getMaterialPosition:material.inventoryId];
                            _batchArray[_curPosition] = [batchs copy];
                            [_directView setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
                        }
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
                    }
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_reservationHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryReservationListEventType type = tmpNumber.integerValue;
            NSInteger position;
            switch(type) {
                case INVENTORY_RESERVATION_LIST_EVENT_SHOW_DETAIL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    position = tmpNumber.integerValue;
                    [self gotoReservationDetail:position];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void) tryToDeleteMaterial:(NSDictionary *) data {
    if(data) {
        MaterialEntity * material = [data valueForKeyPath:@"material"];
        NSNumber * tmpNumber = [data valueForKeyPath:@"position"];
        NSInteger position = tmpNumber.integerValue;
        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_alert_delete_material" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];

        alertView.leftBlock = ^() {
            [_materials removeObjectAtIndex:position];
            [_batchArray removeObjectAtIndex:position];
            [_directView deleteMaterialAtPosition:position];
        };
        alertView.rightBlock = ^() {
        };
        [alertView show];
    }
}

#pragma mark - 二维码扫描结束
- (void) onQrCodeScanFinished:(NSString *)result {
    _backFromQrcode = YES;
    _materialQrcode = [[InventoryMaterialQrcode alloc] initWithString:result];
    _isValidQrcode = [_materialQrcode isValidQrcode];
}

#pragma mark - 界面跳转
//扫描二维码
- (void) gotoScanQrcode {
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

//选择仓库
- (void) gotoSelectWarehouse {
    if(_warehouse && [_materials count] > 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"selectAll", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    }
}

//选择物料
- (void) gotoSelectMaterial {
    if(_warehouse) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_warehouse.warehouseId, @"warehouseId", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//物料详情
- (void) gotoMaterialDetail:(NSInteger) position {
    _curPosition = position;
    MaterialEntity * material = _materials[position];
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
    NSMutableArray * batchs = _batchArray[position];
    [vc setInfoWithMaterial:material batch:batchs];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

- (void) gotoMaterialDetailByMaterialCode:(NSString *) materialCode warehouseId:(NSString *) warehouseId {
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
    NSNumber *whId = [FMUtils stringToNumber:warehouseId];
    [vc setInfoWithMaterialCode:materialCode warehouseId:whId];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//预定详情
- (void) gotoReservationDetail:(NSInteger) position {
    ReservationDetailViewController * vc = [[ReservationDetailViewController alloc] init];
    ReservationEntity * entity = [_reservationHelper getDataByPosition:position];
    [vc setInfoWithReservationId:entity.activityId];
    [vc setReadonly:NO];
    [vc setCanEditHandler:YES];
    [self gotoViewController:vc];
}

//选择仓库管理员
- (void) gotoSelectAdministrator {
    _selectType = INVENTORY_STORAGE_OUT_SELECT_TYPE_ADMINISTRATOR;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
    for(WarehouseAdministrator * admin in _warehouse.administrator) {
        [data addObject:admin.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择主管
- (void) gotoSelectSupervisor {
    _selectType = INVENTORY_STORAGE_OUT_SELECT_TYPE_SUPERVISOR;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_supervisor" inTable:nil];;
    for(WorkTeamSupervisorEntity * supervisor in _supervisorArray) {
        [data addObject:supervisor.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择领用人
- (void) gotoSelectReceinvingPerson {
    _selectType = INVENTORY_STORAGE_OUT_SELECT_TYPE_RECEIVING_PERSON;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc = [[BaseBundle getInstance] getStringByKey:@"inventory_out_person" inTable:nil];
    for(SimpleUserEntity * user in _personArray) {
        [data addObject:user.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

@end
