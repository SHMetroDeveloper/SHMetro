//
//  ApprovalOrderViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ApprovalOrderViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "UIButton+Bootstrap.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "WorkOrderNetRequest.h"
#import "SeperatorView.h"
#import "WorkOrderApprovalEntity.h"
#import "WorkOrderDetailViewController.h"
#import "BaseDataDbHelper.h"
#import "TaskAlertView.h"
#import "ApprovalTaskAlertContentView.h"
#import "ApprovalWorkOrderEntity.h"
#import "SeperatorTableViewCell.h"

#import "ImageItemView.h"
#import "WorkOrderBusiness.h"
#import "OrderApprovalTableHelper.h"
#import "BaseBundle.h"

@interface ApprovalOrderViewController ()

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;

@property (readwrite, nonatomic, strong) OrderApprovalTableHelper * ordersHelper;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@end

@implementation ApprovalOrderViewController

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_approval" inTable:nil]];
    [self setBackAble:YES];
}


- (void)initLayout {
    CGRect frame = [self getContentFrame];
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    _noticeHeight = [FMSize getInstance].noticeHeight;
    _business = [WorkOrderBusiness getInstance];
    
    _ordersHelper = [[OrderApprovalTableHelper alloc] initWithContext:self];
    [_ordersHelper setOnMessageHandleListener:self];
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _pullTableView.dataSource = _ordersHelper;
    _pullTableView.delegate = _ordersHelper;
    _pullTableView.pullDelegate = self;
    
    _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
    _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
    [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_approval_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
    [_noticeLbl setHidden:YES];
    [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
    [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];

    [_noticeLbl setHidden:YES];
    
    [_mainContainerView addSubview:_pullTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initOrderStatusChangeHandler];
    [self work];
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

- (void) work {
//    _needUpdate = NO;
    [self showLoadingDialog];
    if(!_pullTableView.pullTableIsRefreshing) {
        _pullTableView.pullTableIsRefreshing = YES;
    }
    [self requestData];
}

- (void) requestData {
    NetPage * mpage = [_ordersHelper getPage];
    if (_needUpdate) {
        _needUpdate = NO;
        [mpage reset];
    }
    [_business getOrdersApprovalPage:mpage Success:^(NSInteger key, id object) {
        ApprovalWorkOrderResponseData * response = object;
        NetPage * page = [response page];
        if (!page || [page isFirstPage]) {
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
    _pullTableView.pullLastRefreshDate = [NSDate date];
    _pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    _pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [_ordersHelper removeAllOrders];
    [self updateList];
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    NetPage * page = [_ordersHelper getPage];
    if ([page haveMorePage]) {
        [page nextPage];
        [_ordersHelper setPage:page];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
    }
}

- (void) showOrderDetail:(WorkOrderApproval *) order {
    WorkOrderDetailViewController * taskDetailVC = [[WorkOrderDetailViewController alloc] init];
    [taskDetailVC setWorkOrderWithId:order.woId approvalId:order.approvalId];
    [self gotoViewController:taskDetailVC];
}

#pragma mark - 点击
- (void)handleMessage:(id)msg {
    NSString * strOrigin = [msg valueForKey:@"msgOrigin"];
    if ([strOrigin isEqualToString:NSStringFromClass([_ordersHelper class])]) {
        id result = [msg valueForKey:@"result"];
        OrderApplyApprovalType type = [[result valueForKeyPath:@"eventType"] integerValue];
        if (type == WO_APPROVAL_EVENT_ITEM_CLICK) {
            WorkOrderApproval * order = [result valueForKeyPath:@"eventData"];
            [self showOrderDetail:order];
        }
    }
}

#pragma mark --- 工单状态修复监听
- (void) initOrderStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMOrderStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMOrderStatusUpdate"
                                               object: nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMOrderStatusUpdate" object:nil];
}



- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}
@end
