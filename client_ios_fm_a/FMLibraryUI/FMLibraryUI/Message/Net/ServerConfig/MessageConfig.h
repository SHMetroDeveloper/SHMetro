//
//  MessageConfig.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 2017/2/10.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageItemType) {
    MESSAGE_ITEM_TYPE_ALL = 0,   //所有类型
    MESSAGE_ITEM_TYPE_WORKORDER = 1,   //工单
    MESSAGE_ITEM_TYPE_PATROL = 2,   //巡检
    MESSAGE_ITEM_TYPE_PPM = 3,   //计划性维护
    MESSAGE_ITEM_TYPE_ASSET = 4,   //资产类型消息
    MESSAGE_ITEM_TYPE_REQUIREMENT = 5,   //需求类型消息
    MESSAGE_ITEM_TYPE_INVENTORY = 6,   //库存
    MESSAGE_ITEM_TYPE_CONTRACT = 7,   //合同
    MESSAGE_ITEM_TYPE_BULLETIN = 100,   //公告
};

//全部标记为已读URL
extern NSString * const MESSAGE_READ_MARK_URL;

//消息删除URL
extern NSString * const MESSAGE_DELETE_MARK_URL;

@interface MessageConfig : NSObject

@end


