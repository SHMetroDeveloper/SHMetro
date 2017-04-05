//
//  AttendanceRecordViewController.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "BaseBundle.h"
#import "MJRefresh.h"
#import "FMColor.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "MonthFilterTimeView.h"
#import "ImageItemView.h"
#import "UserBusiness.h"
#import "AttendanceRecordEntity.h"
#import "MJExtension.h"
#import "AttendanceRecordTableHelper.h"

@interface AttendanceRecordViewController ()<OnMessageHandleListener, OnClickListener, OnItemClickListener>

//顶部视图
@property (nonatomic, strong) MonthFilterTimeView * timeFilterView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AttendanceRecordTableHelper *tableHelper; //表格数据来源
@property (nonatomic, strong) NetPage *page; //分页

//没有数据时的图片显示
@property (nonatomic, strong) ImageItemView *noticeImage;

@property (nonatomic, strong) BaseTimePicker *datePicker; //日期选取器
@property (nonatomic, strong) TaskAlertView *alertView; //弹出框

//内容尺寸
@property (nonatomic, assign) CGRect contentFrame;

@end

@implementation AttendanceRecordViewController


- (void) initNavigation {
    
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"user_my_attendance_record" inTable:nil]];
    [self setBackAble:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //下拉刷新
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 初始化视图

- (void)initLayout {
    
    _contentFrame = [self getContentFrame];
    CGFloat headerHeight = [FMSize getInstance].topControlHeight;
    
    //顶部视图
    _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_contentFrame), CGRectGetWidth(_contentFrame), headerHeight)];
    [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
    [_timeFilterView setOnMessageHandleListener:self];
    [self.view addSubview:_timeFilterView];
    
    //表格视图
    CGFloat tableViewPadding = [FMSize getInstance].defaultPadding;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_contentFrame) + headerHeight, CGRectGetWidth(_contentFrame), CGRectGetHeight(_contentFrame) - headerHeight)];
    _tableHelper = [[AttendanceRecordTableHelper alloc] init];
    _tableView.delegate = _tableHelper;
    _tableView.dataSource = _tableHelper;
    _tableView.separatorInset = UIEdgeInsetsMake(0, tableViewPadding, 0, tableViewPadding);
    _tableView.backgroundColor = [FMColor getInstance].mainBackground;
    _tableView.showsVerticalScrollIndicator = NO;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentFrame), [FMSize getInstance].seperatorHeight)];
    lineView.backgroundColor = [FMColor getInstance].seperatorDialog;
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:_tableView];
    
    //表格的下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableHeaderRefreshing)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    //表格的上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tableFooterRefreshing)];
}


/**
 初始化无数据图片显示

 @return 懒加载 只有在使用的时候才会创建对象
 */
- (ImageItemView *)noticeImage {
    
    if (_noticeImage == nil) {
        
        //没有数据
        CGFloat noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeImage = [[ImageItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(_contentFrame) - noticeHeight / 2, CGRectGetWidth(_contentFrame), noticeHeight)];
        [_noticeImage setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"my_attendance_record_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeImage setHidden:YES];
        [_noticeImage setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeImage setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        [self.view addSubview:_noticeImage];
    }
    return _noticeImage;
}


/**
 初始化日期选择框

 @return 懒加载 只有在使用的时候才会创建对象
 */
- (BaseTimePicker *)datePicker {
    
    if (_datePicker == nil) {
        
        //日期选取器
        _datePicker = [[BaseTimePicker alloc] init];
        _datePicker.backgroundColor = [FMColor getInstance].mainWhite;
        [_datePicker setPickerType:BASE_TIME_PICKER_MONTH];
        [_datePicker setOnItemClickListener:self];
        
        //弹出框
        _alertView = [[TaskAlertView alloc] init];
        [_alertView setFrame:CGRectMake(0, 0, CGRectGetWidth(_contentFrame), [FMSize getInstance].screenHeight)];
        [_alertView setHidden:YES];
        [_alertView setOnClickListener:self];
        [_alertView setContentView:_datePicker withKey:@"time" andHeight:250 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
        [self.view addSubview:_alertView];
    }
    return _datePicker;
}


#pragma mark - 表格的下拉刷新和上拉加载

/**
 表格下拉刷新
 */
- (void)tableHeaderRefreshing {
    
    if (_page == nil) {
        
        _page = [[NetPage alloc] init];
    }
    [_page reset];
    
    [_tableHelper.attendanceRecordList removeAllObjects];
    
    //获取签到记录数据
    [self reloadAttendanceRecord];
}


/**
 表格上拉加载
 */
- (void)tableFooterRefreshing {
    
    if ([_page haveMorePage]) {
        
        [_page nextPage];
        
        //获取签到记录数据
        [self reloadAttendanceRecord];
    }
    else {
        
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


#pragma mark - 表格数据获取

/**
 获取签到数据
 */
- (void)reloadAttendanceRecord {
    
    [[UserBusiness getInstance] getAttendanceRecordByTimeStart:[_timeFilterView getCurrentTimeBegin] timeEnd:[_timeFilterView getCurrentTimeEnd] page:_page Success:^(NSInteger key, id object) {
        
        AttendanceRecordResponseData *data = object;
        _page = data.page;
        [_tableHelper.attendanceRecordList addObjectsFromArray:data.contents];
        [_tableView reloadData];
        
        [self.noticeImage setHidden:_tableHelper.attendanceRecordList.count];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    } fail:^(NSInteger key, NSError *error) {
        
        [self.noticeImage setHidden:_tableHelper.attendanceRecordList.count];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 监听日期的选择状态

/**
 监听顶部按钮的点击
 */
- (void)handleMessage:(id)msg {
    
    if(msg) {
        
        NSDictionary * result = [msg valueForKeyPath:@"result"];
        NSInteger type = [[result valueForKeyPath:@"eventType"] integerValue];
        
        //选择日期
        if (type == MONTH_FILTER_TYPE_SELECT_TIME) {
            
            //弹出日期选择框
            NSNumber *selectedTime = [_timeFilterView getCurrentTime];
            NSNumber *currentTime = [FMUtils dateToTimeLong:[NSDate date]];
            NSNumber *time = [FMUtils isNumberNullOrZero:selectedTime]? currentTime : selectedTime;
            [self.datePicker setCenterDate:time];
            [_alertView showType:@"time"];
            [_alertView show];
        }
        //上一月和下一月
        else if (type == MONTH_FILTER_TYPE_UPDATE) {
            
            [_tableView.mj_header beginRefreshing];
        }
    }
}


/**
 监听日期选择
 */
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    
    if(view == _datePicker) {
        
        if(subView) {
            
            BaseTimePickerActionType type = subView.tag;
            if (type == BASE_TIME_PICKER_ACTION_OK) {
                
                NSNumber *time = [_datePicker getSelectTime];
                [_timeFilterView setCurrentTime:time];
            }
        }
        [_alertView close];
        [_tableView.mj_header beginRefreshing];
    }
}


/**
 监听界面点击，隐藏弹出框
 */
- (void)onClick:(UIView *)view {
    
    if(view == _alertView) {
        
        [_alertView close];
    }
}

@end
