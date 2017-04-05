//
//  BaseTextView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnClickListener.h"


//view 的显示模式
typedef NS_ENUM(NSInteger, BaseTextViewMode) {
    BaseTextViewNever,      //不显示
    BaseTextViewAlways      //显示
};

@interface BaseTextView : ResizeableView <UITextViewDelegate>

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度
@property (readwrite, nonatomic, assign) CGFloat paddingTop;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;  //文本框到右边界的距离宽度

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

//设置最大字数限制
- (void)setMaxTextLength:(NSInteger) maxlength;

//设置最大字数限制的字符格式
- (void)setLimitedFont:(UIFont *)font andTextColor:(UIColor *)color;
    
//设置是否可编辑，不可编辑状态下会相应点击事件
- (void) setEditAble:(BOOL) editable;

//设置是否显示边框
- (void) setShowBounds:(BOOL) show;

//设置显示圆角
- (void) setShowCorner:(BOOL) show;

//设置字体大小
- (void) setContentFont:(UIFont *)font;

//设置字体颜色
- (void) setContentColor:(UIColor *)color;

//设置背景色
- (void) setBackgroundColor:(UIColor *)backgroundColor;

//设置最小高度
- (void) setMinHeight:(CGFloat) minHeight;

//设置对齐格式
- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;

//设置标签view 和显示模式
- (void) setLeftView:(UIView *) leftView andLeftViewMode:(BaseTextViewMode) leftViewMode;
- (void) setLeftDesc:(NSString *) leftDesc andLabelWidth:(CGFloat) labelWidth;
- (void) setTopView:(UIView *) topView andTopViewMode:(BaseTextViewMode) topViewMode;

//设置placeholder
- (void) setTopDesc:(NSString *) topDesc;

//设置键盘样式
- (void) setKeyboardType:(UIKeyboardType)KeyboardType;


//设置标签颜色，如果标签为 UILabel 类型
- (void) setDescColor:(UIColor *) color;


//设置文本
- (void) setContentWith:(NSString *) content;

//读取文本内容
- (NSString *) getContent;
//
//设置点击事件监代理
- (void) setOnClickedListener:(id<OnClickListener>) listener;

- (BOOL)resignFirstResponder;
@end

