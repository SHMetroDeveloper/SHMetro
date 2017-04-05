//
//  MyReportViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/11/9.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OnItemClickListener.h"
#import "OnMessageHandleListener.h"

@interface MyReportViewController : BaseViewController <PullTableViewDelegate, OnMessageHandleListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;


@end