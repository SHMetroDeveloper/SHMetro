//
//  AppDelegate.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;


//退出到登陆界面
- (void) logoOut;
- (void) registerDevice;
- (void) unRegisterDevice;
@end

