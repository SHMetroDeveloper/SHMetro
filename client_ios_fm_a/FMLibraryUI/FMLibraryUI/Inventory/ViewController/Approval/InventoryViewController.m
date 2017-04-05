//
//  InventoryViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/18.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "InventoryViewController.h"
#import "PullTableView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "NetPage.h"
#import "SeperatorView.h"
#import "ReservationEntity.h"
#import "OnItemClickListener.h"
#import "SystemConfig.h"
#import "InventoryNetRequest.h"
#import "ReservationDetailViewController.h"
#import "OperateReservationEntity.h"
#import "InventoryBusiness.h"
#import "ReservationListTableHelper.h"
#import "BaseTabbarView.h"

typedef NS_ENUM(NSInteger, InventoryApprovalType) {
    INVENTORY_RESERVATION_TYPE_UNAPPROVALED,    //待审核
    INVENTORY_RESERVATION_TYPE_APPROVALED,      //已审核
};

@interface InventoryViewController () <PullTableViewDelegate, OnMessageHandleListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) BaseTabbarView * typeTabbar;
@property (readwrite, nonatomic, strong) PullTableView * infoTableView;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat filterHeight;  //tabbar 高度

@property (readwrite, nonatomic, strong) NSMutableArray * infoArray;
@property (readwrite, nonatomic, strong) InventoryBusiness *business;
@property (readwrite, nonatomic, strong) ReservationListTableHelper *helper;

@property (readwrite, nonatomic, assign) InventoryApprovalType operationType;

@property (nonatomic, assign) BOOL needUpdate;
@end

@implementation InventoryViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_approval" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
    
        _business = [InventoryBusiness getInstance];
        _helper = [[ReservationListTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        [_helper setShowMore:NO showSeperator:NO];
        
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _filterHeight = 44;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _typeTabbar = [[BaseTabbarView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _filterHeight)];
        [_typeTabbar setStyle:BASE_TABBAR_STYLE_BOTTOM_LINE];
        [_typeTabbar setInfoWithArray:[[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_approval_type_undo" inTable:nil],  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_approval_type_finish" inTable:nil], nil]];
        [_typeTabbar setOnItemClickListener:self];
        _typeTabbar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _infoTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, _filterHeight, _realWidth, _realHeight-_filterHeight)];
        _infoTableView.dataSource = _helper;
        _infoTableView.delegate = _helper;
        _infoTableView.pullDelegate = self;
        _infoTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _infoTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _infoTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _infoTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data_approval" inTable:nil]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        
        [_mainContainerView addSubview:_typeTabbar];
        [_mainContainerView addSubview:_infoTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStatusChangeHandler];
    _operationType = INVENTORY_RESERVATION_TYPE_UNAPPROVALED;   //默认为待审核
    [_typeTabbar setSelected:0];
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
        switch(_operationType) {
            case INVENTORY_RESERVATION_TYPE_UNAPPROVALED:
                [_noticeLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data_approval" inTable:nil]];
                break;
            case INVENTORY_RESERVATION_TYPE_APPROVALED:
                [_noticeLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data_history" inTable:nil]];
                break;
        }
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_infoTableView reloadData];
}


- (void) requestData {
    [self showLoadingDialog];
    NSNumber *userId = [SystemConfig getEmployeeId];
    ReservationQueryType queryType = RESERVATION_QUERY_TYPE_UNKNOW;
    switch(_operationType) {
        case INVENTORY_RESERVATION_TYPE_UNAPPROVALED:
            queryType = RESERVATION_QUERY_TYPE_CHECK;
            break;
        case INVENTORY_RESERVATION_TYPE_APPROVALED:
            queryType = RESERVATION_QUERY_TYPE_HISTORY;
            break;
    }
    GetReservationListParam *param = [[GetReservationListParam alloc] initWithUserId:userId
                                                                            queryType:queryType
                                                                                 page:[_helper getPage]];
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

#pragma mark - 点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[BaseTabbarView class]]) {
        NSInteger index = subView.tag;
        switch(index) {
            case 0:
                _operationType = INVENTORY_RESERVATION_TYPE_UNAPPROVALED;
                break;
            case 1:
                _operationType = INVENTORY_RESERVATION_TYPE_APPROVALED;
                break;
        }
        [_helper setPage:[[NetPage alloc] init]];   //初始化数据页
        [self requestData];
    }
}


#pragma mark --- 消息处理
- (void) handleMessage:(id)msg {
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
        }
    }
}

- (void) gotoInventoryDetail:(NSInteger) position{
    ReservationEntity * reservation = [_helper getDataByPosition:position];
    if(reservation) {
        ReservationDetailViewController * detailVC = [[ReservationDetailViewController alloc] init];
        [detailVC setInfoWithReservationId:reservation.activityId];
        if(_operationType == INVENTORY_RESERVATION_TYPE_APPROVALED) {
            [detailVC setReadonly:YES];
        } else {
            [detailVC setReadonly:NO];
        }
        [self gotoViewController:detailVC];
    }
}

@end
