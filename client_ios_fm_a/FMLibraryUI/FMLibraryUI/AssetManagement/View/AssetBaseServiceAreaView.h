//
//  AssetBaseServiceAreaView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/7/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetEquipmentDetailEntity.h"

@interface AssetBaseServiceAreaView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setFlexible:(BOOL) flexible;

- (void) setServiceAreaInfoWith:(nonnull AssetEquipmentServiceZone *) entity;

+ (CGFloat) calculaterHeightBy:(nonnull AssetEquipmentServiceZone *) entity andFlexible:(BOOL) isFlexible;

@end
