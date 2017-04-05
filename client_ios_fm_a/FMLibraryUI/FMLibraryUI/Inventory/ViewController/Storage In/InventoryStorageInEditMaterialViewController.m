//
//  InventoryStorageInAddMaterialViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageInEditMaterialViewController.h"
#import "FMUtilsPackages.h"
#import "InventoryStorageInEditMaterialTableView.h"
#import "InventoryMaterialBatchEditViewController.h"
#import "InventoryBusiness.h"
#import "InventoryMaterialDetailEntity.h"
#import "AttachmentViewController.h"
#import "PhotoShowHelper.h"
#import "SystemConfig.h"
#import "BaseBundle.h"

@interface InventoryStorageInEditMaterialViewController ()<OnMessageHandleListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) InventoryStorageInEditMaterialTableView *tableView;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block NSMutableArray<InventoryMaterialBatchViewModel *> *batchArray;
@property (nonatomic, strong) __block InventoryMaterialDetail *materialDetail;

@property (nonatomic, strong) PhotoShowHelper *photoHelper; //图片展示

@property (nonatomic, strong) NSNumber *modifyPosition;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation InventoryStorageInEditMaterialViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil]];
    [self setBackAble:YES];
    
    if (_operateType == INVENTORY_STORAGE_IN_NORMAL) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]]];
    } else if (_operateType == INVENTORY_STORAGE_IN_QR_SCAN) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil]]];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (_operateType == INVENTORY_STORAGE_IN_NORMAL) {
        [self tryToSaveBatch];
    } else if (_operateType == INVENTORY_STORAGE_IN_QR_SCAN) {
        [self finishEditing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_fromQrcode) {
        [self requestMaterialDetailByCode];
//        [self requestWarehouseList];
    } else {
        [self requestMaterialDetail];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        
        if (!_business) {
            _business = [InventoryBusiness getInstance];
        }
        
        if (!_photoHelper) {
            _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        }
        
        if (!_batchArray) {
            _batchArray = [NSMutableArray new];
        }
        
        if (!_materialDetail) {
            _materialDetail = [[InventoryMaterialDetail alloc] init];
        }
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
        
        if (_batchArray.count > 0) {
            [self updateBatch];
        }
    }
}


//获取当前物料所属仓库信息
- (WarehouseEntity *) getWarehouse {
    WarehouseEntity * warehouse  = [[WarehouseEntity alloc] init];
    warehouse.warehouseId = [_materialDetail.warehouseId copy];
    warehouse.name = [_materialDetail.warehouseName copy];
    return warehouse;
}

//获取物料概况
- (MaterialEntity *) getMaterialInfo {
    MaterialEntity * res = [[MaterialEntity alloc] init];
    res.inventoryId = [_materialDetail.inventoryId copy];
    res.materialCode = [_materialDetail.code copy];
    res.materialName = [_materialDetail.name copy];
    res.materialBrand = [_materialDetail.brand copy];
    res.materialModel = [_materialDetail.model copy];
    res.materialUnit = [_materialDetail.unit copy];
    res.totalNumber = _materialDetail.totalNumber;
    res.realNumber = _materialDetail.realNumber;
    res.minNumber = _materialDetail.minNumber;
    res.cost = _materialDetail.price;
    return res;
}

