//
//  OrderMyReportTableHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyReportHistoryEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, OrderMyReportEventType) {
    WO_MYREPORT_EVENT_UNKNOW,
    WO_MYREPORT_EVENT_ITEM_CLICK,
};

@interface OrderMyReportTableHelper : NSObject <UITableViewDelegate,UITableViewDataSource>

- (instancetype) initWithContext:(BaseViewController *) context;

- (MyReportHistory *) getOrderByPosition:(NSInteger) position;

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
