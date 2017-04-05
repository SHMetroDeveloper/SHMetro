//
//  EnergyBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "EnergyTaskListEntity.h"
#import "EnergyTaskSubmitEntity.h"

typedef NS_ENUM(NSInteger, EnergyBusinessType){
    BUSINESS_ENERGY_UNKNOW,  //
    BUSINESS_ENERGY_TASK_LIST, //获取抄表任务
    BUSINESS_ENERGY_SUBMIT_TASK,  //提交任务
};


@interface EnergyBusiness : BaseBusiness
//获取工单业务的实例对象
+ (instancetype) getInstance;

//获取设备列表或者筛选设备
- (void) getEnergyTaskListByParam:(EnergyTaskListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//上传任务数据
- (void) requestSubmitEnergyTask:(EnergyTaskSubmitParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

@end
