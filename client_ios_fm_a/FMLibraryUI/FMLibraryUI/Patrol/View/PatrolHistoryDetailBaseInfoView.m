//
//  PatrolHistoryDetailBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryDetailBaseInfoView.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "SeperatorView.h"

@interface PatrolHistoryDetailBaseInfoView ()

@property (readwrite, nonatomic, strong) BaseLabelView * userBaseLbl;       //用户
@property (readwrite, nonatomic, strong) BaseLabelView * cycleBaseLbl;      //周期
@property (readwrite, nonatomic, strong) BaseLabelView * estimateTimeBaseLbl;//预估时间
@property (readwrite, nonatomic, strong) BaseLabelView * actualTimeBaseLbl; //实际时间
@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator; //底部分割线

@property (readwrite, nonatomic, strong) NSString * userName;
@property (readwrite, nonatomic, strong) NSString * cycle;
@property (readwrite, nonatomic, strong) NSString * estimateTime;
@property (readwrite, nonatomic, strong) NSString * actualTime;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) BOOL isInited;
@end


@implementation PatrolHistoryDetailBaseInfoView

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
        
        [self setShowBound:YES];
        _labelWidth = 0;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _userBaseLbl = [[BaseLabelView alloc] init];
        [_userBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_laborer" inTable:nil] andLabelWidth:0];
        [_userBaseLbl setLabelFont:mFont andColor:labelColor];
        [_userBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_userBaseLbl setContentAlignment:NSTextAlignmentLeft];
        [_userBaseLbl setContentFont:mFont];
        [_userBaseLbl setContentColor:contentColor];
        
        _cycleBaseLbl = [[BaseLabelView alloc] init];
        [_cycleBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_cycle" inTable:nil] andLabelWidth:0];
        [_cycleBaseLbl setLabelFont:mFont andColor:labelColor];
        [_cycleBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_cycleBaseLbl setContentAlignment:NSTextAlignmentLeft];
        [_cycleBaseLbl setContentFont:mFont];
        [_cycleBaseLbl setContentColor:contentColor];
        
        _estimateTimeBaseLbl = [[BaseLabelView alloc] init];
        [_estimateTimeBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_time_estimate" inTable:nil] andLabelWidth:0];
        [_estimateTimeBaseLbl setLabelFont:mFont andColor:labelColor];
        [_estimateTimeBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_estimateTimeBaseLbl setContentAlignment:NSTextAlignmentLeft];
        [_estimateTimeBaseLbl setContentFont:mFont];
        [_estimateTimeBaseLbl setContentColor:contentColor];
        
        _actualTimeBaseLbl = [[BaseLabelView alloc] init];
        [_actualTimeBaseLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"patrol_time_reality" inTable:nil] andLabelWidth:0];
        [_actualTimeBaseLbl setLabelFont:mFont andColor:labelColor];
        [_actualTimeBaseLbl setLabelAlignment:NSTextAlignmentLeft];
        [_actualTimeBaseLbl setContentAlignment:NSTextAlignmentLeft];
        [_actualTimeBaseLbl setContentFont:mFont];
        [_actualTimeBaseLbl setContentColor:contentColor];
        
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [self addSubview:_userBaseLbl];
        [self addSubview:_cycleBaseLbl];
        [self addSubview:_estimateTimeBaseLbl];
        [self addSubview:_actualTimeBaseLbl];
        [self addSubview:_bottomSeperator];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat itemHeigt = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepHeight = (height - itemHeigt * 4) /5;
    CGFloat padding = [FMSize getInstance].padding50;
    
    CGFloat originX = 0;
    CGFloat originY = padding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    [_userBaseLbl setFrame:CGRectMake(originX, originY, width, itemHeigt)];
    originY += itemHeigt + padding;
    
    [_cycleBaseLbl setFrame:CGRectMake(originX, originY, width, itemHeigt)];
    originY += itemHeigt + padding;
    
    [_estimateTimeBaseLbl setFrame:CGRectMake(originX, originY, width, itemHeigt)];
    originY += itemHeigt + padding;
    
    [_actualTimeBaseLbl setFrame:CGRectMake(originX, originY, width, itemHeigt)];
    originY += itemHeigt + padding;
    
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_userBaseLbl setContent:_userName];
    [_cycleBaseLbl setContent:_cycle];
    [_estimateTimeBaseLbl setContent:_estimateTime];
    [_actualTimeBaseLbl setContent:_actualTime];
}

//设置信息
- (void) setInfoWithName:(NSString *) userName andCycle:(NSString *) cycle andEstimateTime:(NSString *) estimateTime andActualTime:(NSString *) actualTime {
    _userName = userName;
    _cycle = cycle;
    _estimateTime = estimateTime;
    _actualTime = actualTime;
    [self updateViews];
}

- (void) setShowBound:(BOOL) show {
    if(show) {
        [_bottomSeperator setHidden:NO];
    } else {
        [_bottomSeperator setHidden:YES];
    }
}

+ (CGFloat) getBaseInfoHeight {
    CGFloat height = 0;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].padding50;
    
    
    height = itemHeight * 4 + padding * 5;
    
    return height;
}

@end







