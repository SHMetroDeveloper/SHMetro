//
//  RoundLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

//  圆形的标签
#import <UIKit/UIKit.h>

@interface RoundLabel : UIImageView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置标签文本
- (void) setContent:(NSString *)content;

//设置字体
- (void) setFont:(UIFont *) font;

//设置文字颜色和边框颜色
- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor;

//设置文字颜色和边框颜色,背景色
- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor backgroundColor:(UIColor *) bgColor;
@end
