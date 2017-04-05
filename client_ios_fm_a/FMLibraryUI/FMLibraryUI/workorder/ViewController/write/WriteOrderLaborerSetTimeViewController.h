//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

@interface WriteOrderLaborerSetTimeViewController : BaseViewController <UITextFieldDelegate>

- (instancetype) initWithLaborerName:(NSString *) name;

- (void) setWorkOrderId:(NSNumber *)woId andLaborerId:(NSNumber *)laborerId;
- (void) setArriveTime:(NSNumber *)arriveTime andFinishTime:(NSNumber *) finishTime;
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end