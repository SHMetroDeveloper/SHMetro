//
//  MessageItemModel.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/15.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageItemModel : NSObject

@property (nonatomic, strong) NSNumber * msgId;   //记录ID
@property (nonatomic, strong) NSString * title;      //
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * time;       //消息时间
@property (nonatomic, assign) NSInteger type;        //通知类型
@property (nonatomic, strong) NSNumber * patrolId;
@property (nonatomic, strong) NSNumber * woId;
@property (nonatomic, assign) NSInteger woStatus;
@property (nonatomic, strong) NSNumber * assetId;
@property (nonatomic, strong) NSNumber * pmId;
@property (nonatomic, strong) NSNumber * todoId;
@property (nonatomic, strong) NSNumber * projectId;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) BOOL deleted;   //是否删除
@property (nonatomic, assign) BOOL read;   //是否已读

@end
