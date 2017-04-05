//
//  ReservationMaterialViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReservationMaterialViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseTextField.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderDetailEntity.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseLabelView.h"
#import "InfoSelectViewController.h"
#import "SystemConfig.h"
#import "BaseTextView.h"
#import "SeperatorView.h"
#import "CaptionTextField.h"
#import "MaterialEntity.h"


@interface ReservationMaterialViewController ()

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) CaptionTextField *codeTF;    //物料编码
@property (readwrite, nonatomic, strong) CaptionTextField *nameTF;    //名称
@property (readwrite, nonatomic, strong) CaptionTextField *brandTF;   //品牌
@property (readwrite, nonatomic, strong) CaptionTextField *modelTF;   //型号
@property (readwrite, nonatomic, strong) CaptionTextField *amountTF;  //库存量
@property (readwrite, nonatomic, strong) CaptionTextField *costTF;   //费用（单价）
@property (readwrite, nonatomic, strong) CaptionTextField *countTF;   //预定数量


@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, assign) ReservationMaterialOperateType requestType;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * warehouseId;
@property (readwrite, nonatomic, strong) NSMutableArray * materials;
@property (readwrite, nonatomic, strong) NSNumber * currentMaterialId;
@property (readwrite, nonatomic, strong) NSMutableDictionary * material;    //待预定的物料

@property (readwrite, nonatomic, strong) ReservationMaterial * rmaterial;    //已经预定的物料

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end


@implementation ReservationMaterialViewController

- (instancetype) initWithRequestType:(ReservationMaterialOperateType)type {
    self = [super  init];
    if(self) {
        _requestType = type;
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateLayout];
}

- (void) initNavigation {
    NSString * strTitle =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_title_add" inTable:nil];;
    NSMutableArray * menus;
    if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD) {
        menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil], nil];
        
    } else if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT) {
        strTitle =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_title_edit" inTable:nil];;
        menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    }
    [self setMenuWithArray:menus];
    [self setTitleWith:strTitle];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self updateLayout];
}


