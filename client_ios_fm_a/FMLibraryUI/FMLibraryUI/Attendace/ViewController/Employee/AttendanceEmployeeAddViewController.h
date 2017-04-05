//
//  AttendanceEmployeeAddViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface AttendanceEmployeeAddViewController : BaseViewController

- (instancetype) init;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