- (NSNumber *) getAmountByBatchArray:(NSMutableArray *) array {
    NSNumber * count = 0;
    double sum = 0;
    for (InventoryMaterialBatchViewModel *batchDetailModel in array) {
        sum += batchDetailModel.number.floatValue;
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

#pragma mark - Private Method
- (BOOL) updateInventoryOperationAbilityByWarehouseArray:(NSMutableArray *)warehouseArray {
    BOOL canOperate = NO;
    for(WarehouseEntity * warehouse in warehouseArray) {
        if(warehouse.warehouseId && _materialDetail.warehouseId && [warehouse.warehouseId isEqualToNumber:_materialDetail.warehouseId]) {
            canOperate = YES;
            break;
        }
    }
    return canOperate;
}

- (void)tryToSaveBatch {
    if(_fromQrcode) {
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        WarehouseEntity * warehouse  = [self getWarehouse];
        MaterialEntity * material = [self getMaterialInfo];
        NSNumber * storageNumber = [self getAmountByBatchArray:_batchArray];
        
        [data setValue:warehouse forKeyPath:@"warehouse"];
        [data setValue:material forKeyPath:@"material"];
        [data setValue:_batchArray forKeyPath:@"batch"];
        [data setValue:storageNumber forKeyPath:@"amount"];
        
        [self notifyEvent:INVENTORY_STORAGE_IN_MATERIAL_QRCODE_OK data:data];
    } else {
        NSNumber * storageNumber = [self getAmountByBatchArray:_batchArray];
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:_batchArray forKeyPath:@"batch"];
        [data setValue:storageNumber forKeyPath:@"amount"];
        [data setValue:_inventoryId forKeyPath:@"inventoryId"];
        [self notifyEvent:INVENTORY_STORAGE_IN_MATERIAL_DETAIL_EVENT_OK data:data];
    }
    [self finish];
}

- (void)deleteBatchByPosition:(NSNumber *)position {
    [_batchArray removeObjectAtIndex:position.integerValue];
    [self updateBatch];
}

- (void)updateMaterialDetail {
    _tableView.materialDetail = _materialDetail;
}

- (void)updateBatch {
    _tableView.batchArray = _batchArray;
}

#pragma mark - Lazyload
- (InventoryStorageInEditMaterialTableView *)tableView {
    if (!_tableView) {
        _tableView = [[InventoryStorageInEditMaterialTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(MATERIAL_EDIT_TYPE type, id eventData){
            if (type == MATERIAL_EDIT_TYPE_BATCH_ADD) {
                [weakSelf gotoAddBatch];
            } else if (type == MATERIAL_EDIT_TYPE_BATCH_EDIT) {
                NSNumber *position = eventData;
                [weakSelf gotoEditBatch:position.integerValue];
            } else if (type == MATERIAL_EDIT_TYPE_BATCH_DELETE) {
                NSNumber *position = eventData;
                [weakSelf deleteBatchByPosition:position];
            }
        };
        _tableView.itemClickBlock = ^(ItemTypeClick type, id object){
            if (type == MATERIAL_TYPE_CLICK_PHOTO) {
                NSNumber *position = object;
                [weakSelf gotoShowPhoto:position];
            } else if (type == MATERIAL_TYPE_CLICK_ATTACHMENT) {
                InventoryMaterialDetailAttachment *attachment = (InventoryMaterialDetailAttachment *)object;
                [weakSelf gotoAttachment:attachment.fileId andAttachmentName:attachment.fileName];
            }
        };
    }
    return _tableView;
}

#pragma mark - Setter & Getter
- (void)setInventoryId:(NSNumber *)inventoryId {
    _inventoryId = inventoryId;
}

- (void)setBatchModelArray:(NSMutableArray<InventoryMaterialBatchViewModel *> *)batchModelArray {
    _batchModelArray = batchModelArray;
    _batchArray = _batchModelArray;
}

#pragma mark - NetWorking 
- (void)requestMaterialDetail {
    InventoryMaterialDetailIdRequestParam *param = [[InventoryMaterialDetailIdRequestParam alloc] init];
    param.inventoryId = _inventoryId;
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business requestMaterialDetail:param success:^(NSInteger key, id object) {
        weakSelf.materialDetail = object;
        [weakSelf updateMaterialDetail];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
    }];
}

- (void)requestMaterialDetailByCode {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getMaterialDetailByCode:_materialCode warehouse:_warehouseId success:^(NSInteger key, id object) {
        weakSelf.materialDetail = object;
        weakSelf.inventoryId = weakSelf.materialDetail.inventoryId;
        [weakSelf hideLoadingDialog];
        [weakSelf updateMaterialDetail];
        
        if (!weakSelf.materialDetail.inventoryId) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [weakSelf requestWarehouseList];
        }
        
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.materialDetail = nil;
        [weakSelf hideLoadingDialog];
        [weakSelf updateMaterialDetail];
    }];
}

