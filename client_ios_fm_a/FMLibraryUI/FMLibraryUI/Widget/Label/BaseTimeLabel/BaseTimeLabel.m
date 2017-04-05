//
//  BaseTimeLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/13.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseTimeLabel.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"


@interface BaseTimeLabel ()

@property (readwrite, nonatomic, strong) UILabel * dateLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;

@property (readwrite, nonatomic, strong) NSString * strDate;
@property (readwrite, nonatomic, strong) NSString * strTime;

@property (readwrite, nonatomic, assign) CGFloat dateHeight;
@property (readwrite, nonatomic, assign) CGFloat timeHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end


@implementation BaseTimeLabel

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
        
        _dateLbl = [[UILabel alloc] init];
        _timeLbl = [[UILabel alloc] init];
        
        _dateHeight = 30;
        _timeHeight = 50;
        
        [_dateLbl setFont:[FMFont getInstance].defaultFontLevel2];
        [_timeLbl setFont:[FMFont getInstance].chartCountFont];
        
        [_dateLbl setTextAlignment:NSTextAlignmentCenter];
        [_timeLbl setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:_dateLbl];
        [self addSubview:_timeLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat sepHeight = (height - _dateHeight - _timeHeight) / 2;
    CGFloat originY = sepHeight;
    [_dateLbl setFrame:CGRectMake(0, originY, width, _dateHeight)];
    originY += _dateHeight;
    [_timeLbl setFrame:CGRectMake(0, originY, width, _timeHeight)];
    originY += _timeHeight;
    
    [self updateInfo];
}


- (void) updateInfo {
    [_dateLbl setText:_strDate];
    [_timeLbl setText:_strTime];
}

//设置时间
- (void) setTime:(NSDate *) date {
    if(date) {
        NSString * strDay = [FMUtils getDayStr:date];
        _strDate = strDay;
        _strTime = [FMUtils getTimeStr:date];
        
    } else {
        _strDate = @"";
        _strTime = @"";
    }
    [self updateViews];
}

- (void) setTimeWithNumber:(NSNumber *) timeNumber {
    NSDate * date = [FMUtils timeLongToDate:timeNumber];
    [self setTime:date];
}


@end

