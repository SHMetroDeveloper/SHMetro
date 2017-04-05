//
//  FunctionManager.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FunctionPermission.h"

NSString * keySeperator = @"-";    //模块标识

@interface FunctionPermission ()

@property (readwrite, nonatomic, strong) NSString * key;    //模块标识
@property (readwrite, nonatomic, assign) FunctionAccessPermissionType permission;    //模块权限

@property (readwrite, nonatomic, strong) NSMutableArray * functions;//存储子模块

@end

@implementation FunctionPermission


- (instancetype) initWithKey:(NSString *) key {
    self = [super init];
    if(self) {
        _key = [key copy];
        _functions = [[NSMutableArray alloc] init];
    }
    return self;
}

//获取模块键值
- (NSString *) getKey {
    return _key;
}

//获取子模块的键值，结构：模块键值 + 分隔符 + 子模块键值
- (NSString *) getKeyOfSubFunction:(const NSString *) subkey {
    NSString * key = [[NSString alloc] initWithFormat:@"%@%@%@", _key, keySeperator, subkey];
    return key;
}

//依据键值判断是否属于本模块
- (BOOL) hasSuchFunction:(NSString *) key {
    BOOL res = NO;
    if(key) {
        NSArray * tmpArray = [key componentsSeparatedByString:keySeperator];
        if([tmpArray count] > 0) {
            NSString * tmpStr = tmpArray[0];
            if([key isEqualToString:tmpStr]) {
                res = YES;
            }
        }
    }
    return res;
}

//获取包括子模块在内的所有模块的键值
- (NSArray *) getAllKeysOfSubFunction {
    NSMutableArray * keys = [[NSMutableArray alloc] init];
    for(FunctionItem * function in _functions) {
        [keys addObject:function.key];
    }
    return keys;
}

//获取所有的子模块
- (NSArray *) getAllFunctions {
    return _functions;
}

//根据键值获取子模块信息
- (FunctionItem *) getFunctionByKey:(const NSString *) key {
    FunctionItem * function;
    if(key) {
        for(FunctionItem * item in _functions) {
            if([item.key isEqualToString:key]) {
                function = item;
                break;
            }
        }
    }
    return function;
}

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType {
    FunctionAccessPermissionType permission = _permission;
    return permission;
}

//依据键值获取子模块信息
- (FunctionItem *) getFunctionItemByKey:(const NSString *) key {
    FunctionItem * function;
    if(key) {
        for(FunctionItem * item in _functions) {
            if([item.key isEqualToString:key]) {
                function = item;
                break;
            }
        }
    }
    return function;
}

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) subkey {
    FunctionAccessPermissionType permission = _permission;
    if(permission == FUNCTION_ACCESS_PERMISSION_SOME) {
        permission = FUNCTION_ACCESS_PERMISSION_NONE;
        FunctionItem * function = [self getFunctionItemByKey:subkey];
        permission = function.permissionType;
    }
    return permission;
}

//设置模块的访问权限
- (void) setPermissionType:(FunctionAccessPermissionType) permissionType {
    _permission = permissionType;
}

//设置子模块的访问权限
- (void) setPermissionType:(FunctionAccessPermissionType) permissionType ofSubFunction:(const NSString *) subkey {
    FunctionItem * function = [self getFunctionItemByKey:subkey];
    if(function) {
        function.permissionType = permissionType;
    }
}

//判断模块是否存在
- (BOOL) isFunctionExist:(FunctionItem *) function {
    BOOL res = NO;
    for(FunctionItem * func in _functions) {
        if(function.key && [function.key isEqualToString:func.key]) {
            res = YES;
            break;
        }
    }
    return res;
}

//添加模块，有就不管
- (void) addSubFunction:(FunctionItem *) function {
    if(![self isFunctionExist:function]) {
        [_functions addObject:function];
    }
}

//添加模块，有就更新
- (void) addOrUpdateSubFunction:(FunctionItem *) function {
    NSInteger index = 0;
    NSInteger count = [_functions count];
    if(function.key) {
        BOOL isOldFunction = NO;
        for(index=0;index<count;index++) {
            FunctionItem * obj = _functions[index];
            if([function.key isEqualToString:obj.key]) {
                _functions[index] = function;
                isOldFunction = YES;
                break;
            }
        }
        if(!isOldFunction) {
            [_functions addObject:function];
        }
    }
    
}

//依据任意给定键值获取主键
+ (NSString *) getFunctionKey:(NSString *) key {
    NSString * res;
    if(key) {
        NSArray * tmpArray = [key componentsSeparatedByString:keySeperator];
        if([tmpArray count] > 0) {
            res = tmpArray[0];
        }
    }
    return res;
}

//获取子模块键值
+ (NSString *) getSubFunctionKeyFromFullKey:(NSString *) fullKey {
    NSString * res;
    if(fullKey) {
        NSArray * tmpArray = [fullKey componentsSeparatedByString:keySeperator];
        if([tmpArray count] > 1) {
            NSString * major = tmpArray[0];
            NSInteger mlen = major.length;
            NSInteger slen = keySeperator.length;
            res = [fullKey substringFromIndex:mlen+slen];
        }
    }
    return res;
}

+ (NSArray *) getKeysFromFullKey:(NSString *) fullKey {
    NSArray * res;
    if(fullKey) {
        res = [fullKey componentsSeparatedByString:keySeperator];
    }
    return res;
}

@end
