//
//  ReservationViewController.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//


#import "BaseViewController.h"

@interface ReservationViewController : BaseViewController

- (instancetype) init;

- (void) setInfoWithWorkOrderId:(NSNumber *) woId code:(NSString *) woCode;
@end
