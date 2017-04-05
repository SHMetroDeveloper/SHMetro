//
//  PatrolTaskFinishedViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "PatrolTaskQueryViewController.h"
#import "PullTableView.h"
#import "PatrolTaskItemView.h"
#import "BaseBundle.h"
#import "PatrolTaskEntity.h"
#import "FMTheme.h"
#import "PatrolTaskHistoryDetailViewController.h"
#import "PatrolHistoryItemView.h"
#import "UIButton+Bootstrap.h"
#import "NetPage.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "FMFont.h"
#import "FMSize.h"
#import "CustomAlertView.h"
#import "SeperatorView.h"
#import "PatrolTaskHistoryEntity.h"
#import "FilterButton.h"
#import "OnClickListener.h"
#import "ImageItemView.h"
#import "TaskAlertView.h"
#import "BaseTimePicker.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "PatrolTaskQueryFilterViewController.h"
#import "MonthFilterTimeView.h"
#import "PatrolQueryListHelper.h"
#import "PatrolBusiness.h"

@interface PatrolTaskQueryViewController () <OnMessageHandleListener, OnItemClickListener, OnClickListener, PullTableViewDelegate>

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;
@property (readwrite, nonatomic, strong) NSMutableArray* patrolTaskArray;

@property (readwrite, nonatomic, strong) MonthFilterTimeView * timeFilterView;
@property (readwrite, nonatomic, assign) CGFloat timeControlHeight;

@property (readwrite, nonatomic, strong) SeperatorView * seperator;

@property (readwrite, nonatomic, strong) UIButton * filterBtn;
@property (readwrite, nonatomic, assign) CGFloat filterWidth;
@property (readwrite, nonatomic, assign) CGFloat filterHeight;


@property (readwrite, nonatomic, strong) NSString * patorlName;
@property (readwrite, nonatomic, strong) NSMutableArray * statusArray;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, assign) CGFloat realWidth;   //
@property (readwrite, nonatomic, assign) CGFloat realHeight;   //
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;   //分割高度

@property (readwrite, nonatomic, strong) NSNumber * startTime;
@property (readwrite, nonatomic, strong) NSNumber * endTime;

@property (readwrite, nonatomic, strong) NetPage * mPage;

@property (readwrite, nonatomic, assign) BOOL isFirst;
@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, strong) PatrolSearchCondition * filter;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> filterHandler;
@property (readwrite, nonatomic, strong) PatrolQueryListHelper * tableHelper;
@property (readwrite, nonatomic, strong) PatrolBusiness * business;

@end

@implementation PatrolTaskQueryViewController

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_patrol_query" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        _business = [[PatrolBusiness alloc] init];
        _tableHelper = [[PatrolQueryListHelper alloc] init];
        [_tableHelper setOnMessageHandleListener:self];
        
        _isFirst = YES;
        _itemHeight = 120;
        _seperatorHeight = 10;
        _timeControlHeight = [FMSize getInstance].topControlHeight+5;
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mPage = [[NetPage alloc] init];
        _filterWidth = [FMSize getInstance].filterWidth;
        _filterHeight = [FMSize getInstance].filterHeight;
        
        _filter = [[PatrolSearchCondition alloc] init];
        
        _patrolTaskArray = [[NSMutableArray alloc] init];
        
        CGRect mframe = [self getContentFrame];
        _realWidth = CGRectGetWidth(mframe);
        _realHeight = CGRectGetHeight(mframe);
        
        _mainContainerView = [[UIView alloc] initWithFrame:mframe];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeControlHeight)];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        [_timeFilterView setOnMessageHandleListener:self];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, _timeControlHeight, _realWidth, _realHeight-_timeControlHeight)];
        
        _pullTableView.dataSource = _tableHelper;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = _tableHelper;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];

        _filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-_filterWidth-[FMSize getSizeByPixel:50], _realHeight-_filterHeight-[FMSize getSizeByPixel:60], _filterWidth, _filterHeight)];
        [_filterBtn addTarget:self action:@selector(moveLeft) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_normal"] forState:UIControlStateNormal];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_highlight"] forState:UIControlStateHighlighted];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"patrol_no_task_current" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
        
        [_mainContainerView addSubview:_timeFilterView];
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_filterBtn];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
        
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    }
}

- (void) initAlertView {
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];

    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_MONTH];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController panGestureRecognized:sender];
}

- (void) initDate {
    [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initPatrolReportSuccessHandler];
    [self initDate];
    [self initAlertView];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [self requestData];
    }
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) initCondition {
    if(!_filter) {
        _filter = [[PatrolSearchCondition alloc] init];
    }
}

- (NSNumber *) getTimeStart {
    NSNumber * time = nil;
    if(_startTime) {
        time = _startTime;
    } else {
        time = [FMUtils dateToTimeLong:[FMUtils getFirstSecondOfMonth:[FMUtils timeLongToDate:[_timeFilterView getCurrentTime]]]];
    }
    return time;
}
- (NSNumber *) getTimeEnd {
    NSNumber * time = nil;
    if(_endTime) {
        time = _endTime;
    } else {
        time = [FMUtils dateToTimeLong:[FMUtils getLastSecondOfMonth:[FMUtils timeLongToDate:[_timeFilterView getCurrentTime]]]];
    }
    return time;
}


- (void) updateList {
    [self refreshTable];
    [self loadMoreDataToTable];
    [_tableHelper setDataWithArray:_patrolTaskArray];
    if([_patrolTaskArray count] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_pullTableView reloadData];
}

