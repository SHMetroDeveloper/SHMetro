//
//  ReservationDetailBaseView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryServerConfig.h"


@interface ReservationDetailBaseView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithCode:(NSString *) code warehouse:(NSString *) warehouseName date:(NSString *) date orderCode:(NSString *) order desc:(NSString *) desc status:(ReservationStatusType) status;

+ (CGFloat) calculateHeightByDesc:(NSString *) desc width:(CGFloat) width;
@end
