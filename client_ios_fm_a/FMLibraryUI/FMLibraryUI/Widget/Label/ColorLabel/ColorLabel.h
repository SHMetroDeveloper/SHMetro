//
//  ColorLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  彩色小标签

#import <UIKit/UIKit.h>
#import "ResizeableView.h"


@interface ColorLabel : UIImageView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;

//设置文本
- (void) setInfoWithText:(NSString *) text;
- (void) setContent:(NSString *) text;

//设置文本颜色
- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor;
- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor andBackgroundColor:(UIColor *) backgroundColor;

//设置显示圆角或者直角
- (void) setShowCorner:(BOOL) isCircle;

+ (CGSize) calculateSizeByInfo:(NSString *) text;
@end
