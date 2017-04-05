//
//  WorkOrderFilterViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderHistoryFilterViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource,OnMessageHandleListener>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end