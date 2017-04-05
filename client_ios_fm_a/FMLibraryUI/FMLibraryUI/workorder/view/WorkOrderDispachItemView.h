//
//  WorkOrderDispachItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "ExpandableView.h"
#import "WorkOrderDispachEntity.h"

@interface WorkOrderDispachItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;
- (instancetype) init;
- (void) setFrame:(CGRect)frame;

//- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithWorkJobDetail:(WorkOrderDispach *) order;

//- (void) setShowDispachButton:(BOOL) show;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andLocation:(NSString *) location pfmCode:(NSString *) pfmCode  andWidth:(CGFloat) width;

@end

