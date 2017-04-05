//
//  RequirementManagerBusiness.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/22.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "RequirementManagerBusiness.h"
#import "ServiceCenterNetRequest.h"
#import "MJExtension.h"

static RequirementManagerBusiness * instance = nil;

@interface RequirementManagerBusiness()

@property (readonly, nonatomic, strong) ServiceCenterNetRequest * netRequest;

@end

@implementation RequirementManagerBusiness

- (instancetype)init {
    self = [super init];
    if (self) {
        _netRequest = [ServiceCenterNetRequest getInstance];
    }
    return self;
}

+ (instancetype)getInstance {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[RequirementManagerBusiness alloc] init];
        });
    }
    return instance;
}

//上传需求创建信息
- (void) createRequirementByParam:(NewDemandRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(BUSINESS_REQUIREMENT_CREATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_CREATE, error);
            }
        }];
    }
}

//获取待处理需求列表信息
- (void) getUndoRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail{
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RequirementEntityResponse * response = [RequirementEntityResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_REQUIREMENT_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_LIST, error);
            }
        }];
    }
}

//获取待审核需求列表信息
- (void) getApprovalRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail{
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RequirementEntityResponse * response = [RequirementEntityResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_REQUIREMENT_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_LIST, error);
            }
        }];
    }
}

//获取待评价需求信息
- (void) getCommentRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RequirementEntityResponse * response = [RequirementEntityResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_REQUIREMENT_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_LIST, error);
            }
        }];
    }
}

//获取需求记录信息
- (void) getHistoryRequirementListDataByParam:(RequirementRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RequirementEntityResponse * response = [RequirementEntityResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_REQUIREMENT_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_LIST, error);
            }
        }];
    }
}


//获取需求详情信息
- (void) getRequirementDetailByParam:(RequirementDetailRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            RequirementDetailResponse * response = [[RequirementDetailResponse alloc] init];
            response = [RequirementDetailResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL, error);
            }
        }];
    }
}


//需求详情保存操作
- (void) saveOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber * __weak successTag = [NSNumber numberWithBool:YES];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL_OPERATE, successTag);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL_OPERATE, error);
            }
        }];
    }
}

//需求详情处理完成操作
- (void) finishOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber * __weak successTag = [NSNumber numberWithBool:YES];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL_OPERATE, successTag);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL_OPERATE, error);
            }
        }];
    }
}


//需求详情审核通过操作
- (void) passApprovalOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber * __weak successTag = [NSNumber numberWithBool:YES];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL_OPERATE, successTag);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL_OPERATE, error);
            }
        }];
    }
}

//需求详情审核拒绝操作
- (void) rejectApprovalOperateTypeByparam:(RequirementOperateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber * __weak successTag = [NSNumber numberWithBool:YES];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL_OPERATE, successTag);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL_OPERATE, error);
            }
        }];
    }
}


//需求详情满意度操作
- (void) evaluateOperateTypeByparam:(RequirementEvaluateRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSNumber * successTag = [NSNumber numberWithBool:YES];
            if (success) {
                success(BUSINESS_REQUIREMENT_DETAIL_OPERATE, successTag);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_REQUIREMENT_DETAIL_OPERATE, error);
            }
        }];
    }
}


@end





