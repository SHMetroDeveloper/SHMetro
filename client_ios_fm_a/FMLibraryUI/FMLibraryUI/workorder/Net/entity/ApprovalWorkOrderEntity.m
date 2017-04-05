//
//  ApprovalWorkOrderEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ApprovalWorkOrderEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"


@implementation ApprovalWorkOrderRequestParam

- (instancetype) initWithOrderId:(NSNumber *) woId content:(NSString *) content operateType:(NSInteger) operateType approvalId:(NSNumber *) approvalId {
    self = [super init];
    if(self) {
        _woId = [woId copy];
        _content = [content copy];
        _operateType = operateType;
        _approvalId = [approvalId copy];
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], WORK_ORDER_APPROVAL_URL];
    return res;
}

@end