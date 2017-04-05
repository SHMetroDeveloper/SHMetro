//
//  InventoryProviderSelectViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryProviderSelectViewController.h"
#import "ImageItemView.h"
#import "BaseBundle.h"
#import "FMUtilsPackages.h"
#import "InventoryBusiness.h"
#import "FMLoadMoreFooterView.h"
#import "InventoryProviderTableViewCell.h"

@interface InventoryProviderSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block NetPage *netPage;
@property (nonatomic, strong) __block NSMutableArray *providerArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation InventoryProviderSelectViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_select_provider" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPrivider];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        _business = [InventoryBusiness getInstance];
        _netPage = [[NetPage alloc] init];
        _providerArray = [NSMutableArray new];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

#pragma mark - Lazyload
- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_provider_empty" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
    }
    return _noticeLbl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[InventoryProviderTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        _tableView.mj_footer.automaticallyChangeAlpha = YES;
    }
    return _tableView;
}

#pragma mark - Private Method
- (void)updateList {
    if (_providerArray.count > 0) {
        [self.noticeLbl setHidden:YES];
    } else {
        [self.noticeLbl setHidden:NO];
    }
    
    if (_tableView.mj_footer.isRefreshing && ![_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else if (_tableView.mj_footer.isRefreshing && [_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    }
    
    [_tableView reloadData];
}

- (void)LoadMoreToTableView {
    if ([_netPage haveMorePage]) {
        [_netPage nextPage];
        [self requestPrivider];
    } else {
        [self updateList];
    }
}

#pragma mark - NetWorking
- (void)requestPrivider {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    InventoryMaterialProviderRequestParam *param = [[InventoryMaterialProviderRequestParam alloc] init];
    param.inventoryId = _inventoryId;
    param.page.pageSize = _netPage.pageSize;
    param.page.pageNumber = _netPage.pageNumber;
    [_business requestMaterialProvider:param success:^(NSInteger key, id object) {
        InventoryMaterialProviderResponseData *responseData = object;
        weakSelf.netPage = responseData.page;
        if ([weakSelf.netPage isFirstPage]) {
            weakSelf.providerArray = responseData.contents;
        } else {
            [weakSelf.providerArray addObjectsFromArray:responseData.contents];
        }
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
    }];
}


#pragma mark - OnMessageHandleListener
- (void)setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    if (handler) {
        _handler = handler;
    }
}

- (void)notifyEventData:(id)eventData {
    if (_handler) {
        NSMutableDictionary *msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        [msg setValue:eventData forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _providerArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [InventoryProviderTableViewCell getItemHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(InventoryProviderTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    InventoryMaterialProviderDetail *provider = _providerArray[position];
    if (position == _providerArray.count - 1) {
        cell.seperatorGapped = NO;
    } else {
        cell.seperatorGapped = YES;
    }
    [cell setInfoWithName:provider.name
                  contact:provider.contact
                    phone:provider.phone
                 location:provider.address];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    InventoryMaterialProviderDetail *provider = _providerArray[position];
    [self notifyEventData:provider];
    [self finish];
}

@end



