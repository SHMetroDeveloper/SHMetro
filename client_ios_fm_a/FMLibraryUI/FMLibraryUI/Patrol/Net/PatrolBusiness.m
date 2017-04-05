//
//  PatrolBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolBusiness.h"
#import "PatrolServerConfig.h"
#import "PatrolNetRequest.h"
#import "MJExtension.h"
#import "PatrolContentItemExceptionMarkEntity.h"



PatrolBusiness * patrolBusinessInstance;

@interface PatrolBusiness ()

@property (readwrite, nonatomic, strong) PatrolNetRequest * netRequest;

@end

@implementation PatrolBusiness

+ (instancetype) getInstance {
    if(!patrolBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            patrolBusinessInstance = [[PatrolBusiness alloc] init];
        });
    }
    return patrolBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [PatrolNetRequest getInstance];
    }
    return self;
}

//获取巡检任务
- (void) requestPatrolTaskByPage:(NetPageParam *) page success:(business_success_block) success fail:(business_failure_block) fail {
    
    if(_netRequest) {
        PatrolTaskRequest * param = [[PatrolTaskRequest alloc] initWithPage:page];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            PatrolTaskResponse * response = [PatrolTaskResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_PATROL_GET_TASK, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PATROL_GET_TASK, error);
            }
        }];
    }
}


//查询巡检记录
- (void) requestPatrolHistoryByPage:(NetPageParam *) page condition:(PatrolSearchCondition *) con success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        PatrolTaskQueryRequest * param = [[PatrolTaskQueryRequest alloc] initWithPage:page andCondition:con];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            PatrolTaskQueryResponse * response = [PatrolTaskQueryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_PATROL_QUERY, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PATROL_QUERY, error);
            }
        }];
    }
}

//获取巡检任务记录详情
- (void) requestPatrolTaskDetailById:(NSNumber *) taskId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        PatrolTaskDetatilRequest * param = [[PatrolTaskDetatilRequest alloc] initWithTaskId:taskId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            PatrolTaskDetatilResponse * response = [PatrolTaskDetatilResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_PATROL_QUERY_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PATROL_QUERY_DETAIL, error);
            }
        }];
    }
}

//请求上传巡检任务数据
- (void) requestUploadPatrolTask:(SubmitPatrolTaskRequest *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                success(BUSINESS_PATROL_TASK_UPLOAD, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PATROL_TASK_UPLOAD, error);
            }
        }];
    }
}

- (void) requestMarkExceptionContentItem:(NSNumber *) contentId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        PatrolContentItemExceptionMarkRequestParam * param = [[PatrolContentItemExceptionMarkRequestParam alloc] initWithContentId:contentId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            if(success) {
                success(BUSINESS_PATROL_EXCEPTION_CONTENT_ITEM_MARK, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PATROL_EXCEPTION_CONTENT_ITEM_MARK, error);
            }
        }];
    }
}

@end
