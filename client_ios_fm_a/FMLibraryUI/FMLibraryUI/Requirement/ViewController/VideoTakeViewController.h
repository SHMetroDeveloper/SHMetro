//
//  TestViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"


@interface VideoTakeViewController : BaseViewController
- (instancetype) init;
- (void) setOnMessageHanleListener:(id<OnMessageHandleListener>) handler;
@end
