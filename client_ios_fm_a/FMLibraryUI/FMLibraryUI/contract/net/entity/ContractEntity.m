//
//  ContractEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractEntity.h"
#import "SystemConfig.h"
#import "ContractServerConfig.h"

@implementation ContractEntity
@end

@implementation ContractManagementParam
- (instancetype) initWithPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        _page = [[NetPageParam alloc] init];
        _page.pageSize = page.pageSize;
        _page.pageNumber = page.pageNumber;
    }
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_MANAGEMENT_URL];
    return res;
}
@end

@implementation ContractQueryCondition
- (instancetype) init {
    self = [super init];
    if(self) {
        _status = [[NSMutableArray alloc] init];
        _opStatus = [[NSMutableArray alloc] init];
        _costType = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation ContractQueryParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _page = [[NetPageParam alloc] init];
    }
    return self;
}

- (instancetype) initWithCondition:(ContractQueryCondition *) condition andPage:(NetPageParam *) page {
    self = [super init];
    if(self) {
        _condition = condition;
        
        _page = [[NetPageParam alloc] init];
        _page.pageSize = page.pageSize;
        _page.pageNumber = page.pageNumber;
    }
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_QUERY_URL];
    return res;
}
@end

@implementation ContractQueryResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"ContractEntity"
             };
}
@end

@implementation ContractQueryResponse

@end
