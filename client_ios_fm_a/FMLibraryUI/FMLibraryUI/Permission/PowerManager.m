//
//  PowerManager.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PowerManager.h"
#import "FMUtils.h"

PowerManager * pmInstance;
const NSString * KEY_PRE_NET = @"m-";


@interface PowerManager ()

@property (readwrite, nonatomic, strong) NSMutableDictionary * permissions;

@end

@implementation PowerManager

+ (instancetype) getInstance {
    if(!pmInstance) {
        pmInstance = [[PowerManager alloc] init];
    }
    return pmInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _permissions = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//通过有权限的 key 数组来初始化权限设置
- (void) initPermissionWithFunctionKeyArray:(NSMutableArray *) array {
    for(NSString * tkey in array) {
        NSString * key;
        if([FMUtils isString:tkey startWith:KEY_PRE_NET]) {
            key = [tkey substringFromIndex:KEY_PRE_NET.length];
            if(![FMUtils isStringEmpty:key]) {
                FunctionPermission * permission = [self getFunctionPermissionByKey:key];
                if(permission) {
                    
                    NSString * subKey = [FunctionPermission getSubFunctionKeyFromFullKey:key];
                    
                    FunctionItem * func = [permission getFunctionByKey:subKey];
                    if(func) { //子模块需要入口
                        if(func.isFormal) {
                            [permission setPermissionType:FUNCTION_ACCESS_PERMISSION_SOME];     //把主模块权限设置为 SOME
                        }
                        [permission setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL ofSubFunction:subKey]; //设置子模块权限
                        
                    } else {
                        [permission setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];     //把主模块权限设置为 SOME
                    }
                }
            }
        }
    }
}

//注册模块权限
- (void) registerFunction:(FunctionPermission *) functionPermission {
    if(functionPermission) {
        [_permissions setObject:functionPermission forKey:[functionPermission getKey]];
    }
}

//获取模块权限, 根据键或者子模块的键 获取模块权限
- (FunctionPermission *) getFunctionPermissionByKey:(const NSString *) key {
    FunctionPermission * function;
    NSString * functionKey = [FunctionPermission getFunctionKey:key];
    if(functionKey) {
        function = [_permissions valueForKeyPath:functionKey];
    }
    return function;
}



//依据键值查询模块权限
- (FunctionAccessPermissionType) getPermissionTypeOfFunctionByMajorKey:(NSString *) majorKey minorKey:(NSString *) minorKey {
    FunctionAccessPermissionType type = FUNCTION_ACCESS_PERMISSION_NONE;
    
    FunctionPermission * function = [self getFunctionPermissionByKey:majorKey];
    if(function) {
        if(minorKey) {
            type = [function getPermisstionTypeOfSubFunctionByKey:minorKey];
        } else {
            type = [function getPermissionType];
        }
    }
    return type;
}

@end
