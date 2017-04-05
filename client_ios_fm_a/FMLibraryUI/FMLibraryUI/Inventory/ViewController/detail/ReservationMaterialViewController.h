//
//  ReservationMaterialViewController.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//


#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "BaseDataEntity.h"
#import "OnClickListener.h"
#import "OnMessageHandleListener.h"
#import "ReservationDetailEntity.h"


typedef NS_ENUM(NSInteger, ReservationMaterialOperateType) {
    RESERVATION_MATERIAL_OPERATE_TYPE_UNKNOW,
    RESERVATION_MATERIAL_OPERATE_TYPE_ADD,  //添加
    RESERVATION_MATERIAL_OPERATE_TYPE_EDIT, //编辑
    RESERVATION_MATERIAL_OPERATE_TYPE_EDIT_RESERVED //编辑已经预定的物料
};

@interface ReservationMaterialViewController : BaseViewController <UITextFieldDelegate, OnClickListener, OnMessageHandleListener>

- (instancetype) initWithRequestType:(ReservationMaterialOperateType) type;


- (void) setInfoWithWorkOrderId:(NSNumber *) woId;

- (void) setInfoWithWarehouse:(NSNumber *) warehouseId;

//设置工单相关 的物料信息---预定物料时使用
- (void) setInfoWithMaterials:(NSMutableArray *) materials;
//设置当前正在编辑的物料---预定物料时使用
- (void) setMaterial:(NSMutableDictionary *)material;

//设置当前正在编辑的物料---出库时使用
- (void) setReservationMaterial:(ReservationMaterial *) material;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

