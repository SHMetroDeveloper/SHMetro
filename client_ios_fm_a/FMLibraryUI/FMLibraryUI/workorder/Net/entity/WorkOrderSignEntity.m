//
//  WorkOrderSignEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderSignEntity.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"

@implementation WorkOrderSignRequestParam
-(NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@",[SystemConfig getServerAddress],WORK_ORDER_SIGN_URL];
    return res;
}

- (instancetype) initWithWoId:(NSNumber *) woId
                     signType:(SignatureType) operateType
                        imgId:(NSNumber *) imgId
                         time:(NSNumber *) time {
    self = [super init];
    if (self) {
        _woId = [woId copy];
        _operateType = operateType;
        _signImg = [imgId copy];
        _time = [time copy];
    }
    return self;
}
@end
