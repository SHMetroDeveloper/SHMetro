//
//  BaseAlertView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/13.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  弹出框，实现 UIAlertView 效果，内容可自定义

#import <UIKit/UIKit.h>
#import "onClickListener.h"

@interface BaseAlertView : UIView

- (instancetype) init;

//设置内容
- (void) setContentView:(UIView *) contentView;

//设置左右边距
- (void) setPadding:(CGFloat) padding;

//设置内容高度
- (void) setContentHeight:(CGFloat) height;

- (void) show;

- (void) close;

- (void) setOnClickListener:(id<OnClickListener>) listener;

@end
