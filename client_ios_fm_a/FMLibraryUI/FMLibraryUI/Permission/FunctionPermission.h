//
//  FunctionManager.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionItem.h"



@interface FunctionPermission : NSObject

- (instancetype) initWithKey:(const NSString *) key;

//获取模块键值
- (NSString *) getKey;

//获取包括子模块在内的所有模块的键值
- (NSArray *) getAllKeysOfSubFunction;

//获取所有的子模块
- (NSArray *) getAllFunctions;

//根据键值获取子模块信息
- (FunctionItem *) getFunctionByKey:(const NSString *) key;

//获取子模块的实际键值
- (NSString *) getKeyOfSubFunction:(const NSString *) subkey;

//依据键值判断是否属于本模块
- (BOOL) hasSuchFunction:(const NSString *) key;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(const NSString *) subkey;

//设置模块的访问权限
- (void) setPermissionType:(FunctionAccessPermissionType) permissionType;

//添加模块,有就忽略
- (void) addSubFunction:(FunctionItem *) function;

//添加模块，有就更新
- (void) addOrUpdateSubFunction:(FunctionItem *) function;

//设置子模块的访问权限
- (void) setPermissionType:(FunctionAccessPermissionType) permissionType ofSubFunction:(const NSString *) key;

//依据任意给定键值获取主键
+ (NSString *) getFunctionKey:(const NSString *) key;

//获取子模块键值
+ (NSString *) getSubFunctionKeyFromFullKey:(NSString *) fullKey;

//根据模块键值，获取对应的关系模块数组
+ (NSArray *) getKeysFromFullKey:(NSString *) fullKey;
@end
