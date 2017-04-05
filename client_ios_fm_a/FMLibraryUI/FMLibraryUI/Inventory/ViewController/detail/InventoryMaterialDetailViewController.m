//
//  InventoryMaterialDetailViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailViewController.h"
#import "InventoryMaterialDetailTableView.h"
#import "InventoryBusiness.h"
#import "AttachmentViewController.h"
#import "PhotoShowHelper.h"
#import "MenuAlertContentView.h"
#import "TaskAlertView.h"

#import "BaseBundle.h"
#import "InventoryStorageInViewController.h"
#import "InventoryStorageOutViewController.h"
#import "InventoryStorageMoveViewController.h"
#import "InventoryMaterialCheckViewController.h"

#import "InventoryStorageInEditMaterialViewController.h"
#import "InventoryMaterialCheckEditViewController.h"
#import "InventoryDeliveryMaterialDetailViewController.h"
#import "SystemConfig.h"

@interface InventoryMaterialDetailViewController ()<OnMessageHandleListener,OnClickListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) InventoryMaterialDetailTableView *tableView;

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block InventoryMaterialDetail *materialDetail;  //物资详情
@property (nonatomic, strong) __block NSMutableArray<InventoryMaterialDetailRecordDetail *> *recordArray;  //物资记录
@property (nonatomic, strong) __block NetPage *netPage;


@property (nonatomic, strong) NetPage * warehousePage;
@property (nonatomic, strong) NSMutableArray * warehouseArray;  //所负责的仓库数组
@property (nonatomic, assign) BOOL canOperate;  //拥有管理权限

@property (nonatomic, strong) PhotoShowHelper *photoHelper; //图片展示

@property (nonatomic, strong) TaskAlertView *alertView; //弹出框
@property (nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度

@property (nonatomic, strong) MenuAlertContentView *menuContentView;    //菜单界面
@property (nonatomic, strong) NSMutableArray *actionHandlerArray;   //事件处理

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) __block BOOL needUpdate;
@end

@implementation InventoryMaterialDetailViewController

