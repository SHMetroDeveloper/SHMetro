//
//  MessageTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/15.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMessageTableViewCell.h"
#import "NotificationEntity.h"

typedef NS_ENUM(NSInteger, NotificationEditType) {
    NOTIFICATION_EDIT_TYPE_READ,  //标记已读未读
    NOTIFICATION_EDIT_TYPE_DELETE,  //删除
    NOTIFICATION_EDIT_TYPE_MORE,  //查看更多
};

typedef void(^NotificationActionBlock)(NotificationEntity *notificationEntity, NotificationItemType notificationType);
typedef void(^NotificationEditBlock)(NotificationEditType editType, NSIndexPath *indexPath, NotificationEntity *notificationEntity);
typedef void(^NotificationShowMoreBlock)(NotificationItemType type);

@interface MessageTableView : UITableView

@property (nonatomic, copy) NotificationActionBlock actionBlock;  //跳转到详情
@property (nonatomic, copy) NotificationEditBlock editBlock;      //左滑
@property (nonatomic, copy) NotificationShowMoreBlock moreBlock;  //点击header查看更多

- (void) setOrderMsgArray:(NSMutableArray *) orderMsgArray;
- (void) setPatrolMsgArray:(NSMutableArray *) patrolMsgArray;
- (void) setMaintenanceMsgArray:(NSMutableArray *) maintenanceMsgArray;
- (void) setAssetMsgArray:(NSMutableArray *) assetMsgArray;

- (void) setRequirementMsgArray:(NSMutableArray *) msgArray;
- (void) setInventoryMsgArray:(NSMutableArray *) msgArray;
- (void) setContractMsgArray:(NSMutableArray *) msgArray;
- (void) setBulletinMsgArray:(NSMutableArray *) msgArray;

//设置是否可以侧滑操作
- (void) setEditable:(BOOL)editable;

- (void) setShowHeader:(BOOL) show;
@end
