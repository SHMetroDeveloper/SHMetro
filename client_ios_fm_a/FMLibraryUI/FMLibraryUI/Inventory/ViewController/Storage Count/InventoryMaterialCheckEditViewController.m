//
//  InventoryMaterialCountEditViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialCheckEditViewController.h"
#import "FMUtilsPackages.h"
#import "InventoryMaterialCheckEditTableView.h"
#import "InventoryBusiness.h"
#import "InventoryMaterialDetailEntity.h"
#import "CommonAlertContentView.h"
#import "TaskAlertView.h"
#import "IQKeyboardManager.h"
#import "AttachmentViewController.h"
#import "PhotoShowHelper.h"
#import "SystemConfig.h"
#import "BaseBundle.h"


@interface InventoryMaterialCheckEditViewController ()<OnClickListener,OnItemClickListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) InventoryMaterialCheckEditTableView *tableView;

@property (nonatomic, strong) TaskAlertView *alertView;
@property (nonatomic, strong) CommonAlertContentView *amountView;
@property (nonatomic, strong) NSNumber *currentPosition;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, strong) PhotoShowHelper *photoHelper; //图片展示

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block NetPage *netPage;
@property (nonatomic, strong) __block InventoryMaterialDetail *materialDetail;
@property (nonatomic, strong) __block NSMutableArray<InventoryMaterialDetailBatchEntity *> *batchEntityArray;
@property (nonatomic, strong) __block NSMutableArray<InventoryBatchCheckViewModel *> *batchModelArray;


