//
//  DemandListEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementEntity.h"
#import "SystemConfig.h"
#import "MJExtension.h"
#import "ServiceCenterServerConfig.h"
#import "FMUtils.h"

@implementation RequirementRequestCondition
@end

@implementation RequirementRequestParam

- (instancetype) initWithPage:(NetPageParam *) page
                 andQueryType:(NSInteger) queryType
                 andCondition:(RequirementRequestCondition *) condition {
    self = [super init];
    if (self) {
        
        _queryType = queryType;
        if(condition) {
            _timeStart = condition.timeStart;
            _timeEnd = condition.timeEnd;
        }
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}

- (NSString*) getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_REQUIREMENT_LIST_URL];
    
    return res;
}

@end

@implementation RequirementEntity

- (NSString *) getStatusDescription {
    NSString * res = [ServiceCenterServerConfig getRequirementStatusDescriptionBy:_status];
    return res;
}

- (NSString *) getOriginDescription {
    NSString * res = [ServiceCenterServerConfig getRequirementOriginDescriptionBy:_origin];
    return res;
}

- (NSString *) getTimeDescription {
    NSString * res = @"";
    if(_createDate) {
        NSDate * date = [FMUtils timeLongToDate:_createDate];
        res = [FMUtils getTimeDescriptionByDate:date format:@"MM-dd hh:mm"];
    }
    return res;
}
@end



@implementation RequirementEntityResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"RequirementEntity"
             };
}
@end

@implementation RequirementEntityResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[RequirementEntityResponseData alloc] init];
    }
    return self;
}

@end

