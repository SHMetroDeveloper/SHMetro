//
//  GrabWorkOrderEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "GrabWorkOrderParam.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

@implementation GrabWorkOrderParam
- (instancetype) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GRAB_WORK_ORDER_URL];
    return res;
}
@end