- (void) initLayout {
    if(!_mainContainerView) {
        
        _defaultItemHeight = 92;
        
        _mainContainerView = [[UIScrollView alloc] init];
        
        _codeTF = [[CaptionTextField alloc] init];
        [_codeTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_code" inTable:nil]];
        [_codeTF setEditable:NO];
        [_codeTF setShowMark:YES];
        [_codeTF setOnClickListener:self];
        [_codeTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_placeholder_name" inTable:nil]];
        
        _nameTF = [[CaptionTextField alloc] init];
        [_nameTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_name" inTable:nil]];
        [_nameTF setEditable:NO];
        [_nameTF setShowMark:YES];
        [_nameTF setOnClickListener:self];
        [_nameTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_placeholder_name" inTable:nil]];
        
        _brandTF = [[CaptionTextField alloc] init];
        [_brandTF setEditable:NO];
        [_brandTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_brand" inTable:nil]];
        

        _modelTF = [[CaptionTextField alloc] init];
        [_modelTF setEditable:NO];
        [_modelTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_model" inTable:nil]];
        
        _amountTF = [[CaptionTextField alloc] init];
        [_amountTF setEditable:NO];
        [_amountTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_amount" inTable:nil]];
        
        _countTF = [[CaptionTextField alloc] init];
        [_countTF setShowMark:YES];
        [_countTF setKeyboardType:UIKeyboardTypeDecimalPad];
        [_countTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_reserve_amount" inTable:nil]];
        [_countTF setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_material_placeholder_reserve_amount" inTable:nil]];

        _costTF = [[CaptionTextField alloc] init];
        [_costTF setEditable:NO];
        [_costTF setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_material_reserve_cost" inTable:nil]];
        
        [_mainContainerView addSubview:_codeTF];
        [_mainContainerView addSubview:_nameTF];
        [_mainContainerView addSubview:_brandTF];
        [_mainContainerView addSubview:_modelTF];
        [_mainContainerView addSubview:_amountTF];
        [_mainContainerView addSubview:_costTF];
        [_mainContainerView addSubview:_countTF];
        
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [self.view addSubview:_mainContainerView];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self onMaterialSaved];
    }
}

- (void) updateLayout {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = 0;
    CGFloat itemHeight = _defaultItemHeight;
    
    [_mainContainerView setFrame:frame];
    
    [_codeTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_nameTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_brandTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_modelTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_amountTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_costTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;
    
    [_countTF setFrame:CGRectMake(0, originY, width, itemHeight)];
    originY += itemHeight;

    _mainContainerView.contentSize = CGSizeMake(width, originY);
                                      
    [self updateInfo];
}

- (void) setInfoWithWorkOrderId:(NSNumber *) woId {
    _woId = [woId copy];
}

//设置当前操作的仓库
- (void) setInfoWithWarehouse:(NSNumber *) warehouseId {
    _warehouseId = [warehouseId copy];
}

//设置工单相关 的物料信息
- (void) setInfoWithMaterials:(NSMutableArray *) materials {
    _materials = materials;
}

//设置当前正在编辑的物料
- (void) setMaterial:(NSMutableDictionary *)material {
    _material = material;
}

//设置当前正在编辑的物料
- (void) setReservationMaterial:(ReservationMaterial *) rmaterial {
    _rmaterial = rmaterial;
    if(!_material) {
        _material = [[NSMutableDictionary alloc] init];
        [_material setValue:_rmaterial.inventoryId forKeyPath:@"inventoryId"];
        [_material setValue:_rmaterial.materialName forKeyPath:@"name"];
        [_material setValue:_rmaterial.materialBrand forKeyPath:@"brand"];
        [_material setValue:_rmaterial.materialModel forKeyPath:@"model"];
        [_material setValue:_rmaterial.materialUnit forKeyPath:@"unit"];
        [_material setValue:_rmaterial.amount forKeyPath:@"amount"];
        [_material setValue:_rmaterial.bookAmount forKeyPath:@"reserveAmount"];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) notifyMaterialsUpdate {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:@"WriteOrderAddMaterialViewController" forKeyPath:@"msgOrigin"];
        [msg setValue:@"refresh" forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

- (void) updateInfo {
    if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD || _requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT) {
        if(_material) {
            [_codeTF setText:[_material valueForKeyPath:@"code"]];
            [_nameTF setText:[_material valueForKeyPath:@"name"]];
            [_brandTF setText:[_material valueForKeyPath:@"brand"]];
            [_modelTF setText:[_material valueForKeyPath:@"model"]];
            
            //有效数量
            [_amountTF setText:[[NSString alloc] initWithFormat:@"%0.2f", [self getRealNumber].doubleValue]];
            
            //费用
            NSNumber * cost = [_material valueForKeyPath:@"cost"];
            [_costTF setText:[[NSString alloc] initWithFormat:@"%.2f", cost.doubleValue]];
            
            //预定数量
            NSNumber * reserveAmount = [_material valueForKeyPath:@"reserveAmount"];
            if (reserveAmount.doubleValue <= 0) {
                [_countTF setText:nil];
            } else {
                [_countTF setText:[[NSString alloc] initWithFormat:@"%0.2f", reserveAmount.doubleValue]];
            }
        }
    } else if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT_RESERVED) {
        if(_rmaterial) {
            [_codeTF setText:_rmaterial.materialCode];
            [_nameTF setText:_rmaterial.materialName];
            [_brandTF setText:_rmaterial.materialBrand];
            [_modelTF setText:_rmaterial.materialModel];
            [_amountTF setText:[[NSString alloc] initWithFormat:@"%0.2f", [self getRealNumber].doubleValue]];
            
            [_countTF setText:[[NSString alloc] initWithFormat:@"%0.2f", _rmaterial.bookAmount.doubleValue]];
            [_costTF setText:[[NSString alloc] initWithFormat:@"%0.2f", _rmaterial.cost.doubleValue]];
        }
    }
}


//账面库存量
- (NSNumber *) getRealNumber {
    NSNumber * realNumber;
    double sum = 0;
    if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD || _requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT) {   //预定的时候就等于当前库存量
        if(_material) {
            NSNumber *tmpNumber = [_material valueForKeyPath:@"realNumber"];
            sum = tmpNumber.doubleValue;
        }
    } else if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT_RESERVED) {
        if(_rmaterial) {    //已经预定的数量 + 当前库存量
            sum = _rmaterial.amount.doubleValue + _rmaterial.bookAmount.doubleValue;
        }
    }
    realNumber = [NSNumber numberWithDouble:sum];
    return realNumber;
}

- (void) reserveMaterial {
    if([self isReserveAmountOK]) {
        NSNumber * reserveAmount = [FMUtils stringToNumber:[_countTF text]];
        [_material setValue:reserveAmount forKeyPath:@"reserveAmount"];
        if(_handler) {
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            [msg setValue:@"ReservationMaterialViewController" forKeyPath:@"msgOrigin"];
            [msg setValue:_material forKeyPath:@"result"];
            [_handler handleMessage:msg];
        }
        [self finish];
    }
}

- (void) onClick:(UIView *)view {
    if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD) {
        if(view == _nameTF || view == _codeTF) {
            [self gotoSelectMaterial];
        }
    }
}


- (void) onMaterialSaved {
    [self reserveMaterial];
}

- (BOOL) isMaterialExist:(NSNumber *) materialId {
    BOOL res = NO;
    if(_requestType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD || _requestType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT) {
        if(_materials && [_materials count] > 0) {
            for(NSDictionary * obj in _materials) {
                if([[obj valueForKeyPath:@"inventoryId"] isEqualToNumber:materialId]) {
                    res = YES;
                    break;
                }
            }
        }
    }
    return res;
}

//判断预定数量是否正确
- (BOOL) isReserveAmountOK {
    BOOL res = YES;
    NSNumber * reserveAmount = [self getReserveAmount];
    NSNumber * warehouseAmount = [self getRealNumber];
    
    if ([FMUtils isStringEmpty:[_nameTF text]]) {
        res = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_name_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if(res && reserveAmount.floatValue <= 0) {
        res = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_amount_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (res && (warehouseAmount.floatValue <= 0 || reserveAmount.floatValue > warehouseAmount.floatValue)) {
        res = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_more_than_inventory" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    return res;
}

//获取预定的物料的数量
- (NSNumber *) getReserveAmount {
    NSNumber * amount = 0;
    NSString * str = [_countTF text];
    amount = [FMUtils stringToNumber:str];
    return amount;
}

#pragma --- 键盘的显示与隐藏
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    if(keyboardSize.height > 0) {
//        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//            CGRect frame = [self getContentFrame];
//            frame.size.height -= keyboardSize.height;
//            _mainContainerView.frame = frame;
//            
//        }];
//    }
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
//        CGRect frame = [self getContentFrame];
//        _mainContainerView.frame = frame;
//    }];
//}

#pragma --- 选择完物料信息
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:@"InfoSelectViewController"]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"requestType"];
            NSInteger type = tmpNumber.integerValue;
            if(type == REQUEST_TYPE_MATERIAL_INFO_SELECT) {
                MaterialEntity *res = [msg valueForKeyPath:@"result"];
                if(![self isMaterialExist:res.inventoryId]) {
                    _material = [[NSMutableDictionary alloc] init];
                    [_material setValue:res.inventoryId forKeyPath:@"inventoryId"];
                    [_material setValue:res.materialCode forKeyPath:@"code"];
                    [_material setValue:res.materialName forKeyPath:@"name"];
                    [_material setValue:res.materialBrand forKeyPath:@"brand"];
                    [_material setValue:res.materialModel forKeyPath:@"model"];
                    [_material setValue:res.materialUnit forKeyPath:@"unit"];
                    [_material setValue:res.totalNumber forKeyPath:@"totalNumber"];  //库存数量
                    [_material setValue:res.minNumber forKeyPath:@"minNumber"];
                    [_material setValue:res.realNumber forKeyPath:@"realNumber"];  //有效数量
                    [_material setValue:res.cost forKeyPath:@"cost"];
                    [_material setValue:res.pictures forKeyPath:@"pictures"];
                    [self updateInfo];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    });
                }
            }
        }
    }
}

- (void) gotoSelectMaterial {
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:_warehouseId forKeyPath:@"warehouseId"];
    InfoSelectViewController * materialVC = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_MATERIAL_INFO_SELECT andParam:param];
    [materialVC setOnMessageHandleListener:self];
    [self gotoViewController:materialVC];
}

@end
