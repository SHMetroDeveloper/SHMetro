//
//  WorkOrderOperateEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderOperateEntity.h"
#import "WorkOrderServerConfig.h"
#import "SystemConfig.h"


@implementation WorkOrderOperateRequestParam
- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],OPERATE_WORK_ORDER_URL];
    return res;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

