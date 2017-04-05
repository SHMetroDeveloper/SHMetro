//
//  WorkOrderHistoryQueryViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderHistoryQueryViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
 
#import "UIButton+Bootstrap.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderHistoryEntity.h"
#import "WorkJobHistoryItemView.h"
#import "CustomAlertView.h"
#import "WorkOrderDetailViewController.h"
#import "SystemConfig.h"
#import "SeperatorView.h"
#import "FilterButton.h"
#import "WorkOrderServerConfig.h"
#import "SeperatorTableViewCell.h"
#import "WorkOrderBusiness.h"
#import "OrderHistoryTableHelper.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailViewController.h"

#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "WorkOrderHistoryFilterViewController.h"
#import "ImageItemView.h"
#import "TaskAlertView.h"
#import "BaseTimePicker.h"
#import "MonthFilterTimeView.h"

@interface WorkOrderHistoryQueryViewController () <OnMessageHandleListener, OnItemClickListener, OnClickListener>
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;
@property (readwrite, nonatomic, strong) NSMutableArray* jobsArray;

@property (readwrite, nonatomic, assign) CGFloat timeControlHeight;

@property (readwrite, nonatomic, strong) MonthFilterTimeView * timeFilterView;

@property (readwrite, nonatomic, strong) SeperatorView * seperator;

//@property (readwrite, nonatomic, strong) FilterButton * filterBtn;
@property (readwrite, nonatomic, strong) UIButton * filterBtn;
@property (readwrite, nonatomic, assign) CGFloat filterWidth;
@property (readwrite, nonatomic, assign) CGFloat filterHeight;

@property (readwrite, nonatomic, assign) NSInteger year;
@property (readwrite, nonatomic, assign) NSInteger month;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, assign) CGFloat realWidth;   //
@property (readwrite, nonatomic, assign) CGFloat realHeight;   //
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;   //分割高度

@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, strong) WorkOrderHistorySearchCondition * condition;//查询条件
@property (readwrite, nonatomic, assign) BOOL isFirst;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) OrderHistoryTableHelper * ordersHelper;
@end

@implementation WorkOrderHistoryQueryViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect mframe = [self getContentFrame];
    _realWidth = CGRectGetWidth(mframe);
    _realHeight = CGRectGetHeight(mframe);
    [self updateLayout];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_query" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        _isFirst = YES;
        _itemHeight = 120;
        _seperatorHeight = 10;
        _timeControlHeight = [FMSize getInstance].topControlHeight;
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mPage = [[NetPage alloc] init];
        _filterWidth = [FMSize getInstance].filterWidth;
        _filterHeight = [FMSize getInstance].filterHeight;
        _jobsArray = [[NSMutableArray alloc] init];
        
        _business = [WorkOrderBusiness getInstance];
        _ordersHelper = [[OrderHistoryTableHelper alloc] initWithContext:self];
        [_ordersHelper setOnMessageHandleListener:self];
        
        CGRect mframe = [self getContentFrame];
        _realWidth = CGRectGetWidth(mframe);
        _realHeight = CGRectGetHeight(mframe);
        
        _mainContainerView = [[UIView alloc] init];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView = [[PullTableView alloc] init];
        
        _pullTableView.dataSource = _ordersHelper;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = _ordersHelper;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];

        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];

        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeControlHeight)];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        [_timeFilterView setOnMessageHandleListener:self];
        
        
        //        _filterBtn = [[FilterButton alloc] init];
        _filterBtn = [[UIButton alloc] init];
        [_filterBtn addTarget:self action:@selector(moveLeft) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_normal"] forState:UIControlStateNormal];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_highlight"] forState:UIControlStateHighlighted];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_history_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
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
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}

- (void) updateLayout {
    CGFloat originY = 0;
    CGRect frame = [self getContentFrame];
    [_mainContainerView setFrame:frame];
    
    [_pullTableView setFrame:CGRectMake(0, _timeControlHeight, _realWidth, _realHeight - _timeControlHeight)];
    
    [_timeFilterView setFrame:CGRectMake(0, originY, _realWidth, _timeControlHeight)];
    
    [_filterBtn setFrame:CGRectMake(_realWidth-_filterWidth-[FMSize getInstance].defaultPadding, _realHeight-_filterHeight-[FMSize getInstance].defaultPadding, _filterWidth, _filterHeight)];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
    [self initAlertView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_isFirst) {
        _isFirst = NO;
        if(!self.pullTableView.pullTableIsRefreshing) {
            self.pullTableView.pullTableIsRefreshing = YES;
        }
        [self requestData];
    }
    
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) initCondition {
    if(!_condition) {
        _condition = [[WorkOrderHistorySearchCondition alloc] init];
    }
}

- (void) updateList {
    [self refreshTable];
    [self loadMoreDataToTable];
    
    if([_ordersHelper getOrderCount] == 0) {
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
- (void) gotoOrderHistoryDetail:(NSNumber *) orderId {
    WorkOrderDetailViewController * detailVC = [[WorkOrderDetailViewController alloc] init];
    [detailVC setWorkOrderWithId:orderId];
    [detailVC setReadOnly:YES];  //TODO: 此处先注释掉了
    [self gotoViewController:detailVC];
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

#pragma - 月份切换

- (void) timeChanged {
    NSLog(@"时间设置完成");
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

- (void) work {
    [self showLoadingDialog];
    [self requestData];
}


- (void) requestData {
    WorkOrderHistorySearchCondition * con = [self getQueryCondition];
    [_business getOrdersHistoryPage:_mPage condition:con Success:^(NSInteger key, id object) {
        WorkOrderHistoryResponseData * response = object;
        NetPage * page = [response page];
        if(!page || [page isFirstPage]) {
            [_ordersHelper removeAllOrders];
        }
        [_ordersHelper setPage:page];
        _mPage = page;
        [_ordersHelper addOrdersWithArray:response.contents];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [_ordersHelper removeAllOrders];
        [self updateList];
    }];
}

/**
 * 获取查询条件
 */
- (WorkOrderHistorySearchCondition *) getQueryCondition {
    if(!_condition) {
        [self initCondition];
    }
    _condition.startDateTime = [_timeFilterView getCurrentTimeBegin];
    _condition.endDateTime = [_timeFilterView getCurrentTimeEnd];
    return _condition;
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([_ordersHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber;
            tmpNumber = [result valueForKeyPath:@"eventType"];
            OrderHistoryEventType type = [tmpNumber integerValue];
            WorkOrderHistory * order;
            switch (type) {
                case WO_HISTORY_EVENT_ITEM_CLICK:
                    order = [result valueForKeyPath:@"eventData"];
                    if(order) {
                        [self gotoOrderHistoryDetail:order.woId];
                    }
                    break;
                    
                default:
                    break;
            }
            
        } else if([msgOrigin isEqualToString:NSStringFromClass([_timeFilterView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSInteger type = tmpNumber.integerValue;
            switch (type) {
                case MONTH_FILTER_TYPE_SELECT_TIME:
                    [self performSelectorOnMainThread:@selector(showTimeSelectDialog) withObject:nil waitUntilDone:NO];
                    break;
                case MONTH_FILTER_TYPE_UPDATE:
                    [_ordersHelper removeAllOrders];
                    [self updateList];
                    [self work];
                    break;
                default:
                    break;
            }
        }
        else {
            id filter = [msg valueForKeyPath:@"result"];
            _condition = (WorkOrderHistorySearchCondition *) filter;
            [_mPage reset];
            [self work];
        }
    }
}

#pragma mark - 时间选择
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            NSDictionary * dic;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    dic = [FMUtils timeLongToDictionary:time];
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

@end



