//
//  OrderHistoryTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOrderHistoryEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderHistoryEventType) {
    WO_HISTORY_EVENT_UNKNOW,
    WO_HISTORY_EVENT_ITEM_CLICK
};

@interface OrderHistoryTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) initWithContext:(BaseViewController *) context;

- (WorkOrderHistory *) getOrderByPosition:(NSInteger) position;

- (void) setDataWithArray:(NSMutableArray *) orders;

- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) addOrdersWithArray:(NSMutableArray *) orders;

- (void) removeAllOrders;

- (NSInteger) getOrderCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
