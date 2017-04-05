//
//  AcceptWorkOrderEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  接单，退单，暂停，续单，等待，误报

#import "AcceptWorkOrderEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

//typedef NS_ENUM(NSInteger, AcceptWorkOrderOperateType) {
//    ORDER_OPERATE_TYPE_UNKNOW,
//    ORDER_OPERATE_TYPE_ACCEPT  = 1,     //接单
//    ORDER_OPERATE_TYPE_BACK,            //退单
//    ORDER_OPERATE_TYPE_PAUSE,           //暂停
//    ORDER_OPERATE_TYPE_CONTINUE,        //续单
//    ORDER_OPERATE_TYPE_WAIT,            //等待
//    ORDER_OPERATE_TYPE_FALSE            //误报
//};


@implementation AcceptWorkOrderRequestParam

- (instancetype) initWithOrderID:(NSNumber *) woId andOperateType:(NSInteger) operateType andOperateDescription:(NSString *) desc {
    self = [super init];
    if(self) {
        _woId = [woId copy];
        _operateType = operateType;
        _operateDescription = [desc copy];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], ACCEPT_WORK_ORDER_URL];
    return res;
}

@end