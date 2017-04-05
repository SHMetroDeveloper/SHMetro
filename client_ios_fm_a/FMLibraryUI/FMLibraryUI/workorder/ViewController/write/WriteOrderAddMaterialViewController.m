//
//  WriteOrderAddMaterialViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WriteOrderAddMaterialViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseTextField.h"
#import "BaseLabelView.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderDetailEntity.h"
#import "FMSize.h"
#import "InfoSelectViewController.h"
#import "CustomAlertView.h"
#import "BaseDataNetRequest.h"
#import "SystemConfig.h"
#import "MaterialDetailItemView.h"
#import "MarkedListHeaderView.h"
#import "SeperatorView.h"
#import "TaskAlertView.h"
#import "MaterialAmountAlertContentItemView.h"
#import "DXAlertView.h"
#import "MaterialBatchPickerView.h"
#import "CaptionTextField.h"
#import "WorkOrderBusiness.h"
#import "MaterialEntity.h"


@interface WriteOrderAddMaterialViewController ()
@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) CaptionTextField * nameTF;
@property (readwrite, nonatomic, strong) CaptionTextField * brandTF;
@property (readwrite, nonatomic, strong) CaptionTextField * modelTF;
@property (readwrite, nonatomic, strong) CaptionTextField * amountTF;
@property (readwrite, nonatomic, strong) CaptionTextField * reserveAmountTF;

@property (readwrite, nonatomic, strong) WorkOrderMaterial * woMaterial;//用于物料编辑
@property (readwrite, nonatomic, strong) MaterialEntity * material;     //用于物料预定
@property (readwrite, nonatomic, strong) NSMutableArray * materials;    //工单相关所有物料，用于参考，做重复性判断
@property (readwrite, nonatomic, strong) MaterialAmountEntity * materialAmount;//物料库存数量，编辑时使用
@property (readwrite, nonatomic, strong) NSNumber * woId;   //关联的工单的ID
@property (readwrite, nonatomic, strong) NSNumber* warehouseId;//仓库ID

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@property (readwrite, nonatomic, strong) id<OnMessageHandleListener> resultHandler;
@property (readwrite, nonatomic, assign) WriteOrderAddMaterialOperateType requestType;
@end

@implementation WriteOrderAddMaterialViewController

- (instancetype) initWithOperateType:(WriteOrderAddMaterialOperateType) operateType{
    self = [super  init];
    if(self) {
        _requestType = operateType;
    }
    return self;
}

- (void) initNavigation {
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_material_add" inTable:nil]];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_material_edit" inTable:nil]];
    }
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [WorkOrderBusiness getInstance];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _defaultItemHeight = 92;

        
        //    frame.size.height -= _controlHeight;
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _nameTF = [[CaptionTextField alloc] init];
        _brandTF = [[CaptionTextField alloc] init];
        _modelTF = [[CaptionTextField alloc] init];
        _amountTF = [[CaptionTextField alloc] init];
        _reserveAmountTF = [[CaptionTextField alloc] init];
    
        [_nameTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_material_name" inTable:nil]];
        [_brandTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_material_brand" inTable:nil]];
        [_modelTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_material_model" inTable:nil]];
        [_amountTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_material_inventory_amount" inTable:nil]];
        [_reserveAmountTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_material_reserve_amount" inTable:nil]];
        
        [_nameTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_material_name_placeholder" inTable:nil]];
//        [_brandTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_material_brand_placeholder" inTable:nil]];
//        [_modelTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_material_model_placeholder" inTable:nil]];
//        [_amountTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_material_inventory_quantity_placeholder" inTable:nil]];
        [_reserveAmountTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_material_reserve_quantity_placeholder" inTable:nil]];
        
        [_nameTF setEditable:NO];
        [_brandTF setEditable:NO];
        [_modelTF setEditable:NO];
        [_amountTF setEditable:NO];
        
        
        [_nameTF setShowMark:YES];
        [_reserveAmountTF setShowMark:YES];
        
        [_reserveAmountTF setKeyboardType:UIKeyboardTypeNumberPad];
        
        [_nameTF setOnClickListener:self];
        

        
        [_mainContainerView addSubview:_nameTF];
        [_mainContainerView addSubview:_brandTF];
        [_mainContainerView addSubview:_modelTF];
        [_mainContainerView addSubview:_amountTF];
        [_mainContainerView addSubview:_reserveAmountTF];
        
        [self.view addSubview:_mainContainerView];
    }
}
//
- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
    [self updateInfo];
    [self updateMaterialAmount];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if([self hasSelectMaterial] && [self isRerveAmountOK]) {
        [self reserveMaterial];
    }
}

- (NSString *) getMaterialUnitDesc {
    NSString * res = @"";
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_EDIT) {
        if(![FMUtils isStringEmpty:_woMaterial.materialUnit]) {
            res = [[NSString alloc] initWithFormat:@"(%@)", _woMaterial.materialUnit];
        }
    } else if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
        if(_material) {
            res = [[NSString alloc] initWithFormat:@"(%@)", _material.materialUnit];
        }
    }
    return res;
}

- (void) updateInfo {
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_EDIT) {
        if(_woMaterial) {
            [_nameTF setText:_woMaterial.materialName];
            [_brandTF setText:_woMaterial.materialBrand];
            [_modelTF setText:_woMaterial.materialModel];
            
            [_amountTF setTitle:[[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"order_material_amount" inTable:nil], [self getMaterialUnitDesc]]];
            [_amountTF setText:[[NSString alloc] initWithFormat:@"%ld", [self getMaterialAmount]]];

            [_reserveAmountTF setTitle:[[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"order_material_reserve_amount" inTable:nil], [self getMaterialUnitDesc]]];
            [_reserveAmountTF setText:[[NSString alloc] initWithFormat:@"%ld", _woMaterial.amount]];
        }
    } else if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
        if(_material) {
            [_nameTF setText:_material.materialName];
            [_brandTF setText:_material.materialBrand];
            [_modelTF setText:_material.materialModel];
            
            [_amountTF setTitle:[[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"order_material_amount" inTable:nil], [self getMaterialUnitDesc]]];
            [_amountTF setText:[[NSString alloc] initWithFormat:@"%ld", [self getMaterialAmount]]];
            
            [_reserveAmountTF setTitle:[[NSString alloc] initWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"order_material_reserve_amount" inTable:nil], [self getMaterialUnitDesc]]];
        }
    }
}

