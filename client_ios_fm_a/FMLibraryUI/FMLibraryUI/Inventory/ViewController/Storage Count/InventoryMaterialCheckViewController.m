//
//  InventoryStorageCountViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialCheckViewController.h"
#import "FMUtilsPackages.h"
#import "CaptionTextField.h"
#import "InventoryStorageInTableView.h"
#import "InfoSelectViewController.h"
#import "WarehouseEntity.h"
#import "InventoryMaterialCheckEditViewController.h"
#import "InventoryBusiness.h"
#import "InventoryBatchCheckViewModel.h"
#import "QrCodeViewController.h"
#import "InventoryMaterialQrcode.h"
#import "DXAlertView.h"
#import "BaseBundle.h"

@interface InventoryMaterialCheckViewController ()<OnMessageHandleListener, OnQrCodeScanFinishedListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) InventoryStorageInTableView *tableView;

@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIButton *storageInConfirmBtn;
@property (nonatomic, assign) CGFloat bottomBtnHeight;

@property (nonatomic, strong) WarehouseEntity *warehouse;  //仓库
@property (nonatomic, strong) NSNumber *warehouseId;   //仓库ID
@property (nonatomic, strong) NSString *warehouseName;   //仓库名字

@property (nonatomic, strong) NSMutableArray *inventoryArray;  //物料
@property (nonatomic, strong) NSMutableDictionary *batchModelDictionary;  //物料model

@property (nonatomic, strong) InventoryBusiness *business;

@property (readwrite, nonatomic, strong) InventoryMaterialQrcode * materialQrcode;
@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) BOOL needUpdate;
@end

@implementation InventoryMaterialCheckViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil]];
    [self setBackAble:YES];
    UIImage *addImage = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
    UIImage *scanImage = [[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"];
    [self setMenuWithArray:@[addImage, scanImage]];
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self tryToAddMaterial];
    } else if (position == 1) {
        [self gotoScanQrcode];
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
        [self updateList];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        _bottomBtnHeight = [FMSize getInstance].btnBottomControlHeight + [FMSize getInstance].padding20;
        
        if (!_business) {
            _business = [InventoryBusiness getInstance];
        }
        if (!_inventoryArray) {
            _inventoryArray = [NSMutableArray new];
        }
        if (!_batchModelDictionary) {
            _batchModelDictionary = [NSMutableDictionary new];
        }

        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.controlView];
        
        [self.view addSubview:_mainContainerView];
    }
}

#pragma mark - Lazyload 
- (InventoryStorageInTableView *)tableView {
    if (!_tableView) {
        _tableView = [[InventoryStorageInTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight-_bottomBtnHeight) style:UITableViewStyleGrouped];
        _tableView.tableViewType = TABLEVIEW_TYPE_CHECK;
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(){
            [weakSelf gotoSelectWarehouse];
        };
        _tableView.editBlock = ^(NSNumber *inventoryId){
            [weakSelf gotoCountMaterial:inventoryId];
        };
        _tableView.deleteBlock = ^(NSNumber *position){
            [weakSelf deleteMaterialByPosition:position];
        };
    }
    return _tableView;
}

- (UIView *)controlView {
    if (!_controlView) {
        CGFloat padding = [FMSize getInstance].padding20;
        _storageInConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0, _realWidth-padding*2, _bottomBtnHeight - padding)];
        _storageInConfirmBtn.layer.masksToBounds = YES;
        _storageInConfirmBtn.layer.cornerRadius = 3;
        [_storageInConfirmBtn addTarget:self action:@selector(confimButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_storageInConfirmBtn setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        [_storageInConfirmBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [_storageInConfirmBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil] forState:UIControlStateNormal];
        _storageInConfirmBtn.titleLabel.font = [FMFont getInstance].font44;
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, _realHeight-_bottomBtnHeight, _realWidth, _bottomBtnHeight)];
        [_controlView addSubview:_storageInConfirmBtn];
    }
    return _controlView;
}

