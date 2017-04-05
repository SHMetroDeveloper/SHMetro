//
//  BulletinReadStateViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinReadStateViewController.h"
#import "BulletinHeaderView.h"
#import "BulletinReadStateCollectionView.h"
#import "ImageItemView.h"
#import "FMUtilsPackages.h"
#import "BulletinBusiness.h"
#import "BaseBundle.h"


@interface BulletinReadStateViewController ()
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) __block BulletinHeaderView *headerView;
@property (nonatomic, strong) __block BulletinReadStateCollectionView *collectionView;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度


@property (nonatomic, strong) BulletinBusiness *bussiness;
@property (nonatomic, assign) __block BOOL queryReaderStatus;
@property (nonatomic, strong) __block NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation BulletinReadStateViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"bulletin_read_unread_list" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reqeustData];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        _bussiness = [BulletinBusiness getInstance];
        _queryReaderStatus = NO;
        
        _dataArray = [NSMutableArray new];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];

        [_mainContainerView addSubview:self.headerView];
        [_mainContainerView addSubview:self.collectionView];
        [_mainContainerView addSubview:self.noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateList {
    if(_dataArray.count == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    
    if (_collectionView.mj_footer.isRefreshing) {
        if (![_collectionView.page haveMorePage]) {
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_collectionView.mj_footer endRefreshing];
        }
    }
    
    _collectionView.dataArray = _dataArray;
}

#pragma mark - Lazyload
- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"bulletin_reader_no_data" inTable:nil] andLogo:[[FMTheme getInstance]  getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance]  getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    }
    return _noticeLbl;
}

- (BulletinHeaderView *)headerView {
    if (!_headerView) {
        CGFloat headerHeight = [BulletinHeaderView getHeaderHeight];
        _headerView = [[BulletinHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, headerHeight)];
        __weak typeof(self) weakSelf = self;
        _headerView.actionBlock = ^(BulletinHeaderType headerType){
            switch (headerType) {
                case BULLETIN_HEADER_TYPE_READ_NO:
                    if (weakSelf.collectionView.dataType != BULLETIN_READ_STATE_DATA_TYPE_UNREAD) {
                        weakSelf.collectionView.dataType = BULLETIN_READ_STATE_DATA_TYPE_UNREAD;
                        weakSelf.queryReaderStatus = NO;
                        [weakSelf.dataArray removeAllObjects];
                        weakSelf.collectionView.page = [[NetPage alloc] init];
                        weakSelf.collectionView.page.pageSize = [NSNumber numberWithInteger:20];
                        [weakSelf.collectionView.mj_footer endRefreshing];
                        [weakSelf reqeustData];
                    }
                    break;
                    
                case BULLETIN_HEADER_TYPE_READ_YES:
                    if (weakSelf.collectionView.dataType != BULLETIN_READ_STATE_DATA_TYPE_READ) {
                        weakSelf.collectionView.dataType = BULLETIN_READ_STATE_DATA_TYPE_READ;
                        weakSelf.queryReaderStatus = YES;
                        [weakSelf.dataArray removeAllObjects];
                        weakSelf.collectionView.page = [[NetPage alloc] init];
                        weakSelf.collectionView.page.pageSize = [NSNumber numberWithInteger:20];
                        [weakSelf.collectionView.mj_footer endRefreshing];
                        [weakSelf reqeustData];
                    }
                    break;
            }
        };
        
        _headerView.leftButtonTitle = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"bulletin_notice_unread_count" inTable:nil],_unreadCount];
        _headerView.rightButtonTitle = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"bulletin_notice_read_count" inTable:nil],_readCount];
    }
    return _headerView;
}

- (BulletinReadStateCollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat headerHeight = [BulletinHeaderView getHeaderHeight];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[BulletinReadStateCollectionView alloc] initWithFrame:CGRectMake(0, headerHeight, _realWidth, _realHeight - headerHeight) collectionViewLayout:flowLayout];
        __weak typeof(self) weakSelf = self;
        _collectionView.loadMoreBlock = ^(){
            NetPage *page = weakSelf.collectionView.page;
            if([page haveMorePage]) {
                [page nextPage];
                weakSelf.collectionView.page = page;
                [weakSelf reqeustData];
            } else {
                [weakSelf updateList];
            }
        };
        
    }
    
    return _collectionView;
}

#pragma mark - Setter
- (void)setReadCount:(NSInteger)readCount {
    _readCount = readCount;
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    _unreadCount = unreadCount;
}

#pragma mark - NetWorking
- (void) reqeustData {
    BulletinReceiverRequestParam *param = [[BulletinReceiverRequestParam alloc] init];
    param.bulletinId = _bulletinId;
    param.read = _queryReaderStatus;
    param.page = _collectionView.page;
    __weak typeof(self) weakSelf = self;
    [self showLoadingDialog];
    [_bussiness getBulletinReadStateByParam:param Success:^(NSInteger key, id object) {
        BulletinReceiverResponseData *response = object;
        NetPage *page = [response page];
        weakSelf.collectionView.page = page;
        weakSelf.collectionView.page.pageSize = [NSNumber numberWithInteger:20];
        if (!weakSelf.collectionView.page || [weakSelf.collectionView.page isFirstPage]) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:response.contents];
        } else {
            [weakSelf.dataArray addObjectsFromArray:response.contents];
        }
        
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } Fail:^(NSInteger key, NSError *error) {
        [weakSelf.dataArray removeAllObjects];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

@end
