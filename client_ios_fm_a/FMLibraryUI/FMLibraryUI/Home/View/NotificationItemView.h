//
//  MessageItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, NotificationItemType) {
//    NOTIFICATION_ITEM_TYPE_UNKNOW = 0,
//    NOTIFICATION_ITEM_TYPE_ORDER = 1,   //工单
//    NOTIFICATION_ITEM_TYPE_PATROL = 2,  //巡检
//    NOTIFICATION_ITEM_TYPE_MAINTENANCE = 3, //计划性维护
//    NOTIFICATION_ITEM_TYPE_ASSET = 4,   //资产
//    NOTIFICATION_ITEM_TYPE_REQUIREMENT = 5,   //需求
//    NOTIFICATION_ITEM_TYPE_INVENTORY = 6    //物料
//};

@interface NotificationItemView : UIView

//- (instancetype) init;
//- (instancetype) initWithFrame:(CGRect)frame;
//- (void) setFrame:(CGRect)frame;

//设置信息
//- (void) setInfoWithTitle:(NSString *)title
//                  content:(NSString *)content
//                     time:(NSNumber *)time
//                     type:(NotificationItemType)type
//                   status:(NSInteger)status
//                     read:(BOOL) isRead;

//根据消息内容计算所需要的高度
//+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width;

@end