#pragma mark - NetWorking
- (void)requestCheckIn {
    __weak typeof(self) weakSelf = self;
    InventoryMaterialCheckRequestParam *param = [self getCheckParam];
    BOOL canCheck = NO;
    for(InventoryMaterialCheckInventory * inventory in param.inventory) {
        if([inventory.batch count] > 0) {
            canCheck = YES;
            break;
        }
    }
    if(canCheck) {
        [weakSelf showLoadingDialog];
        [_business requestCheckInMaterial:param success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_check_upload_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_check_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    } else {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_batch_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    
}

- (InventoryMaterialCheckRequestParam *)getCheckParam {
    InventoryMaterialCheckRequestParam *param = [[InventoryMaterialCheckRequestParam alloc] init];
    param.warehouseId = _warehouseId;
    
    for (InventoryMaterialDetail *inventoryID in _inventoryArray) {
        InventoryMaterialCheckInventory *inventory = [[InventoryMaterialCheckInventory alloc] init];
        inventory.inventoryId = inventoryID.inventoryId;
        
        NSString *key = [NSString stringWithFormat:@"%ld",inventoryID.inventoryId.integerValue];
        NSMutableArray<InventoryBatchCheckViewModel *> *editBatchModelArray = [_batchModelDictionary valueForKeyPath:key];
        if (editBatchModelArray) {
            for (InventoryBatchCheckViewModel *batchModel in editBatchModelArray) {
                InventoryMaterialCheckBatch *batchEntity = [[InventoryMaterialCheckBatch alloc] init];
                batchEntity.batchId = batchModel.batchId;
                batchEntity.inventoryNumber = [[NSString alloc] initWithFormat:@"%.2f", batchModel.inventoryNumber.doubleValue];
                batchEntity.number = [[NSString alloc] initWithFormat:@"%.2f", batchModel.checkNumber.doubleValue];
                
                [inventory.batch addObject:batchEntity];
            }
        }

        [param.inventory addObject:inventory];
    }
    
    return param;
}

#pragma mark - Private Method

- (void)updateList {
    _tableView.dataArray = _inventoryArray;
}

- (void)deleteMaterialByPosition:(NSNumber *)position {
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_alert_delete_material" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
    
    NSInteger index = position.integerValue;
    InventoryMaterialDetail *inventoryDetail = _inventoryArray[index];
    NSString *key = [NSString stringWithFormat:@"%ld",inventoryDetail.inventoryId.integerValue];
    alertView.leftBlock = ^() {
        [_batchModelDictionary removeObjectForKey:key];
        
        [_inventoryArray removeObjectAtIndex:position.integerValue];
        
        [self updateList];
    };
    alertView.rightBlock = ^() {
    };
    [alertView show];
}


- (void) confimButtonEvent:(UIButton *)button {
    if (!_warehouseId) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (!_inventoryArray || _inventoryArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        [self requestCheckIn];
    }
}

- (void) tryToAddMaterial {
    if(_warehouseId) {
        [self gotoAddMaterial];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void)addMaterialToTableView:(MaterialEntity *)material batchs:(NSArray *) batchArray{
    if (!_inventoryArray) {
        _inventoryArray = [NSMutableArray new];
    }
    InventoryMaterialDetail *inventoryDetail = [[InventoryMaterialDetail alloc] init];
    inventoryDetail.inventoryId = material.inventoryId;
    inventoryDetail.code = material.materialCode;
    inventoryDetail.name = material.materialName;
    inventoryDetail.model = material.materialModel;
    inventoryDetail.unit = material.materialUnit;
    inventoryDetail.price = material.cost;
    inventoryDetail.realNumber = material.realNumber;
    inventoryDetail.totalNumber = material.totalNumber;
    inventoryDetail.minNumber = material.minNumber;
    if (batchArray) {
        inventoryDetail.reservedNumber = [self getAmountByBatchArray:batchArray];
    } else {
        inventoryDetail.reservedNumber = material.totalNumber;
    }
    inventoryDetail.brand = material.materialBrand;
    
    [_inventoryArray addObject:inventoryDetail];
}

- (NSNumber *) getAmountByBatchArray:(NSArray *) array {
    NSNumber * count = 0;
    double sum = 0;
    for(InventoryBatchCheckViewModel * model in array) {
        sum += model.checkNumber.doubleValue;
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

- (BOOL) isMaterialExist:(NSNumber *) materialId {
    BOOL res = NO;
    for(InventoryMaterialDetail * material in _inventoryArray) {
        if([material.inventoryId isEqualToNumber:materialId]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (NSInteger) getMaterialPosition:(NSNumber *) inventoryId {
    NSInteger position = -1;
    NSInteger index = 0;
    for(InventoryMaterialDetail * material in _inventoryArray) {
        if([material.inventoryId isEqualToNumber:inventoryId]) {
            position = index;
            break;
        }
        index++;
    }
    return position;
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"InfoSelectViewController"]) {
            NSNumber * tmpNumber;
            NSInteger requestType;
            tmpNumber = [msg valueForKeyPath:@"requestType"];
            requestType = [tmpNumber integerValue];
            switch(requestType) {
                case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:{
                    _warehouse = [msg valueForKeyPath:@"result"];
                    if (_warehouse) {
                        _warehouseId = _warehouse.warehouseId;
                        [_tableView setWareHouseName:_warehouse.name];
                    }
                }
                    break;
                    
                case REQUEST_TYPE_MATERIAL_INFO_SELECT:{
                    MaterialEntity *material = [msg valueForKeyPath:@"result"];
                    if (material) {
                        if(![self isMaterialExist:material.inventoryId]) {
                            [self addMaterialToTableView:material batchs:nil];
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        }
                        _needUpdate = YES;
                    }
                }
                    break;
            }
        } else if([msgOrigin isEqualToString:@"InventoryMaterialCheckEditViewController"]){
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryCheckMaterialDetailEventType eventType = [tmpNumber integerValue];
            NSMutableArray * batchs;
            MaterialEntity * material;
            NSMutableDictionary * data;
            NSNumber *inventoryId;
            NSInteger position;
            switch (eventType) {
                case INVENTORY_CHECK_MATERIAL_DETAIL_EVENT_OK:
                    batchs = [result valueForKeyPath:@"eventData"];
                    inventoryId = [result valueForKeyPath:@"inventoryId"];
                    position = [self getMaterialPosition:inventoryId];
                    [_tableView setAmount:[self getAmountByBatchArray:batchs] forMaterial:inventoryId];
                    [_batchModelDictionary setValue:batchs forKeyPath:[NSString stringWithFormat:@"%ld",inventoryId.integerValue]];
                    break;
                case INVENTORY_CHECK_MATERIAL_QRCODE_OK:
                    data = [result valueForKeyPath:@"eventData"];
                    if(!_warehouse) {
                        _warehouse = [data valueForKeyPath:@"warehouse"];
                        _warehouseId = _warehouse.warehouseId;
                        [_tableView setWareHouseName:_warehouse.name];
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
                    if(!_inventoryArray) {
                        _inventoryArray = [[NSMutableArray alloc] init];
                    }
                    if(!_batchModelDictionary) {
                        _batchModelDictionary = [[NSMutableDictionary alloc] init];
                    }
                    if(![self isMaterialExist:material.inventoryId]) {
                        [self addMaterialToTableView:material batchs:batchs];
                        _needUpdate = YES;
                        [_batchModelDictionary setValue:batchs forKeyPath:[NSString stringWithFormat:@"%ld",material.inventoryId.integerValue]];
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
                    }
                    break;
                default:
                    break;
            }
            
        }
    }
}

#pragma mark - 二维码扫描结束
- (void) onQrCodeScanFinished:(NSString *)result {
    _backFromQrcode = YES;
    _materialQrcode = [[InventoryMaterialQrcode alloc] initWithString:result];
    _isValidQrcode = [_materialQrcode isValidQrcode];
}


#pragma mark - PushEvent
//扫描二维码
- (void) gotoScanQrcode {
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

//选择仓库
- (void) gotoSelectWarehouse {
    if(_warehouse && [_inventoryArray count] > 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"selectAll", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    }
}

//添加物料
- (void)gotoAddMaterial {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_warehouseId forKeyPath:@"warehouseId"];
    InventoryGetMaterialCondition *condition = [[InventoryGetMaterialCondition alloc] init];
    condition.type = INVENTORY_GET_MATERIAL_TYPE_BATCH_ABLE;
    [param setValue:condition forKeyPath:@"condition"];
    InfoSelectViewController * materialVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
    [materialVC setOnMessageHandleListener:self];
    
    [self gotoViewController:materialVC];
}

//编辑物料
- (void)gotoCountMaterial:(NSNumber *) inventoryId {
    
    NSString *key = [NSString stringWithFormat:@"%ld",inventoryId.integerValue];
    NSMutableArray<InventoryBatchCheckViewModel *> *editBatchModelArray = [_batchModelDictionary valueForKeyPath:key];
    
    InventoryMaterialCheckEditViewController *editMaterialVC = [[InventoryMaterialCheckEditViewController alloc] init];
    editMaterialVC.inventoryId = inventoryId;
    if (editBatchModelArray) {
        editMaterialVC.editBatchModelArray = editBatchModelArray;
    }
    [editMaterialVC setOnMessageHandleListener:self];

    [self gotoViewController:editMaterialVC];
}

- (void) gotoMaterialDetailByMaterialCode:(NSString *) materialCode warehouseId:(NSString *) warehouseId {
    if(![FMUtils isStringEmpty:materialCode] && ![FMUtils isStringEmpty:warehouseId]) {
        InventoryMaterialCheckEditViewController * vc = [[InventoryMaterialCheckEditViewController alloc] init];
        vc.fromQrcode = YES;
        vc.materialCode = materialCode;
        vc.warehouseId = [FMUtils stringToNumber:warehouseId];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"qrcode_notice_not_valid" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

@end
