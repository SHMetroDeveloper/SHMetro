//
//  WriteOrderAddChargeViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderDetailEntity.h"

@interface WriteOrderAddChargeViewController : BaseViewController

- (instancetype) init;

- (void) setWorkOrderId:(NSNumber *) woId;

- (void) setChargeInfoWithEntity:(WorkOrderChargeItem *) chargeItem;

- (void) setOperateType:(WorkOrderChargeEditType)operateType;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
