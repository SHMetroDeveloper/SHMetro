//
//  EquipmentListViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentListViewController.h"
#import "EquipmentListTableHelper.h"
#import "AssetManagementBusiness.h"
#import "FMUtilsPackages.h"
#import "EquipmentDetailViewController.h"
#import "PhotoItemContentView.h"
#import "PhotoItemModel.h"
#import "ImageItemView.h"
#import "TaskAlertView.h"
#import "PullTableView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"

#import "EquipmentListFilterViewController.h"

@interface EquipmentListViewController () <OnMessageHandleListener, PullTableViewDelegate>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * tableView;
@property (readwrite, nonatomic, strong) UIButton * moreBtn;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

//@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, strong) SearchCondition * condition;

@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, strong) EquipmentListTableHelper * tableViewHelper;
@property (readwrite, nonatomic, strong) AssetManagementBusiness * business;

//@property (readwrite, nonatomic, strong) NSMutableArray * equipArray;

@end

@implementation EquipmentListViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"asset_equipment_query" inTable:nil]];
    [self setBackAble:YES];
}

- (void)initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _btnWidth = [FMSize getInstance].filterWidth;
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _tableViewHelper = [[EquipmentListTableHelper alloc] initWithContext:self];
        [_tableViewHelper setOnMessageHandleListener:self];
        
//        _mPage = [[NetPage alloc] init];
        _condition = [[SearchCondition alloc] init];
        _business = [AssetManagementBusiness getInstance];
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = _tableViewHelper;
        _tableView.dataSource = _tableViewHelper;
        
        _tableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _tableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _tableView.pullDelegate = self;
        
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"asset_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        
        CGFloat padding = [FMSize getInstance].defaultPadding;
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-padding-_btnWidth, _realHeight-padding-_btnWidth, _btnWidth, _btnWidth)];
        [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_normal"] forState:UIControlStateNormal];
        [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_highlight"] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(showFilterViewController) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.layer.cornerRadius = _btnWidth/2;
        
        
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_noticeLbl];
        [_mainContainerView addSubview:_moreBtn];
        
        [self.view addSubview:_mainContainerView];
        
        //监听滑动手势
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOrderStatusChangeHandler];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        [self work];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}



- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];
}


- (void) initOrderStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @""
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) work {
    _needUpdate = NO;
    [self showLoadingDialog];
    if(!_tableView.pullTableIsRefreshing) {
        _tableView.pullTableIsRefreshing = YES;
    }
    [self requestData];
}

- (void) updateList {
    [self refreshTable];
    [self loadMoreDataToTable];
    
    if([_tableViewHelper getOrderCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_tableView reloadData];
}


- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

//请求设备数据
- (void) requestData {
    [self showLoadingDialog];
    AssetManagementEquipmentsRequestParam *params = [[AssetManagementEquipmentsRequestParam alloc] initWithCondition:_condition andPage:[_tableViewHelper getPage]];
    [_business getEquipmentsListDataByParam:params Success:^(NSInteger key, id object) {
        AssetManagementEquipmentsResponseData * response = object;
        NetPage * page = [response page];
        if(!page || [page isFirstPage]) {
            [_tableViewHelper removeAllOrders];
        }
        [_tableViewHelper setPage:page];
        [_tableViewHelper addOrdersWithArray:response.contents];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [_tableViewHelper removeAllOrders];
        [self hideLoadingDialog];
        [self updateList];
    }];
}

#pragma mark - Refresh and load more methods
- (void) refreshTable {
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    _tableView.pullTableIsLoadingMore = NO;
}


#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [_tableViewHelper removeAllOrders];
    [self updateList];
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    NetPage * page = [_tableViewHelper getPage];
    if([page haveMorePage]) {
        [page nextPage];
        [_tableViewHelper setPage:page];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.0f];
    }
}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([_tableViewHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            AssetManagementEquipmentsEntity * data = [result valueForKeyPath:@"eventData"];
            [self gotoShowEquipmentDetailByEqid:data.eqId];
        }
        if ([strOrigin isEqualToString:NSStringFromClass([EquipmentListFilterViewController class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            _condition.equipmentCode = [result valueForKeyPath:@"code"];
            _condition.basicinformation = [result valueForKeyPath:@"baseinfo"];
            _condition.location = [result valueForKeyPath:@"location"];
            _condition.system = [result valueForKeyPath:@"classification"];
            _condition.status = [result valueForKeyPath:@"statusArray"];
            [_tableViewHelper setPage:[[NetPage alloc] init]];
            [self requestData];
        }
    }
}

- (void) gotoShowEquipmentDetailByEqid:(NSNumber *) equipmentId {
    EquipmentDetailViewController * viewController = [[EquipmentDetailViewController alloc] initWithEquipmentID:equipmentId];
    [viewController setEditable:YES];
    [self gotoViewController:viewController];
}

- (void) showFilterViewController {
    [self.frostedViewController presentMenuViewController];
}

@end