- (void) updateLayout {
    
    CGFloat originY = 0;
    [_nameTF setFrame:CGRectMake(0, originY, _realWidth, _defaultItemHeight)];
    originY += _defaultItemHeight;
    
    [_brandTF setFrame:CGRectMake(0, originY, _realWidth, _defaultItemHeight)];
    originY += _defaultItemHeight;
    
    [_modelTF setFrame:CGRectMake(0, originY, _realWidth, _defaultItemHeight)];
    originY += _defaultItemHeight;
    
    [_amountTF setFrame:CGRectMake(0, originY, _realWidth, _defaultItemHeight)];
    originY += _defaultItemHeight;
    
    [_reserveAmountTF setFrame:CGRectMake(0, originY, _realWidth, _defaultItemHeight)];
    originY += _defaultItemHeight;
    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
    
    [self updateInfo];
}

- (void) setInfoWith:(WorkOrderMaterial *) woMaterial {
    _woMaterial = woMaterial;
    [self updateLayout];
}

- (void) setInfoWithMaterialArray:(NSMutableArray *) array {
    _materials = array;
}

- (void) setInfoWithOrderId:(NSNumber *) orderId warehouseId:(NSNumber *) warehouseId {
    _woId = orderId;
    _warehouseId = warehouseId;
}

- (BOOL) hasSelectMaterial {
    BOOL res = NO;
    NSNumber * inventoryId = [self getInventoryId];
    if(inventoryId) {
        res = YES;
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_name_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    return res;
}

//检测预定数量是否合理
- (BOOL) isRerveAmountOK {
    BOOL res = YES;
    NSNumber * tmpNumber = [FMUtils stringToNumber:[_reserveAmountTF text]];
    NSInteger reserveAmount = tmpNumber.integerValue;
    if(reserveAmount <= 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_amount_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        res = NO;
    } else if(reserveAmount > [self getMaterialAmount]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_more_than_inventory" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        res = NO;
    }
    return res;
}


- (void) onClick:(UIView *)view {
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {   //添加物料
        [self gotoMaterialSelect];
    }
}


//发送更新物料信息请求
- (void) requestUpdateMaterialInfo {
    NSDictionary * msg = [[NSDictionary alloc] initWithObjectsAndKeys:NSStringFromClass([self class]), @"msgOrigin", @"refreshMaterial", @"requestType", nil];
    if(_resultHandler) {
        [_resultHandler handleMessage:msg];
    }
}

- (NSNumber *) getInventoryId {
    NSNumber * inventoryId;
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
        inventoryId = _material.inventoryId;
    } else if (_requestType == ORDER_MATERIAL_OPERATE_TYPE_EDIT) {
        inventoryId = _woMaterial.inventoryId;
    }
    return inventoryId;
}

