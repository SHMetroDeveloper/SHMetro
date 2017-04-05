//
//  ContractOperateEntity.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractOperateEntity.h"
#import "SystemConfig.h"
#import "ContractServerConfig.h"

@implementation ContractOperateRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _photos = [NSMutableArray new];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_OPERATE_URL];
    return res;
}
@end
