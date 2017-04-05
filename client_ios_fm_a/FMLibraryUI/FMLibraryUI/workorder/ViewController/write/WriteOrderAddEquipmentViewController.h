//
//  WriteOrderAddEquipmentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailEntity.h"
#import "OnClickListener.h"
#import "OnMessageHandleListener.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, WriteOrderAddEquipmentOperateType) {
    ORDER_EQUIPMENT_TYPE_UNKNOW,    //未知
    ORDER_EQUIPMENT_TYPE_ADD,       //新增
    ORDER_EQUIPMENT_TYPE_EDIT       //编辑
};

@interface WriteOrderAddEquipmentViewController : BaseViewController <UITextFieldDelegate, OnClickListener, OnMessageHandleListener>

- (instancetype) initWithType:(WriteOrderAddEquipmentOperateType) type andTitleName:(NSString *) name;
- (void) setInfoWith:(WorkOrderEquipment *) equip;
- (void) setWorkOrderId:(NSNumber *) woId;
- (void) setEquipmentArrayWithIds:(NSMutableArray *) ids;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
