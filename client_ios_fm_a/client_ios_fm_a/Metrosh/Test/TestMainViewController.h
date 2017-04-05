//
//  TestMainViewController.h
//  client_ios_fm_a
//
//  Created by flynn.yang on 2017/2/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "BaseViewController.h"

@interface TestMainViewController : UITabBarController<OnMessageHandleListener>

- (instancetype) init;

@end

