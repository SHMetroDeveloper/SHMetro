//
//  ReservationDetailMaterialView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationDetailEntity.h"

@interface ReservationDetailMaterialView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithMaterial:(ReservationMaterial *) material;

//设置是否显示领用数量
- (void) setShowReceiveAmount:(BOOL) show;

//设置是否显示核定价格
- (void) setShowPirce:(BOOL)showPrice;

+ (CGFloat) calculateHeight;
@end
