//
//  WorkOrderHistoryQueryViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OnListItemButtonClickListener.h"
#import "MMPNavigationProtocols.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderHistoryQueryViewController : BaseViewController <PullTableViewDelegate, OnMessageHandleListener>

@property (nonatomic, assign) id<MMPMainViewDelegate> ldelegate;

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

//设置界面的显示与隐藏
- (void) notifyViewControllerDisplay:(BOOL) needDisplay;

@end
