//
//  WorkOrderApproverEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/30.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "WorkOrderApproverEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

@implementation WorkOrderApproverRequestParam
- (instancetype) initWithPostId:(NSNumber *) postId {
    self = [super init];
    if(self) {
        _postId = postId;
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_WORK_ORDER_APPROVER_URL];
    return res;
}
@end

@implementation WorkOrderApprover
@end


@implementation WorkOrderApproverResponse
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"WorkOrderApprover"
             };
}

@end
