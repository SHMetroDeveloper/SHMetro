//
//  ApplyApprovalWorkOrderEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/30.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ApplyApprovalWorkOrderEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"


@implementation ApplyApprovalParamItem
@end

@implementation ApplyApprovalContent
- (instancetype) init {
    self = [super init];
    if(self) {
        _parameters = [[NSMutableArray alloc] init];
        _approvalType = ORDER_APPLY_APPROVAL_TYPE_MULTI;    //默认为联合审批
    }
    return self;
}
@end


@implementation ApplyApprovalWorkOrderParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _approverIds = [[NSMutableArray alloc] init];
        _approval = [[ApplyApprovalContent alloc] init];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], WORK_ORDER_APPLY_APPROVAL_URL];
    return res;
}

@end

@implementation ApplyApprovalWorkOrderResponse
@end
