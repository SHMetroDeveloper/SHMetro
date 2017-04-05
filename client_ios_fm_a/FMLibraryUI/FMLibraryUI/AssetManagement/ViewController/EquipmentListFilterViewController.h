//
//  EquipmentListFilterViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface EquipmentListFilterViewController : BaseViewController <OnMessageHandleListener>


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
