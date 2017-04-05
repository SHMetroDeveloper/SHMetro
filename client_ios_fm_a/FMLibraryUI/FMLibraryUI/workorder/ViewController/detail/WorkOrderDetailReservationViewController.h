//
//  WorkOrderDetailReservationViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkOrderServerConfig.h"

@interface WorkOrderDetailReservationViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWithOrderId:(NSNumber *)woId code:(NSString *) woCode ;

//设置工单状态
- (void) setOrderStatus:(WorkOrderStatus) status;

//设置只读状态，不允许做任何事情
- (void) setReadOnly:(BOOL)readOnly ;

//设置可以预定
- (void) setReserveAble:(BOOL)reserveAble;
@end
