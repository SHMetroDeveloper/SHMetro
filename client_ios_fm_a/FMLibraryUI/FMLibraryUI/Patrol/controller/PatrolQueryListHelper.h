//
//  PatrolHistoryListHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolTaskEntity.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, PatrolQueryListEventType) {
    PATROL_QUERY_LIST_EVENT_UNKNOW,
    PATROL_QUERY_LIST_SHOW_DETAIL
};

@interface PatrolQueryListHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;


- (void) setDataWithArray:(NSMutableArray *) tasks;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
