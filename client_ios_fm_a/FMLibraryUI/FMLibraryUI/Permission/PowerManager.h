//
//  PowerManager.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  用来负责业务权限管理

#import <Foundation/Foundation.h>
#import "FunctionPermission.h"

@interface PowerManager : NSObject

+ (instancetype) getInstance;

//通过有权限的 key 数组来初始化权限设置
- (void) initPermissionWithFunctionKeyArray:(NSMutableArray *) array;

//注册模块权限
- (void) registerFunction:(FunctionPermission *) functionPermission;

//获取模块权限, 根据键或者子模块的键 获取模块权限
- (FunctionPermission *) getFunctionPermissionByKey:(const NSString *) key;

//依据键值查询模块权限
- (FunctionAccessPermissionType) getPermissionTypeOfFunctionByMajorKey:(const NSString *) majorKey minorKey:(const NSString *) minorKey;

@end
