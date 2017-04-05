//
//  InventoryDeliveryMaterialDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  出库物料详情
//

#import "InventoryDeliveryMaterialDetailViewController.h"
#import "InventoryBusiness.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "InventoryMaterialDetailEntity.h"
#import "InventoryMaterialDetailTableHelper.h"
#import "FMUtils.h"
#import "TaskAlertView.h"
#import "CommonAlertContentView.h"
#import "IQKeyboardManager.h"
#import "InventoryDeliveryEntity.h"
#import "InfoSelectViewController.h"
#import "SystemConfig.h"
#import "UserBusiness.h"
#import "WorkOrderBusiness.h"
#import "WorkTeamSupervisorEntity.h"

typedef NS_ENUM(NSInteger, InventoryInfoSelectType) {
    INVENTORY_INFO_SELECT_TYPE_UNKNOW,
    INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_SRC,
    INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_TARGET,
    INVENTORY_INFO_SELECT_TYPE_SUPERVISOR,
    INVENTORY_INFO_SELECT_TYPE_RECEIVING_PERSON
};

@interface InventoryDeliveryMaterialDetailViewController ()<OnMessageHandleListener, OnClickListener, OnItemClickListener>
@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) TaskAlertView *alertView;
@property (readwrite, nonatomic, strong) CommonAlertContentView *amountView;

@property (readwrite, nonatomic, strong) __block NSNumber *inventoryId;    //库存ID
@property (readwrite, nonatomic, strong) __block InventoryMaterialDetail *material;    //物料详情
@property (readwrite, nonatomic, strong) __block NSMutableArray *batchAmountArray;   //批次数组
@property (readwrite, nonatomic, strong) __block NSMutableDictionary *batchAmountDict;   //所选批次
@property (readwrite, nonatomic, strong) __block NSMutableDictionary *batchPriceDict;   //所选批次价格
@property (readwrite, nonatomic, strong) __block NSNumber * reservedAmount;  //预定数量
@property (readwrite, nonatomic, strong) __block NSNumber *validNumber;  //有效数量

@property (readwrite, nonatomic, strong) __block NSString *materialCode;   //物资编码
@property (readwrite, nonatomic, strong) __block NSNumber *warehouseId;    //仓库ID

@property (readwrite, nonatomic, strong) InventoryBusiness *business;
@property (readwrite, nonatomic, strong) UserBusiness * userBusiness;
@property (readwrite, nonatomic, strong) WarehouseEntity *targetWarehouse;//目标仓库
@property (readwrite, nonatomic, strong) InventoryMaterialDetailBatchEntity *curBatch;
@property (readwrite, nonatomic, strong) __block NetPage *page;    //批次分页

@property (readwrite, nonatomic, assign) __block NSInteger currentWarehouse;
@property (readwrite, nonatomic, strong) __block NSMutableArray *warehouseArray;  //仓库列表

@property (readwrite, nonatomic, assign) __block NSInteger currentSrcWareHouseAdmin;
@property (readwrite, nonatomic, strong) __block NSMutableArray *srcWareHouseAdminArray;  //源仓库管理员列表

@property (readwrite, nonatomic, assign) __block NSInteger currentTargetWareHouseAdmin;
@property (readwrite, nonatomic, strong) __block NSMutableArray *targetWareHouseAdminArray;  //目标仓库管理员列表

@property (readwrite, nonatomic, assign) __block NSInteger currentRecivingPerson;
@property (readwrite, nonatomic, strong) __block NSMutableArray *recivingPersonArray;  //领用人列表

@property (readwrite, nonatomic, assign) __block NSInteger currentSupervisor;
@property (readwrite, nonatomic, strong) __block NSMutableArray *supervisorArray;  //主管列表

@property (readwrite, nonatomic, strong) __block InventoryMaterialDetailTableHelper *helper;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;

@property (readwrite, nonatomic, assign) BOOL readOnly; //是否只读
@property (readwrite, nonatomic, assign) BOOL fromQrcode; //来自二维码扫描
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) InventoryDeliveryOperationType operationType;
@property (readwrite, nonatomic, assign) InventoryInfoSelectType selectType;  //infoselectioncontrallertype

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation InventoryDeliveryMaterialDetailViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _operationType = INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_NORMAL;  //默认为正常出库
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_fromQrcode) {
        [self requestMaterialDetailByCcode];
        [self requestWarehouseList];
    } else {
        [self requestMaterialDetail];
        [self requestBatchList];
        if (_operationType == INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE) {
            [self requestReceivingPerson];
            [self requestWarehouseList];
        } else if (_operationType == INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE) {
            [self requestWarehouseList];
        }
    }
    [self initAlertView];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    if(!_readOnly) {
    //        [self notifyBatchSelectOK];
    //    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        [self updateList];
    }
}

