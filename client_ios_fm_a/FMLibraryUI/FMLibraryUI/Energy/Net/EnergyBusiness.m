//
//  EnergyBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "EnergyBusiness.h"
#import "EnergyNetRequest.h"
#import "MJExtension.h"


EnergyBusiness * energyInstance;

@interface EnergyBusiness ()

@property (readwrite, nonatomic, strong) EnergyNetRequest * netRequest;

@end

@implementation EnergyBusiness
//获取工单业务的实例对象
+ (instancetype) getInstance {
    if(!energyInstance) {
        energyInstance = [[EnergyBusiness alloc] init];
    }
    return energyInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _netRequest = [EnergyNetRequest getInstance];
    }
    return self;
}

//获取设备列表或者筛选设备
- (void) getEnergyTaskListByParam:(EnergyTaskListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            EnergyTaskListResponse * response =  [EnergyTaskListResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ENERGY_TASK_LIST,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ENERGY_TASK_LIST,error);
            }
        }];
    }
}

- (void) requestSubmitEnergyTask:(EnergyTaskSubmitParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(BUSINESS_ENERGY_SUBMIT_TASK,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ENERGY_SUBMIT_TASK,error);
            }
        }];
    }
}

@end
