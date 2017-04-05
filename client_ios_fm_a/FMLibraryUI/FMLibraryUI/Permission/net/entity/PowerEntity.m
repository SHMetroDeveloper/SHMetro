//
//  PowerEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PowerEntity.h"
#import "SystemConfig.h"
#import "PowerServerConfig.h"

@implementation PowerEntity

@end

@implementation PowerRequestParam
- (instancetype) init {
    self = [super init];
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],POWER_REQUEST_PERMISSION_URL];
    return res;
}
@end


@implementation PowerRequestResponse
@end
