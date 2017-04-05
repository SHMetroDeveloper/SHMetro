//
//  ReservationDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseViewController.h"

@interface ReservationDetailViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWithReservationId:(NSNumber *) reservationId;

- (void) setReadonly:(BOOL) readonly;

//设置是否允许编辑操作人
- (void) setCanEditHandler:(BOOL) can;

- (void) setCanCancelReservation:(BOOL) can;

@end
