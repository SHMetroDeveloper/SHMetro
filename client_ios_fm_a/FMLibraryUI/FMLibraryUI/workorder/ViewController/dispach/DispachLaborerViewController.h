//
//  DispachLaborerViewController.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface DispachLaborerViewController : BaseViewController

//设置工单ID和抢单类型
- (void) setWorkOrderWithId:(NSNumber *) woId;

//设置被选中的执行人
- (void) setSelectedLaborers:(NSMutableArray *) laborers;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
