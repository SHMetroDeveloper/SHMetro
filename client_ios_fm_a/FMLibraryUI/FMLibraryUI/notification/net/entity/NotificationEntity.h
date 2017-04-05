//
//  NotificationEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NotificationEntity : NSObject

@property (readwrite, nonatomic, strong) NSNumber * msgId;   //记录ID
@property (readwrite, nonatomic, strong) NSString * title;      //
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, strong) NSNumber * time;       //消息时间
@property (readwrite, nonatomic, assign) NSInteger type;        //通知类型
@property (readwrite, nonatomic, strong) NSNumber * projectId;  //所属项目ID
@property (readwrite, nonatomic, assign) BOOL read;   //是否已读

@property (readwrite, nonatomic, strong) NSNumber * patrolId;   //巡检消息

@property (readwrite, nonatomic, strong) NSNumber * woId;       //工单
@property (readwrite, nonatomic, assign) NSInteger woStatus;

@property (readwrite, nonatomic, strong) NSNumber * assetId;    //资产

@property (readwrite, nonatomic, strong) NSNumber * contractId;    //合同
@property (readwrite, nonatomic, strong) NSNumber * contractStatus;

@property (readwrite, nonatomic, strong) NSNumber * pmId;       //计划性维护
@property (readwrite, nonatomic, strong) NSNumber * todoId;

@property (readwrite, nonatomic, strong) NSNumber * bulletinId; //公告ID

@property (readwrite, nonatomic, strong) NSNumber * reservationId; //预定单ID
@property (readwrite, nonatomic, strong) NSNumber * inventoryId; //物资ID

@property (readwrite, nonatomic, assign) BOOL deleted;   //是否删除
@property (nonatomic, assign) CGFloat itemHeight;

@end
