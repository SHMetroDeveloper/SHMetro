//
//  DemandCommentEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementOperationEntity.h"
#import "SystemConfig.h"
#import "ServiceCenterServerConfig.h"
#import "FMUtils.h"

@implementation RequirementOperateRequestParam
- (instancetype)initWithReqId:(NSNumber *) reqId
                        grade:(NSNumber *) gradeId
                         desc:(NSString *) desc
                  operateType:(NSInteger) operateType {
    self = [super init];
    if (self) {
        _reqId = reqId;
        _gradeId = gradeId;
        _desc = desc;
        _operateType = operateType;
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], OPERATE_REQUIREMENT_URL];
    return res;
}

@end
