//
//  InventoryProviderSelectViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface InventoryProviderSelectViewController : BaseViewController<OnMessageHandleListener>

@property (nonatomic, strong) NSNumber *inventoryId;

- (void)setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
