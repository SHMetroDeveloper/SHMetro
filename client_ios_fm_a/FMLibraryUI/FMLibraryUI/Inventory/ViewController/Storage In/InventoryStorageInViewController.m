//
//  InventoryStorageInViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageInViewController.h"
#import "FMUtilsPackages.h"
#import "CaptionTextField.h"
#import "InventoryStorageInTableView.h"
#import "InfoSelectViewController.h"
#import "WarehouseEntity.h"
#import "ReservationMaterialViewController.h"
#import "InventoryStorageInEditMaterialViewController.h"
#import "InventoryBusiness.h"
#import "InventoryMaterialBatchViewModel.h"
#import "QrCodeViewController.h"
#import "InventoryMaterialQrcode.h"
#import "DXAlertView.h"
#import "BaseBundle.h"

@interface InventoryStorageInViewController () <OnMessageHandleListener, OnQrCodeScanFinishedListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) InventoryStorageInTableView *tableView;

@property (nonatomic, strong) WarehouseEntity *warehouse;  //仓库
@property (nonatomic, strong) NSNumber *warehouseId;   //仓库ID
@property (nonatomic, strong) NSString *warehouseName;   //仓库名字

@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIButton *storageInConfirmBtn;
@property (nonatomic, assign) CGFloat bottomBtnHeight;

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) NSMutableArray *inventoryModelArray;  //物料Model  用于tableview显示
@property (nonatomic, strong) NSMutableArray *inventoryParamArray;  //物料参数 用于网络请求
@property (nonatomic, strong) NSMutableDictionary *batchModelDictionary;     //批次model 用于物资批次修改

@property (readwrite, nonatomic, strong) InventoryMaterialQrcode * materialQrcode;
@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) BOOL needUpdate;
@end

@implementation InventoryStorageInViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil]];
    [self setBackAble:YES];
    
    UIImage *scanImage = [[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"];
    UIImage *addImage = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
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
            NSString *code = [_materialQrcode getMaterialCode];
            NSString *warehouseId = [_materialQrcode getWarehouseId];
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
        if (!_inventoryParamArray) {
            _inventoryParamArray = [NSMutableArray new];
        }
        if (!_inventoryModelArray) {
            _inventoryModelArray = [NSMutableArray new];;
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
        
        _tableView.tableViewType = TABLEVIEW_TYPE_STORAGE;
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(){
            [weakSelf gotoSelectWarehouse];
        };
        _tableView.editBlock = ^(NSNumber *inventoryId){
            [weakSelf gotoEditMaterial:inventoryId];
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
        [_storageInConfirmBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil] forState:UIControlStateNormal];
        _storageInConfirmBtn.titleLabel.font = [FMFont getInstance].font44;
        
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, _realHeight-_bottomBtnHeight, _realWidth, _bottomBtnHeight)];
        [_controlView addSubview:_storageInConfirmBtn];
    }
    return _controlView;
}

#pragma mark - Private Method
- (void)deleteMaterialByPosition:(NSNumber *)position {
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_alert_delete_material" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
    
    NSInteger index = position.integerValue;
    InventoryMaterialDetail *inventoryDetail = _inventoryModelArray[index];
    NSString *key = [NSString stringWithFormat:@"%ld",inventoryDetail.inventoryId.integerValue];
    alertView.leftBlock = ^() {
        [_batchModelDictionary removeObjectForKey:key];
        [_inventoryModelArray removeObjectAtIndex:position.integerValue];
        [_inventoryParamArray removeObjectAtIndex:position.integerValue];
        [self updateList];
    };
    alertView.rightBlock = ^() {
    };
    [alertView show];
}

- (void)updateList {
    _tableView.dataArray = _inventoryModelArray;
}

