//
//  ChartEventView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/13.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ChartEventView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseTimeLabel.h"
#import "SeperatorView.h"
#import "BaseLabelView.h"

@interface ChartEventView ()


@property (readwrite, nonatomic, strong) BaseTimeLabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * contentLbl;
@property (readwrite, nonatomic, strong) SeperatorView * middleSeperator;

@property (readwrite, nonatomic, strong) NSNumber * time;
@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat timeWidth;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ChartEventView

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
        
        _timeWidth = 100;
        _padding = [FMSize getInstance].defaultPadding;
        _defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
        
        _timeLbl = [[BaseTimeLabel alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _contentLbl = [[BaseLabelView alloc] init];
        _middleSeperator = [[SeperatorView alloc] init];
        
        
        [_titleLbl setFont:[FMFont getInstance].defaultFontLevel1];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_timeLbl];
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
        [self addSubview:_middleSeperator];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat originX = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorWidth = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight;
    [_timeLbl setFrame:CGRectMake(0, 0,_timeWidth, height)];
    originX += _timeWidth;
    
    [_middleSeperator setFrame:CGRectMake(originX, 0, seperatorWidth, height)];
    originX += seperatorWidth;
    
    itemHeight = _defaultItemHeight;
    [_titleLbl setFrame:CGRectMake(originX + padding, padding, width-_timeWidth-padding*2, itemHeight)];
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_content font:nil desc:nil labelFont:nil andLabelWidth:0 andWidth:width-_timeWidth-padding*2];
    if(itemHeight < _defaultItemHeight) {
        itemHeight = _defaultItemHeight;
    }
    [_contentLbl setFrame:CGRectMake(originX + padding, padding + _defaultItemHeight, width-_timeWidth-padding*2, itemHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    
    if(_time) {
        [_timeLbl setTimeWithNumber:_time];
    }
    if(_title) {
        [_titleLbl setText:_title];
    }
    if(_content) {
        [_contentLbl setContent:_content];
    }
}

- (void) setInfoWithTime:(NSNumber *) time title:(NSString *) title content:(NSString *) content;{
    _time = time;
    _title = title;
    _content = content;
    
    [self updateViews];
}

- (void) setShowBound:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderWidth = 0;
    }
}

+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width{
    CGFloat height;
    CGFloat timeWidth = 100;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    
    CGFloat contentHeight = [BaseLabelView calculateHeightByInfo:content font:nil desc:nil labelFont:nil andLabelWidth:0 andWidth:width-timeWidth-padding*2];
    
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    height = defaultItemHeight + contentHeight + padding * 2;
    return height;
}

@end


