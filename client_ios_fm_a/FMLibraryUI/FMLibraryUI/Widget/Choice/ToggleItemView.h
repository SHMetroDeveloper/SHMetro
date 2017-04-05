//
//  ToggleItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  开关按钮

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

@interface ToggleItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置名称
- (void) setInfoWithName:(NSString *)name;

//设置上边线的显示与否
- (void) setShowTopSeperator:(BOOL) show;

//设置下边线的显示与否
- (void) setShowBottomSeperator:(BOOL) show;

//设置是否选中
- (void) setStatus:(BOOL) on;

//查看是否选中
- (BOOL) isToggleOn;

//设置左右对齐间距
- (void) setPadding:(CGFloat)padding;

//设置名字字体
- (void) setNameFont:(UIFont *) font;

//值改变
- (void) onSwitchValueChanged;

//设置事件监听
- (void) setOnValueChangedListener:(id<OnMessageHandleListener>) listener;
@end
