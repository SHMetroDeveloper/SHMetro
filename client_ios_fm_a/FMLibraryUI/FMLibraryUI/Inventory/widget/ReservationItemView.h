//
//  ReservationItemView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "ReservationEntity.h"

@interface ReservationItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置信息
- (void) setInfoWith:(ReservationEntity *) entity;
- (void) setIsLast:(BOOL)isLast;

//计算所需高度
+ (CGFloat) calculateHeight;

@end
