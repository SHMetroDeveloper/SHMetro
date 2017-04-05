//
//  PatrolCheckViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检项页面---巡检项详情

#import "BaseViewController.h"
#import "PullTableView.h"
#import "PatrolTaskEntity.h"
#import "OnListItemButtonClickListener.h"
#import "QuestionEditViewController.h"
#import "OnValueChangedListener.h"
#import "PatrolDBHelper.h"
#import "OnItemClickListener.h"


@interface PatrolCheckViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, OnQuestionEditFinishedListener>

- (instancetype) init;
- (void) setPatrolTaskSpot:(DBPatrolSpot *) spot withPosition:(NSInteger) position;


/**
 只显示一个设备，不显示上一项下一项
 */
- (void)setShowOneDevice:(BOOL)showOneDevice;

@end
