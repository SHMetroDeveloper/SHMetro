//
//  MarkedListHeaderView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

typedef NS_ENUM(NSInteger, ListHeaderDescStyle) {
    LIST_HEADER_DESC_STYLE_NONE,    //不显示
    LIST_HEADER_DESC_STYLE_RED_BG,    //红底白字
    LIST_HEADER_DESC_STYLE_BOUND_CIRCLE,    //有边框，圆角
    LIST_HEADER_DESC_STYLE_TEXT_ONLY,    //只显示字
    LIST_HEADER_DESC_STYLE_TEXT_LABEL,    //突出显示文字（描述性文字中标签跟内容分开展示）
};

@interface MarkedListHeaderView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置索要显示的名字，说明文本以及文本的展示方式
- (void) setInfoWithName:(NSString *) name desc:(NSString *) desc andDescStyle:(ListHeaderDescStyle) descStyle;
//设置是否显示向右箭头
- (void) setShowMore:(BOOL)showMore;
//设置是否显示添加图标
- (void) setShowAdd:(BOOL)showAdd;
//设置是否显示添加图标
- (void) setShowEdit:(BOOL)showEdit;
//设置右图标
- (void) setRightImage:(UIImage *) image;
//设置右图标 --- 多个
- (void) setRightImageWithArray:(NSMutableArray *) imgArray;
//设置右图标的宽度
- (void) setRightImgWidth:(CGFloat)rightImgWidth;
//设置是否显示左侧标签
- (void) setShowMark:(BOOL)showMark;
////设置是否显示边框
- (void) setShowBorder:(BOOL)showBorder;
//设置上分割线
- (void) setShowTopBorder:(BOOL) show withPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight;
//设置下分割线
- (void) setShowBottomBorder:(BOOL) show withPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight;
//设置上分割线为虚线
- (void) setTopBorderDotted:(BOOL) show;
//设置下分割线为虚线
- (void) setBottomBorderDotted:(BOOL) show;
//设置描述文字颜色
- (void) setDescColor:(UIColor *) color;

#pragma mark - LIST_HEADER_DESC_STYLE_TEXT_LABEL 样式时使用
//设置描述文字的标签和正文颜色
- (void) setDescLabelColor:(UIColor *) labelColor contentColor:(UIColor *) contentColor;
- (void) setDescLabelFont:(UIFont *) labelFont contentFont:(UIFont *) contentFont;
- (void) setDescLabel:(NSString *) label content:(NSString *) content;



//设置点击事件
- (void) setOnClickListener:(id<OnClickListener>) clickListener;

@end
