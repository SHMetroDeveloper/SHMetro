//
//  DispachWorkOrderEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DispachWorkOrderEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"


@implementation DispachWorkOrderLaborer
@end


@implementation DispachWorkOrderRequestParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _laborers = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], WORK_ORDER_DISPACH_URL];
    return res;
}

@end