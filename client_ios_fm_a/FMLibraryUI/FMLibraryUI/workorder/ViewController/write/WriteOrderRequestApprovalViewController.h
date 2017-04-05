//
//  WriteOrderRequestApprovalViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"


@interface WriteOrderRequestApprovalViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWithOrderId:(NSNumber *) orderId;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
