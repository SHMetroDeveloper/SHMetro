//
//  BulletinViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinViewController.h"
#import "FMUtilsPackages.h"
#import "BulletinTableView.h"
#import "BulletinBusiness.h"
#import "ImageItemView.h"
#import "BulletinDetailViewController.h"
#import "BaseTabbarView.h"
#import "BaseBundle.h"

@interface BulletinViewController () <OnItemClickListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) __block BulletinTableView *tableView;
@property (nonatomic, strong) __block BaseTabbarView * typeTabbar;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, strong) __block NSMutableArray *dataArray; //公告历史数据

@property (nonatomic, strong) BulletinBusiness *business;
@property (nonatomic, assign) __block NSInteger historyType;  //1-未读 2-已读

@property (nonatomic, assign) BOOL needUpdate;  //从详情返回的时候是否需要刷新列表

@property (nonatomic, assign) CGFloat typeHeight;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;
@end

@implementation BulletinViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_typeTabbar setSelected:0];
    [self requestBulletinHistory];
    [self initOrderStatusChangeHandler];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [_tableView.page reset];
        
        [self requestBulletinHistory];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realHeight = CGRectGetHeight(mFrame);
        _realWidth = CGRectGetWidth(mFrame);
        _typeHeight = 45;
        
        _business = [BulletinBusiness getInstance];
        _historyType = BULLETIN_DATA_TYPE_UNREAD;  //默认查询未读公告
        
        _dataArray = [NSMutableArray new];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        _typeTabbar = [[BaseTabbarView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _typeHeight)];
        [_typeTabbar setStyle:BASE_TABBAR_STYLE_BOTTOM_LINE];
        [_typeTabbar setInfoWithArray:[[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"bulletin_notice_unread" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"bulletin_notice_read" inTable:nil], nil]];
        [_typeTabbar setOnItemClickListener:self];
        _typeTabbar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_mainContainerView addSubview:_typeTabbar];
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateList {
    if(_dataArray.count == 0) {
        [_noticeLbl setHidden:NO];
        if (_historyType == BULLETIN_DATA_TYPE_UNREAD) {  //未读
            [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"bulletin_history_no_data_unreaded" inTable:nil] andLogo:[[FMTheme getInstance]  getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance]  getImageByName:@"no_data"]];
        } else if (_historyType == BULLETIN_DATA_TYPE_READ) {  //已读
            [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"bulletin_history_no_data_readed" inTable:nil] andLogo:[[FMTheme getInstance]  getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance]  getImageByName:@"no_data"]];
        }
    } else {
        [_noticeLbl setHidden:YES];
    }
    
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
    
    if (_tableView.mj_footer.isRefreshing) {
        if (![_tableView.page haveMorePage]) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_tableView.mj_footer endRefreshing];
        }
    }
    
    _tableView.dataArray = _dataArray;
    [_tableView reloadData];
}

#pragma mark - Lazyload
- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"bulletin_history_no_data" inTable:nil] andLogo:[[FMTheme getInstance]  getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance]  getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    }
    return _noticeLbl;
}


- (BulletinTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BulletinTableView alloc] initWithFrame:CGRectMake(0, _typeHeight, _realWidth, _realHeight - _typeHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(BulletinHistory *historyDetail) {
            BulletinDetailViewController *vc = [[BulletinDetailViewController alloc] init];
            vc.bulletinId = historyDetail.bulletinId;
            vc.dataType = weakSelf.tableView.dataType;
            [weakSelf gotoViewController:vc];
        };
        
        _tableView.refreshBlock = ^(LoadOrRefreshType type) {
            switch (type) {
                case BULLETIN_HISTORY_LOADMORE: {
                    NetPage *page = weakSelf.tableView.page;
                    if([page haveMorePage]) {
                        [page nextPage];
                        weakSelf.tableView.page = page;
                        [weakSelf requestBulletinHistory];
                    } else {
                        [weakSelf updateList];
                    }
                }
                    break;
                    
                case BULLETIN_HISTORY_REFRESH: {
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.tableView.page reset];
                    [weakSelf requestBulletinHistory];
                }
                    break;
            }
        };
    }
    return _tableView;
}

#pragma mark - NetWorking
- (void) requestBulletinHistory {
    BulletinHistoryRequestParam *param = [[BulletinHistoryRequestParam alloc] init];
    param.type = _historyType;
    param.page = _tableView.page;
    __weak typeof(self) weakSelf = self;
    [self showLoadingDialog];
    [_business getBulletinHistoryByParam:param Success:^(NSInteger key, id object) {
        BulletinHistoryResponseData *response = object;
        NetPage *page = [response page];
        weakSelf.tableView.page = page;
        if (!weakSelf.tableView.page || [weakSelf.tableView.page isFirstPage]) {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:response.contents];
        } else {
            [_dataArray addObjectsFromArray:response.contents];
        }
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } Fail:^(NSInteger key, NSError *error) {
        [_dataArray removeAllObjects];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

#pragma mark - 点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[BaseTabbarView class]]) {
        NSInteger index = subView.tag;
        BOOL update = NO;
        switch(index) {
            case 0:
                if (_tableView.dataType != BULLETIN_DATA_TYPE_UNREAD) {
                    _historyType = BULLETIN_DATA_TYPE_UNREAD;
                    _tableView.dataType = BULLETIN_DATA_TYPE_UNREAD;
                    [_dataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshing];
                    update = YES;
                }
                break;
            case 1:
                if (_tableView.dataType != BULLETIN_DATA_TYPE_READ) {
                    _historyType = BULLETIN_DATA_TYPE_READ;
                    _tableView.dataType = BULLETIN_DATA_TYPE_READ;
                    [_dataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshing];
                    update = YES;
                }
                break;
        }
        if(update) {
            [self requestBulletinHistory];
        }
    }
}


#pragma mark - NSNotificationCenter
- (void) initOrderStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMBulletinReadStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMBulletinReadStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"%@ --- 收到通知", NSStringFromClass([self class]));
    _needUpdate = YES;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMBulletinReadStatusUpdate" object:nil];
}


@end


