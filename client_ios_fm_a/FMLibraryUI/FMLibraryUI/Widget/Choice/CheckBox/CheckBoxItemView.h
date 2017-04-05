//
//  PatrolHistoryFilterItemSpotStatusView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  列表项组件，包含一个名字 和一个 复选框

#import <UIKit/UIKit.h>
#import "OnListItemButtonClickListener.h"

@interface CheckBoxItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
               isChecked:(BOOL) isChecked;
//是否选中
- (BOOL) isChecked;

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener;

- (void) setFont:(UIFont*) font;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;

@end
