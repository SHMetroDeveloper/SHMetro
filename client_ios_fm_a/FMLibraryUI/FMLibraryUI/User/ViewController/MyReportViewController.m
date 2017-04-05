//
//  MyReportViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/11/9.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MyReportViewController.h"
#import "FMTheme.h"

#import "BaseBundle.h"
#import "UIButton+Bootstrap.h"
#import "NetPage.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "AFNetworking.h"
#import "CustomAlertView.h"
#import "SeperatorView.h"
#import "FilterButton.h"
#import "FMFont.h"
#import "FMSize.h"

#import "WorkOrderBusiness.h"
#import "OrderMyReportTableHelper.h"
#import "SeperatorTableViewCell.h"

#import "MyReportHistoryEntity.h"   //我的报障实体
#import "MyReportItemCellView.h"    //我的报障itemView

#import "WorkOrderDetailViewController.h"
#import "WorkOrderHistoryEntity.h"
#import "WorkOrderNetRequest.h"
#import "BaseDataDbHelper.h"
#import "ImageItemView.h"

@interface MyReportViewController ()

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;

@property (readwrite, nonatomic, strong) OrderMyReportTableHelper * ordersHelper;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;  //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight; //提示高度


@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@end

@implementation MyReportViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_my_report" inTable:nil]];
    [self setBackAble:YES];
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    _noticeHeight = [FMSize getInstance].noticeHeight;
    _business = [WorkOrderBusiness getInstance];
    
    _ordersHelper = [[OrderMyReportTableHelper alloc] initWithContext:self];
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
    [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"report_my_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
    [_noticeLbl setHidden:YES];
    [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
    [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];

    [_noticeLbl setHidden:YES];
    
    [_mainContainerView addSubview:_pullTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self work];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) updateList {
    
    if([_ordersHelper getOrderCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_pullTableView reloadData];
    
    [self refreshTable];
    [self loadMoreDataToTable];
}

- (void) work {
    [self showLoadingDialog];
    if(!_pullTableView.pullTableIsRefreshing) {
        _pullTableView.pullTableIsRefreshing = YES;
    }
    [self requestData];
}

- (void) requestData {
    [_business getOrdersMyReportPage:[_ordersHelper getPage] Success:^(NSInteger key, id object) {
        MyreportHistoryResponseData * response = object;
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

- (void) showOrderDetail:(MyReportHistory *) order {
    
    WorkOrderDetailViewController * taskDetailVC = [[WorkOrderDetailViewController alloc] init];
    [taskDetailVC setWorkOrderWithId:order.woId];
    [taskDetailVC setReadOnly:YES];
    [self gotoViewController:taskDetailVC];
    
}

#pragma mark - 点击
- (void)handleMessage:(id)msg {
    NSString * strOrigin = [msg valueForKey:@"msgOrigin"];
    if ([strOrigin isEqualToString:NSStringFromClass([_ordersHelper class])]) {
        id result = [msg valueForKey:@"result"];
        OrderMyReportEventType type = [[result valueForKeyPath:@"eventType"] integerValue];
        if (type == WO_MYREPORT_EVENT_ITEM_CLICK) {
            MyReportHistory * order = [result valueForKeyPath:@"eventData"];
            [self showOrderDetail:order];
        }
    }
}

@end