#pragma mark - Refresh and load more methods
- (void) refreshTable {
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(!_mPage) {
        _mPage = [[NetPage alloc] init];
    } else {
        [_mPage reset];
    }
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if([_mPage haveMorePage]) {
        [_mPage nextPage];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelectorOnMainThread:@selector(loadMoreDataToTable) withObject:nil waitUntilDone:NO];
    }
}


#pragma - 跳转
- (void) goToPatrolTaskDetail:(PatrolTaskHistoryItem *) task {
    PatrolTaskHistoryDetailViewController * taskDetailVC = [[PatrolTaskHistoryDetailViewController alloc] init];
    [taskDetailVC setPatrolTaskWithId:task.patrolTaskId andTaskName:task.patrolName];
    [self gotoViewController:taskDetailVC];
}

- (void) moveLeft {
    [self.frostedViewController presentMenuViewController];
}

- (void) notifyViewControllerDisplay:(BOOL) needDisplay {
    if(needDisplay) {
        [_filterBtn setHidden:NO];
    } else {
        [_filterBtn setHidden:YES];
    }
}

- (void) showTimeSelectDialog {
    NSNumber * time = [_timeFilterView getCurrentTime];
    [_datePicker setCenterDate:time];
    
    [_alertView showType:@"time"];
    [_alertView show];
}

- (void) work {
    [self showLoadingDialog];
    [self requestData];
}

- (void) requestData {
    PatrolSearchCondition * con = [self getQueryCondition];
    [_business requestPatrolHistoryByPage:_mPage condition:con success:^(NSInteger key, id object) {
        PatrolTaskQueryResponseData * data = object;
        [_mPage setPage:data.page];
        if(!_patrolTaskArray) {
            _patrolTaskArray = [[NSMutableArray alloc] init];
        } else if([_mPage isFirstPage]){
            [_patrolTaskArray removeAllObjects];
        }
        [_patrolTaskArray addObjectsFromArray:data.contents];
        [self hideLoadingDialog];
        [self updateList];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        if(_patrolTaskArray) {
            [_patrolTaskArray removeAllObjects];
        }
        [self updateList];
    }];
}

- (PatrolSearchCondition *) getQueryCondition {
    if (!_filter) {
        [self initCondition];
    }
    if(_startTime && _endTime) {
        _filter.startDateTime = [_startTime copy];
        _filter.endDateTime = [_endTime copy];
    } else {
        _filter.startDateTime = [_timeFilterView getCurrentTimeBegin];
        _filter.endDateTime = [_timeFilterView getCurrentTimeEnd];
    }
    
    if (![FMUtils isStringEmpty:_patorlName]) {
        _filter.patrolName = _patorlName;
    } else {
        _filter.patrolName = nil;
    }
    
    _filter.normal = nil;
    _filter.exception = nil;
    _filter.leak = nil;
    _filter.repair = nil;
    
    if (_statusArray) {
        for (NSNumber * statusNumber in _statusArray) {
            switch(statusNumber.integerValue) {
                case PATROL_HISTORY_STATUS_NORMAL:
                    _filter.normal = [NSNumber numberWithBool:YES];
                    break;
                case PATROL_HISTORY_STATUS_EXCEPTION:
                    _filter.exception = [NSNumber numberWithBool:YES];
                    break;
                case PATROL_HISTORY_STATUS_MISS:
                    _filter.leak = [NSNumber numberWithBool:YES];
                    break;
                case PATROL_HISTORY_STATUS_REPAIR:
                    _filter.repair = [NSNumber numberWithBool:YES];
                    break;
            }
        }
    }
    return _filter;
}

- (void) handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([PatrolTaskQueryFilterViewController class])]) {
            NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * eventType = [result valueForKeyPath:@"eventType"];
            if (eventType.integerValue == PATROL_FILTER_EVENT_TYPE_FILTERDATA) {
                if(_mPage) {
                    [_mPage reset];
                }
                _patorlName = [result valueForKeyPath:@"patrolName"];
                _startTime = [result valueForKeyPath:@"startTime"];
                _endTime = [result valueForKeyPath:@"endTime"];
                if (!_statusArray) {
                    _statusArray = [NSMutableArray new];
                }
                _statusArray = [result valueForKeyPath:@"patrolStatus"];
                [self work];
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_timeFilterView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSInteger type = tmpNumber.integerValue;
            switch (type) {
                case MONTH_FILTER_TYPE_SELECT_TIME:
                    _startTime = nil;
                    _endTime = nil;
                    [self performSelectorOnMainThread:@selector(showTimeSelectDialog) withObject:nil waitUntilDone:NO];
                    break;
                case MONTH_FILTER_TYPE_UPDATE:
                    _startTime = nil;
                    _endTime = nil;
                    [_mPage reset];
                    [self requestData];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_tableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            PatrolQueryListEventType type = [tmpNumber integerValue];
            PatrolTaskHistoryItem * task;
            switch(type) {
                case PATROL_QUERY_LIST_SHOW_DETAIL:
                    task = [result valueForKeyPath:@"eventData"];
                    [self goToPatrolTaskDetail:task];
                    break;
            }
        }
    }
}

#pragma mark - 时间选择
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    [_timeFilterView setCurrentTime:time];
                    [self work];
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

#pragma mark --- 消息
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMPatrolReportSuccess" object:nil];
}

- (void) initPatrolReportSuccessHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMPatrolReportSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMPatrolReportSuccess"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}
@end

