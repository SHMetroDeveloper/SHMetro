//
//  WorkOrderFragmentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "ResizeableView.h"
#import "OnItemClickListener.h"

@interface UndoWorkOrderViewController : BaseViewController <PullTableViewDelegate>
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
@end