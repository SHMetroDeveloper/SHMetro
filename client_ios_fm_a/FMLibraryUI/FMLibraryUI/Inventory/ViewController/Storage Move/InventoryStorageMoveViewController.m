//
//  InventoryStorageMoveViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageMoveViewController.h"
#import "InventoryTransferWarehouseSelectView.h"
#import "UIButton+Bootstrap.h"
#import "InventoryTransferTableHelper.h"
#import "QrCodeViewController.h"
#import "InfoSelectViewController.h"
#import "InventoryDeliveryMaterialDetailViewController.h"
#import "WarehouseEntity.h"
#import "InventoryDeliveryEntity.h"
#import "DXAlertView.h"
#import "InventoryBusiness.h"
#import "WorkOrderBusiness.h"
#import "InventoryMaterialQrcode.h"
#import "BaseBundle.h"

typedef NS_ENUM(NSInteger, InventoryStorageMoveSelectType) {
    INVENTORY_STORAGE_MOVE_SELECT_UNKNOW,
    INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_SRC,
    INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_TARGET,
};

@interface InventoryStorageMoveViewController () <OnMessageHandleListener, OnQrCodeScanFinishedListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) InventoryTransferWarehouseSelectView * warehouseView;

@property (readwrite, nonatomic, strong) UITableView * materialTableView;

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * okBtn;

@property (readwrite, nonatomic, assign) CGFloat warehouseHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, strong) InventoryTransferTableHelper * helper;
@property (readwrite, nonatomic, strong) InventoryBusiness * business;

@property (readwrite, nonatomic, strong) WarehouseEntity * warehouse;   //原仓库
@property (readwrite, nonatomic, strong) WarehouseEntity * targetWarehouse;   //目标仓库

@property (readwrite, nonatomic, strong) NSMutableArray * materials;    //物料数组
@property (readwrite, nonatomic, strong) NSMutableArray * batchArray;   //存储物料出库批次数组
@property (readwrite, nonatomic, strong) InventoryMaterialQrcode * materialQrcode;

@property (readwrite, nonatomic, assign) InventoryTransferWarehouseSelectType warehouseType;
@property (readwrite, nonatomic, assign) NSInteger curPosition;
@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, assign) NSInteger srcAdministratorIndex;   //原仓库管理员索引
@property (readwrite, nonatomic, assign) NSInteger targetAdministratorIndex;//目标仓库管理员索引

@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法

@property (readwrite, nonatomic, assign) InventoryStorageMoveSelectType selectType;//选择类型

@end

@implementation InventoryStorageMoveViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_move" inTable:nil]];
    UIImage *addImage = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
    UIImage *scanImage = [[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"];
    [self setMenuWithArray:@[addImage, scanImage]];
    [self setBackAble:YES];
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    CGFloat realWidth = CGRectGetWidth(frame);
    CGFloat realHeight = CGRectGetHeight(frame);
    
    _helper = [[InventoryTransferTableHelper alloc] init];
    [_helper setOnMessageHandleListener:self];
    _business = [InventoryBusiness getInstance];
    
    _warehouseHeight = 120;
    _controlHeight = [FMSize getInstance].btnBottomControlHeight + [FMSize getInstance].padding20;
    _btnHeight = [FMSize getInstance].btnBottomControlHeight;
    
    CGFloat padding = [FMSize getInstance].padding20;
    
    if(!_mainContainerView) {
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _warehouseView = [[InventoryTransferWarehouseSelectView alloc] initWithFrame:CGRectMake(0, 0, realWidth, _warehouseHeight)];
        _warehouseView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_warehouseView setOnItemClickListener:self];
        
        _materialTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _warehouseHeight, realWidth, realHeight-_warehouseHeight-_controlHeight)];
        _materialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _materialTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _materialTableView.dataSource = _helper;
        _materialTableView.delegate = _helper;
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, realHeight-_controlHeight, realWidth, _controlHeight)];
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0, realWidth-padding * 2, _btnHeight)];
        [_okBtn successStyle];
        [_okBtn setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_transfer" inTable:nil] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(onOkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.titleLabel.font = [FMFont getInstance].font44;
        
        [_controlView addSubview:_okBtn];
        
        [_mainContainerView addSubview:_warehouseView];
        [_mainContainerView addSubview:_materialTableView];
        [_mainContainerView addSubview:_controlView];
        
        [self.view addSubview:_mainContainerView];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    }
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateWarehouse];
        [self updateList];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    switch(position) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    NSNumber *  count = 0;
    double sum = 0;
    for(InventoryDeliveryMaterialBatchEntity * batch in array) {
        sum += batch.amount.doubleValue;
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

- (void) updateWarehouse {
    [_warehouseView setInfoWithSrcWarehouse:_warehouse.name targetWarehouse:_targetWarehouse.name];
    if(_srcAdministratorIndex >= 0 && _srcAdministratorIndex < [_warehouse.administrator count]) {
        WarehouseAdministrator * srcAdmin = _warehouse.administrator[_srcAdministratorIndex];
        [_helper setSrcAdministrator:srcAdmin.name];
    } else {
        [_helper setSrcAdministrator:nil];
    }
    if(_targetAdministratorIndex >= 0 && _targetAdministratorIndex < [_targetWarehouse.administrator count]) {
        WarehouseAdministrator * targetAdmin = _targetWarehouse.administrator[_targetAdministratorIndex];
        [_helper setTargetAdministrator:targetAdmin.name];
    } else {
        [_helper setTargetAdministrator:nil];
    }
}

- (void) updateList {
    [_materialTableView reloadData];
}



#pragma mark - 点击事件
- (void) onOkButtonClicked {    //
    [self requestTransfer];
}

- (void) onAddButtonClicked {   //
    [self gotoSelectMaterial];
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


- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _warehouseView) {
        InventoryTransferWarehouseSelectType type = subView.tag;
        BOOL isOK = NO;
        switch(type) {
            case INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC:
                isOK = YES;
                break;
            case INVENTORY_TRANSFER_WAREHOUSE_SELECT_TARGET:
                isOK = YES;
                break;
            default:
                break;
        }
        if(isOK) {
            _warehouseType = type;
            [self gotoSelectWarehouse];
        }
        
    }
}