- (void) initNavigation {
    switch (_operationType) {
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE:    //出库物料，出库
            [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_delivery_material_detail" inTable:nil]];
            if(!_readOnly) {
                NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_stock_out" inTable:nil], nil];
                [self setMenuWithArray:menus];
            }
            break;
        
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE:
            [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_move_material_detail" inTable:nil]];
            if(!_readOnly) {
                NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_transfer" inTable:nil], nil];
                [self setMenuWithArray:menus];
            }
            break;
        
        case INVENTORY_DELIVERY_MATERIAL_TYPE_RESERVATION:
            [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_delivery_material_detail" inTable:nil]];
            [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]]];
            break;
            
        
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_NORMAL:
            [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_delivery_material_detail" inTable:nil]];
            [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]]];
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL:
            [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_move_material_detail" inTable:nil]];
            [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]]];
            break;
        
        default:
            break;
    }
    
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    switch (_operationType) {
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE:    //扫描二维码出库
            [self requestDelivery];
            break;
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE:    //扫描二维码移库
            [self requestTransfer];
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL:    //正常移库
            [self notifyBatchSelectOK];
            [self finish];
            break;
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_NORMAL:    //正常出库
            [self notifyBatchSelectOK];
            [self finish];
            break;
        case INVENTORY_DELIVERY_MATERIAL_TYPE_RESERVATION:    //预定物料
            [self notifyBatchSelectOK];
            [self finish];
            break;
        default:
            break;
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
            [manager.disabledDistanceHandlingClasses addObject:[self class]];
        }
        
        _business = [InventoryBusiness getInstance];
        _userBusiness = [UserBusiness getInstance];
        _helper = [[InventoryMaterialDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        _page = [[NetPage alloc] init];
        
        if (!_batchPriceDict) {
            _batchPriceDict = [[NSMutableDictionary alloc] init];
        }
        if (!_batchAmountDict) {
            _batchAmountDict = [[NSMutableDictionary alloc] init];
        }
        if (!_batchAmountArray) {
            _batchAmountArray = [NSMutableArray new];
        }
        
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = _helper;
        _tableView.delegate = _helper;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_mainContainerView addSubview:_tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initAlertView {
    _amountView = [[CommonAlertContentView alloc] init];
    [_amountView setShowOneLine:YES];
    [_amountView setTitleWithText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount_edit_title" inTable:nil]];
    [_amountView setEditLabelWithText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount_edit_placeholder" inTable:nil]];
    [_amountView setOperationButtonText:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]];
    [_amountView setTextFieldKeyboardType:UIKeyboardTypeDecimalPad];
    [_amountView setOnItemClickListener:self];
    
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];

    CGFloat amountHeight = 160;
    
    [_alertView setContentView:_amountView withKey:@"amount" andHeight:amountHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void) updateList {
    [self updateAmount];
    switch (_operationType) {
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_NORMAL:
            [_helper setInventoryMaterialTableViewType:INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL];
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE:
            [_helper setInventoryMaterialTableViewType:INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE];
            //默认设置第一个管理员
            if (_warehouseArray.count > 0 && !_srcWareHouseAdminArray) {
                for (WarehouseEntity *warehouse in _warehouseArray) {
                    if ([warehouse.warehouseId isEqualToNumber:_material.warehouseId]) {
                        _srcWareHouseAdminArray = warehouse.administrator;
                        _currentSrcWareHouseAdmin = 0;
                    }
                }
            }
            if (_srcWareHouseAdminArray && _currentSrcWareHouseAdmin >= 0 && _currentSrcWareHouseAdmin < [_srcWareHouseAdminArray count]) {
                WarehouseAdministrator *admin = _srcWareHouseAdminArray[_currentSrcWareHouseAdmin];
                [_helper setSrcAdministrator:admin.name andTargetAdministrator:nil];
            }
            
            //设置显示第一个领用人
            if (_recivingPersonArray && _currentRecivingPerson >= 0 && _currentRecivingPerson < [_recivingPersonArray count]) {
                SimpleUserEntity * user = _recivingPersonArray[_currentRecivingPerson];
                [_helper setReceivingPerson:user.name];
            }
            
            //设置主管
            if (_supervisorArray && _currentSupervisor >= 0 && _currentSupervisor < [_supervisorArray count]) {
                WorkTeamSupervisorEntity *supervisor = _supervisorArray[_currentSupervisor];
                [_helper setSupervisor:supervisor.name];
            }
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_RESERVATION:
            [_helper setInventoryMaterialTableViewType:INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_RESERVATION];
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL:
            [_helper setInventoryMaterialTableViewType:INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL];
            break;
            
        case INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE:
            [_helper setInventoryMaterialTableViewType:INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE];
            [_helper setSrcWarehouse:_material.warehouseName targetWarehouse:_targetWarehouse.name];
            //默认原仓库管理员
            if (_warehouseArray.count > 0 && !_srcWareHouseAdminArray) {
                for (WarehouseEntity *warehouse in _warehouseArray) {
                    if ([warehouse.warehouseId isEqualToNumber:_material.warehouseId]) {
                        _srcWareHouseAdminArray = warehouse.administrator;
                        _currentSrcWareHouseAdmin = 0;
                    }
                }
            }
            if (_srcWareHouseAdminArray && _currentSrcWareHouseAdmin >= 0 && _currentSrcWareHouseAdmin < [_srcWareHouseAdminArray count]) {
                WarehouseAdministrator *admin = _srcWareHouseAdminArray[_currentSrcWareHouseAdmin];
                [_helper setSrcAdministrator:admin.name andTargetAdministrator:nil];
            }
            
            //设置目标仓库管理员
            if (_targetWarehouse && !_targetWareHouseAdminArray) {
                _targetWareHouseAdminArray = _targetWarehouse.administrator;
                _currentTargetWareHouseAdmin = 0;
            }
            if (_targetWareHouseAdminArray && _currentTargetWareHouseAdmin >= 0 && _currentTargetWareHouseAdmin < [_targetWareHouseAdminArray count]) {
                WarehouseAdministrator *admin = _targetWareHouseAdminArray[_currentTargetWareHouseAdmin];
                [_helper setSrcAdministrator:nil andTargetAdministrator:admin.name];
            }
            
            break;
        
        default:
            break;
    }
    
    [_tableView reloadData];
}

//获取当前所有批次数量
- (NSNumber*) getBatchAmountExceptCurBatch:(InventoryMaterialDetailBatchEntity *)curBatch {
    NSNumber * count = 0;
    double sum = 0;
    NSString *curKey = [NSString stringWithFormat:@"%lld", curBatch.batchId.longLongValue];
    for(NSString * key in _batchAmountDict) {
        if (![key isEqualToString:curKey]) {
            NSNumber * tmpNumber = [_batchAmountDict valueForKeyPath:key];
            if([tmpNumber doubleValue] > 0) {
                sum += tmpNumber.doubleValue;
            }
        }
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

- (void) updateAmount {
    for(NSString * key in _batchAmountDict) {
        NSNumber * tmpNumber = [_batchAmountDict valueForKeyPath:key];
        if([tmpNumber doubleValue] > 0) {
            NSNumber * batchId = [FMUtils stringToNumber:key];
            [_helper setAmount:tmpNumber forBatch:batchId];
        }
    }
    if(_reservedAmount.doubleValue > 0) {
        [_helper setReservedAmount:_reservedAmount];
    }
}

////设置物料类型（会影响展示的信息描述）
//- (void) setMaterialType:(InventoryDeliveryOperationType) type {
//    _operationType = type;
//}

//设置操作类型
- (void) setOperationType:(InventoryDeliveryOperationType) operationType {
    _operationType = operationType;
}

- (void) setReadOnly:(BOOL)readOnly {
    _readOnly = readOnly;
}

//
- (void) setInfoWithMaterial:(MaterialEntity *) material batch:(NSMutableArray *) array {
    _inventoryId = material.inventoryId;
    if(!_batchAmountDict) {
        _batchAmountDict = [[NSMutableDictionary alloc] init];
    }
    for(InventoryDeliveryMaterialBatchEntity * batch in array) {
        NSString * key = [[NSString alloc] initWithFormat:@"%lld", batch.batchId.longLongValue];
        [_batchAmountDict setValue:batch.amount forKeyPath:key];
        
    }
}

//预定出库使用
- (void) setInfoWithReservationMaterial:(ReservationMaterial *) material batch:(NSMutableArray *) array {
    _inventoryId = material.inventoryId;
    _reservedAmount = material.bookAmount;
    if(!_batchAmountDict) {
        _batchAmountDict = [[NSMutableDictionary alloc] init];
    }
    for(InventoryDeliveryMaterialBatchEntity * batch in array) {
        NSString *key = [[NSString alloc] initWithFormat:@"%lld", batch.batchId.longLongValue];
        [_batchAmountDict setValue:batch.amount forKeyPath:key];
    }
}

//预定出库实际价格
- (void) setInfoWithRealCost:(NSMutableDictionary *)costDict {
    if(!_batchPriceDict) {
        _batchPriceDict = [[NSMutableDictionary alloc] init];
    }
    _batchPriceDict = costDict;
}

//预定出库批次数量  batchId : "batchNumber"
- (void) setInfoWithBatchNumber:(NSMutableDictionary *)numberDict {
    if(!_batchAmountDict) {
        _batchAmountDict = [[NSMutableDictionary alloc] init];
    }
    _batchAmountDict = numberDict;
}

//二维码扫描时使用
- (void) setInfoWithMaterialCode:(NSString *) materialCode warehouseId:(NSNumber *) warehouseId {
    _fromQrcode = YES;
    _materialCode = materialCode;
    _warehouseId = warehouseId;
    if(!_batchAmountDict) {
        _batchAmountDict = [[NSMutableDictionary alloc] init];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (BOOL) updateInventoryOperationAbilityByWarehouseArray:(NSMutableArray *)warehouseArray {
    BOOL canOperate = NO;
    for(WarehouseEntity * warehouse in warehouseArray) {
        if(warehouse.warehouseId && _material.warehouseId && [warehouse.warehouseId isEqualToNumber:_material.warehouseId]) {
            canOperate = YES;
            break;
        }
    }
    return canOperate;
}

#pragma mark - 点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _amountView) {
        NSString *strAmount = [_amountView getDesc];
        NSNumber *amount = [FMUtils stringToNumber:strAmount];
        if ([FMUtils isNumberNullOrZero:amount]) {
            amount = [NSNumber numberWithDouble:0.00];
        }
//        NSInteger tamount = amount + [self getBatchAmount];
        NSNumber * getAmount = [self getBatchAmountExceptCurBatch:_curBatch];
        double tamount = amount.doubleValue + getAmount.doubleValue;
        
        double realOrTotalNumber = _material.realNumber.doubleValue;
        NSString *realOrTotalNumberNotice =  [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_amount_less_than_realnumber" inTable:nil];;
        if (_operationType == INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL) {
            realOrTotalNumber = _material.totalNumber.doubleValue;
            realOrTotalNumberNotice =  [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_amount_less_than_totalnumber" inTable:nil];;
        }
        if (_reservedAmount.doubleValue > 0) {
            realOrTotalNumber = _material.totalNumber.doubleValue;
            realOrTotalNumberNotice =  [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_amount_less_than_totalnumber" inTable:nil];;
        }
        
        if(_reservedAmount.doubleValue > 0 && [FMUtils compareDoubleA:tamount andDoubleB:_reservedAmount.doubleValue] == 1) {  //如果所有批次的数量大于预定的数量
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_amount_less_than_reserved" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if (_reservedAmount.doubleValue > 0 && [FMUtils compareDoubleA:tamount andDoubleB:realOrTotalNumber] == 1) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:realOrTotalNumberNotice time:DIALOG_ALIVE_TIME_SHORT];
        } else if (_curBatch && [FMUtils compareDoubleA:amount.doubleValue andDoubleB:_curBatch.amount.doubleValue] == 1) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_amount_less_than_batch" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if ([FMUtils compareDoubleA:tamount andDoubleB:realOrTotalNumber] == 1) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:realOrTotalNumberNotice time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            if(_curBatch) {
                [_helper setAmount:amount forBatch:_curBatch.batchId];
                if(!_batchAmountDict) {
                    _batchAmountDict = [[NSMutableDictionary alloc] init];
                }
                NSString *batchIdKey = [[NSString alloc] initWithFormat:@"%lld", _curBatch.batchId.longLongValue];
//                NSString *inventoryIdKey = [[NSString alloc] initWithFormat:@"%lld",_inventoryId.longLongValue];
//                InventoryDeliveryMaterialBatchEntity *batch = [[InventoryDeliveryMaterialBatchEntity alloc] init];
//                batch.batchId = _curBatch.batchId;
//                batch.amount = amount.stringValue;
                
                [_batchAmountDict setValue:amount forKeyPath:batchIdKey];
                [_batchPriceDict setValue:_curBatch.cost forKeyPath:batchIdKey];
            }
        }
    }
    [self resetWorking];
}

- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [self resetWorking];
    }
}

#pragma mark - 弹出框隐藏
- (void) resetWorking {
    [self updateList];
    [_alertView close];
}

- (void) showAmountAlertDialog {
    NSString *strBatch = [[NSString alloc] initWithFormat:@"%lld", _curBatch.batchId.longLongValue];
    NSNumber *amount = [_batchAmountDict valueForKeyPath:strBatch];
    if(amount.doubleValue > 0) {
        [_amountView setDesc:[[NSString alloc] initWithFormat:@"%0.2f", amount.doubleValue]];
    } else {
        [_amountView clearInput];
    }
    
    [_alertView showType:@"amount"];
    [_alertView show];
}

#pragma mark - 网络请求
//通过ID获取物资详情
- (void) requestMaterialDetail {
    if(_inventoryId) {
        __weak typeof(self) weakSelf = self;
        [weakSelf showLoadingDialog];
        [_business getMaterialDetailById:_inventoryId success:^(NSInteger key, id object) {
            weakSelf.material = object;
            weakSelf.validNumber = [NSNumber numberWithDouble:weakSelf.material.realNumber.doubleValue - weakSelf.material.reservedNumber.doubleValue];
            [weakSelf.helper setInfoWithMaterialDetail:weakSelf.material];
            [weakSelf updateList];
            [weakSelf hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf.helper setInfoWithMaterialDetail:weakSelf.material];
            [weakSelf updateList];
            [weakSelf hideLoadingDialog];
        }];
    }
}

//通过编码查询物资详情
- (void) requestMaterialDetailByCcode {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getMaterialDetailByCode:_materialCode warehouse:_warehouseId success:^(NSInteger key, id object) {
        weakSelf.material = object;
        weakSelf.inventoryId = weakSelf.material.inventoryId;
        [weakSelf.helper setInfoWithMaterialDetail:weakSelf.material];
        [weakSelf updateList];
        [weakSelf requestBatchList];
        [weakSelf hideLoadingDialog];
        if (!weakSelf.material.inventoryId) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [weakSelf requestWarehouseList];
        }
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf.helper setInfoWithMaterialDetail:weakSelf.material];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

//获取仓库列表以便于获取仓库管理员
- (void) requestWarehouseList {
    if (!_warehouseArray) {
        _warehouseArray = [NSMutableArray new];
    } else {
        [_warehouseArray removeAllObjects];
    }
    __block NetPage *warehousePage = [[NetPage alloc] init];
    __block BOOL canOperate = NO;
    __weak typeof(self) weakSelf = self;
    InventoryGetWarehouseParam *param = [[InventoryGetWarehouseParam alloc] initWith:warehousePage employeeId:[SystemConfig getEmployeeId]];
    [_business getWarehouseList:param success:^(NSInteger key, id object) {
        InventoryGetWarehouseResponseData * data = object;
        [warehousePage setPage:data.page];
        if([warehousePage isFirstPage]) {
            weakSelf.warehouseArray = data.contents;
        } else {
            [weakSelf.warehouseArray addObjectsFromArray:data.contents];
        }
        if([warehousePage haveMorePage]) {
            [weakSelf requestWarehouseList];
        } else {
            canOperate = [weakSelf updateInventoryOperationAbilityByWarehouseArray:weakSelf.warehouseArray];//判断有无操作权限
            if (!canOperate) {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_no_right" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            }
        }
        [weakSelf updateList];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf.warehouseArray removeAllObjects];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_request_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//获取领用人列表
- (void) requestReceivingPerson {
    if (!_recivingPersonArray) {
        _recivingPersonArray = [NSMutableArray new];
    } else {
        [_recivingPersonArray removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    [_userBusiness getUsersOfCurrentProjectSuccess:^(NSInteger key, id object) {
        weakSelf.recivingPersonArray = object;
        weakSelf.currentRecivingPerson = -1;
        [weakSelf updateList];
        [weakSelf requestSupervisors];
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.recivingPersonArray = nil;
        weakSelf.supervisorArray = nil;
        [weakSelf updateList];
    }];
}

//请求主管信息列表
- (void) requestSupervisors {
    if(_recivingPersonArray && _currentRecivingPerson >= 0 && _currentRecivingPerson < [_recivingPersonArray count]) {
        WorkOrderBusiness *business = [WorkOrderBusiness getInstance];
        SimpleUserEntity *user = _recivingPersonArray[_currentRecivingPerson];
        NSNumber *emId = user.emId;
        if (!_supervisorArray) {
            _supervisorArray = [NSMutableArray new];
        } else {
            [_supervisorArray removeAllObjects];
        }
        __weak typeof(self) weakSelf = self;
        [business getWorkGroupSupervisors:emId success:^(NSInteger key, id object) {
            weakSelf.supervisorArray = object;
            weakSelf.currentSupervisor = -1;
        } fail:^(NSInteger key, NSError *error) {
            weakSelf.currentSupervisor = -1;
        }];
    }
}

//获取物资批次列表
- (void) requestBatchList {
    if(_inventoryId) {
        __weak typeof(self) weakSelf = self;
        [weakSelf showLoadingDialog];
        [_business getMaterialBatchList:INVENTORY_MATERIAL_DETAIL_GET_BATCH_VALID material:_inventoryId page:_page success:^(NSInteger key, id object) {
            InventoryGetMaterialDetailBatchResponseData *data = object;
            [weakSelf.page setPage:data.page];
            NSMutableArray *batchs = data.contents;
            [weakSelf.helper addBatchArray:batchs];
            [weakSelf updateList];
            if([weakSelf.page haveMorePage]) {
                [weakSelf.page nextPage];
                [weakSelf requestBatchList];
            }
            [weakSelf hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
        }];
    }
}

//请求出库
- (void) requestDelivery {
    if(_business) {
        InventoryDeliveryParam * param = [self getDeliveryParam];
        if ([FMUtils isNumberNullOrZero:param.administrator]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if ([FMUtils isNumberNullOrZero:param.receivingPersonId]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_receiving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            if([param.inventory count] > 0) {
                __weak typeof(self) weakSelf = self;
                [weakSelf showLoadingDialog];
                [_business requestDelivery:param success:^(NSInteger key, id object) {
                    [weakSelf hideLoadingDialog];
                    [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
                } fail:^(NSInteger key, NSError *error) {
                    [weakSelf hideLoadingDialog];
                    [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                }];
            } else {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_receive_amount" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        }
    }
}

//请求移库
- (void) requestTransfer {
    InventoryDeliveryParam * param = [self getTransferParam];
    if([param.inventory count] > 0) {
        if ([FMUtils isNumberNullOrZero:param.administrator]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator_src" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if ([FMUtils isNumberNullOrZero:param.targetAdministrator]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator_target" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if ([FMUtils isNumberNullOrZero:param.targetWarehouseId]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_target" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            __weak typeof(self) weakSelf = self;
            [weakSelf showLoadingDialog];
            [_business requestDelivery:param success:^(NSInteger key, id object) {
                [weakSelf hideLoadingDialog];
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_transfer_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            } fail:^(NSInteger key, NSError *error) {
                [weakSelf hideLoadingDialog];
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_transfer_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_shift_receive_amount" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//出库参数
- (InventoryDeliveryParam *) getDeliveryParam {
    InventoryDeliveryParam * param = [[InventoryDeliveryParam alloc] init];
    param.type = INVENTORY_DELIVERY_TYPE_DIRECT;
    if(_material) {
        param.activityId = nil;
        param.warehouseId = _material.warehouseId;
        param.targetWarehouseId = nil;
        if (_srcWareHouseAdminArray && _currentSrcWareHouseAdmin >= 0 && _currentSrcWareHouseAdmin < [_srcWareHouseAdminArray count]) {
            WarehouseAdministrator *admin = _srcWareHouseAdminArray[_currentSrcWareHouseAdmin];
            param.administrator = admin.administratorId;
        }
        if (_recivingPersonArray && _currentRecivingPerson >= 0 && _currentRecivingPerson < [_recivingPersonArray count]) {
            SimpleUserEntity * user = _recivingPersonArray[_currentRecivingPerson];
            param.receivingPersonId = user.emId;
        }
        if (_supervisorArray && _currentSupervisor >= 0 && _currentSupervisor < [_supervisorArray count]) {
            WorkTeamSupervisorEntity *supervisor = _supervisorArray[_currentSupervisor];
            param.supervisor = supervisor.supervisorId;
        }
        InventoryDeliveryMaterialEntity * material = [[InventoryDeliveryMaterialEntity alloc] init];
        material.inventoryId = [_material.inventoryId copy];
        material.batch = [self getSelectBatchArray];
        if([material.batch count] > 0) {
            [param.inventory addObject:material];
        }
    }
    return param;
}

//获取移库参数
- (InventoryDeliveryParam *) getTransferParam {
    InventoryDeliveryParam * param = [[InventoryDeliveryParam alloc] init];
    param.type = INVENTORY_DELIVERY_TYPE_TRANSFER;
    
    if(_material) {
        param.activityId = nil;
        param.warehouseId = _material.warehouseId;
        if(_targetWarehouse) {
            param.targetWarehouseId = _targetWarehouse.warehouseId;
        }
        if (_srcWareHouseAdminArray && _currentSrcWareHouseAdmin >= 0 && _currentSrcWareHouseAdmin < [_srcWareHouseAdminArray count]) {
            WarehouseAdministrator *admin = _srcWareHouseAdminArray[_currentSrcWareHouseAdmin];
            param.administrator = admin.administratorId;
        }
        
        if (_targetWareHouseAdminArray && _currentTargetWareHouseAdmin >= 0 && _currentTargetWareHouseAdmin < [_targetWareHouseAdminArray count]) {
            WarehouseAdministrator *admin = _targetWareHouseAdminArray[_currentTargetWareHouseAdmin];
            param.targetAdministrator = admin.administratorId;
        }
        
        InventoryDeliveryMaterialEntity * material = [[InventoryDeliveryMaterialEntity alloc] init];
        material.inventoryId = [_material.inventoryId copy];
        material.batch = [self getSelectBatchArray];
        if([material.batch count] > 0) {
            [param.inventory addObject:material];
        }
    }
    return param;
}

#pragma mark - 事件通知
- (void) notifyEvent:(InventoryDeliveryMaterialDetailEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        if (type == INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_OK) {
            [result setValue:_batchPriceDict forKeyPath:@"cost"];
            [result setValue:_batchAmountDict forKeyPath:@"amount"];
        }
        [msg setValue:result forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

//获取所选批次信息
- (NSMutableArray *) getSelectBatchArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(NSString * key in _batchAmountDict) {
        NSNumber *tmpNumber = [_batchAmountDict valueForKeyPath:key];
        if(tmpNumber.doubleValue > 0) {
            InventoryDeliveryMaterialBatchEntity * batch = [[InventoryDeliveryMaterialBatchEntity alloc] init];
            batch.batchId = [FMUtils stringToNumber:key];
            batch.amount = [[NSString alloc] initWithFormat:@"%.2f", tmpNumber.doubleValue];
            [array addObject:batch];
        }
    }
    return array;
}

//- (NSString *)getSelectBatchCost {
//    CGFloat cost = 0;
//    for(NSString *key in _batchAmountDict) {
//        NSNumber *tmpNumber = [_batchAmountDict valueForKeyPath:key];
//        NSString *pirce = [_batchPriceDict valueForKeyPath:key];
//        
//        cost += tmpNumber.floatValue * pirce.floatValue;
//    }
//    NSString *costStr = [NSString stringWithFormat:@"%0.2f",cost];
//    return costStr;
//}

//获取当前物料所属仓库信息
- (WarehouseEntity *) getWarehouse {
    WarehouseEntity * warehouse  = [[WarehouseEntity alloc] init];
    warehouse.warehouseId = [_material.warehouseId copy];
    warehouse.name = [_material.warehouseName copy];
    for(WarehouseEntity * obj in _warehouseArray) {
        if(obj.warehouseId && [obj.warehouseId isEqualToNumber:warehouse.warehouseId]) {
            warehouse.administrator = obj.administrator;
            break;
        }
    }
    return warehouse;
}

//获取物料概况
- (MaterialEntity *) getMaterialInfo {
    MaterialEntity * res = [[MaterialEntity alloc] init];
    res.inventoryId = [_material.inventoryId copy];
    res.materialCode = [_material.code copy];
    res.materialName = [_material.name copy];
    res.materialBrand = [_material.brand copy];
    res.materialModel = [_material.model copy];
    res.materialUnit = [_material.unit copy];
    res.realNumber = [_material.realNumber copy];
    res.totalNumber = [_material.totalNumber copy];
    res.minNumber = [_material.minNumber copy];
    res.cost = [_material.price copy];
//    [FMUtils stringToNumber:_material.price];
    return res;
}

//批次修改完成
- (void) notifyBatchSelectOK {
    if(_fromQrcode) {
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        WarehouseEntity * warehouse  = [self getWarehouse];
        MaterialEntity * material = [self getMaterialInfo];
        NSMutableArray * batchs = [self getSelectBatchArray];
        [data setValue:warehouse forKeyPath:@"warehouse"];
        [data setValue:material forKeyPath:@"material"];
        [data setValue:batchs forKeyPath:@"batch"];
        [self notifyEvent:INVENTORY_DELIVERY_MATERIAL_QRCODE_OK data:data];
    } else {
        NSMutableArray * batchs = [self getSelectBatchArray];
        [self notifyEvent:INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_OK data:batchs];
    }
}

#pragma mark - 事件处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryMaterialDetailEventType eventType = [tmpNumber integerValue];
            NSMutableDictionary * data = [result valueForKeyPath:@"eventData"];
            switch(eventType) {
                case INVENTORY_MATERIAL_DETAIL_EVENT_EDIT_AMOUNT:
                    _curBatch = [data valueForKeyPath:@"batch"];
                    if(!_readOnly) {
                        [self showAmountAlertDialog];
                    }
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_NEED_UPDATE:
                    [self updateList];
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_WAREHOUSE_TARGET:
                    [self gotoSelectTargetWarehouse];
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_SRC:
                    [self gotoSelectSrcAdministrator];
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_TARGET:
                    [self gotoSelectTargetAdministrator];
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_RECIVING_PERSON:
                    [self gotoSelectReceinvingPerson];
                    break;
                case INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_SUPERVISOR:
                    [self gotoSelectSupervisor];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            WarehouseEntity * warehouse;
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            switch (requestType) {
                case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
                    warehouse = [msg valueForKeyPath:@"result"];
                    if(!_targetWarehouse || (![warehouse.warehouseId isEqualToNumber:_targetWarehouse.warehouseId])) {
                        if(_material.warehouseId && [_material.warehouseId isEqualToNumber:warehouse.warehouseId]) {  //如果目标仓库跟原仓库一样
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_src_target_same" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        } else {
                            _targetWarehouse = warehouse;
                            _targetWareHouseAdminArray = nil;
                            _needUpdate = YES;
                        }
                    }
                    break;
                    
                case REQUEST_TYPE_COMMON_INFO_SELECT:
                    if(_selectType == INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_SRC) {
                        NSMutableDictionary *result = [msg valueForKeyPath:@"result"];
                        NSNumber *tmpNumber;
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentSrcWareHouseAdmin = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if (_selectType == INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_TARGET) {
                        NSMutableDictionary *result = [msg valueForKeyPath:@"result"];
                        NSNumber *tmpNumber;
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentTargetWareHouseAdmin = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if (_selectType == INVENTORY_INFO_SELECT_TYPE_RECEIVING_PERSON) {
                        NSMutableDictionary *result = [msg valueForKeyPath:@"result"];
                        NSNumber *tmpNumber;
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentRecivingPerson = tmpNumber.integerValue;
                            _needUpdate = YES;
                            [self requestSupervisors];
                        }
                    } else if (_selectType == INVENTORY_INFO_SELECT_TYPE_SUPERVISOR) {
                        NSMutableDictionary *result = [msg valueForKeyPath:@"result"];
                        NSNumber *tmpNumber;
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentSupervisor = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - 键盘的显示与隐藏
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
//        CGFloat statusBarHeight = 20;
//        [_alertView moveToTopWithHeight:keyboardSize.height andPadding:statusBarHeight];
        [_alertView moveUp:keyboardSize.height];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if(![_alertView isHidden]) {
        [_alertView reset];
    }
}

#pragma mark - 页面跳转
- (void) gotoSelectTargetWarehouse {
    NSDictionary *param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"selectAll", nil];    //目标仓库为本项目所有仓库
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择原仓库管理员
- (void) gotoSelectSrcAdministrator {
    _selectType = INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_SRC;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
    for(WarehouseAdministrator * admin in _srcWareHouseAdminArray) {
        [data addObject:admin.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择目标库管理员
- (void) gotoSelectTargetAdministrator {
    if (_targetWarehouse) {
        _selectType = INVENTORY_INFO_SELECT_TYPE_ADMINISTRATOR_TARGET;
        NSMutableArray * data = [[NSMutableArray alloc] init];
        NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
        for(WarehouseAdministrator * admin in _targetWareHouseAdminArray) {
            [data addObject:admin.name];
        }
        NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
        InfoSelectViewController *vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_target" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    
}

//选择领用人
- (void) gotoSelectReceinvingPerson {
    _selectType = INVENTORY_INFO_SELECT_TYPE_RECEIVING_PERSON;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc = [[BaseBundle getInstance] getStringByKey:@"inventory_out_person" inTable:nil];
    for(SimpleUserEntity * user in _recivingPersonArray) {
        [data addObject:user.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择主管
- (void) gotoSelectSupervisor {
    if (_recivingPersonArray && _currentRecivingPerson >= 0 && _currentRecivingPerson < _recivingPersonArray.count) {
        _selectType = INVENTORY_INFO_SELECT_TYPE_SUPERVISOR;
        NSMutableArray * data = [[NSMutableArray alloc] init];
        NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_supervisor" inTable:nil];;
        for(WorkTeamSupervisorEntity *supervisor in _supervisorArray) {
            [data addObject:supervisor.name];
        }
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_receiving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

@end

