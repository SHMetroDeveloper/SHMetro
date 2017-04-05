//
//  WriteOrderEquipmentComponentReplaceViewController.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "BaseViewController.h"
#import "WorkOrderSaveEntity.h"

@interface WriteOrderEquipmentComponentReplaceViewController : BaseViewController
- (instancetype) init;
- (void) setInfoWith:(WorkOrderEquipmentOperationRecord *) record;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
