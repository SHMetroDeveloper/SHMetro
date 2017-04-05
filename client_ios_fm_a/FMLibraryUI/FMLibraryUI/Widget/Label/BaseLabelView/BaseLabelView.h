//
//  BaseLabelView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface BaseLabelView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置标签文本
- (void) setLabelText:(NSString *) labeltext andLabelWidth:(CGFloat) labelWidth;
//设置标签字体和颜色
- (void) setLabelFont:(UIFont *) labelFont andColor:(UIColor *) labelColor;
//设置内容
- (void) setContent:(NSString *) content;

//设置内容颜色
- (void) setContentColor:(UIColor *) textColor;

//设置内容字体
- (void) setContentFont:(UIFont *) font;


- (void) setShowBounds:(BOOL) showBounds;
//设置边框颜色
- (void) setBoundsColor:(UIColor *) boundColor;

//设置标签的对齐格式
- (void) setLabelAlignment:(NSTextAlignment) alignment;

//设置内容的对齐格式
- (void) setContentAlignment:(NSTextAlignment) alignment;

//设置是否为单行
- (void) setShowOneLine:(BOOL) isOneLine;

//设置点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener;

//在宽度固定的情况下计算所需要的高度
+ (CGFloat) calculateHeightByInfo:(NSString *) content
                             font:(UIFont *) contentFont
                             desc:(NSString *) desc
                        labelFont:(UIFont *) labelFont
                    andLabelWidth:(CGFloat) labelWidth
                         andWidth:(CGFloat) width ;

//在只展示一行的情况下计算所需宽度
+ (CGFloat) calculateWidthByInfo:(NSString *) content font:(UIFont *) contentFont desc:(NSString *) desc labelFont:(UIFont *) labelFont andLabelWidth:(CGFloat) labelWidth;

@end