- (void) confimButtonEvent:(UIButton *)button {
    if (!_warehouseId) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (!_inventoryModelArray || _inventoryModelArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if ([self isBatchEmpty]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_batch_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        [self requestStorageIn];
    }
}

- (BOOL)isBatchEmpty {
    BOOL isEmpty = NO;
    for (InventoryMaterialStorageInInventory *inventory in _inventoryParamArray) {
        if (inventory.batch.count == 0) {
            isEmpty = YES;
            break;
        }
    }
    return isEmpty;
}

- (void) tryToAddMaterial {
    if(_warehouseId) {
        [self gotoAddMaterial];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void)updateInventoryParam:(NSMutableArray *)batchModelArray andInventoryId:(NSNumber *)inventoryId {
    NSMutableArray *batchArray = [NSMutableArray new];
    for (InventoryMaterialBatchViewModel *batchModel in batchModelArray) {
        InventoryMaterialStorageInBatch *batch = [[InventoryMaterialStorageInBatch alloc] init];
        batch.providerId = batchModel.providerId;
        batch.dueDate = batchModel.dueDate;
        batch.price = batchModel.price;
        batch.number = batchModel.number;
        batch.providerName = batchModel.name;
        [batchArray addObject:batch];
    }
    InventoryMaterialStorageInInventory *inventory = [[InventoryMaterialStorageInInventory alloc] init];
    inventory.inventoryId = inventoryId;
    inventory.batch = batchArray;
    
    BOOL isExist = NO;
    NSUInteger index = 0;
    for (index = 0; index < _inventoryParamArray.count; index ++) {
        InventoryMaterialStorageInInventory *tmpInventory = _inventoryParamArray[index];
        if ([tmpInventory.inventoryId isEqualToNumber:inventoryId]) {
            isExist = YES;
            break;
        }
    }
    if (isExist) {
        [_inventoryParamArray replaceObjectAtIndex:index withObject:inventory];
    } else {
        [_inventoryParamArray addObject:inventory];
    }
}

- (void)updateInventoryModelWithStorageNumber:(NSNumber *)storageNumber andInventoryId:(NSNumber *)inventoryId {
    for (NSUInteger i = 0; i < _inventoryModelArray.count; i ++) {
        InventoryMaterialDetail *inventoryModel = _inventoryModelArray[i];
        if ([inventoryModel.inventoryId isEqualToNumber:inventoryId]) {
            inventoryModel.reservedNumber = storageNumber;
        }
    }
}

- (void)addMaterialToTableView:(MaterialEntity *)material amount:(NSNumber *) amount {
    InventoryMaterialDetail *inventoryDetail = [[InventoryMaterialDetail alloc] init];
    inventoryDetail.inventoryId = material.inventoryId;
    inventoryDetail.code = material.materialCode;
    inventoryDetail.brand = material.materialBrand;
    inventoryDetail.name = material.materialName;
    inventoryDetail.model = material.materialModel;
    inventoryDetail.realNumber = material.realNumber;
    inventoryDetail.totalNumber = material.totalNumber;
    inventoryDetail.reservedNumber = amount;

    //物资网络请求参数
    InventoryMaterialStorageInInventory *inventoryParam = [[InventoryMaterialStorageInInventory alloc] init];
    inventoryParam.inventoryId = inventoryDetail.inventoryId;
    [_inventoryParamArray addObject:inventoryParam];
    
    //物资显示Model
    [_inventoryModelArray addObject:inventoryDetail];
    
}

- (BOOL) isMaterialExist:(NSNumber *) materialId {
    BOOL res = NO;
    for(InventoryMaterialDetail * material in _inventoryModelArray) {
        if([material.inventoryId isEqualToNumber:materialId]) {
            res = YES;
            break;
        }
    }
    return res;
}

#pragma mark - NetWorking
- (void)requestStorageIn {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    InventoryMaterialStorageInRequestParam *param = [self getStorageParam];
    [_business requestStorageInMaterial:param success:^(NSInteger key, id object) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_storage_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf hideLoadingDialog];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
    }];
}

