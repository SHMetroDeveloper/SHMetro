//
//  MessageTableViewHelper.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMessageTableViewCell.h"
#import "NotificationEntity.h"
#import "PullTableView.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, NotificationEditType) {
    NOTIFICATION_EDIT_TYPE_READ,  //标记已读未读
    NOTIFICATION_EDIT_TYPE_DELETE,  //删除
    NOTIFICATION_EDIT_TYPE_MORE,  //查看更多
    NOTIFICATION_EDIT_TYPE_REFRESH,  //下拉刷新
    NOTIFICATION_EDIT_TYPE_LOAD_MORE,  //上拉加载更多
};

typedef void(^NotificationActionBlock)(NotificationEntity *notificationEntity, NotificationItemType notificationType);
typedef void(^NotificationEditBlock)(NotificationEditType editType, NSInteger position, NotificationEntity *notificationEntity);
typedef void(^NotificationShowMoreBlock)(NotificationItemType type);
typedef void(^NotificationRefreshBlock)();
typedef void(^NotificationLoadMoreBlock)();

@interface MessageTableViewHelper : NSObject <UITableViewDelegate, UITableViewDataSource, PullTableViewDelegate>

@property (nonatomic, copy) NotificationActionBlock actionBlock;  //跳转到详情
@property (nonatomic, copy) NotificationEditBlock editBlock;      //左滑
@property (nonatomic, copy) NotificationRefreshBlock refershBlock;      //下拉刷新
@property (nonatomic, copy) NotificationLoadMoreBlock loadMoreBlock;      //上拉加载

- (void) setMsgArray:(NSMutableArray *) msgArray;

//设置事件监听
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end

