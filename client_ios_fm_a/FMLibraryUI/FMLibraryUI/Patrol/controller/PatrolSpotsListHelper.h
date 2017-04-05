//
//  PatrolSpotsListHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, PatrolSpotsListEventType) {
    PATROL_SPOTS_LIST_EVENT_UNKNOW,
    PATROL_SPOTS_LIST_SHOW_DETAIL
};

@interface PatrolSpotsListHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;


- (void) setDataWithArray:(NSMutableArray *) spots;

- (void) setShowTask:(BOOL)showTask;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end