//
//  EnergyStarServerConfig.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyServerConfig.h"
#import "BaseBundle.h"

//获取抄表任务
NSString * const GET_METER_MISSION_LIST_URL = @"/m/v2/meterreadings/list";

//提交抄表结果
NSString * const UPLOAD_METER_PARAMETER_URL = @"/m/v1/meterreadings/submit";




@implementation EnergyServerConfig

+ (NSString *) getEnergyCycleDescription:(EnergyCycleType) type {
    NSString * res = @"";
    switch (type) {
        case ENERGY_CYCLE_TYPE_MONTH:
            res = [[BaseBundle getInstance] getStringByKey:@"energy_cycle_month" inTable:nil];
            break;
            
        default:
            res = [[BaseBundle getInstance] getStringByKey:@"energy_cycle_other" inTable:nil];
            break;
    }
    return res;
}

@end