- (InventoryMaterialStorageInRequestParam *)getStorageParam {
    InventoryMaterialStorageInRequestParam *param = [[InventoryMaterialStorageInRequestParam alloc] init];
    param.warehouseId = _warehouseId;
    param.inventory = _inventoryParamArray;
    return param;
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
                            [self addMaterialToTableView:material amount:0];
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        }
                        _needUpdate = YES;
                    }
                }
                    break;
            }
        } else if([msgOrigin isEqualToString:@"InventoryStorageInEditMaterialViewController"]){
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryStorageInMaterialDetailEventType eventType = [tmpNumber integerValue];
            NSMutableDictionary * data = [result valueForKeyPath:@"eventData"];
            NSMutableArray * batchs;
            MaterialEntity * material;
            NSNumber *inventoryId;
            
            switch (eventType) {
                case INVENTORY_STORAGE_IN_MATERIAL_DETAIL_EVENT_OK:
                    batchs = [data valueForKeyPath:@"batch"];
                    tmpNumber = [data valueForKeyPath:@"amount"];
                    inventoryId = [data valueForKeyPath:@"inventoryId"];
                    
                    [_batchModelDictionary setValue:batchs forKeyPath:[NSString stringWithFormat:@"%ld",inventoryId.integerValue]];
                    
                    //更新网络请求参数
                    [self updateInventoryParam:batchs andInventoryId:inventoryId];
                    
                    //更新tableview页面信息
                    [self updateInventoryModelWithStorageNumber:tmpNumber andInventoryId:inventoryId];
                    _needUpdate = YES;
                    break;
                    
                case INVENTORY_STORAGE_IN_MATERIAL_QRCODE_OK: {
                    WarehouseEntity *tempWarehouse = [data valueForKeyPath:@"warehouse"];
                    if (_warehouse && ![tempWarehouse.warehouseId isEqualToNumber:_warehouse.warehouseId]) {
                        __weak typeof(self) weakSelf = self;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
                    } else {
                        if(!_warehouse) {
                            _warehouse = tempWarehouse;
                            _warehouseId = _warehouse.warehouseId;
                            [_tableView setWareHouseName:_warehouse.name];
                        }
                        
                        tmpNumber = [data valueForKeyPath:@"amount"];
                        material = [data valueForKeyPath:@"material"];
                        batchs = [data valueForKeyPath:@"batch"];
                        
                        if(![self isMaterialExist:material.inventoryId]) {
                            if(!_inventoryModelArray) {
                                _inventoryModelArray = [[NSMutableArray alloc] init];
                            }
                            if(!_batchModelDictionary) {
                                _batchModelDictionary = [[NSMutableDictionary alloc] init];
                            }
                            if(![self isMaterialExist:material.inventoryId]) {
                                [self addMaterialToTableView:material amount:tmpNumber];
                            }
                            [_batchModelDictionary setValue:batchs forKeyPath:[NSString stringWithFormat:@"%ld",material.inventoryId.integerValue]];
                            
                            //更新网络请求参数
                            [self updateInventoryParam:batchs andInventoryId:material.inventoryId];
                            
                            //更新tableview页面信息
                            [self updateInventoryModelWithStorageNumber:tmpNumber andInventoryId:material.inventoryId];
                            _needUpdate = YES;
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        }
                    }
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

//添加物料
- (void)gotoAddMaterial {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:_warehouseId forKeyPath:@"warehouseId"];
    InfoSelectViewController * materialVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
    [materialVC setOnMessageHandleListener:self];
    [self gotoViewController:materialVC];
}

//编辑物料
- (void)gotoEditMaterial:(NSNumber *) inventoryId {
    InventoryStorageInEditMaterialViewController *editMaterialVC = [[InventoryStorageInEditMaterialViewController alloc] init];
    editMaterialVC.inventoryId = inventoryId;
    editMaterialVC.operateType = INVENTORY_STORAGE_IN_NORMAL;
    NSString *key = [NSString stringWithFormat:@"%ld",inventoryId.integerValue];
    editMaterialVC.batchModelArray = [_batchModelDictionary valueForKeyPath:key];
    [editMaterialVC setOnMessageHandleListener:self];
    
    [self gotoViewController:editMaterialVC];
}

//通过code编辑物料
- (void) gotoMaterialDetailByMaterialCode:(NSString *) materialCode warehouseId:(NSString *) warehouseId {
    if(![FMUtils isStringEmpty:materialCode] && ![FMUtils isStringEmpty:warehouseId]) {
        InventoryStorageInEditMaterialViewController * vc = [[InventoryStorageInEditMaterialViewController alloc] init];
        vc.operateType = INVENTORY_STORAGE_IN_NORMAL;
        vc.fromQrcode = YES;
        vc.materialCode = materialCode;
        vc.warehouseId = [FMUtils stringToNumber:warehouseId];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"qrcode_notice_not_valid" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//选择仓库
- (void) gotoSelectWarehouse {
    if(_warehouse && [_inventoryParamArray count] > 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"selectAll", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    }
}

@end
