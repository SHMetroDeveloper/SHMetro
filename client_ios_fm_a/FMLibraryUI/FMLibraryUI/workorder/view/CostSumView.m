//
//  WorkOrderDetailCostSumView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "CostSumView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface CostSumView ()

@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UILabel * sumLbl;

@property (readwrite, nonatomic, strong) NSString * sum;

@property (readwrite, nonatomic, assign) CGFloat defaultSumWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation CostSumView

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
        
        _paddingRight = 17;
        _defaultSumWidth = 50;
        
        _descLbl = [[UILabel alloc] init];
        _sumLbl = [[UILabel alloc] init];
        
        _descLbl.font = [FMFont getInstance].defaultFontLevel2;
        _sumLbl.font = [FMFont fontWithSize:24];
        
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _sumLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        
        _descLbl.text = [[BaseBundle getInstance] getStringByKey:@"cost_submit" inTable:nil];
        
        [self addSubview:_descLbl];
        [self addSubview:_sumLbl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepWidth = 8;
    CGFloat sumWidth = _defaultSumWidth;
    CGFloat paddingTop = 6;
    if(![FMUtils isStringEmpty:_sum]) {
        sumWidth = [FMUtils widthForString:_sumLbl value:_sum];
    }
    [_sumLbl setFrame:CGRectMake(width-_paddingRight-sumWidth, 0, sumWidth, height)];
    
    NSString * strDesc = [[BaseBundle getInstance] getStringByKey:@"cost_submit" inTable:nil];
    CGFloat descWidth = [FMUtils widthForString:_descLbl value:strDesc];
    [_descLbl setFrame:CGRectMake(width-_paddingRight-sumWidth-descWidth-sepWidth, paddingTop, descWidth, height-paddingTop)];
    
//    [self updateInfo];
}

- (void) updateInfo {
    if(![FMUtils isStringEmpty:_sum]) {
        [_sumLbl setText:_sum];
    } else {
        [_sumLbl setText:@""];
    }
    [self updateViews];
}

- (void) setInfoWithCost:(NSString *) cost {
    NSString *sumStr = [NSString stringWithFormat:@"%@%@", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], cost];
    _sum = sumStr;
    [self updateInfo];
}

@end
