//
//  PatrolHistoryFilterItemTimeView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryFilterItemTimeView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"

@interface PatrolHistoryFilterItemTimeView ()

@property (readwrite, nonatomic, strong) NSString * timeStart;  //开始时间
@property (readwrite, nonatomic, strong) NSString * timeEnd;    //结束时间


@property (readwrite, nonatomic, strong) UIButton * timeStartBtn;
@property (readwrite, nonatomic, strong) UIButton * timeEndBtn;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;
@end

@implementation PatrolHistoryFilterItemTimeView

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
        
        UIFont * nameFont  = [FMFont getInstance].defaultFontLevel2;
        
        _timeStartBtn = [[UIButton alloc] init];
        _timeEndBtn = [[UIButton alloc] init];
        
        
        [_timeStartBtn.titleLabel setFont:nameFont];
        [_timeEndBtn.titleLabel setFont:nameFont];
        
        
        [_timeStartBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
        [_timeEndBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
        
        _timeStartBtn.tag = FILTER_ITEM_VIEW_TAG_START;
        _timeEndBtn.tag = FILTER_ITEM_VIEW_TAG_END;
        
        _timeStartBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeEndBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        [_timeStartBtn addTarget:self action:@selector(onTimeStartClicked) forControlEvents:UIControlEventTouchUpInside];
        [_timeEndBtn addTarget:self action:@selector(onTimeEndClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.timeStartBtn];
        [self addSubview:self.timeEndBtn];
    }
}

- (void) updateViews {
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight = (height - sepHeight * 3)/2;
    if(width == 0 || height == 0) {
        return;
    }
    [_timeStartBtn setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft*2, itemHeight)];
    [_timeEndBtn setFrame:CGRectMake(_paddingLeft, height/2 , width - _paddingLeft*2, itemHeight)];
    
    [self updateInfo];
}

- (void) setInfoWithTimeStart:(NSString*) startTime
                          end:(NSString*) endTime {
    
    _timeStart = startTime;
    _timeEnd = endTime;
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) updateInfo {
    [_timeStartBtn setTitle:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"time_start" inTable:nil], _timeStart] forState:UIControlStateNormal];
    [_timeEndBtn setTitle:[[NSString alloc] initWithFormat:@"%@: %@",[[BaseBundle getInstance] getStringByKey:@"time_end" inTable:nil], _timeEnd] forState:UIControlStateNormal];
    
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _clickListener = listener;
}

- (void) onTimeStartClicked {
    if(_clickListener) {
        [_clickListener onClick:_timeStartBtn];
    }
}

- (void) onTimeEndClicked {
    if(_clickListener) {
        [_clickListener onClick:_timeEndBtn];
    }
}

@end

