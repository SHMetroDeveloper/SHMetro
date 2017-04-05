//
//  PatrolTaskHistoryDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检历史记录详情页面

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OnListItemButtonClickListener.h"
#import "PatrolTaskEntity.h"
#import "ExtendibleListHeaderView.h"
#import "PatrolTaskHistoryEntity.h"

@interface PatrolTaskHistoryDetailViewController : BaseViewController
- (instancetype) init;
- (void) setPatrolTaskWithId: (NSNumber *) taskId andTaskName:(NSString *) taskName;
@end