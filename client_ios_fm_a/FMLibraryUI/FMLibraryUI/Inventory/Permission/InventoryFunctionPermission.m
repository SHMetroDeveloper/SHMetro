//
//  InventoryFunctionPermission.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/13/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryFunctionPermission.h"
#import "PowerManager.h"

#import "BaseBundle.h"
#import "ReservationViewController.h"
#import "MyReservationViewController.h"
#import "InventoryViewController.h"
#import "WarehouseQueryViewController.h"
#import "InventoryStorageInViewController.h"
#import "InventoryStorageOutViewController.h"
#import "InventoryStorageMoveViewController.h"
#import "InventoryMaterialCheckViewController.h"


const NSString * INVENTORY_FUNCTION = @"inventory";

const NSString * INVENTORY_SUB_FUNCTION_IN = @"in";       //入库
const NSString * INVENTORY_SUB_FUNCTION_OUT = @"out";       //出库
const NSString * INVENTORY_SUB_FUNCTION_MOVE = @"move";       //移库
const NSString * INVENTORY_SUB_FUNCTION_CHECK = @"check";       //盘点

const NSString * INVENTORY_SUB_FUNCTION_RESERVE = @"reserve";       //库存预定
const NSString * INVENTORY_SUB_FUNCTION_APPROVAL = @"approval";   //库存审核
const NSString * INVENTORY_SUB_FUNCTION_MY_RESERVATION = @"my";    //我的预定
const NSString * INVENTORY_SUB_FUNCTION_QUERY = @"query";       //库存查询

const NSString * INVENTORY_SUB_FUNCTION_RESERVATION_DETAIL = @"reservation";       //预定详情
const NSString * INVENTORY_SUB_FUNCTION_MATERIAL_DETAIL = @"detail";       //物料详情


InventoryFunctionPermission * inventoryPermissionInstance;

@interface InventoryFunctionPermission ()

@end


@implementation InventoryFunctionPermission


+ (instancetype) getInstance {
    if(!inventoryPermissionInstance) {
        inventoryPermissionInstance = [[InventoryFunctionPermission alloc] init];
        
        [InventoryFunctionPermission initFunctionPermission];
    }
    return inventoryPermissionInstance;
}

- (instancetype) init {
    self = [super initWithKey:INVENTORY_FUNCTION];
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
    [inventoryPermissionInstance setPermissionType:FUNCTION_ACCESS_PERMISSION_NONE];
    
    //子模块权限
    //入库
    FunctionItem * item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_IN;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_in" inTable:nil];
    item.iconName = @"inventory_function_storage_in";
    item.entryClass = [InventoryStorageInViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //出库
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_OUT;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_out" inTable:nil];
    item.iconName = @"inventory_function_storage_out";
    item.entryClass = [InventoryStorageOutViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //移库
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_MOVE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_move" inTable:nil];
    item.iconName = @"inventory_function_storage_move";
    item.entryClass = [InventoryStorageMoveViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //盘点
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_CHECK;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_storage_count" inTable:nil];
    item.iconName = @"inventory_function_storage_count";
    item.entryClass = [InventoryMaterialCheckViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //预定
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_RESERVE;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_reserve" inTable:nil];
    item.iconName = @"inventory_function_storage_reserve";
    item.entryClass = [ReservationViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //我的预定
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_MY_RESERVATION;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_reserved" inTable:nil];
    item.iconName = @"inventory_function_storage_myhistory";
    item.entryClass = [MyReservationViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //库存审核
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_APPROVAL;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_approval" inTable:nil];
    item.iconName = @"inventory_function_approval";
    item.entryClass = [InventoryViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
    //库存查询
    item = [[FunctionItem alloc] init];
    item.key = INVENTORY_SUB_FUNCTION_QUERY;
    item.name = [[BaseBundle getInstance] getStringByKey:@"function_inventory_history" inTable:nil];
    item.iconName = @"inventory_function_storage_history";
    item.entryClass = [WarehouseQueryViewController class];
    item.permissionType = FUNCTION_ACCESS_PERMISSION_NONE;
    item.isFormal = YES;
    [inventoryPermissionInstance addOrUpdateSubFunction:item];
    
}

@end

