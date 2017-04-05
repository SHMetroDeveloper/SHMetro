//
//  UserBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/4/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "UserBusiness.h"
#import "UserRequest.h"
#import "UserNetRequest.h"
#import "MJExtension.h"
#import "UserEntity.h"


UserBusiness * userBusinessInstance;

@interface UserBusiness ()

@property (readwrite, nonatomic, strong) UserNetRequest * netRequest;

@end

@implementation UserBusiness

+ (instancetype)getInstance {
    
    if(!userBusinessInstance) {
        
        userBusinessInstance = [[UserBusiness alloc] init];
    }
    return userBusinessInstance;
}

- (instancetype) init {
    
    self = [super init];
    if(self) {
        
        _netRequest = [UserNetRequest getInstance];
    }
    return self;
}


/**
 获取当前用户信息
 */
- (void)getCurrentUserInfoSuccess:(business_success_block)success
                             fail:(business_failure_block)fail {
    
    if(_netRequest) {
        
        UserRequest * param = [[UserRequest alloc] init];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            DLog(@"用户信息：%@", responseObject);
            
            UserInfoResponse * response = [UserInfoResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                
                success(BUSINESS_USER_GET_INFO, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(fail) {
                
                fail(BUSINESS_USER_GET_INFO, error);
            }
        }];
    }
}


/**
 获取当前项目下的员工列表
 */
- (void) getUsersOfCurrentProjectSuccess:(business_success_block)success
                                    fail:(business_failure_block)fail {
    
    if(_netRequest) {
        
        SimpleUserRequestParam * param = [[SimpleUserRequestParam alloc] init];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            SimpleUserRequestResponse * response = [SimpleUserRequestResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                
                success(BUSINESS_USER_GET_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(fail) {
                
                fail(BUSINESS_USER_GET_LIST, error);
            }
        }];
    }
}


/**
 获取我的签到记录

 @param timeStart 开始时间
 @param timeEnd 结束时间
 @param page 页数
 */
- (void)getAttendanceRecordByTimeStart:(NSNumber *)timeStart
                               timeEnd:(NSNumber *)timeEnd
                                  page:(NetPage *)page
                               Success:(business_success_block)success
                                  fail:(business_failure_block)fail {
    
    //初始化请求体
    NetPageParam *pageParam = [[NetPageParam alloc] init];
    pageParam.pageNumber = page.pageNumber;
    AttendanceRecordRequest *request = [[AttendanceRecordRequest alloc] initWithTimeStart:timeStart timeEnd:timeEnd page:pageParam];
    
    //开始请求
    [[UserNetRequest getInstance] request:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AttendanceRecordResponse *response = [AttendanceRecordResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            
            success(BUSINESS_USER_GET_ATTENDANCE_RECORD_LIST, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(fail) {
            
            fail(BUSINESS_USER_GET_ATTENDANCE_RECORD_LIST, error);
        }
    }];
}


/**
 获取最后一次签到记录
 */
- (void)getLastAttendanceRecordSuccess:(business_success_block)success
                                  fail:(business_failure_block)fail {
    
    //初始化请求体
    LastAttendanceRecordRequest *request = [[LastAttendanceRecordRequest alloc] init];
    
    //开始请求
    [[UserNetRequest getInstance] request:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LastAttendanceRecordResponse *response = [LastAttendanceRecordResponse mj_objectWithKeyValues:responseObject];
        if(success) {
            
            success(BUSINESS_USER_GET_ATTENDANCE_RECORD_LAST, response.data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(fail) {
            
            fail(BUSINESS_USER_GET_ATTENDANCE_RECORD_LAST, error);
        }
    }];
}

//获取基础数据的更新记录
- (void) getBaseDataUpdateRecordByTime:(NSNumber *) time
                               success:(business_success_block)success
                                  fail:(business_failure_block)fail {
    BaseDataGetUpdateRecordRequestParam *param = [[BaseDataGetUpdateRecordRequestParam alloc] initWith:time];
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            BaseDataGetUpdateRecordResponse * response = [BaseDataGetUpdateRecordResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_USER_GET_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(fail) {
                
                fail(BUSINESS_USER_GET_LIST, error);
            }
        }];
    }
}
@end
