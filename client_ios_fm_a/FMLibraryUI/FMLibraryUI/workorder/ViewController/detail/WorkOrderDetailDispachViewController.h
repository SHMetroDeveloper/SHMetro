//
//  WorkOrderDetailDispachViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface WorkOrderDetailDispachViewController : BaseViewController
- (instancetype) init;

- (void) setInfoWithOrderId:(NSNumber *) orderId code:(NSString *) code;

//设置预估开始时间和预估完成时间
- (void) setEstimateTimeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd;
@end