#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            id data = [result valueForKeyPath:@"eventData"];
            InventoryTransferTableEventType eventType = [tmpNumber integerValue];
            MaterialEntity * material;
            switch(eventType) {
                case INVENTORY_TRANSFER_TABLE_EVENT_SHOW_MATERIAL:
                    material = [data valueForKeyPath:@"material"];
                    tmpNumber = [data valueForKeyPath:@"position"];
                    [self gotoMaterialDetail:tmpNumber.integerValue];
                    break;
                case INVENTORY_TRANSFER_TABLE_EVENT_DELETE_MATERIAL:
                    [self tryToDeleteMaterial:data];
                    break;
                case INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_SRC:
                    if(_warehouse && [_warehouse.administrator count] > 1) {
                        [self gotoSelectAdministratorSrc];
                    }
                    break;
                case INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_TARGET:
                    if(_targetWarehouse && [_targetWarehouse.administrator count] > 1) {
                        [self gotoSelectAdministratorTarget];
                    }
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            MaterialEntity * material;
            WarehouseEntity * warehouse;
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            NSNumber * tmpNumber;
            __weak id weakSelf = self;
            switch (requestType) {
                case REQUEST_TYPE_MATERIAL_INFO_SELECT:
                    material = [msg valueForKeyPath:@"result"];
                    if(material) {
                        if([weakSelf isMaterialExist:material.inventoryId]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
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
                            [_helper addMaterial:material];
                            _needUpdate = YES;
                        }
                    }
                    break;
                case REQUEST_TYPE_COMMON_INFO_SELECT:
                    if(_selectType == INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_SRC) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _srcAdministratorIndex = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if(_selectType == INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_TARGET) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _targetAdministratorIndex = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    }
                    break;
                case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
                    warehouse = [msg valueForKeyPath:@"result"];
                    if(_warehouseType == INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC) {
                        if(!_warehouse || ![warehouse.warehouseId isEqualToNumber:_warehouse.warehouseId]) {
                            if(_targetWarehouse && [_targetWarehouse.warehouseId isEqualToNumber:warehouse.warehouseId]) {  //如果原仓库跟目标仓库一样
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_src_target_same" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                                });
                            } else {
                                _warehouse = warehouse;
                                if ([_warehouse.administrator count]  > 0) {
                                    _srcAdministratorIndex = 0;
                                } else {
                                    _srcAdministratorIndex = -1;
                                }
                            }
                        }
                    } else if(_warehouseType == INVENTORY_TRANSFER_WAREHOUSE_SELECT_TARGET) {
                        if(!_targetWarehouse || (![warehouse.warehouseId isEqualToNumber:_targetWarehouse.warehouseId])) {
                            if(_warehouse && [_warehouse.warehouseId isEqualToNumber:warehouse.warehouseId]) {  //如果目标仓库跟原仓库一样
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_src_target_same" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                                });
                            } else {
                                _targetWarehouse = warehouse;
                                if ([_targetWarehouse.administrator count]  > 0) {
                                    _targetAdministratorIndex = 0;
                                } else {
                                    _targetAdministratorIndex = -1;
                                }
                            }
                        }
                    }
                    _needUpdate = YES;
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
                    [_helper setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
                    break;
                case INVENTORY_DELIVERY_MATERIAL_QRCODE_OK:
                    data = [result valueForKeyPath:@"eventData"];
                    if(!_warehouse) {
                        _warehouse = [data valueForKeyPath:@"warehouse"];
                        _needUpdate = YES;
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
                    if(!_materials) {
                        _materials = [[NSMutableArray alloc] init];
                    }
                    if(!_batchArray) {
                        _batchArray = [[NSMutableArray alloc] init];
                    }
                    if(![self isMaterialExist:material.inventoryId]) {
                        [_materials addObject:material];
                        [_batchArray addObject:batchs];
                        [_helper addMaterial:material];
                        [_helper setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
                        _needUpdate = YES;
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
//                        _curPosition = [self getMaterialPosition:material.inventoryId];
//                        _batchArray[_curPosition] = [batchs copy];
//                        [_helper setAmount:[self getAmountByBatchArray:batchs] forMaterial:material.inventoryId];
//                        _needUpdate = YES;
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void) tryToDeleteMaterial:(NSDictionary *) data {
    if(data) {
//        MaterialEntity * material = [data valueForKeyPath:@"material"];
        NSNumber * tmpNumber = [data valueForKeyPath:@"position"];
        NSInteger position = tmpNumber.integerValue;
        DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_alert_delete_material" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        
        alertView.leftBlock = ^() {
            [_materials removeObjectAtIndex:position];
            [_batchArray removeObjectAtIndex:position];
            [_helper deleteMaterialAtPosition:position];
            [self updateList];
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

#pragma mark - 网络请求
- (void) requestTransfer {
    InventoryDeliveryParam * param = [self getDeliveryParam];
    if([param.inventory count] > 0) {
        if(param.administrator) {
            if(param.targetWarehouseId) {
                if(param.targetAdministrator) {
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
                } else {
                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator_target" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                }
            } else {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_target" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator_src" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_receive_amount" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (InventoryDeliveryParam *) getDeliveryParam {
    InventoryDeliveryParam * param = [[InventoryDeliveryParam alloc] init];
    param.type = INVENTORY_DELIVERY_TYPE_TRANSFER;
    param.activityId = nil;
    param.warehouseId = _warehouse.warehouseId;
    param.targetWarehouseId = _targetWarehouse.warehouseId;
    if(_srcAdministratorIndex >= 0 && _srcAdministratorIndex < [_warehouse.administrator count]) {
        WarehouseAdministrator * admin = _warehouse.administrator[_srcAdministratorIndex];
        param.administrator = admin.administratorId;
    }
    if(_targetAdministratorIndex >= 0 && _targetAdministratorIndex < [_targetWarehouse.administrator count]) {
        WarehouseAdministrator * admin = _targetWarehouse.administrator[_targetAdministratorIndex];
        param.targetAdministrator = admin.administratorId;
    }
    NSInteger index = 0;
    for(MaterialEntity * obj in _materials) {
        InventoryDeliveryMaterialEntity * material = [[InventoryDeliveryMaterialEntity alloc] init];
        material.inventoryId = [obj.inventoryId copy];
        if(index >= 0 && index < [_batchArray count]) {
            NSMutableArray * batchArray = _batchArray[index];
            material.batch = batchArray;
            if([batchArray count] > 0) {    //如果预定的有批次
                [param.inventory addObject:material];
                index ++;
            }
        }
    }
    return param;
}

#pragma mark - 页面跳转
//扫描二维码
- (void) gotoScanQrcode {
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

//选择仓库
- (void) gotoSelectWarehouse {
    if(_warehouseType == INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC && _warehouse && [_materials count] > 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSDictionary * param = nil;
        if(_warehouseType == INVENTORY_TRANSFER_WAREHOUSE_SELECT_SRC) {
            param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"selectAll", nil];
        } else {
            param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"selectAll", nil];    //目标仓库为本项目所有仓库
        }
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    }
}

//选择物料
- (void) gotoSelectMaterial {
    if(_warehouse && _warehouse.warehouseId) {
        NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_warehouse.warehouseId, @"warehouseId", nil];
        InfoSelectViewController *vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_src" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//通过ID进入物料详情
- (void) gotoMaterialDetail:(NSInteger) position {
    _curPosition = position;
    MaterialEntity * material = _materials[position];
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
//    [vc setOperationType:INVENTORY_OPERATION_TYPE_SHIFT];
    [vc setOperationType:INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL];
    NSMutableArray * batchs = _batchArray[position];
    [vc setInfoWithMaterial:material batch:batchs];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//通过二维码扫描进入物料详情
- (void) gotoMaterialDetailByMaterialCode:(NSString *) materialCode warehouseId:(NSString *) warehouseId {
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
//    [vc setOperationType:INVENTORY_OPERATION_TYPE_SHIFT];
    [vc setOperationType:INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_NORMAL];
    NSNumber * whId = [FMUtils stringToNumber:warehouseId];
    [vc setInfoWithMaterialCode:materialCode warehouseId:whId];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择原仓库管理员
- (void) gotoSelectAdministratorSrc {
    _selectType = INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_SRC;
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

//选择目标仓库管理员
- (void) gotoSelectAdministratorTarget {
    _selectType = INVENTORY_STORAGE_MOVE_SELECT_ADMINISTRATOR_TARGET;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
    for(WarehouseAdministrator * admin in _targetWarehouse.administrator) {
        [data addObject:admin.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

@end
