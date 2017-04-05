//
//  PatrolHistoryEquipmentOrderItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolHistoryEquipmentOrderItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithCode:(NSString *) code andLaborder:(NSString *) laborer andTime:(NSString *) time andStatus:(NSString *) status;
//- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

@end
