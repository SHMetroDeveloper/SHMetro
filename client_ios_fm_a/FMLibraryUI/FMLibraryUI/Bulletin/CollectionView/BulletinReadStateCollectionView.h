//
//  BulletinReadStateCollectionView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "FMLoadMoreFooterView.h"
#import "BulletinReceiverEntity.h"
#import "NetPage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BulletinReadStateDataType) {
    BULLETIN_READ_STATE_DATA_TYPE_READ,   //已读
    BULLETIN_READ_STATE_DATA_TYPE_UNREAD  //未读
};

typedef void(^BulletinReadStateLoadMoreBlock) ();

@interface BulletinReadStateCollectionView : UICollectionView

@property (nonatomic, strong) __block NetPage *page;
@property (nonatomic, strong) __block NSMutableArray *dataArray;
@property (nonatomic, assign) __block BulletinReadStateDataType dataType;

//刷新加载
@property (nonatomic, copy) BulletinReadStateLoadMoreBlock loadMoreBlock;

@end

NS_ASSUME_NONNULL_END
