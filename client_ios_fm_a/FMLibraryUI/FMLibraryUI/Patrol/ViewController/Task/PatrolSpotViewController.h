//
//  PatrolSpotViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检点位页面---巡检项列表

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "PatrolTaskEntity.h"
#import "PatrolDBHelper.h"

@interface PatrolSpotViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
- (instancetype) init;
- (void) setPatrolSpot:(DBPatrolSpot *) spot;
@end