//获取库存总量
- (NSInteger) getMaterialAmount {
    NSInteger count = 0;
    if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
        count = _material.totalNumber;
    } else if (_requestType == ORDER_MATERIAL_OPERATE_TYPE_EDIT) {
        count = _materialAmount.realAmount + _woMaterial.amount;
    }
    return count;
}

//更新物料库存数量
- (void) updateMaterialAmount {
    NSNumber * inventoryId = [self getInventoryId];
    if(inventoryId) {
        [self requestMaterialInfo];
    }
}

- (void) requestMaterialInfo {
    NSNumber * inventoryId = [self getInventoryId];
    
    [self showLoadingDialog];
    BaseDataGetMaterialAmountParam * param = [[BaseDataGetMaterialAmountParam alloc] initWithInventoryId:inventoryId];
    if(_business) {
        [_business getMaterialAmount:param success:^(NSInteger key, id object) {
            _materialAmount = object;
            [self updateInfo];
            [self hideLoadingDialog];
            
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
        }];
    }
}

//选择仓库
- (void) gotoWareHouseSelect {
    NSLog(@"选择仓库。");
    NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"selectAll", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
    
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

- (void) gotoMaterialSelect {
    InfoSelectViewController * infoSelectVC = [[InfoSelectViewController alloc] init];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_warehouseId, @"wareHouseId", nil];
    infoSelectVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
    
    [infoSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:infoSelectVC];
}


- (BOOL) isMaterialExist:(NSNumber *) inventoryId {
    BOOL res = NO;
    if(inventoryId) {
        for(WorkOrderMaterial * obj in _materials) {
            if([obj.inventoryId isEqualToNumber:inventoryId]) {
                res = YES;
                break;
            }
        }
        if(!res) {  //不在工单原有的物料列表中

        }
    }
    return res;
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * origin = [msg valueForKeyPath:@"msgOrigin"];
        MaterialEntity * material;
        if([origin isEqualToString:@"InfoSelectViewController"]) {
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            switch (requestType) {
                case REQUEST_TYPE_MATERIAL_INFO_SELECT:
                    material = [msg valueForKeyPath:@"result"];
                    if(material) {
                        if([self isMaterialExist:material.inventoryId]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            });
                        } else {
                            //物料选择成功
                            _material = material;
                        }
                    }
                    [self updateInfo];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

//预定物料
- (void) reserveMaterial {
    BaseDataReserveMaterialParam * param = [[BaseDataReserveMaterialParam alloc] init];
    param.woId = [_woId copy];
    param.warehouseId = _warehouseId;
    
    ReserveMaterialEntity * curMaterial = [[ReserveMaterialEntity alloc] init];
    curMaterial.inventoryId = [self getInventoryId];
    curMaterial.amount = [FMUtils stringToNumber:[_reserveAmountTF text]];
    
    BOOL isExist = NO;//保证物料预定的顺序不变
    for(WorkOrderMaterial * woMaterial in _materials) {
        ReserveMaterialEntity * reMaterial = [[ReserveMaterialEntity alloc] init];
        if(![curMaterial.inventoryId isEqualToNumber:woMaterial.inventoryId]) {
            reMaterial.inventoryId = [woMaterial.inventoryId copy];
            reMaterial.amount = [NSNumber numberWithInteger:woMaterial.amount];
            reMaterial.dueDate = woMaterial.dueDate;
            [param.inventories addObject:reMaterial];
        } else {
            isExist = YES;
            [param.inventories addObject:curMaterial];
        }
    }
    if(!isExist) {
        [param.inventories addObject:curMaterial];
    }
    
    [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"requesting" inTable:nil]];

    [_business reserveMaterial:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        NSString * strMessage = @"";
        if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_ADD) {
            strMessage = [[BaseBundle getInstance] getStringByKey:@"order_material_reserve_success" inTable:nil];
        } else if(_requestType == ORDER_MATERIAL_OPERATE_TYPE_EDIT) {
            strMessage = [[BaseBundle getInstance] getStringByKey:@"order_material_update_success" inTable:nil];
        }
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:strMessage time:DIALOG_ALIVE_TIME_SHORT];
        [self requestUpdateMaterialInfo];
        [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_material_operation_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}


#pragma --- 弹出键盘
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height = _realHeight-keyboardSize.height;
            _mainContainerView.frame = frame;
        }];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        _mainContainerView.frame = frame;
    }];
}



@end
