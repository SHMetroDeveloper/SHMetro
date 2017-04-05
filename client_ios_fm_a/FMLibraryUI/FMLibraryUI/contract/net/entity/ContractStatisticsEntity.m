//
//  ContractStatisticsEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractStatisticsEntity.h"
#import "SystemConfig.h"
#import "ContractServerConfig.h"

@implementation ContractTypeAmount
@end

@implementation ContractStatisticsEntity

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"amount" : @"ContractTypeAmount"
             };
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _amount = [[NSMutableArray alloc] init];
    }
    return self;
}
@end


@implementation ContractStatisticsRequestParam
-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_STATISTICS_URL];
    return res;
}

@end


@implementation ContractStatisticsResponse
@end
