//
//  NotificationFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/5/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "NotificationFunctionPermission.h"
#import "PowerManager.h"


const NSString * NOTIFICATION_FUNCTION = @"notification";

const NSString * NOTIFICATION_SUB_FUNCTION_QUERY = @"query";       //

NotificationFunctionPermission * notificationPermissionInstance;

@interface NotificationFunctionPermission ()

@end


@implementation NotificationFunctionPermission
+ (instancetype) getInstance {
    if(!notificationPermissionInstance) {
        notificationPermissionInstance = [[NotificationFunctionPermission alloc] init];
        
        [NotificationFunctionPermission initFunctionPermission];
    }
    return notificationPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:NOTIFICATION_FUNCTION];
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
    [notificationPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
    //子模块权限
    //查询推送消息记录
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = NOTIFICATION_SUB_FUNCTION_QUERY;
    item.name = nil;
    item.iconName = nil;
    item.entryClass = nil;
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [notificationPermissionInstance addOrUpdateSubFunction:item];
    
}

@end
