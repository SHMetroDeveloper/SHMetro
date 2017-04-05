//
//  PatrolHistoryCountView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryCountView.h"
#import "RoundLabel.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface PatrolHistoryCountView ()

@property (readwrite, nonatomic, strong) RoundLabel * reportRLbl;   //报修
@property (readwrite, nonatomic, strong) UILabel * reportLbl;

@property (readwrite, nonatomic, strong) RoundLabel * ignoreRLbl;   //漏检
@property (readwrite, nonatomic, strong) UILabel * ignoreLbl;

@property (readwrite, nonatomic, strong) RoundLabel * exceptionRLbl;//异常
@property (readwrite, nonatomic, strong) UILabel * exceptionLbl;


@property (readwrite, nonatomic, assign) NSInteger reportCount;
@property (readwrite, nonatomic, assign) NSInteger ignoreCount;
@property (readwrite, nonatomic, assign) NSInteger exceptionCount;

@property (readwrite, nonatomic, assign) CGFloat radius;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation PatrolHistoryCountView

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
    }
    return self;
}
- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        

        _radius = [FMSize getSizeByPixel:198];
        _paddingLeft = [FMSize getInstance].defaultPadding * 2;
        _paddingRight = _paddingLeft;
        [self setShowBounds:YES];
        
        
        _reportRLbl = [[RoundLabel alloc] init];
        [_reportRLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];

        
        _ignoreRLbl = [[RoundLabel alloc] init];
        [_ignoreRLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        
        
        _exceptionRLbl = [[RoundLabel alloc] init];
        [_exceptionRLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        
        _reportLbl = [[UILabel alloc] init];
        [_reportLbl setText:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        [_reportLbl setTextAlignment:NSTextAlignmentCenter];
        [_reportLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        _reportLbl.font = [FMFont getInstance].defaultFontLevel2;
        
        
        _ignoreLbl = [[UILabel alloc] init];
        [_ignoreLbl setText:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        [_ignoreLbl setTextAlignment:NSTextAlignmentCenter];
        [_ignoreLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        _ignoreLbl.font = [FMFont getInstance].defaultFontLevel2;
        
        
        _exceptionLbl = [[UILabel alloc] init];
        [_exceptionLbl setText:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        [_exceptionLbl setTextAlignment:NSTextAlignmentCenter];
        [_exceptionLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        _exceptionLbl.font = [FMFont getInstance].defaultFontLevel2;
        

        [self addSubview:_reportRLbl];
        [self addSubview:_ignoreRLbl];
        [self addSubview:_exceptionRLbl];
        
        [self addSubview:_reportLbl];
        [self addSubview:_ignoreLbl];
        [self addSubview:_exceptionLbl];
    }
    
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat paddingTop = [FMSize getInstance].defaultPadding;
    
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    
    CGFloat labelHeight = 30;
    CGFloat itemWidth = _radius;
    
    CGFloat padding = [FMSize getSizeByPixel:78];
    CGFloat sepWidth = (width - padding*2 - _radius*3)/2;
    
    CGFloat originX = padding;
    CGFloat originY = paddingTop;
    
    
    [_reportRLbl setFrame:CGRectMake(originX, originY, _radius, _radius)];
    originX += sepWidth + _radius;
    
    
    
    [_ignoreRLbl setFrame:CGRectMake(originX, originY, _radius, _radius)];
    originX += sepWidth + _radius;
    
    
    
    [_exceptionRLbl setFrame:CGRectMake(originX, originY, _radius, _radius)];
    originY += sepHeight + _radius;
    
    originX = padding;
    
    
//    itemWidth = [FMUtils widthForString:_reportLbl value:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
//    if(itemWidth < _radius) {
//        itemWidth = _radius;
//    }
    [_reportLbl setFrame:CGRectMake(originX, originY, itemWidth, labelHeight)];
    originX += itemWidth + sepWidth;
    
    
    
//    itemWidth = [FMUtils widthForString:_reportLbl value:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
//    if(itemWidth < _radius) {
//        itemWidth = _radius;
//    }
    [_ignoreLbl setFrame:CGRectMake(originX, originY, itemWidth, labelHeight)];
    originX += itemWidth + sepWidth;
    
    
    
//    itemWidth = [FMUtils widthForString:_reportLbl value:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
//    if(itemWidth < _radius) {
//        itemWidth = _radius;
//    }
    [_exceptionLbl setFrame:CGRectMake(originX, originY, itemWidth, labelHeight)];
    originY += labelHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_reportRLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _reportCount]];
    [_ignoreRLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _ignoreCount]];
    [_exceptionRLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _exceptionCount]];
}

- (void) setInfoWithReportCount:(NSInteger) reportCount
                 andIgnoreCount:(NSInteger) ignoreCount
              andExceptionCount:(NSInteger) exceptionCount {
    _reportCount = reportCount;
    _ignoreCount = ignoreCount;
    _exceptionCount = exceptionCount;
    [self updateViews];
}

- (void) setShowBounds:(BOOL) show {
    if(show) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
    }
    
}

+ (CGFloat) getCountViewHeight {
    CGFloat height = [FMSize getSizeByPixel:380];
    
    return height;
}

@end





