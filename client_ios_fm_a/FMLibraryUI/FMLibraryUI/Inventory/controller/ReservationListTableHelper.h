//
//  ReservationListTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "NetPage.h"

typedef NS_ENUM(NSInteger, InventoryReservationListEventType) {
    INVENTORY_RESERVATION_LIST_EVENT_UNKNOW,
    INVENTORY_RESERVATION_LIST_EVENT_SHOW_DETAIL    //查看详情
};

@interface ReservationListTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setDataWithArray:(NSMutableArray *) array;

- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) addDataWithArray:(NSMutableArray *) array;

- (id) getDataByPosition:(NSInteger) position;

- (void) removeAllData;

- (NSInteger) getDataCount;

- (void) setShowMore:(BOOL) showMore showSeperator:(BOOL) showSeperator;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
