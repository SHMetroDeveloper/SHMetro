//
//  MessageViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface MessageViewController : BaseViewController

- (instancetype) init;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener;
@end
