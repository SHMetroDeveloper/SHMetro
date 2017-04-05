//
//  CommonFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/5/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "FunctionPermission.h"

extern const NSString * COMMON_FUNCTION;        //公共模块主键

extern const NSString * COMMON_SUB_FUNCTION_PHOTO;       //设置头像
extern const NSString * COMMON_SUB_FUNCTION_PHONE;       //设置手机号
extern const NSString * COMMON_SUB_FUNCTION_PASSWORD;    //修改密码
extern const NSString * COMMON_SUB_FUNCTION_DOWNLOAD;    //下载离线数据
extern const NSString * COMMON_SUB_FUNCTION_FEEDBACK;    //意见反馈

@interface CommonFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end