- (void) requestWarehouseList {
    __block NetPage *warehousePage = [[NetPage alloc] init];
    __block NSMutableArray *warehouseArray = [NSMutableArray new];
    __block BOOL canOperate = NO;
    __weak typeof(self) weakSelf = self;
    InventoryGetWarehouseParam *param = [[InventoryGetWarehouseParam alloc] initWith:warehousePage employeeId:[SystemConfig getEmployeeId]];
    [_business getWarehouseList:param success:^(NSInteger key, id object) {
        InventoryGetWarehouseResponseData * data = object;
        [warehousePage setPage:data.page];
        if(!warehouseArray) {
            warehouseArray = [[NSMutableArray alloc] init];
        } else if([warehousePage isFirstPage]) {
            [warehouseArray removeAllObjects];
        }
        [warehouseArray addObjectsFromArray:data.contents];
        if([warehousePage haveMorePage]) {
            [weakSelf requestWarehouseList];
        } else {
            canOperate = [weakSelf updateInventoryOperationAbilityByWarehouseArray:warehouseArray];
            if (!canOperate) {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_no_right" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            }
        }
    } fail:^(NSInteger key, NSError *error) {
        [warehouseArray removeAllObjects];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_request_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void)finishEditing {
    if (_batchArray.count > 0) {
        [self requestStorageIn];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_batch_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

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
    InventoryMaterialStorageInInventory *inventory = [[InventoryMaterialStorageInInventory alloc] init];
    inventory.inventoryId = _materialDetail.inventoryId;
    for (InventoryMaterialBatchViewModel *batchDetailModel in _batchArray) {
        InventoryMaterialStorageInBatch *batch = [[InventoryMaterialStorageInBatch alloc] init];
        batch.providerId = batchDetailModel.providerId;
        batch.providerName = batchDetailModel.name;
        batch.dueDate = batchDetailModel.dueDate;
        batch.price = batchDetailModel.price;
        batch.number = batchDetailModel.number;
        
        [inventory.batch addObject:batch];
    }
    
    InventoryMaterialStorageInRequestParam *param = [[InventoryMaterialStorageInRequestParam alloc] init];
    param.warehouseId = _materialDetail.warehouseId;
    param.inventory = @[inventory].mutableCopy;
    return param;
}

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    if (handler) {
        _handler = handler;
    }
}

- (void) notifyEvent:(InventoryStorageInMaterialDetailEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

-(void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"InventoryMaterialBatchEditViewController"]) {
            NSDictionary *result = [msg valueForKeyPath:@"result"];
            InventoryMaterialBatchViewModel *batchDetailModel = [result valueForKeyPath:@"eventData"];
            NSNumber *type = [result valueForKeyPath:@"eventType"];
            if (type.integerValue == BATCH_EDIT_TYPE_ADD) {
                [_batchArray addObject:batchDetailModel];
            } else if (type.integerValue == BATCH_EDIT_TYPE_MODIFY) {
                [_batchArray replaceObjectAtIndex:_modifyPosition.integerValue withObject:batchDetailModel];
            }
            [self updateBatch];
        }
    }
}

#pragma mark - ClickEvent
- (void)gotoAddBatch {
    InventoryMaterialBatchEditViewController *batchAddVC = [[InventoryMaterialBatchEditViewController alloc] init];
    batchAddVC.editType = BATCH_EDIT_TYPE_ADD;
    batchAddVC.inventoryId = _inventoryId;
    [batchAddVC setOnMessageHandleListener:self];
    [self gotoViewController:batchAddVC];
}

- (void)gotoEditBatch:(NSInteger)position {
    _modifyPosition = [NSNumber numberWithInteger:position];
    InventoryMaterialBatchViewModel *materialBatchModel = _batchArray[position];
    InventoryMaterialBatchEditViewController *batchAddVC = [[InventoryMaterialBatchEditViewController alloc] init];
    batchAddVC.inventoryId = _inventoryId;
    batchAddVC.editType = BATCH_EDIT_TYPE_MODIFY;
    [batchAddVC setOnMessageHandleListener:self];
    [batchAddVC setMaterialBatchModelToModify:materialBatchModel];
    [self gotoViewController:batchAddVC];
}

//查看照片
- (void)gotoShowPhoto:(NSNumber *)position {
    NSMutableArray *imgArray = [NSMutableArray new];
    for(NSNumber *photoId in _materialDetail.pictures) {
        NSURL * url = [FMUtils getUrlOfImageById:photoId];
        [imgArray addObject:url];
    }
    [_photoHelper setPhotos:imgArray];
    [_photoHelper showPhotoWithIndex:position.integerValue];
}

//查看附件
- (void)gotoAttachment:(NSNumber *)attachmentId andAttachmentName:(NSString *)attachmentName {
    NSURL *attachmentUrl = [FMUtils getUrlOfAttachmentById:attachmentId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentUrl];
    [attachmentVC setTitleByFileName:attachmentName];
    [self gotoViewController:attachmentVC];
}

@end
