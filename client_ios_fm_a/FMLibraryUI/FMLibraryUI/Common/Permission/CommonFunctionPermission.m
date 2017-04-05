//
//  CommonFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/5/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "CommonFunctionPermission.h"
#import "PowerManager.h"

const NSString * COMMON_FUNCTION = @"public";        //公共模块主键

const NSString * COMMON_SUB_FUNCTION_PHOTO = @"photo";       //设置头像
const NSString * COMMON_SUB_FUNCTION_PHONE = @"phone";       //设置手机号
const NSString * COMMON_SUB_FUNCTION_PASSWORD = @"password";    //修改密码
const NSString * COMMON_SUB_FUNCTION_DOWNLOAD = @"download";    //下载离线数据
const NSString * COMMON_SUB_FUNCTION_FEEDBACK = @"feedback";    //意见反馈

CommonFunctionPermission * commonPermissionInstance;

@interface CommonFunctionPermission ()

@end


@implementation CommonFunctionPermission
+ (instancetype) getInstance {
    if(!commonPermissionInstance) {
        commonPermissionInstance = [[CommonFunctionPermission alloc] init];
        
        [CommonFunctionPermission initFunctionPermission];
    }
    return commonPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:COMMON_FUNCTION];
    if(self) {
    }
    return self;
}



//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType {
    FunctionAccessPermissionType type = [super getPermissionType];
    return type;
}

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key {
    FunctionAccessPermissionType type = [super getPermisstionTypeOfSubFunctionByKey:key];
    return type;
}

//初始化本模块的权限配置
+ (void) initFunctionPermission {
    
    //模块权限
    [commonPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
    //子模块权限
    //设置头像
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = COMMON_SUB_FUNCTION_PHOTO;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [commonPermissionInstance addOrUpdateSubFunction:item];
    
    //设置手机号
    item = [[FunctionItem alloc] init];
    item.key = COMMON_SUB_FUNCTION_PHONE;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [commonPermissionInstance addOrUpdateSubFunction:item];
    
    //修改密码
    item = [[FunctionItem alloc] init];
    item.key = COMMON_SUB_FUNCTION_PASSWORD;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [commonPermissionInstance addOrUpdateSubFunction:item];
    
    //下载离线数据
    item = [[FunctionItem alloc] init];
    item.key = COMMON_SUB_FUNCTION_DOWNLOAD;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [commonPermissionInstance addOrUpdateSubFunction:item];
    
    //意见反馈
    item = [[FunctionItem alloc] init];
    item.key = COMMON_SUB_FUNCTION_FEEDBACK;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [commonPermissionInstance addOrUpdateSubFunction:item];
}

@end

