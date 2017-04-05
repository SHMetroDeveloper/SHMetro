//
//  NotificationDbHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "DBHelper.h"
#import "DBNotification+CoreDataClass.h"
#import "NotificationEntity.h"

@interface NotificationDbHelper : DBHelper

+ (instancetype) getInstance;

//通知记录
- (BOOL) isNotificationExist:(NSNumber*) recordId withUser:(NSNumber *) userId;
- (BOOL) addNotification:(NotificationEntity*) notification withUserId:(NSNumber *) userId;
- (BOOL) addNotifications:(NSArray *) notificationArray withUserId:(NSNumber *) userId;
- (BOOL) deleteNotificationById:(NSNumber*) recordId andUserId:(NSNumber *) userId;
//删除所有的消息记录
- (BOOL) deleteAllNotificationOfUser:(NSNumber *) userId;
//删除所有的消息记录
- (BOOL) deleteAllNotification;
//更新消息
- (BOOL) updateNotificationById:(NSNumber*) recordId userId:(NSNumber*) userId notification:(NotificationEntity*) notification;

//把指定消息标记为已读状态
- (BOOL) markNotificationRead:(NSNumber *) recordId userId:(NSNumber *) userId;

//把该用户相关的所有消息标记为已读
- (BOOL) markAllNotificationReadByUser:(NSNumber *) userId;

//把 id 值不在数组之内的
- (BOOL) markNotificationReadNotIn:(NSMutableArray *) idArray ofUser:(NSNumber *) userId;

//把用户相关的所有指定类型消息置为已读
- (BOOL) markAllNotificationReadByUser:(NSNumber *) userId andType:(NSInteger) type;

//把该用户相关的所有消息标记为已删除
- (BOOL) deleteAllNotificationByUser:(NSNumber *) userId;

//把当前用户的相关消息标记为已删除
- (BOOL) deleteAllNotificationOfCurrentUser;

//把当前项目下该用户相关的所有指定类型消息标记为已删除
- (BOOL) deleteAllNotificationByUser:(NSNumber *) userId andType:(NSInteger) type;

//删除所有消息记录
- (BOOL) deleteAllNotification;

//查询消息记录，默认以时间排序（接收时间递减）
- (NSMutableArray*) queryAllNotificationBy:(NSNumber *) userId ;

//查询所有公司级公告
- (NSMutableArray*) queryAllNotificationOfCompanyBy:(NSNumber *) userId;

//查询指定类型消息记录，默认以时间排序（接收时间递减）
- (NSMutableArray*) queryAllNotificationByType:(NSInteger) type ofUser:(NSNumber *) userId;

//查询指定项目未读消息记录的条数, 如果projectId 为 nil 则查询所有未读记录
- (NSInteger) queryAllNotificationUnReadBy:(NSNumber *) userId project:(NSNumber *) projectId;

//查询指定消息记录数据
- (NotificationEntity*) queryNotificationById:(NSNumber*) recordId andUserId:(NSNumber *) userId;

@end
