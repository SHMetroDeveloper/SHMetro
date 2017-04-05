//
//  PatrolTaskHistoryViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskHistoryViewController.h"
#import "PatrolTaskQueryViewController.h"
#import "PatrolTaskQueryFilterViewController.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "OnMessageHandleListener.h"


@interface PatrolTaskHistoryViewController () <OnItemClickListener, OnClickListener, REFrostedViewControllerDelegate>
@property (readwrite, nonatomic, strong) PatrolTaskQueryViewController * center;
@property (readwrite, nonatomic, strong) PatrolTaskQueryFilterViewController * right;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end


@implementation PatrolTaskHistoryViewController

- (instancetype) init {
    
    self = [super init];
    if(self) {
        _center = [[PatrolTaskQueryViewController alloc] init];
        _right = [[PatrolTaskQueryFilterViewController alloc] init];
        
        //设置center接收筛选菜单的消息
        [_right setOnMessageHandleListener:_center];
        
        //在容器controller设置日期选择,让right菜单接收消息，用于显示选择的日期
        [self setOnMessageHandleListener:_right];
        
        [self setContentViewController:_center];
        [self setMenuViewController:_right];
        self.direction = REFrostedViewControllerDirectionRight;
        self.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        self.liveBlur = NO;
        self.delegate = self;

    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"patrol_query" inTable:nil]];
    [self setBackAble:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initPatrolHandler];
    [self initAlertView];
}

- (void) initAlertView {
    //initAlertView
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    [_datePicker setPickerType:BASE_TIME_PICKER_DAY];
    _datePicker.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = [self getContentFrame];
    CGFloat realWidth = CGRectGetWidth(frame);
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

#pragma mark - 点击事件
- (void)onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            NSDictionary * dic;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    dic = [FMUtils timeLongToDictionary:time];
                    [self handResult:time];
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler{
    _handler = handler;
}

- (void) handResult:(id) data {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

#pragma mark - 消息处理
- (void) showTimeSelectDialog:(NSNotification *) notification {
    NSNumber * time = [notification object];
    [self.view insertSubview:_alertView atIndex:[self.view.subviews count]];
    if(!time) {
        time = [FMUtils getTimeLongNow];
    }
    NSNumber * minTime = [FMUtils dateToTimeLong:[FMUtils getFirstSecondOfMonth:[FMUtils timeLongToDate:time]]];
    NSNumber * maxTime = [FMUtils dateToTimeLong:[FMUtils getLastSecondOfMonth:[FMUtils timeLongToDate:time]]];
    
    [_datePicker setMinDate:minTime];
    [_datePicker setMaxDate:maxTime];
    
    [_datePicker setCenterDate:time];
    
    
    [_alertView showType:@"time"];
    [_alertView show];
}

- (void) showAutoDismiss {
    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_time_start_behind_end" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
}

- (void) initPatrolHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PatrolDatePicker" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PatrolAutoDismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showTimeSelectDialog:)
                                                 name: @"PatrolDatePicker"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(showAutoDismiss)
                                                 name: @"PatrolAutoDismiss"
                                               object: nil];
}


- (void) frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController {
    
    NSNumber * timeStart = [_center getTimeStart];
    NSNumber * timeEnd = [_center getTimeEnd];
    [_right setTimeStart:timeStart timeEnd:timeEnd];
}

@end


