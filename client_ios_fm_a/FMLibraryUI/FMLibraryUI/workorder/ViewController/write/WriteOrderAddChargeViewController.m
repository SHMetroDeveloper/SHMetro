//
//  WriteOrderAddChargeViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WriteOrderAddChargeViewController.h"
#import "BaseTextField.h"
#import "FMSize.h"
#import "FMColor.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "WorkOrderDetailEntity.h"
#import "UIButton+Bootstrap.h"
#import "CaptionTextField.h"
#import "WorkOrderBusiness.h"


@interface WriteOrderAddChargeViewController ()

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) CaptionTextField * nameTF;
@property (readwrite, nonatomic, strong) CaptionTextField * amountTF;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSNumber * amount;
@property (readwrite, nonatomic, strong) NSNumber * chargeId;
@property (readwrite, nonatomic, strong) NSNumber * woId;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@property (readwrite, nonatomic, assign) WorkOrderChargeEditType operateType;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WriteOrderAddChargeViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_charge_edit" inTable:nil]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [[WorkOrderBusiness alloc] init];
        
        CGRect frame = [self getContentFrame];
        CGFloat width = CGRectGetWidth(frame);
        
        CGFloat originY = 0;
        CGFloat itemHeight = 92;
        CGFloat itemWidth = width ;
        CGFloat sepHeight = 0;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _nameTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
        [_nameTF setDetegate:self];
        [_nameTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_charge_name" inTable:nil]];
        [_nameTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_charge_name_placeholder" inTable:nil]];
        [_nameTF setShowMark:YES];
        originY += itemHeight + sepHeight;
        
        _amountTF = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
        [_amountTF setDetegate:self];
        [_amountTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_charge_amount" inTable:nil]];
        [_amountTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_charge_amount_placeholder" inTable:nil]];
        [_amountTF setShowMark:YES];
        [_amountTF setKeyboardType:UIKeyboardTypeDecimalPad];
        originY += itemHeight + sepHeight;
        
        [_mainContainerView addSubview:_nameTF];
        [_mainContainerView addSubview:_amountTF];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (BOOL) checkInput {
    BOOL isChecked = YES;
    NSString * name = [_nameTF.text copy];
    NSString * amount = [_amountTF.text copy];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if ([FMUtils isStringEmpty:name] || [FMUtils isStringEmpty:amount] || [formatter numberFromString:[NSString stringWithFormat:@"%@",_amountTF.text]].floatValue == 0) {
        
        isChecked = NO;
    }
    return isChecked;
}


- (void) updateInfo {
    [_nameTF setText:_name];
    if(![FMUtils isNumberNullOrZero:_amount]) {
        [_amountTF setText:[[NSString alloc] initWithFormat:@"%.2f", _amount.floatValue]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if([self needUpload]) {
        [self gotoUploadCostInfo];
    }
    
    
//    if(_handler) {
//        WorkOrderChargeItem * item = [self getInfoInput];
//        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
//        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
//        [msg setValue:item forKeyPath:@"result"];
//        [_handler handleMessage:msg];
//    }
//    [self finish];
}

- (BOOL) needUpload {
    BOOL res = YES;
    NSString * name = _nameTF.text;
    NSString * amount = _amountTF.text;
    if([FMUtils isStringEmpty:name]) {
        res = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_charge_notice_empty_name" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if([FMUtils isStringEmpty:amount]) {
        res = NO;
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_charge_notice_empty_amount" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        
    }
    return res;
}

- (WorkOrderChargeItem *) getInfoInput {
    WorkOrderChargeItem * item = [[WorkOrderChargeItem alloc] init];
    item.name = [_nameTF.text copy];
    item.amount = [FMUtils stringToNumber:_amountTF.text];
    item.chargeId = _chargeId;
    return item;
}

- (void) setChargeInfoWithEntity:(WorkOrderChargeItem *) chargeItem {
    _chargeId = chargeItem.chargeId;
    _name = chargeItem.name;
    _amount = chargeItem.amount;
}

- (void) setOperateType:(WorkOrderChargeEditType) operateType {
    _operateType = operateType;
}

- (void) setWorkOrderId:(NSNumber *) woId {
    _woId = [woId copy];
}

- (void) handleResult {
    if(_handler) {
        WorkOrderChargeItem * item = [self getInfoInput];
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:item forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
    [self finish];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

#pragma marl - 网络上传
- (void) gotoUploadCostInfo {   //TODO: 需要修改逻辑
    if ([self checkInput]) {
        [self showLoadingDialog];
        WorkOrderChargeSaveRequestParam * param = [self getChargeInfoParam];
        [_business saveWorkOrderCharge:param success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            if (_operateType == WORK_ORDER_CHARGE_TYPE_ADD) {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_add_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            } else if (_operateType == WORK_ORDER_CHARGE_TYPE_MODIFY) {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_modify_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
            _chargeId = object;   //获取返回的收费项Id
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self handleResult];
            });
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_notice_input" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (WorkOrderChargeSaveRequestParam *) getChargeInfoParam {
    WorkOrderChargeSaveRequestParam * param = [[WorkOrderChargeSaveRequestParam alloc] init];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if (_operateType == WORK_ORDER_CHARGE_TYPE_ADD) {
        param.woId = _woId;
        param.operateType = WORK_ORDER_CHARGE_TYPE_ADD;
        param.chargeId = nil;
        param.name = [_nameTF.text copy];
        param.amount = [formatter numberFromString:[NSString stringWithFormat:@"%@",_amountTF.text]].doubleValue;
    } else if(_operateType == WORK_ORDER_CHARGE_TYPE_MODIFY) {
        param.woId = _woId;
        param.operateType = WORK_ORDER_CHARGE_TYPE_MODIFY;
        param.chargeId = _chargeId;
        param.name = [_nameTF.text copy];
        param.amount = [formatter numberFromString:[NSString stringWithFormat:@"%@",_amountTF.text]].doubleValue;
    }
    return param;
}


@end



