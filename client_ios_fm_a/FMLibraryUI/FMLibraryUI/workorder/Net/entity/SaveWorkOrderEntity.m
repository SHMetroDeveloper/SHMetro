//
//  SaveWorkOrderEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/23.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "SaveWorkOrderEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

@implementation SaveWorkOrderEquipment
@end


@implementation SaveWorkOrderLaborer
@end

@implementation SaveWorkOrderTool
@end

@implementation SaveWorkOrderCharge
@end

@implementation SaveWorkOrderRequestParam
- (instancetype) init {
    self = [super init];
    if(self) {
        _equipments = [[NSMutableArray alloc] init];
        _laborers = [[NSMutableArray alloc] init];
        _tools = [[NSMutableArray alloc] init];
        _pictures = [[NSMutableArray alloc] init];
        _charge = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], WORK_ORDER_SAVE_URL];
    return res;
}
@end