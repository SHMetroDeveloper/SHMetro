//
//  AcceptWorkOrderEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "NetPage.h"
#import "WorkOrderDetailEntity.h"

typedef NS_ENUM(NSInteger, AcceptWorkOrderOperateType) {
    ORDER_OPERATE_ACCEPT_TYPE_UNKNOW,
    ORDER_OPERATE_ACCEPT_TYPE_ACCEPT = 1,   //接单
    ORDER_OPERATE_ACCEPT_TYPE_REJECT = 2,   //退回
    ORDER_OPERATE_ACCEPT_TYPE_TERMINATE = 3,   //终止
    ORDER_OPERATE_ACCEPT_TYPE_CONTINUE = 4   //继续工作
};

@interface AcceptWorkOrderRequestParam : BaseRequest

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, assign) NSInteger operateType;
@property (readwrite, nonatomic, strong) NSString * operateDescription;

- (instancetype) initWithOrderID:(NSNumber *) woId andOperateType:(NSInteger) operateType andOperateDescription:(NSString *) desc;
- (NSString*) getUrl;

@end