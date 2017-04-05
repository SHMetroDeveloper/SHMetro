//
//  UserBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/4/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseBusiness.h"
#import "ProjectEntity.h"
#import "SimpleUserEntity.h"
#import "NetPage.h"
#import "AttendanceRecordEntity.h"

typedef NS_ENUM(NSInteger, UserBusinessType) {
    
    BUSINESS_USER_UNKNOW,
    BUSINESS_USER_GET_INFO, //获取用户信息
    BUSINESS_USER_CHANGE_PASSWORD, //修改用户密码
    BUSINESS_USER_FEEDBACK, //反馈建议
    BUSINESS_USER_BIND_PHONE, //绑定手机号
    BUSINESS_USER_GET_LIST, //获取用户列表
    BUSINESS_USER_GET_ATTENDANCE_RECORD_LIST, //我的签到记录
    BUSINESS_USER_GET_ATTENDANCE_RECORD_LAST, //最后一次签到记录
};


@interface UserBusiness : BaseBusiness

+ (instancetype)getInstance;

/**
 获取当前用户信息
 */
- (void)getCurrentUserInfoSuccess:(business_success_block)success
                             fail:(business_failure_block) fail;


/**
 获取当前项目下的员工列表
 */
- (void) getUsersOfCurrentProjectSuccess:(business_success_block) success
                                    fail:(business_failure_block) fail;

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
                                  fail:(business_failure_block)fail;


/**
 获取最后一次签到记录
 */
- (void)getLastAttendanceRecordSuccess:(business_success_block)success
                                  fail:(business_failure_block)fail;


/**
 获取基础数据的更新记录

 @param time 记录时间
 */
- (void)getBaseDataUpdateRecordByTime:(NSNumber *) time
                               success:(business_success_block)success
                                  fail:(business_failure_block)fail;
@end
