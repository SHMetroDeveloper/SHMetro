//
//  HistoryInventoryViewController.m
//  client_ios_shangan
//
//  Created by Master.lyn on 16/12/05.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WarehouseQueryViewController.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import "InventoryBusiness.h"
#import "ImageItemView.h"
#import "WarehouseQueryTableView.h"
#import "MaterialQueryContainerViewController.h"

@interface WarehouseQueryViewController()
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) WarehouseQueryTableView *tableView;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block NetPage *netPage;
@property (nonatomic, strong) __block NSMutableArray *warehouseArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@end

@implementation WarehouseQueryViewController

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_history" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestWarehouseData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        _business = [InventoryBusiness getInstance];
        _netPage = [[NetPage alloc] init];
        _warehouseArray = [NSMutableArray new];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)updateList {
    if (_warehouseArray.count > 0) {
        [self.noticeLbl setHidden:YES];
    } else {
        [self.noticeLbl setHidden:NO];
    }
    
    if (_tableView.mj_footer.isRefreshing && ![_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else if (_tableView.mj_footer.isRefreshing && [_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    }
    
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
    
    _tableView.dataArray = _warehouseArray;
}


#pragma mark - Lazyload
- (WarehouseQueryTableView *)tableView {
    if (!_tableView) {
        _tableView = [[WarehouseQueryTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        
        __weak typeof(self) weakSelf = self;
        _tableView.refreshBlock = ^(WarehouseRefreshType type){
            if (type == WAREHOUSE_REFRESH_TYPE_REFRESH) {
                [weakSelf.netPage reset];
                [weakSelf.warehouseArray removeAllObjects];
                [weakSelf requestWarehouseData];
            } else if (type == WAREHOUSE_REFRESH_TYPE_LOADMORE) {
                if ([weakSelf.netPage haveMorePage]) {
                    [weakSelf.netPage nextPage];
                    [weakSelf requestWarehouseData];
                } else {
                    [weakSelf updateList];
                }
            }
        };
        
        _tableView.actionBlock = ^(NSNumber *warehouseId, NSString *warehouseName){
            [weakSelf gotoWarehouseById:warehouseId andWarehouseName:warehouseName];
        };
    }
    return _tableView;
}

- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
    }
    return _noticeLbl;
}


#pragma mark - NetWorking 
- (void)requestWarehouseData {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business requestWarehouseListBy:_netPage success:^(NSInteger key, id object) {
        InventoryWarehouseQueryResponseData *responseData = object;
        weakSelf.netPage = responseData.page;
        
        [weakSelf.warehouseArray addObjectsFromArray:responseData.contents];
        
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

#pragma mark - PushEvent
- (void)gotoWarehouseById:(NSNumber *)warehouseId andWarehouseName:(NSString *)warehouseName {
    MaterialQueryContainerViewController *queryContainerVC = [[MaterialQueryContainerViewController alloc] initWithWarehouseId:warehouseId andWarehouseName:warehouseName];
    [self gotoViewController:queryContainerVC];
}

@end
