//
//  MonthFilterTimeView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "MonthFilterTimeView.h"
#import "SeperatorView.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"


@interface MonthFilterTimeView ()

@property (readwrite, nonatomic, strong) UIButton * preBtn;
@property (readwrite, nonatomic, strong) UIButton * nextBtn;
@property (readwrite, nonatomic, strong) UIButton * curBtn;
@property (readwrite, nonatomic, strong) SeperatorView * seperator;

@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;

@property (readwrite, nonatomic, strong) NSNumber * currentTime;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation MonthFilterTimeView

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
        
        _preBtn = [[UIButton alloc] init];
        _nextBtn = [[UIButton alloc] init];
        _curBtn = [[UIButton alloc] init];
        
        _seperator = [[SeperatorView alloc] init];
        
        _seperatorHeight = [FMSize getInstance].seperatorHeight;
        
        [_preBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_previous_month" inTable:nil] forState:UIControlStateNormal];
        [_nextBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_next_month" inTable:nil] forState:UIControlStateNormal];
        
        [_preBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
//        [_preBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateHighlighted];
        [_curBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
//        [_curBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateHighlighted];
        [_nextBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT] forState:UIControlStateNormal];
//        [_nextBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateHighlighted];
        
        [_preBtn addTarget:self action:@selector(onPreviousButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_curBtn addTarget:self action:@selector(onCurrentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _preBtn.titleLabel.font = [FMFont setFontByPX:38];
        _curBtn.titleLabel.font = [FMFont setFontByPX:38];
        _nextBtn.titleLabel.font = [FMFont setFontByPX:38];
        
        [_preBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7] width:1 height:1] forState:UIControlStateHighlighted];
        [_curBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7] width:1 height:1] forState:UIControlStateHighlighted];
        [_nextBtn setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7] width:1 height:1] forState:UIControlStateHighlighted];
        
        [self addSubview:_preBtn];
        [self addSubview:_curBtn];
        [self addSubview:_nextBtn];
        [self addSubview:_seperator];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat btnWidth = width / 3;
    [_preBtn setFrame:CGRectMake(0, 0, btnWidth, height)];
    [_curBtn setFrame:CGRectMake(btnWidth, 0, btnWidth, height)];
    [_nextBtn setFrame:CGRectMake(width-btnWidth, 0, btnWidth, height)];
    
    [_seperator setFrame:CGRectMake(0, height-_seperatorHeight, width, _seperatorHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [self updateTimeDesc];
}

- (void) setCurrentTime:(NSNumber *) time {
    _currentTime = time;
    [self updateInfo];
}

- (void) updateTimeDesc {
    if(!_currentTime) {
        _currentTime = [FMUtils getTimeLongNow];
    }
    NSDate * date = [FMUtils timeLongToDate:_currentTime];
    NSString * desc = [FMUtils getMonthStr:date];
    [_curBtn setTitle:desc forState:UIControlStateNormal];
}

//获取当前时间段的起始时间
- (NSNumber *) getCurrentTimeBegin {
    NSNumber * timeStart;
    NSDate * date = [FMUtils getFirstSecondOfMonth:[FMUtils timeLongToDate:_currentTime]];
    timeStart = [FMUtils dateToTimeLong:date];
    return timeStart;
}

- (NSNumber *) getCurrentTime {
    return _currentTime;
}

//获取当前时间段的结束时间
- (NSNumber *) getCurrentTimeEnd {
    NSNumber * timeEnd;
    NSDate * date = [FMUtils getLastSecondOfMonth:[FMUtils timeLongToDate:_currentTime]];
    timeEnd = [FMUtils dateToTimeLong:date];
    return timeEnd;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

//时间更新，前推一个月或者后推一个月
- (void) changeTime:(BOOL) previous {
    NSDate * date = [FMUtils timeLongToDate:_currentTime];
    NSDictionary * dict = [FMUtils dateToDictionary:date];
    NSNumber * tmpNumber = [dict valueForKeyPath:@"year"];
    NSInteger year = tmpNumber.integerValue;
    tmpNumber = [dict valueForKeyPath:@"month"];
    NSInteger month = tmpNumber.integerValue;
    
    NSInteger offet = -1;   //往前算
    if(!previous) { //往后算
        offet = 1;
    }
    
    month += offet;
    
    if(month < 1) {
        year -= 1;
        month += 12;
    } else if(month > 12) {
        year += 1;
        month -= 12;
    }
    
    date = [FMUtils getDateByYear:year month:month day:1 hour:0 minute:0 second:0];
    _currentTime = [FMUtils dateToTimeLong:date];
    
}

//按钮点击
- (void) onPreviousButtonClicked:(id) sender {
    [self changeTime:YES];
    [self updateInfo];
    [self notifyEvent:MONTH_FILTER_TYPE_UPDATE data:nil];
}

- (void) onCurrentButtonClicked:(id) sender {
    [self notifyEvent:MONTH_FILTER_TYPE_SELECT_TIME data:_currentTime];
}

- (void) onNextButtonClicked:(id) sender {
    [self changeTime:NO];
    [self updateInfo];
    [self notifyEvent:MONTH_FILTER_TYPE_UPDATE data:nil];
}

- (void) notifyEvent:(MonthFilterTimeEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

@end
