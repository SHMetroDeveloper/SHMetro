//
//  RequirementEvaluateEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "RequirementEvaluateEntity.h"
#import "SystemConfig.h"
#import "ServiceCenterServerConfig.h"
#import "FMUtils.h"


@implementation RequirementEvaluateRequestParam

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], EVALUATE_REQUIREMENT_URL];
    return res;
}

@end
