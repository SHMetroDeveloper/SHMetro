//
//  UserServerConfig.m
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "UserServerConfig.h"
#import "SystemConfig.h"

NSString * const USER_INFO_URL = @"/m/v2/user/info";
NSString * const USER_Retrieve_PWD_URL = @"/v1/user/back";
NSString * const USER_EDIT_URL = @"/v1/user/save";
NSString * const USER_CHANGE_PWD_URL = @"/m/v1/user/repwd";
NSString * const USER_BIND_PHONE_URL = @"/m/v1/user/bind";
NSString * const USER_FEEDBACK_URL = @"/m/v2/user/feedback";
NSString * const USER_PHOTO_SET_URL = @"/m/v1/user/photo";
NSString * const USER_LIST_URL = @"/m/v1/user/list";
NSString * const USER_ATTENDANCE_RECORD_LIST_URL = @"/m/v1/user/attendance/list"; //签到记录
NSString * const USER_ATTENDANCE_RECORD_LAST_URL = @"/m/v1/user/attendance/last"; //最后一次签到记录

@implementation UserServerConfig

@end