- (void)initNavigation {
    [self setTitleWith: [[BaseBundle getInstance] getStringByKey:@"inventory_material_section_title_detail" inTable:nil]];
    [self setBackAble:YES];
    
    if (_isEditAble && _canOperate) {
        [self setMenuWithArray:@[[[FMTheme getInstance] getImageByName:@"menu_more"]]];
    } else {
        [self setMenuWithArray:nil];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (_isEditAble) {
        [self showControlMenue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_fromQrcode) {
        [self requestMaterialDetailByCode];
        [self requestWarehouseList];
    } else {
        [self requestMaterialDetail];
        [self requestMaterialRecord];
        [self requestWarehouseList];
    }
    [self initAlertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        _needUpdate = NO;
        [self requestMaterialDetail];
        [self requestMaterialRecord];
        [self requestWarehouseList];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        
        _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        _business = [InventoryBusiness getInstance];
        _materialDetail = [[InventoryMaterialDetail alloc] init];
        _recordArray = [NSMutableArray new];
        _netPage = [[NetPage alloc] init];
        _warehousePage = [[NetPage alloc] init];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat itemHeight = 50;
    CGFloat contentHeight = itemHeight * (4 + 1);//附加一个取消按钮
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:contentHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

//更新菜单
- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
//    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (MaterialEntity *) getMaterialInfo {
    MaterialEntity * res = [[MaterialEntity alloc] init];
    if(_materialDetail) {
        res.inventoryId = _materialDetail.inventoryId;
        res.materialCode = _materialDetail.code;
        res.materialName = _materialDetail.name;
        res.materialBrand = _materialDetail.brand;
        res.materialModel = _materialDetail.model;
        res.materialUnit = _materialDetail.unit;
        res.realNumber = _materialDetail.realNumber;
        res.totalNumber = _materialDetail.totalNumber;
        res.cost = _materialDetail.price;
    }
    return res;
}

- (void) updateInventoryOperationAbility {
    _canOperate = NO;
    for(WarehouseEntity * warehouse in _warehouseArray) {
        if(warehouse.warehouseId && _materialDetail.warehouseId && [warehouse.warehouseId isEqualToNumber:_materialDetail.warehouseId]) {
            _canOperate = YES;
            break;
        }
    }
}

#pragma mark - Lazyload
- (InventoryMaterialDetailTableView *)tableView {
    if (!_tableView) {
        _tableView = [[InventoryMaterialDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.loadMoreBlock = ^(){
            if ([weakSelf.netPage haveMorePage]) {
                [weakSelf.netPage nextPage];
                [weakSelf requestMaterialRecord];
            } else {
                [weakSelf updateMateriadRecord];
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

#pragma mark - Private Method
- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers{
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_alertView setContentHeight:height withKey:@"menu"];
    [_alertView showType:@"menu"];
    [_alertView show];
}

- (void) showControlMenue {
    NSMutableArray *menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_out" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_move" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil], nil];
    
    
    __weak id weakSelf = self;
    ActionHandler storageInHandler = ^(UIAlertAction * action) {
        [weakSelf gotoStorageIn];
    };
    
    ActionHandler storageOutHandler = ^(UIAlertAction * action) {
        [weakSelf gotoStorageOut];
    };
    
    ActionHandler storageMoveHandler = ^(UIAlertAction * action) {
        [weakSelf gotoStorageMove];
    };
    
    ActionHandler storageCheckHandler = ^(UIAlertAction * action) {
        [weakSelf gotoStorageCheck];
    };
    
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:storageInHandler, storageOutHandler, storageMoveHandler, storageCheckHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

- (void)updateMaterialDetail {
    _tableView.materialDetail = _materialDetail;
}

- (void)updateMateriadRecord {
    if ([_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    _tableView.recordArray = _recordArray;
}

#pragma mark - 处理推送过来的数据
- (void) handleNotification {
    if(self.baseVcParam) {
        _inventoryId = [self.baseVcParam valueForKeyPath:@"inventoryId"];
        [self requestMaterialDetail];
    }
}

#pragma mark - NetWorking 
- (void)requestMaterialDetail {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    InventoryMaterialDetailIdRequestParam *param = [[InventoryMaterialDetailIdRequestParam alloc] init];
    param.inventoryId = _inventoryId;
    [_business requestMaterialDetail:param success:^(NSInteger key, id object) {
        weakSelf.materialDetail = (InventoryMaterialDetail *)object;
        [weakSelf updateMaterialDetail];
        [weakSelf hideLoadingDialog];
        [weakSelf updateInventoryOperationAbility];
        [weakSelf updateTitle];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf updateInventoryOperationAbility];
        [weakSelf updateTitle];
    }];
}

- (void)requestMaterialDetailByCode {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    InventoryMaterialDetailCodeRequestParam *param = [[InventoryMaterialDetailCodeRequestParam alloc] init];
    param.code = _inventoryCode;
    param.warehouseId = _warehouseId;
    [_business requestMaterialDetailByCode:param success:^(NSInteger key, id object) {
        weakSelf.materialDetail = (InventoryMaterialDetail *)object;
        if ([FMUtils isNumberNullOrZero:weakSelf.materialDetail.inventoryId]) {
            weakSelf.isEditAble = NO;
            [weakSelf updateTitle];
        }
        weakSelf.inventoryId = weakSelf.materialDetail.inventoryId;
        [weakSelf requestMaterialRecord];
        [weakSelf updateMaterialDetail];
        [weakSelf hideLoadingDialog];
        [weakSelf updateInventoryOperationAbility];
        [weakSelf updateTitle];
        if (!weakSelf.materialDetail.inventoryId) {
            if(_inventoryCode) {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            } else {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_request_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        }
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf updateInventoryOperationAbility];
        [weakSelf updateTitle];
    }];
}

- (void)requestMaterialRecord {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    
    InventoryMaterialDetailRecordRequestParam *param = [[InventoryMaterialDetailRecordRequestParam alloc]init];
    param.inventoryId = _inventoryId;
    param.page.pageSize = _netPage.pageSize;
    param.page.pageNumber = _netPage.pageNumber;
    [_business requestMaterialDetailRecord:param success:^(NSInteger key, id object) {
        InventoryMaterialDetailRecordResponseData *responseData = object;
        weakSelf.netPage = responseData.page;
        if ([weakSelf.netPage isFirstPage]) {
            weakSelf.recordArray = responseData.contents;
        } else {
            [weakSelf.recordArray addObjectsFromArray:responseData.contents];
        }
        [weakSelf updateMateriadRecord];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateMateriadRecord];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) requestWarehouseList {
    InventoryGetWarehouseParam * param = [[InventoryGetWarehouseParam alloc] initWith:_warehousePage employeeId:[SystemConfig getEmployeeId]];
    [_business getWarehouseList:param success:^(NSInteger key, id object) {
        InventoryGetWarehouseResponseData * data = object;
        [_warehousePage setPage:data.page];
        if(!_warehouseArray) {
            _warehouseArray = [[NSMutableArray alloc] init];
        } else if([_warehousePage isFirstPage]) {
            [_warehouseArray removeAllObjects];
        }
        [_warehouseArray addObjectsFromArray:data.contents];
        if([_warehousePage haveMorePage]) {
            [self requestWarehouseList];
        } else {
            [self updateInventoryOperationAbility];
            [self updateTitle];
        }
    } fail:^(NSInteger key, NSError *error) {
        [_warehouseArray removeAllObjects];
        _canOperate = NO;
        [self updateTitle];
    }];
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            NSNumber *tmpNumber = [msg valueForKeyPath:@"menuType"];
            MenuAlertViewType type = [tmpNumber integerValue];
            NSInteger position;
            switch(type) {
                case MENU_ALERT_TYPE_NORMAL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    position = tmpNumber.integerValue;
                    if(position < [_actionHandlerArray count]) {
                        ActionHandler handler = _actionHandlerArray[position];
                        [_alertView close];
                        [_netPage reset];
                        _needUpdate = YES;
                        handler(nil);
                    }
                    break;
                case MENU_ALERT_TYPE_CANCEL:
                    [_alertView close];
                    break;
            }
        }
    }
}

- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[TaskAlertView class]]) {
        [_alertView close];
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

//入库
- (void)gotoStorageIn {
    InventoryStorageInEditMaterialViewController *storageInVC = [[InventoryStorageInEditMaterialViewController alloc] init];
    storageInVC.inventoryId = _materialDetail.inventoryId;
    storageInVC.operateType = INVENTORY_STORAGE_IN_QR_SCAN;
    [self gotoViewController:storageInVC];
}

//出库
- (void)gotoStorageOut {
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
//    [vc setMaterialType:INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE];
    [vc setOperationType:INVENTORY_DELIVERY_MATERIAL_TYPE_DELIVERY_QRCODE];
    [vc setInfoWithMaterial:[self getMaterialInfo] batch:nil];
    [self gotoViewController:vc];
}

//移库
- (void)gotoStorageMove {
    InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
//    [vc setMaterialType:INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE];
    [vc setOperationType:INVENTORY_DELIVERY_MATERIAL_TYPE_SHIFT_QRCODE];
    [vc setInfoWithMaterial:[self getMaterialInfo] batch:nil];
    [self gotoViewController:vc];
}

//盘点
- (void)gotoStorageCheck {
    InventoryMaterialCheckEditViewController *storageCheckVC = [[InventoryMaterialCheckEditViewController alloc] init];
    storageCheckVC.inventoryId = _materialDetail.inventoryId;
    storageCheckVC.operateType = INVENTORY_STORAGE_IN_QR_SCAN;
    [self gotoViewController:storageCheckVC];
}


@end
