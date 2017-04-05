//
//  ContractManagementViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/23/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractManagementViewController.h"
#import "PullTableView.h"
#import "ContractBusiness.h"
#import "FMTheme.h"
#import "ImageItemView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "ContractServerConfig.h"
#import "ContractQueryTableHelper.h"
#import "ContractDetailViewController.h"

@interface ContractManagementViewController () <PullTableViewDelegate, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, assign) __block BOOL needUpdate;

@property (readwrite, nonatomic, strong) __block NetPage * mPage;

@property (readwrite, nonatomic, strong) ContractBusiness * business;
@property (readwrite, nonatomic, strong) __block ContractQueryTableHelper * contractHelper;

@end

@implementation ContractManagementViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_management_title" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [[ContractBusiness alloc] init];
        _contractHelper = [[ContractQueryTableHelper alloc] init];
        [_contractHelper setOnMessageHandleListener:self];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, realWidth, realHeight)];
        _pullTableView.dataSource = _contractHelper;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = _contractHelper;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (realHeight-_noticeHeight)/2, realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"contract_query_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
        
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initContractStatusChangeHandler];
    [self work];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        _needUpdate = NO;
        
        [_mPage reset];
        [self work];
    }
}

- (void) initContractStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMContractStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMContractStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMContractStatusUpdate" object:nil];
}

- (void) initData {
    _mPage = [[NetPage alloc] init];
}

- (void) updateNotice {
    if([_contractHelper getContractCount] > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

- (void) updateList {
    [self refreshTable];
    [self loadMoreDataToTable];
    
    if([_contractHelper getContractCount] == 0) {
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

- (void) work {
    [self requestData];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([_contractHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber;
            tmpNumber = [result valueForKeyPath:@"eventType"];
            ContractQueryEventType type = [tmpNumber integerValue];
            ContractEntity * contract;
            switch (type) {
                case CONTRACT_QUERY_EVENT_ITEM_CLICK:
                    contract = [result valueForKeyPath:@"eventData"];
                    if(contract) {
                        [self gotoContractDetail:contract.contractId];
                    }
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

#pragma mark - 网络请求
- (void) requestData {
    if(_business) {
        [self showLoadingDialog];
        __weak typeof(self) weakSelf = self;
        [_business getContractManagementListByPage:_mPage success:^(NSInteger key, id object) {
            ContractQueryResponseData * response = object;
            NetPage * page = [response page];
            if(!page || [page isFirstPage]) {
                [weakSelf.contractHelper removeAllContracts];
            }
            [weakSelf.contractHelper setPage:page];
            weakSelf.mPage = page;
            [weakSelf.contractHelper addContractsWithArray:response.contents];
            [weakSelf updateList];
            [weakSelf hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf.contractHelper removeAllContracts];
            [weakSelf updateList];
        }];
    }
}

#pragma - 跳转
- (void) gotoContractDetail:(NSNumber *) contractId {
    ContractDetailViewController * detailVC = [[ContractDetailViewController alloc] init];
    [detailVC setContractWithId:contractId];
    [detailVC setEditable:YES];
    [self gotoViewController:detailVC];
}

@end
