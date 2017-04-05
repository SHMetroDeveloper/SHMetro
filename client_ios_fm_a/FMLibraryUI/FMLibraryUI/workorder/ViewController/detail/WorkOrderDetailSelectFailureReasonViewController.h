//
//  WorkOrderDetailSelectFailureReasonViewController.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "BaseViewController.h"
#import "NodeList.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderDetailSelectFailureReasonViewController : BaseViewController < UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (instancetype) init;

- (void) setInfoWithWorkOrderId:(NSNumber *) woId;  //设置工单ID
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end

