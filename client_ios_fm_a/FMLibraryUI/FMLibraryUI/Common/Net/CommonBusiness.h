//
//  CommonBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "BaseDataEntity.h"
#import "ServerInfoEntity.h"


typedef NS_ENUM(NSInteger, CommonBusinessType) {
    BUSINESS_COMMON_UNKNOW,   //
    BUSINESS_COMMON_GET_TASK_COUNT_UNDO,       //获取待处理任务数量
    BUSINESS_COMMON_GET_FAILURE_REASON,       //获取故障原因
    BUSINESS_COMMON_GET_FLOW,           //获取流程信息
    BUSINESS_COMMON_GET_EQUIPMENT,       //获取设备信息
    BUSINESS_COMMON_GET_BUILDDING,       //获取站点和区间信息
    BUSINESS_COMMON_GET_BASE_DATA_UPDATE_RECORD, //获取基础数据的更新记录
};

@interface CommonBusiness : BaseBusiness

//获取常规业务的实例对象
+ (instancetype) getInstance;


#pragma mark - 权限查询
//请求待处理的任务的数量
- (void) getTaskCountUndo:(BaseDataGetUndoTaskCountParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//请求故障原因列表
- (void) getFailureReasonByParam:(BaseDataGetFailureReasonRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//请求流程信息
- (void) getFlowByParam:(BaseDataGetFlowListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;


//请求设备信息
- (void) getEquipmentByParam:(BaseDataGetDeviceListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;


//请求站点和区间信息
- (void) getBuildingByParam:(BaseDataGetBuildingListRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取基础数据的更新记录
- (void) getBaseDataUpdateRecordByTime:(NSNumber *) time
                               success:(business_success_block)success
                                  fail:(business_failure_block)fail;
@end
