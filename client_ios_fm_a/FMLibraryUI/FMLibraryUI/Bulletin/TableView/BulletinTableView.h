//
//  BulletinTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "BulletinHistoryEntity.h"
#import "FMRefreshHeaderView.h"
#import "FMLoadMoreFooterView.h"
#import "NetPage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LoadOrRefreshType) {
    BULLETIN_HISTORY_LOADMORE = 100,
    BULLETIN_HISTORY_REFRESH = 200
};

typedef NS_ENUM(NSInteger, BulletinDataType) {
    BULLETIN_DATA_TYPE_UNKNOW,
    BULLETIN_DATA_TYPE_UNREAD, //未读
    BULLETIN_DATA_TYPE_READ,  //已读
    
};

typedef void(^BulletinActionBlock)(BulletinHistory *historyDetail);
typedef void(^BulletinLoadOrRefreshBlock)(LoadOrRefreshType type);

@interface BulletinTableView : UITableView

@property (nonatomic, strong) __block NetPage *page;
@property (nonatomic, strong) __block NSMutableArray *dataArray;
@property (nonatomic, assign) __block BulletinDataType dataType;

//刷新TableView
- (void) RefreshTableView;
//加载更多
- (void) LoadMoreToTableView;

//点击
@property (nonatomic, copy) BulletinActionBlock actionBlock;
//刷新加载
@property (nonatomic, copy) BulletinLoadOrRefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
