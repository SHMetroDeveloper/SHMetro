//
//  BaseTextField.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  单行文本框

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right andLabelWidth:(CGFloat) labelWidth;

//设置文本框左侧的提示文本
- (void) setLabelWithText:(NSString*) labelText;

//设置左侧文本字体
- (void) setLabelFont:(UIFont*) labelFont;

//设置左侧文本颜色
- (void) setLabelColor:(UIColor *) labelColor;

//设置文本框左侧的图片
- (void) setLabelWithImage:(UIImage*) labelImg;

//设置文本框的默认提示
- (void) setPlaceholder:(NSString *)placeholder;

@end
