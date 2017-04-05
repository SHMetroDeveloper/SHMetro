//
//  TestViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PlannedMaintenanceViewController.h"
#import "JTCalendar.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "PlannedMaintenanceBusiness.h"
#import "PlannedMaintenanceHelper.h"
#import "MaintenanceEventHelper.h"
#import "MaintenanceDetailViewController.h"
#import "ImageItemView.h"


@interface PlannedMaintenanceViewController () <JTCalendarDelegate, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;


@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) UIColor * colorToday;
@property (readwrite, nonatomic, strong) UIColor * colorSelected;


@property (readwrite, nonatomic, strong) PlannedMaintenanceBusiness * business;
@property (readwrite, nonatomic, strong) PlannedMaintenanceHelper * helper;

@end


@implementation PlannedMaintenanceViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    
    NSString * title = @"";
    NSDate * date = [_helper getDateSelected];
    if(date) {
        title = [FMUtils getTimeDescriptionByDate:date format:@"yyyy.MM.dd"];
    } else {
        title = [FMUtils getTimeDescriptionByDate:[NSDate date] format:@"yyyy.MM"];;
    }
    [self setTitleWith:title];
    [self setNavigationColor:[[UIColor colorWithRed:0x64/255.0 green:0x5e/255.0 blue:0x60/255.0 alpha:1] colorWithAlphaComponent:1]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBusiness];
    [self requestMaintenanceCalendar];
}

- (void) initBusiness {
    _business = [PlannedMaintenanceBusiness getInstance];
//    _eventHelper = [[MaintenanceEventHelper alloc] init];
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    
    if(!_mainContainerView) {
        
        _helper = [[PlannedMaintenanceHelper alloc] initWithContext:self];
        [_helper setOnMessageHandleListener:self];
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.delegate = _helper;
        _tableView.dataSource = _helper;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_mainContainerView addSubview:_tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}


- (void) updateMonthTitleWith:(NSDate *) date {
    NSString * title = [FMUtils getTimeDescriptionByDate:date format:@"yyyy.MM"];
    [self setTitleWith:title];
    [self updateNavigationBar];
}

- (void) updateDayTitleWith:(NSDate *) date {
    NSString * title = [FMUtils getTimeDescriptionByDate:date format:@"yyyy.MM.dd"];
    [self setTitleWith:title];
    [self updateNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updateList {
    [_tableView reloadData];
}


#pragma mark --- 请求维护日历
//获取开始时间
- (NSNumber *) getTimeStart {
    NSNumber * timeStart = [_helper getTimeStart];
    return timeStart;
}
//获取结束时间
- (NSNumber *) getTimeEnd {
    NSNumber * timeEnd = [_helper getTimeEnd];
    return timeEnd;
}

- (void) requestMaintenanceCalendar {
    [self showLoadingDialog];
    [_business getMaintenanceCalendarStart:[self getTimeStart] end:[self getTimeEnd] Success:^(NSInteger key, id object) {
        NSLog(@"数据请求成功。");
        [self hideLoadingDialog];
        NSMutableArray * array = object;
        [_helper setDataWithArray:array];
        [self updateList];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"数据请求失败。");
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"maintenance_notice_request_calendar_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

#pragma mark --- 事件处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * res = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [res valueForKeyPath:@"eventType"];
            MaintenanceEntity * obj;
            MaintenanceCalendarEventType eventType = tmpNumber.integerValue;
            NSDate * date;
            switch(eventType) {
                case PM_CALENDAR_EVENT_SHOW_DETAIL:
                    obj = [res valueForKeyPath:@"eventData"];
                    [self gotoMaintenanceDetail:obj];
                    break;
                case PM_CALENDAR_EVENT_TIME_CHANGE:
                    date = [res valueForKeyPath:@"eventData"];
                    [self updateMonthTitleWith:date];
                    [self updateList];
                    [self requestMaintenanceCalendar];
                    break;
                case PM_CALENDAR_EVENT_SELECT_DATE:
                    date = [res valueForKeyPath:@"eventData"];
                    [self updateDayTitleWith:date];
                    [self updateList];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark --- 页面跳转
- (void) gotoMaintenanceDetail:(MaintenanceEntity *) maintenance {
    MaintenanceDetailViewController * detailVC = [[MaintenanceDetailViewController alloc] init];
    [detailVC setInfoWithPmId:maintenance.pmId todoId:maintenance.pmtodoId];
    [self gotoViewController:detailVC];
}

@end
