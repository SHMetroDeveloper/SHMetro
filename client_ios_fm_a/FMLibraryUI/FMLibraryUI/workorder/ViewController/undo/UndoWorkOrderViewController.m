//
//  WorkOrderFragmentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "UndoWorkOrderViewController.h"
#import "WorkJobItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"
 
#import "WorkOrderDetailViewController.h"
#import "WorkOrderUndoEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "WorkOrderNetRequest.h"
#import "SeperatorView.h"
#import "AcceptWorkOrderEntity.h"
#import "SeperatorTableViewCell.h"
#import "WorkOrderBusiness.h"
#import "OrderUndoTableHelper.h"
#import "ImageItemView.h"
#import "UserBusiness.h"
#import "AttendanceRecordEntity.h"
#import "BaseDataDbHelper.h"

@interface UndoWorkOrderViewController () <OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView *pullTableView;

@property (readwrite, nonatomic, strong) OrderUndoTableHelper* ordersHelper;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (nonatomic, strong) AttendanceRecordEntity * attendanceRecord; // 最后一次签到记录

@end


@implementation UndoWorkOrderViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_undo" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    _noticeHeight = [FMSize getInstance].noticeHeight;

    _business = [WorkOrderBusiness getInstance];
    
    _ordersHelper = [[OrderUndoTableHelper alloc] initWithContext:self];
    [_ordersHelper setOnMessageHandleListener:self];
    
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _pullTableView.dataSource = _ordersHelper;
    _pullTableView.pullDelegate = self;
    _pullTableView.delegate = _ordersHelper;
    
    _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
    _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
    [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_undo_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];

    [_noticeLbl setHidden:YES];
    [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
    [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    
    
    [_mainContainerView addSubview:_pullTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initOrderStatusChangeHandler];
    [self work];
    [self requestLastRecord]; // 请求最后一次签到记录
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        [self work];
    }
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) work {
//    _needUpdate = NO;
    [self showLoadingDialog];
    if(!_pullTableView.pullTableIsRefreshing) {
        _pullTableView.pullTableIsRefreshing = YES;
    }
    [self requestData];
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

- (void) requestData {
    NetPage * mpage = [_ordersHelper getPage];
    if (_needUpdate) {
        _needUpdate = NO;
        [mpage reset];
    }
    [_business getOrdersUndoPage:mpage Success:^(NSInteger key, id object) {
        UndoWorkOrderResponseData * response = object;
        NetPage * page = [response page];
        if(!page || [page isFirstPage]) {
            [_ordersHelper removeAllOrders];
        }
        [_ordersHelper setPage:page];
        [_ordersHelper addOrdersWithArray:response.contents];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [_ordersHelper removeAllOrders];
        [self updateList];
        [self hideLoadingDialog];
    }];
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
    [_ordersHelper removeAllOrders];
    [self updateList];
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    NetPage * page = [_ordersHelper getPage];
    if([page haveMorePage]) {
        [page nextPage];
        [_ordersHelper setPage:page];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.0f];
    }
}

- (void) showOrderDetail:(WorkOrderUndo *) order {
    WorkOrderDetailViewController * taskDetailVC = [[WorkOrderDetailViewController alloc] init];
    [taskDetailVC setWorkOrderWithId:order.woId];
    [self gotoViewController:taskDetailVC];
}

#pragma mark - 点击
- (void) handleMessage:(id)msg {
    NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
    if([strOrigin isEqualToString:NSStringFromClass([_ordersHelper class])]) {
        id result = [msg valueForKeyPath:@"result"];
        OrderUndoEventType type = [[result valueForKeyPath:@"eventType"] integerValue];
        if(type == WO_UNDO_EVENT_ITEM_CLICK) {
            
            WorkOrderUndo * order = [result valueForKeyPath:@"eventData"];
            UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
            
            /* 判断是否进行过签到 */
            if (user && [user.type isEqualToNumber:@(USER_TYPE_OUTSOURCE)] && ![self canHandleOrder:order]) {
                
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_need_check" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
            else {
                
                [self showOrderDetail:order];
            }
        }
    }
}


/**
 请求最后一次签到记录
 */
- (void)requestLastRecord {
    
    [[UserBusiness getInstance] getLastAttendanceRecordSuccess:^(NSInteger key, id object) {
        
        _attendanceRecord = object;
        
    } fail:^(NSInteger key, NSError *error) {
        
        DLog(@"请求最后一次签到记录失败");
    }];
}


/**
 判断是否签到

 @param order 工单
 @return 是否签到
 */
- (BOOL)canHandleOrder:(WorkOrderUndo *)order {
    
    BOOL res = NO;
    if(_attendanceRecord) {
        
        if(order) {
            
            Position * pos = [[Position alloc] init];
            pos.buildingId = order.buildingId;
            pos.floorId = order.floorId;
            pos.roomId = order.roomId;
            
            /* 如果工单属于签到站点 */
            if([pos isBelongTo:_attendanceRecord.location]) {
                
                res = YES;
            }
        }
    }
    return res;
}


- (void) initOrderStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMOrderStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMOrderStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMOrderStatusUpdate" object:nil];
}

@end
