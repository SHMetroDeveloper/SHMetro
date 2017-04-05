//
//  WorkOrderDetailStepViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//



#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderDetailStepViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWith:(NSMutableArray *) array;

//设置物料费用
- (void) setMaterialCharge:(NSNumber *)materialCharge;

//设置工单ID
- (void) setWorkOrderId:(NSNumber *) woId;

//设置是否允许编辑
- (void) setEditable:(BOOL)editable;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end