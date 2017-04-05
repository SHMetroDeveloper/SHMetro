//
//  ContractEquipment.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractEquipment.h"
#import "SystemConfig.h"
#import "ContractServerConfig.h"
#import "MJExtension.h"

@implementation ContractEquipment
@end


@implementation ContractEquipmentRequestParam
- (instancetype)initWithContractId:(NSNumber *) contractId andPage:(NetPage *) page {
    self = [super init];
    if(self) {
        _contractId = contractId;
        
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = page.pageNumber;
        _page.pageSize = page.pageSize;
    }
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_QUERY_EQUIPMENT_LIST_URL];
    return res;
}
@end

@implementation ContractEquipmentResponseData
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"contents" : @"ContractEquipment"
             };
}
@end


@implementation ContractEquipmentResponse
@end
