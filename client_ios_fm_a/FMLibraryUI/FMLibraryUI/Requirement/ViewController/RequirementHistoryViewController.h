//
//  DemandQueryListControllerViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnListItemButtonClickListener.h"
#import "PullTableView.h"

@interface RequirementHistoryViewController : BaseViewController <PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;



@end
