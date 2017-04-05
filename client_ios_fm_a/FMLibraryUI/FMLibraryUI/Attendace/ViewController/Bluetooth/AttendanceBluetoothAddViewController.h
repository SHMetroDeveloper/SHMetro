//
//  AttendanceBluetoothAddViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface AttendanceBluetoothAddViewController : BaseViewController

- (instancetype) init;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
