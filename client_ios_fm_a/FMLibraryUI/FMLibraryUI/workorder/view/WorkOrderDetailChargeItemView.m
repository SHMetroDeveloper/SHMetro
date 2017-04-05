//
//  WorkOrderDetailChargeItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailChargeItemView.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "UIButton+Bootstrap.h"

@interface WorkOrderDetailChargeItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * amountLbl;


@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSNumber * amount;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;


@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation WorkOrderDetailChargeItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingLeft = 17;
        _paddingRight = 17;
        
        _nameLbl = [[UILabel alloc] init];
        _amountLbl = [[UILabel alloc] init];
        
        
        _nameLbl.font = [FMFont getInstance].defaultFontLevel2;
        _amountLbl.font = [FMFont getInstance].defaultFontLevel2;
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _amountLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        
        _nameLbl.numberOfLines = 1;
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_amountLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = (height - itemHeight * 2) / 3;
    CGFloat originY = sepHeight;
    
    
    
    NSString * strAmount = [self getAmountDesc];
    CGFloat amountWidth = [FMUtils widthForString:_amountLbl value:strAmount];
    [_amountLbl setFrame:CGRectMake(width-_paddingRight-amountWidth, 0, amountWidth, height)];
    
    
    CGFloat itemWidth = width - _paddingLeft - _paddingRight - amountWidth;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, itemWidth, height)];

    
    originY += itemHeight + sepHeight;
    
    
    
    [self updateInfo];
}

- (NSString *) getAmountDesc {
    NSString * amount = [[NSString alloc] initWithFormat:@"%@%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], _amount.floatValue];
    return amount;
}

- (void) updateInfo {
    [_nameLbl setText:_name];
    NSString * strCost = [self getAmountDesc];
    [_amountLbl setText:strCost];
}

- (void) setInfoWithName:(NSString *) name amount:(NSNumber *) amount {
    _name = name;
    _amount = amount;
    [self updateViews];
}

- (void) setEditable:(BOOL)editable {
//    _editable = editable;
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}



- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClick:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
}
@end
