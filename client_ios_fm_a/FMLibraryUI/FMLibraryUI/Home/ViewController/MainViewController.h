//
//  MainViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "BaseViewController.h"

@interface MainViewController : UITabBarController<OnMessageHandleListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;

- (instancetype) initWithType:(BaseVcType) type param:(NSDictionary *) param;

@end
