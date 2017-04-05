//
//  DemandDetailEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementDetailEntity.h"
#import "ServiceCenterServerConfig.h"
#import "SystemConfig.h"
#import "FMUtils.h"

@implementation RequirementDetailRequestParam
- (instancetype)initWithReqId:(NSNumber *)reqId {
    self = [super init];
    if (self) {
        _reqId = reqId;
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress], GET_REQUIREMENT_DETAIL_URL];

    return res;
}
@end

@implementation RequirementRequestor
@end

@implementation RequirementRecord
@end

@implementation RequirementOrder
@end

@implementation RequirementAttachment
@end

@implementation RequirementEquipment
@end

@implementation RequirementDetailEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _records = [NSMutableArray new];
        _orders = [NSMutableArray new];
        _audios = [NSMutableArray new];
        _images = [NSMutableArray new];
        _videos = [NSMutableArray new];
        _attachment = [NSMutableArray new];
        _equipment = [NSMutableArray new];
    }
    return self;
}
+ (NSDictionary *) mj_objectClassInArray {
    return @{@"records" : @"RequirementRecord",
             @"orders" : @"RequirementOrder",
             @"attachment" : @"RequirementAttachment",
             @"equipment" : @"RequirementEquipment"
             };
}

//获取状态的描述
- (NSString *) getStatusDescription {
    NSString * res = [ServiceCenterServerConfig getRequirementStatusDescriptionBy:_status];
    return res;
}

//获取来源的描述
- (NSString *) getOriginDescription {
    NSString * res = [ServiceCenterServerConfig getRequirementOriginDescriptionBy:_origin];
    return res;
}

//获取时间的描述
- (NSString *) getTimeDescription {
    NSDate * date = [FMUtils timeLongToDate:_createDate];
    NSString * res = [FMUtils getDayStr:date];
    return res;
}

@end


@implementation RequirementDetailResponse



@end
