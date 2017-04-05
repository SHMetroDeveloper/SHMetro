//
//  NotificationServerConfig.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//消息类型
typedef NS_ENUM(NSInteger, NotificationReadType) {
    NOTIFICATION_READ_TYPE_UNREAD,     //未读消息
    NOTIFICATION_READ_TYPE_READ = 1,   //已读消息
    NOTIFICATION_READ_TYPE_ALL,        //所有消息
};

typedef NS_ENUM(NSInteger, NotificationItemType) {
    NOTIFICATION_ITEM_TYPE_UNKNOW = 0,  //所有类型
    NOTIFICATION_ITEM_TYPE_ORDER = 1,   //工单
    NOTIFICATION_ITEM_TYPE_PATROL = 2,  //巡检
    NOTIFICATION_ITEM_TYPE_MAINTENANCE = 3, //计划性维护
    NOTIFICATION_ITEM_TYPE_ASSET = 4,   //资产
    NOTIFICATION_ITEM_TYPE_REQUIREMENT = 5,   //需求
    NOTIFICATION_ITEM_TYPE_INVENTORY = 6,    //库存
    NOTIFICATION_ITEM_TYPE_CONTRACT = 7,    //合同
    NOTIFICATION_ITEM_TYPE_BULLETION = 100    //公告
};

//库存推送消息子类型
typedef NS_ENUM(NSInteger, NotificationInventorySubItemType) {
    INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_UNKNOW = 0,
    INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_RESERVATION = 1,   //预定单
    INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_MATERIAL = 2,  //物料
};

@interface NotificationServerConfig : NSObject

@end

//消息已读确认接口
extern NSString * const OPERATE_NOTIFICATION_READ_URL;
//消息全部已读接口
extern NSString * const OPERATE_NOTIFICATION_READ_ALL_URL;
//消息删除接口
extern NSString * const OPERATE_NOTIFICATION_DELETE_URL;
//获取消息列表接口
extern NSString * const NOTIFICATION_QUERY_URL;
//获取消息概览
extern NSString * const NOTIFICATION_REQUEST_SUMMARY_URL;

