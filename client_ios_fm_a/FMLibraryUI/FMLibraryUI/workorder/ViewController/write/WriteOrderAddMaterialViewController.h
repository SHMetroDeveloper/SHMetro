//
//  WriteOrderAddMaterialViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "WorkOrderDetailEntity.h"
#import "OnMessageHandleListener.h"
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, WriteOrderAddMaterialOperateType) {
    ORDER_MATERIAL_OPERATE_TYPE_UNKNOW,    //未知
    ORDER_MATERIAL_OPERATE_TYPE_ADD,       //新增
    ORDER_MATERIAL_OPERATE_TYPE_EDIT       //编辑
};

@interface WriteOrderAddMaterialViewController : BaseViewController <OnClickListener, OnMessageHandleListener>

- (instancetype) initWithOperateType:(WriteOrderAddMaterialOperateType) operateType;

- (void) setInfoWith:(WorkOrderMaterial *) material;
- (void) setInfoWithMaterialArray:(NSMutableArray *) array;
//设置工单ID 和 仓库 ID
- (void) setInfoWithOrderId:(NSNumber *) orderId warehouseId:(NSNumber *) warehouseId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

