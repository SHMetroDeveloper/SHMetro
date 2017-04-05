//
//  ResizeableLabelView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnClickListener.h"


@interface ResizeableLabelView : ResizeableView <UITextViewDelegate>

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度
@property (readwrite, nonatomic, assign) CGFloat paddingTop;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;  //文本框到右边界的距离宽度

@property (readwrite, nonatomic, assign) CGFloat sepWidth;   //左标签或者图标到文本的距离

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

//设置对齐格式
- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;

//设置标签view 和宽度
- (void) setLabel:(UIView *) leftView andLabelWidth:(CGFloat) labelWidth;
//设置标签view 和宽度
- (void) setLabelWithText:(NSString *) labelText andLabelWidth:(CGFloat) labelWidth;

//设置文本
- (void) setContent:(NSString *) content;
//读取文本内容
- (NSString *) getContent;

//计算所需高度
- (CGFloat) getCurrentHeight;

//设置点击事件监代理
- (void) setOnClickedListener:(id<OnClickListener>) listener;

//计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width ;

@end

