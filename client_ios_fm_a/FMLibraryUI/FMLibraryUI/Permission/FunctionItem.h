//
//  FunctionItem.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/8.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  模块项

#import <Foundation/Foundation.h>

//模块访问权限类型
typedef NS_ENUM(NSInteger, FunctionAccessPermissionType) {
    FUNCTION_ACCESS_PERMISSION_NONE,    //没有任何访问权限
    FUNCTION_ACCESS_PERMISSION_ALL,    //有所有访问权限
    FUNCTION_ACCESS_PERMISSION_SOME    //有部分访问权限
};

@interface FunctionItem : NSObject

@property (readwrite, nonatomic, strong) const NSString * key;       //键(在同一层级下，key 作为唯一标识，用于模块区分)
@property (readwrite, nonatomic, strong) NSString * name;       //名称
@property (readwrite, nonatomic, strong) NSString * iconName;   //图标名称
@property (readwrite, nonatomic, strong) Class entryClass;      //入口类
@property (readwrite, nonatomic, assign) BOOL isFormal;         //是否为正式模块入口
@property (readwrite, nonatomic, assign) FunctionAccessPermissionType permissionType; //权限

@end
