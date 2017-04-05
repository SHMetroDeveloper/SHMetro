//
//  WriteOrderEquipmentExViewController.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/3.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderDetailEntity.h"
#import "OnClickListener.h"
#import "OnMessageHandleListener.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, WriteOrderEquipmentOperateType) {
    ORDER_EQUIPMENT_OPERATE_TYPE_UNKNOW,    //未知
    ORDER_EQUIPMENT_OPERATE_TYPE_ADD,       //新增
    ORDER_EQUIPMENT_OPERATE_TYPE_EDIT       //编辑
};

@interface WriteOrderEquipmentExViewController : BaseViewController <UITextFieldDelegate, OnMessageHandleListener>

- (instancetype) initWithType:(WriteOrderEquipmentOperateType) type andTitleName:(NSString *) name;
- (void) setInfoWith:(WorkOrderEquipment *) equip;
- (void) setWorkOrderId:(NSNumber *) woId;
- (void) setEquipmentArrayWithIds:(NSMutableArray *) ids;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end



