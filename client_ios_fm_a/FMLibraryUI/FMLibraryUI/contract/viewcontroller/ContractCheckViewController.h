//
//  ContractCheckViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface ContractCheckViewController : BaseViewController

- (void)setContractId:(NSNumber *)contractId;

- (void)setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
