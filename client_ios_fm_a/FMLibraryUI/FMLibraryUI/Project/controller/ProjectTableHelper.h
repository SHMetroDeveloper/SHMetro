//
//  ProjectTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "QuickSearchIndexTable.h"

typedef NS_ENUM(NSInteger, ProjectEventType) {
    PROJECT_EVENT_UNKNOW,
    PROJECT_EVENT_ITEM_CLICK
};

@interface ProjectTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) initWithContext:(UIViewController *) context;

//
- (void) setDataWithArray:(NSMutableArray *) array;

- (void) setSearchHelper:(QuickSearchIndexTable *)searchHelper;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
