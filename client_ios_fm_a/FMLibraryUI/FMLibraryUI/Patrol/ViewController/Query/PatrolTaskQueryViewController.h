//
//  PatrolTaskFinishedViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检历史记录页面


#import "BaseViewController.h"
#import "OnListItemButtonClickListener.h"
#import "OnMessageHandleListener.h"

@interface PatrolTaskQueryViewController : BaseViewController <OnMessageHandleListener>

- (void) setFilterHandler:(id<OnMessageHandleListener>)filterHandler;

- (NSNumber *) getTimeStart;
- (NSNumber *) getTimeEnd;

- (void) notifyViewControllerDisplay:(BOOL) needDisplay;

@end
