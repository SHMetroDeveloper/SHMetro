//
//  InventoryFunctionPermission.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/13/16.
//  Copyright © 2016 facilityone. All rights reserved.
//


#import "FunctionPermission.h"

extern const NSString * INVENTORY_FUNCTION;        //库存模块主键

extern const NSString * INVENTORY_SUB_FUNCTION_IN;       //入库
extern const NSString * INVENTORY_SUB_FUNCTION_OUT;       //出库
extern const NSString * INVENTORY_SUB_FUNCTION_MOVE;       //移库
extern const NSString * INVENTORY_SUB_FUNCTION_CHECK;       //移库

extern const NSString * INVENTORY_SUB_FUNCTION_RESERVE;       //库存预定
extern const NSString * INVENTORY_SUB_FUNCTION_APPROVAL;   //库存审核
extern const NSString * INVENTORY_SUB_FUNCTION_MY_RESERVATION;    //我的预定
extern const NSString * INVENTORY_SUB_FUNCTION_QUERY;       //库存查询

extern const NSString * INVENTORY_SUB_FUNCTION_RESERVATION_DETAIL;       //预定详情
extern const NSString * INVENTORY_SUB_FUNCTION_MATERIAL_DETAIL;       //物料详情


@interface InventoryFunctionPermission : FunctionPermission

+ (instancetype) getInstance;

//获取模块的访问权限
- (FunctionAccessPermissionType) getPermissionType;

//根据键值获取子模块的访问权限
- (FunctionAccessPermissionType) getPermisstionTypeOfSubFunctionByKey:(NSString *) key;

//初始化本模块的权限配置
+ (void) initFunctionPermission;

@end
