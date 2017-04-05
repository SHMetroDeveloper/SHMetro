//
//  ContractQueryTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContractEntity.h"
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, ContractQueryEventType) {
    CONTRACT_QUERY_EVENT_UNKNOW,
    CONTRACT_QUERY_EVENT_ITEM_CLICK
};

@interface ContractQueryTableHelper : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;

- (ContractEntity *) getContractByPosition:(NSInteger) position;

- (void) setDataWithArray:(NSMutableArray *) array;

- (void) setPage:(NetPage *)page;

- (NetPage *) getPage;

- (BOOL) isFirstPage;

- (BOOL) hasMorePage;

- (void) addContractsWithArray:(NSMutableArray *) array;

- (void) removeAllContracts;

- (NSInteger) getContractCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
