//
//  OrderApprovalTableHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/3.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  负责待审核工单页面 tabbleview 的数据源和事件代理(向外发事件通知)

#import <Foundation/Foundation.h>
#import "WorkOrderApprovalEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderApprovalEventType) {
    WO_APPROVAL_EVENT_UNKNOW,
    WO_APPROVAL_EVENT_ITEM_CLICK,
};

@interface OrderApprovalTableHelper : NSObject<UITableViewDataSource,UITableViewDelegate>

- (instancetype) initWithContext:(BaseViewController *) context;

- (WorkOrderApproval *) getOrderByPosition:(NSInteger) position;

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
