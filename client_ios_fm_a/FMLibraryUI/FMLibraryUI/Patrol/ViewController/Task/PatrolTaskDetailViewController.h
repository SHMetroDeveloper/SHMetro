//
//  PatrolTaskDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检详情页面- 点位列表

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OnListItemButtonClickListener.h"
#import "PatrolTaskEntity.h"
#import "PatrolDBHelper.h"
#import "QrCodeViewController.h"
#import "FileUploadListener.h"

@interface PatrolTaskDetailViewController : BaseViewController <OnQrCodeScanFinishedListener, FileUploadListener>

- (instancetype) init;
- (void) setPatrolTask: (DBPatrolTask *) task;

@end
