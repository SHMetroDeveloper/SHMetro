//
//  EquipmentListTableHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"
#import "NetPage.h"

@interface EquipmentListTableHelper : NSObject <UITableViewDelegate,UITableViewDataSource>

- (instancetype) initWithContext:(BaseViewController *) context;

- (void) setEquipmentWithArray:(NSMutableArray *) array;

- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) addOrdersWithArray:(NSMutableArray *) orders;

- (void) removeAllOrders;

- (NSInteger) getOrderCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
