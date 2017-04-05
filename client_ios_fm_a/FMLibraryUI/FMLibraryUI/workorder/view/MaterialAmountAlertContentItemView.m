//
//  MaterialAmountSelectContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "MaterialAmountAlertContentItemView.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "BaseLabelView.h"
#import "BaseTextField.h"
#import "BaseBundle.h"

@interface MaterialAmountAlertContentItemView ()

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * dueDateLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * batchAmountLbl;
@property (readwrite, nonatomic, strong) BaseTextField * amountTF;

@property (readwrite, nonatomic, assign) MaterialAmountOperateType approvalType;

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * okBtn;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat labelWidth2;
@property (readwrite, nonatomic, assign) CGFloat labelWidth4;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) id<OnMessageHandleListener> handler;
@end


@implementation MaterialAmountAlertContentItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = _paddingLeft;
        _paddingBottom = 0;
        
        _labelWidth2 = 40;
        _labelWidth4 = 70;
        
        _controlHeight = [FMSize getInstance].bottomControlHeight;
        
        _mainContainerView = [[UIView alloc] init];
        _controlView = [[UIView alloc] init];
        
        _nameLbl = [[BaseLabelView alloc] init];
        _dueDateLbl = [[BaseLabelView alloc] init];
        _batchAmountLbl = [[BaseLabelView alloc] init];
        _amountTF = [[BaseTextField alloc] init];
        
//        _nameLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _dueDateLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _batchAmountLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _dueDateLbl.tag = MATERIAL_AMOUNT_TYPE_BATCH_SELECT;
        [_dueDateLbl setOnClickListener:self];
        
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_name" inTable:nil] andLabelWidth:_labelWidth4];
        [_dueDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_over_due" inTable:nil] andLabelWidth:_labelWidth4];
        [_batchAmountLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_amount" inTable:nil] andLabelWidth:_labelWidth2];
        [_amountTF setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"order_material_reserve_amount" inTable:nil]];
        
        _okBtn = [[UIButton alloc] init];
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        
        [_okBtn addTarget:self action:@selector(onOKButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.tag = MATERIAL_AMOUNT_TYPE_OK;
        
        
        [_controlView addSubview:_okBtn];
        
        [_mainContainerView addSubview:_nameLbl];
        [_mainContainerView addSubview:_dueDateLbl];
        [_mainContainerView addSubview:_batchAmountLbl];
        [_mainContainerView addSubview:_amountTF];
        
        
        [self addSubview:_mainContainerView];
        [self addSubview:_controlView];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemHeight = 40;
    CGFloat originY = _paddingTop;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    
    [_mainContainerView setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    
    CGFloat btnWidth = (width - _paddingLeft - _paddingRight);
    [_okBtn setFrame:CGRectMake(_paddingLeft, padding/2, btnWidth, _controlHeight - padding)];
    
    [_okBtn primaryStyle];
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft , originY, (width-_paddingLeft-_paddingRight), itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_dueDateLbl setFrame:CGRectMake(_paddingLeft, originY, (width-_paddingLeft-_paddingRight)*2/3, itemHeight)];
    [_batchAmountLbl setFrame:CGRectMake(_paddingLeft + (width-_paddingLeft-_paddingRight)*2/3, originY, (width-_paddingLeft-_paddingRight)/3, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_amountTF setFrame:CGRectMake(_paddingLeft, originY, (width-_paddingLeft-_paddingRight), itemHeight)];
    originY += itemHeight + sepHeight;
    
    
}




- (void) clearInput {
    [_dueDateLbl setContent:@""];
    [_batchAmountLbl setContent:@""];
    [_amountTF setText:@""];
}


- (void) onOKButtonClicked {
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:@"MaterialAmountAlertContentItemView" forKeyPath:@"msgOrigin"];
    if(_handler) {
        NSInteger reserveAmount = [self getReserveAmount];
        [msg setValue:[NSNumber numberWithInteger:MATERIAL_AMOUNT_TYPE_OK] forKeyPath:@"resultType"];
        [msg setValue:[NSNumber numberWithInteger:reserveAmount] forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

- (NSInteger) getReserveAmount {
    NSInteger count = 0;
    NSString * tmp = _amountTF.text;
    if(![FMUtils isStringEmpty:tmp]) {
        NSNumber * num = [FMUtils stringToNumber:tmp];
        count = num.integerValue;
    }
    return count;
}

//设置预定数量
- (void) setReserveAmount:(NSInteger) amount {
    NSString * strAmount = @"";
    if(amount > 0) {
        strAmount = [[NSString alloc] initWithFormat:@"%ld", amount];
    }
    [_amountTF setText:strAmount];
}

- (void) setMaterialName:(NSString *) name {
    [_nameLbl setContent:name];
}

- (void) setDueDate:(NSNumber *) dueDate batchAmount:(NSInteger) batchAmount {
    NSString * strDate = @"";
    NSString * strAmount = @"";
    if(dueDate) {
        NSDate * date = [FMUtils timeLongToDate:dueDate];
        strDate = [FMUtils getDayStr:date];
        strAmount = [[NSString alloc] initWithFormat:@"%ld", batchAmount];
    }
    [_dueDateLbl setContent:strDate];
    [_batchAmountLbl setContent:strAmount];
    
}
//
//- (void) setOnItemClickListener:(id<OnItemClickListener>) listener{
//    _clickListener = listener;
//}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) setInputDelegate:(id<UITextFieldDelegate>) delegate {
    [_amountTF setDelegate:delegate];
}

- (void) onClick:(UIView *)view {
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:@"MaterialAmountAlertContentItemView" forKeyPath:@"msgOrigin"];
    if(view == _dueDateLbl) {
        
        if(_handler) {
            [msg setValue:[NSNumber numberWithInteger:MATERIAL_AMOUNT_TYPE_BATCH_SELECT] forKeyPath:@"resultType"];
            [_handler handleMessage:msg];
        }
    }
}

@end
