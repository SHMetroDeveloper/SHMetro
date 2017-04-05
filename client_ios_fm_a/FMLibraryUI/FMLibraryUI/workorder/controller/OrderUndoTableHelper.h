//
//  OrderUndoDataSource.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderUndoEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderUndoEventType) {
    WO_UNDO_EVENT_UNKNOW,
    WO_UNDO_EVENT_ITEM_CLICK
};

@interface OrderUndoTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) initWithContext:(BaseViewController *) context;

- (WorkOrderUndo *) getOrderByPosition:(NSInteger) position;

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
