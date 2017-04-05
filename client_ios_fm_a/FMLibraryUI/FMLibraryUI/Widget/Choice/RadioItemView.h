//
//  RadioItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  包含名字 和一个 单选按钮

#import <UIKit/UIKit.h>
#import "OnListItemButtonClickListener.h"

@interface RadioItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
               isChecked:(BOOL) isChecked;
//是否选中
- (BOOL) isChecked;

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener;

- (void) setFont:(UIFont*) font;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;

@end
