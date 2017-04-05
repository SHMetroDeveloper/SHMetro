//
//  RequirementManagerBusiness.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/22.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBusiness.h"
#import "NewDemandEntity.h"
#import "RequirementEntity.h"
#import "RequirementDetailEntity.h"
#import "RequirementOperationEntity.h"
#import "RequirementEvaluateEntity.h"


typedef NS_ENUM(NSInteger, RequirementManagementBussinessType){
    BUSINESS_REQUIREMENT_UNKNOW,  //
    BUSINESS_REQUIREMENT_CREATE,
    BUSINESS_REQUIREMENT_LIST, //获取、查询设备列表
    BUSINESS_REQUIREMENT_DETAIL,  //获取设备详情
    BUSINESS_REQUIREMENT_DETAIL_OPERATE,
//    BUSINESS_REQUIREMENT_LIST,  //设备工单记录
};

@interface RequirementManagerBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//上传需求创建信息
- (void) createRequirementByParam:(NewDemandRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail;

//获取待处理需求信息
- (void) getUndoRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待审核需求信息
- (void) getApprovalRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取待评价需求信息
- (void) getCommentRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取需求记录信息
- (void) getHistoryRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//获取需求详情信息
- (void) getRequirementDetailByParam:(RequirementDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//需求详情保存操作
- (void) saveOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//需求详情处理完成操作
- (void) finishOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//需求详情审核通过操作
- (void) passApprovalOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//需求详情审核拒绝操作
- (void) rejectApprovalOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;

//需求详情满意度操作
- (void) evaluateOperateTypeByparam:(RequirementEvaluateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail;


@end
