//
//  MissionDetailViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ResizeableView.h"
#import "OnMessageHandleListener.h"

@interface EnergyTaskContentViewController : BaseViewController

- (instancetype)init;


- (void) setInfoWithTitile:(NSString *)title andUnit:(NSString *)unit andResult:(NSString *) result andMeterId:(NSNumber *)meterId;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
