//
//  AssetBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetEquipmentDetailEntity.h"
#import "OnMessageHandleListener.h"

@interface AssetBaseInfoView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setFlexible:(BOOL) flexible;

- (void) setBasicInfoWith:(AssetEquipmentDetailEntity *) entity;

- (void) setOnMessageHandleListener:(id) handler;

+ (CGFloat) calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *) entity andFlexible:(BOOL)flexible andWidth:(CGFloat)width;

@end
