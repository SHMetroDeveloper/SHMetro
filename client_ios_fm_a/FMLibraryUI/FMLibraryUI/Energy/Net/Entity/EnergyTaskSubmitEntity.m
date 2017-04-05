//
//  ParameterDetailEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyTaskSubmitEntity.h"
#import "SystemConfig.h"
#import "EnergyServerConfig.h"
#import "FMUtils.h"

@implementation EnergyTaskSubmitParam

- (instancetype)initWithMeterReadingId:(NSNumber *)meterReadingId startDateTime:(NSNumber *)startDateTime endDateTime:(NSNumber *)endDateTime results:(NSMutableArray *)results {
    self = [super init];
    if (self) {
        _meterReadingId = meterReadingId;
        _startDateTime = startDateTime;
        _endDateTime = endDateTime;
        _results = results;
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],UPLOAD_METER_PARAMETER_URL];
    return res;
}

@end



@implementation EnergyTaskResultItem

@end

@implementation EnergyTaskSubmitResponse

@end
