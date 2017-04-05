//
//  ContractQueryFilterViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface ContractQueryFilterViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource,OnMessageHandleListener>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