@property (nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation InventoryMaterialCheckEditViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil]];
    [self setBackAble:YES];
    
    if (_operateType == INVENTORY_CHECK_NORMAL) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil]]];
    } else if (_operateType == INVENTORY_CHECK_SCAN) {
        [self setMenuWithArray:@[[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil]]];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (_operateType == INVENTORY_CHECK_NORMAL) {
        [self tryToSaveBatch];
    } else if (_operateType == INVENTORY_CHECK_SCAN) {
        [self requestUploadCheckNumber];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_fromQrcode) {
        [self requestMaterialDetailByCode];
    } else {
        [self requestMaterialDetail];
        if (!_editBatchModelArray) {
            [self requestMaterialRecord];
        } else {
            InventoryBatchCheckViewModel *lastBatchModel = [_batchModelArray lastObject];
            _netPage = lastBatchModel.netPage;
            [self updateRecord];
        }
    }
    [self initAlertView];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
            [manager.disabledDistanceHandlingClasses addObject:[self class]];
        }
        
        if (!_business) {
            _business = [InventoryBusiness getInstance];
        }
        if (!_netPage) {
            _netPage = [[NetPage alloc] init];
        }
        if (!_materialDetail) {
            _materialDetail = [[InventoryMaterialDetail alloc] init];
        }
        if (!_batchEntityArray) {
            _batchEntityArray = [NSMutableArray new];
        }
        if (!_batchModelArray) {
            _batchModelArray = [NSMutableArray new];
        }
        if (!_photoHelper) {
            _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        }
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)initAlertView {
    _amountView = [[CommonAlertContentView alloc] init];
    [_amountView setShowOneLine:YES];
    [_amountView setTitleWithText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount_edit_title" inTable:nil]];
    [_amountView setEditLabelWithText:[[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_batch_amount_edit_placeholder" inTable:nil]];
    [_amountView setOperationButtonText:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil]];
    [_amountView setTextFieldKeyboardType:UIKeyboardTypeDecimalPad];
    [_amountView setOnItemClickListener:self];
    
    _alertView = [[TaskAlertView alloc] init];
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat amountHeight = 160;
    
    [_alertView setContentView:_amountView withKey:@"amount" andHeight:amountHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

#pragma mark - Lazyload
- (InventoryMaterialCheckEditTableView *)tableView {
    if (!_tableView) {
        _tableView = [[InventoryMaterialCheckEditTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(MATERIAL_COUNT_EDIT_TYPE type, id eventData){
            if (type == MATERIAL_COUNT_EDIT_TYPE_COUNT) {
                NSNumber *position = eventData;
                [weakSelf showAmountAlertDialogWithPosition:position.integerValue];
            }
        };
        _tableView.loadMoreBlock = ^(){
            if ([weakSelf.netPage haveMorePage]) {
                [weakSelf.netPage nextPage];
                [weakSelf requestMaterialRecord];
            } else {
                [weakSelf updateRecord];
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

- (void)setEditBatchModelArray:(NSMutableArray<InventoryBatchCheckViewModel *> *)editBatchModelArray {
    _editBatchModelArray = editBatchModelArray;
    _batchModelArray = _editBatchModelArray;
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
    res.realNumber = _materialDetail.realNumber;
    res.totalNumber = _materialDetail.totalNumber;
    res.cost = _materialDetail.price;
    return res;
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
    if(_fromQrcode) {   //如果是二维码，需要将其他信息附带传回去
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        WarehouseEntity * warehouse  = [self getWarehouse];
        MaterialEntity * material = [self getMaterialInfo];
        [data setValue:warehouse forKeyPath:@"warehouse"];
        [data setValue:material forKeyPath:@"material"];
        [data setValue:_batchModelArray forKeyPath:@"batch"];
        [self notifyEvent:INVENTORY_CHECK_MATERIAL_QRCODE_OK data:data];
    } else {
        [self notifyEvent:INVENTORY_CHECK_MATERIAL_DETAIL_EVENT_OK data:_batchModelArray];
    }
    [self finish];
}

- (void) showAmountAlertDialogWithPosition:(NSInteger)position {
    InventoryBatchCheckViewModel *batchModel = _batchModelArray[position];
    _currentPosition = [NSNumber numberWithInteger:position];
    if (batchModel.checkNumber > 0) {
        [_amountView setDesc:[[NSString alloc] initWithFormat:@"%0.2f", batchModel.checkNumber.doubleValue]];
    } else {
        [_amountView clearInput];
    }
    
    [_alertView showType:@"amount"];
    [_alertView show];
}

- (void)updateBaseInfo {
    _tableView.materialDetail = _materialDetail;
}

- (void)updateRecord {
    if ([_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }

    _tableView.batchArray = _batchModelArray;
}

- (NSMutableArray<InventoryBatchCheckViewModel *> *)convertEntityToModel:(NSMutableArray<InventoryMaterialDetailBatchEntity *> *)batchEntityArray {
    NSMutableArray *batchModelArray = [NSMutableArray new];
    for (InventoryMaterialDetailBatchEntity *batchEntity in batchEntityArray) {
        InventoryBatchCheckViewModel *batchModel = [[InventoryBatchCheckViewModel alloc] init];
        batchModel.inventoryId = _inventoryId;
        batchModel.batchId = batchEntity.batchId;
        batchModel.providerName = batchEntity.providerName;
        batchModel.storageDate = batchEntity.date;
        batchModel.dueDate = batchEntity.dueDate;
        batchModel.price = batchEntity.cost;
        batchModel.inventoryNumber = batchEntity.amount;
        batchModel.checkNumber = batchEntity.amount;
        batchModel.netPage = _netPage;
        [batchModelArray addObject:batchModel];
    }
    
    return batchModelArray;
}

#pragma mark - NetWorking
//获取物资详情
- (void)requestMaterialDetail {
    InventoryMaterialDetailIdRequestParam *param = [[InventoryMaterialDetailIdRequestParam alloc] init];
    param.inventoryId = _inventoryId;
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business requestMaterialDetail:param success:^(NSInteger key, id object) {
        weakSelf.materialDetail = object;
        [weakSelf updateBaseInfo];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.materialDetail = nil;
        [weakSelf updateBaseInfo];
        [weakSelf hideLoadingDialog];
    }];
}

//获取物资详情
- (void)requestMaterialDetailByCode {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getMaterialDetailByCode:_materialCode warehouse:_warehouseId success:^(NSInteger key, id object) {
        weakSelf.materialDetail = object;
        weakSelf.inventoryId = weakSelf.materialDetail.inventoryId;
        [weakSelf updateBaseInfo];
        [weakSelf hideLoadingDialog];
        [weakSelf requestMaterialRecord];
        if (!weakSelf.materialDetail.inventoryId) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [weakSelf requestWarehouseList];
        }
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.materialDetail = nil;
        [weakSelf updateBaseInfo];
        [weakSelf hideLoadingDialog];
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

//获取批次
- (void)requestMaterialRecord {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getMaterialBatchList:INVENTORY_MATERIAL_DETAIL_GET_BATCH_VALID material:_inventoryId page:_netPage success:^(NSInteger key, id object) {
        InventoryGetMaterialDetailBatchResponseData *responseData = object;
        weakSelf.netPage = responseData.page;
        if ([weakSelf.netPage isFirstPage]) {
            weakSelf.batchModelArray = [weakSelf convertEntityToModel:responseData.contents];
        } else {
            NSMutableArray<InventoryBatchCheckViewModel *> *tmpArray = [weakSelf convertEntityToModel:responseData.contents];
            [weakSelf.batchModelArray addObjectsFromArray:tmpArray];
        }
        if ([weakSelf.netPage haveMorePage]) {
            [weakSelf.netPage nextPage];
            [weakSelf requestMaterialRecord];
        } else {
            [weakSelf updateRecord];
        }
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateRecord];
        [weakSelf hideLoadingDialog];
    }];
}

//直接上传盘点数据
- (void)requestUploadCheckNumber {
    if (!_batchModelArray || _batchModelArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_batch_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        __weak typeof(self) weakSelf = self;
        [weakSelf showLoadingDialog];
        InventoryMaterialCheckRequestParam *param = [self getCheckParam];
        [_business requestCheckInMaterial:param success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_check_upload_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_material_check_upload_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
}

- (InventoryMaterialCheckRequestParam *)getCheckParam {
    InventoryMaterialCheckInventory *inventory = [[InventoryMaterialCheckInventory alloc] init];
    inventory.inventoryId = _materialDetail.inventoryId;
    for (InventoryBatchCheckViewModel *batchModel in _batchModelArray) {
        InventoryMaterialCheckBatch *batchEntity = [[InventoryMaterialCheckBatch alloc] init];
        batchEntity.batchId = batchModel.batchId;
        batchEntity.inventoryNumber = [[NSString alloc] initWithFormat:@"%.2f", batchModel.inventoryNumber.doubleValue];
        batchEntity.number = [[NSString alloc] initWithFormat:@"%.2f", batchModel.checkNumber.doubleValue];
        
        [inventory.batch addObject:batchEntity];
    }
    
    InventoryMaterialCheckRequestParam *param = [[InventoryMaterialCheckRequestParam alloc] init];
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

- (void) notifyEvent:(InventoryCheckMaterialDetailEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:_inventoryId forKeyPath:@"inventoryId"];
        
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

#pragma mark - 点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _amountView) {
        if (subView.tag == COMMON_ALERT_OPERATE_TYPE_LEFT) {
            NSString *strAmount = [_amountView getDesc];
            NSNumber * amount = [FMUtils stringToNumber:strAmount];
            InventoryBatchCheckViewModel *batchModel = _batchModelArray[_currentPosition.integerValue];
            batchModel.checkNumber = amount;
            batchModel.isChecked = YES;
            
            [_alertView close];
            [self updateRecord];
        }
    }
    
}

#pragma mark - OnClickListener
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
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

//查看附件
- (void)gotoAttachment:(NSNumber *)attachmentId andAttachmentName:(NSString *)attachmentName {
    NSURL *attachmentUrl = [FMUtils getUrlOfAttachmentById:attachmentId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentUrl];
    [attachmentVC setTitleByFileName:attachmentName];
    [self gotoViewController:attachmentVC];
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

@end

