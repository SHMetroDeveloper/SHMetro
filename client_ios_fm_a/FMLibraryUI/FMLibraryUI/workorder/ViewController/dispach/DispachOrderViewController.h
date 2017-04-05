//
//  DispachOrderViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OnItemClickListener.h"
#import "WorkOrderDispachItemView.h"
#import "OnMessageHandleListener.h"


@interface DispachOrderViewController : BaseViewController <PullTableViewDelegate, OnMessageHandleListener>


- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;


@end

