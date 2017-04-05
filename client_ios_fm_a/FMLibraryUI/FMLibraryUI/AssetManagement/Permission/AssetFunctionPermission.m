//
//  AssetFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 1/3/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "AssetFunctionPermission.h"
#import "PowerManager.h"


const NSString * ASSET_FUNCTION = @"asset";

//const NSString * ASSET_SUB_FUNCTION_QUERY = @"calendar";
//const NSString * ASSET_SUB_FUNCTION_DETAIL = @"detail";


AssetFunctionPermission * assetPermissionInstance;

@interface AssetFunctionPermission ()

@end


@implementation AssetFunctionPermission
+ (instancetype) getInstance {
    if(!assetPermissionInstance) {
        assetPermissionInstance = [[AssetFunctionPermission alloc] init];
        
        [AssetFunctionPermission initFunctionPermission];
    }
    return assetPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:ASSET_FUNCTION];
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
    [assetPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_ALL];
    
//    //子模块权限
//    //列表查询
//    FunctionItem * item = [[FunctionItem alloc] init];
//    item.key = ASSET_SUB_FUNCTION_QUERY;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [assetPermissionInstance addOrUpdateSubFunction:item];
//    
//    //资产详情
//    item = [[FunctionItem alloc] init];
//    item.key = ASSET_SUB_FUNCTION_DETAIL;
//    item.name = nil;
//    item.iconName = nil;
//    item.entryClass = nil;
//    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
//    item.isFormal = YES;
//    [assetPermissionInstance addOrUpdateSubFunction:item];
    
}

@end
