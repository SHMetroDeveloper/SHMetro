//
//  WorkOrderDetailChargeItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  工单收费明细

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"


@interface WorkOrderDetailChargeItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//
- (void) setInfoWithName:(NSString *) name amount:(NSNumber *) amount;

//
- (void) setEditable:(BOOL)editable;

- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;


@end
