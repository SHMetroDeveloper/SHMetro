//
//  WorkOrderDetailMaterialViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//


#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderDetailMaterialViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWithMaterials:(NSArray *) materials;
- (void) setWorkOrderId:(NSNumber *)woId;
- (void) setEditable:(BOOL)editable;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
