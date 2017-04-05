//
//  ContractDetailEntity.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractDetailEntity.h"
#import "SystemConfig.h"
#import "ContractServerConfig.h"
#import "MJExtension.h"

@implementation ContractProvider
@end

@implementation ContractOperationRecord
- (instancetype)init {
    self = [super init];
    if (self) {
        _attachment = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"attachment" : @"ContractAttachment"
             };
}
@end

@implementation ContractAttachment
@end

@implementation ContractDynamicText
@end

@implementation ContractDynamicNumber
@end

@implementation ContractDynamicOption
- (instancetype)init {
    self = [super init];
    if (self) {
        _value = [NSMutableArray new];
    }
    return self;
}
@end

@implementation ContractDynamicAttachment
@end

@implementation ContractDynamicDate
@end

@implementation ContractDynamic
- (instancetype)init {
    self = [super init];
    if (self) {
        _text = [NSMutableArray new];
        _number = [NSMutableArray new];
        _option = [NSMutableArray new];
        _attachment = [NSMutableArray new];
        _date = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"text" : @"ContractDynamicText",
             @"number" : @"ContractDynamicNumber",
             @"option" : @"ContractDynamicOption",
             @"attachment" : @"ContractDynamicAttachment",
             @"date" : @"ContractDynamicDate"
             };
}
@end

@implementation ContractDetailEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _history = [NSMutableArray new];
        _attachment = [NSMutableArray new];
        _costType = -1;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"history" : @"ContractOperationRecord",
             @"attachment" : @"ContractAttachment"
             };
}
@end


@implementation ContractDetailRequestParam
- (instancetype) initWithContractId:(NSNumber *) contractId {
    self = [super init];
    if(self) {
        _contractId = contractId;
    }
    return self;
}

-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],CONTRACT_DETAIL_URL];
    return res;
}
@end

@implementation ContractDetailRequestResponse
- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[ContractDetailEntity alloc] init];
    }
    return self;
}
@end
