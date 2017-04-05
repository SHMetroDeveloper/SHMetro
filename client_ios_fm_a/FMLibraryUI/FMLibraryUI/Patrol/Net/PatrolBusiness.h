//
//  PatrolBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "PatrolTaskEntity.h"
#import "SubmitPatrolTaskEntity.h"
#import "PatrolTaskHistoryEntity.h"


typedef NS_ENUM(NSInteger, PatrolBusinessType) {
    BUSINESS_PATROL_UNKNOW,   //
    BUSINESS_PATROL_GET_TASK,       //获取巡检任务
    BUSINESS_PATROL_TASK_UPLOAD,   //任务上传
    BUSINESS_PATROL_QUERY,   //巡检查询
    BUSINESS_PATROL_QUERY_DETAIL,   //巡检查询详情
    BUSINESS_PATROL_EXCEPTION_CONTENT_ITEM_MARK,   //标记异常巡检项为已处理
};

@interface PatrolBusiness : BaseBusiness

//获取工单业务的实例对象
+ (instancetype) getInstance;

//获取巡检任务
- (void) requestPatrolTaskByPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail;

//查询巡检记录
- (void) requestPatrolHistoryByPage:(NetPageParam *) page condition:(PatrolSearchCondition *) con success:(business_success_block) success fail:(business_failure_block) fail;

//获取巡检任务记录详情
- (void) requestPatrolTaskDetailById:(NSNumber *) taskId success:(business_success_block) success fail:(business_failure_block) fail;

//请求上传巡检任务数据
- (void) requestUploadPatrolTask:(SubmitPatrolTaskRequest *) param success:(business_success_block) success fail:(business_failure_block) fail;

//标记异常巡检项为已处理
- (void) requestMarkExceptionContentItem:(NSNumber *) contentId success:(business_success_block) success fail:(business_failure_block) fail;
@end
