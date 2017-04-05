//
//  EnergyStarServerConfig.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/26.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EnergyCycleType) {
    ENERGY_CYCLE_TYPE_OTHER,    //其它
    ENERGY_CYCLE_TYPE_MONTH    //一月一次
};

@interface EnergyServerConfig : NSObject

+ (NSString *) getEnergyCycleDescription:(EnergyCycleType) type;

@end



//获取抄表任务
extern NSString * const GET_METER_MISSION_LIST_URL;

//提交抄表结果
extern NSString * const UPLOAD_METER_PARAMETER_URL;