//
//  OrderDispatchTableHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/4.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOrderDispachEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderDispatchEventType) {
    WO_DISPATCH_EVENT_UNKNOW,
    WO_DISPATCH_EVENT_ITEM_CLICK,
};

@interface OrderDispatchTableHelper : NSObject <UITableViewDataSource,UITableViewDelegate>

- (instancetype) initWithContext:(BaseViewController *) context;

- (WorkOrderDispach *) getOrderByPosition:(NSInteger) position;

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
