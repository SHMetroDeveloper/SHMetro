//
//  PatrolTaskListHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolTaskEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, PatrolTaskListEventType) {
    PATROL_TASK_LIST_EVENT_UNKNOW,
    PATROL_TASK_LIST_SHOW_DETAIL
};

@interface PatrolTaskListHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;


- (void) setDataWithArray:(NSMutableArray *) tasks;

- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end