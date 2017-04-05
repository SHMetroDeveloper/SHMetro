//
//  MyReservationViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MyReservationViewController.h"

#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "NetPage.h"
#import "SeperatorView.h"
#import "ReservationEntity.h"
#import "OnItemClickListener.h"
#import "SystemConfig.h"
#import "InventoryNetRequest.h"
#import "ReservationDetailViewController.h"
#import "InventoryBusiness.h"
#import "ReservationListTableHelper.h"
#import "OnMessageHandleListener.h"
#import "MonthFilterTimeView.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "BaseBundle.h"



@interface MyReservationViewController () <PullTableViewDelegate, OnMessageHandleListener, OnItemClickListener, OnClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * infoTableView;

@property (readwrite, nonatomic, strong) MonthFilterTimeView * timeFilterView;
@property (readwrite, nonatomic, assign) CGFloat timeControlHeight;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * infoArray;

@property (readwrite, nonatomic, strong) InventoryBusiness * business;
@property (readwrite, nonatomic, strong) ReservationListTableHelper * helper;

@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) BOOL editable;

@end

@implementation MyReservationViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_reserved" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _editable = NO;
        
        _business = [InventoryBusiness getInstance];
        _helper = [[ReservationListTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _noticeHeight = [FMSize getInstance].noticeHeight;
//        _timeControlHeight = [FMSize getInstance].topControlHeight;
        _timeControlHeight = 0;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeControlHeight)];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        [_timeFilterView setOnMessageHandleListener:self];
        
        _infoTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, _timeControlHeight, _realWidth, _realHeight-_timeControlHeight)];
        _infoTableView.dataSource = _helper;
        _infoTableView.delegate = _helper;
        _infoTableView.pullDelegate = self;
        
        _infoTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _infoTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _infoTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _infoTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data_reserved" inTable:nil]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        
        _datePicker = [[BaseTimePicker alloc] init];
        [_datePicker setOnItemClickListener:self];
        
        _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_datePicker setPickerType:BASE_TIME_PICKER_MONTH];
        
//        [_mainContainerView addSubview:_timeFilterView];
        [_mainContainerView addSubview:_infoTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initAlertView {
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


- (void) showTimeSelectDialog {
    NSDate * curDate = nil;
    NSNumber * time = [_timeFilterView getCurrentTime];
    if(![FMUtils isNumberNullOrZero:time]) {
        curDate = [FMUtils timeLongToDate:time];
    } else
    {
        curDate = [NSDate date];
    }
    
    NSNumber *tmp = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:tmp];
    
    [_alertView showType:@"time"];
    [_alertView show];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStatusChangeHandler];
    [self initAlertView];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        [self work];
    }
}

- (void)viewDidUnload {
    [self setInfoTableView:nil];
    [super viewDidUnload];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
}

- (void) initStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMReservationStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) work {
    _needUpdate = NO;
    [self showLoadingDialog];
    if(!_infoTableView.pullTableIsRefreshing) {
        _infoTableView.pullTableIsRefreshing = YES;
    }
    [self requestData];
}


- (void) updateList {
    [self refreshTable];
    [self loadMoreDataToTable];
    
    if([_helper getDataCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_infoTableView reloadData];
}

- (void) requestData {
    NSNumber *userId = [SystemConfig getEmployeeId];
//    NSNumber *timeStart = [_timeFilterView getCurrentTimeBegin];
//    NSNumber *timeEnd = [_timeFilterView getCurrentTimeEnd];
    NSNumber *timeStart = nil;
    NSNumber *timeEnd = nil;
    ReservationQueryType queryType = RESERVATION_QUERY_TYPE_MY_REQUEST;
    GetReservationListParam * param = [[GetReservationListParam alloc] initWithUserId:userId
                                                                            queryType:queryType
                                                                                 page:[_helper getPage]
                                                                            timeStart:timeStart
                                                                              timeEnd:timeEnd];
    
    [_business getReservationList:param success:^(NSInteger key, id object) {
        GetReservationListResponseData * data = object;
        NetPage * page = [data page];
        if(!page || [page isFirstPage]) {
            [_helper removeAllData];
        }
        [_helper setPage:page];
        _infoArray = data.contents;
        [_helper addDataWithArray:_infoArray];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        _infoArray = nil;
        [_helper removeAllData];
        [self updateList];
        [self hideLoadingDialog];
    }];
}


#pragma mark - Refresh and load more methods
- (void) refreshTable {
    _infoTableView.pullLastRefreshDate = [NSDate date];
    _infoTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    _infoTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [_helper removeAllData];
    [self updateList];
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    NetPage * page = [_helper getPage];
    if([page haveMorePage]) {
        [page nextPage];
        [_helper setPage:page];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.0f];
    }
}



#pragma mark --- 消息处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryReservationListEventType type = tmpNumber.integerValue;
            NSInteger position;
            switch(type) {
                case INVENTORY_RESERVATION_LIST_EVENT_SHOW_DETAIL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    position = tmpNumber.integerValue;
                    [self gotoInventoryDetail:position];
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([MonthFilterTimeView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSInteger type = tmpNumber.integerValue;
            if(type == MONTH_FILTER_TYPE_SELECT_TIME) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showTimeSelectDialog];
                });
            } else if(type == MONTH_FILTER_TYPE_UPDATE) {
                [_helper removeAllData];
                [self updateList];
                [self work];
            }
        }
    }
}



#pragma mark --- 点击事件
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    [_timeFilterView setCurrentTime:time];
                    [_helper removeAllData];
                    [self updateList];
                    [self work];
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}

- (void) gotoInventoryDetail:(NSInteger) position{
    ReservationEntity *reservation = [_helper getDataByPosition:position];
    if(reservation) {
        ReservationDetailViewController *detailVC = [[ReservationDetailViewController alloc] init];
        [detailVC setInfoWithReservationId:reservation.activityId];
        [detailVC setCanCancelReservation:YES];
        [detailVC setReadonly:YES];
        [self gotoViewController:detailVC];
    }
}

@end

