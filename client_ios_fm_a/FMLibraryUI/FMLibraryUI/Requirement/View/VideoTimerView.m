//
//  VideoTimerView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "VideoTimerView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"


@interface VideoTimerView ()

@property (readwrite, nonatomic, strong) UILabel * markLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
//@property (readwrite, nonatomic, strong) UILabel * unitLbl;

@property (readwrite, nonatomic, assign) CGFloat markWidth;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) NSInteger point;

@property (readwrite, nonatomic, assign) NSInteger timerSep;    //时间间隔

@property (readwrite, nonatomic, assign) NSInteger maxPoint;    //计时的最大值

@property (readwrite, nonatomic, strong) NSTimer * timer;

@property (readwrite, nonatomic, weak) id<OnTimerUpdateListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation VideoTimerView

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
        
        _padding = 10;
        _markWidth = 10;
        _point = 0;
        _timerSep = 1;
        _maxPoint = 0;  //无限计时
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        
        _markLbl = [[UILabel alloc] init];
        _timeLbl = [[UILabel alloc] init];
        //        _unitLbl = [[UILabel alloc] init];
        
        _timeLbl.font = msgFont;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        //        _unitLbl.font = msgFont;
        
        _markLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _markLbl.layer.cornerRadius = _markWidth/2;
        _markLbl.clipsToBounds = YES;
        
        //        [_unitLbl setText:@"\""];
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        self.clipsToBounds = YES;
        
        [self addSubview:_markLbl];
        [self addSubview:_timeLbl];
        //        [self addSubview:_unitLbl];
        
        [self setHidden:YES];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height =CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    self.layer.cornerRadius = height / 2;
    CGFloat itemHeight = 20;
    CGFloat originX = _padding;
    CGFloat sepWidth = _padding/2;
    [_markLbl setFrame:CGRectMake(originX, (height-_markWidth)/2, _markWidth, _markWidth)];
    originX += _markWidth + sepWidth;
    [_timeLbl setFrame:CGRectMake(originX, (height-itemHeight)/2, width-originX-_padding, itemHeight)];
    
    [self updateInfo];
    
}

- (void) updateInfo {
    if(_point > 0) {
        NSString * strTimeNow = [[NSString alloc] initWithFormat:@"%ld\"", _point];
        [_timeLbl setText:strTimeNow];
    } else {
        [_timeLbl setText:@""];
    }
}

- (BOOL) isRunning {
    if(_timer) {
        return YES;
    }
    return NO;
}

- (void) start {
    _timer = [NSTimer timerWithTimeInterval:_timerSep target:self selector:@selector(updatePoint) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
}
- (void) stop {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer=nil;
}

- (void) reset {
    _point = 0;
}


- (void) setMaxPoint:(NSInteger)maxPoint {
    _maxPoint = maxPoint;
}

- (void) updatePoint {
    _point++;
    if(_point > 0) {
        [self setHidden:NO];
    }
    [self performSelectorOnMainThread:@selector(updateInfo) withObject:nil waitUntilDone:NO];
    if(_point == _maxPoint) {
        [self stop];
        [self notifyTimerFinished];
    }
}

- (void) notifyTimerFinished {
    if(_listener) {
        [_listener onTimerFinished:self];
    }
}

- (void) setOnTimerUpdateListener:(id<OnTimerUpdateListener>) handler {
    _listener = handler;
}

@end
