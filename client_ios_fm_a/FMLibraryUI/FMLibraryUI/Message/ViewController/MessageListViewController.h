//
//  MessageListViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/31/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "NotificationServerConfig.h"

@interface MessageListViewController : BaseViewController

- (instancetype) init;
- (void) setMsgType:(NotificationItemType) type;

@end
