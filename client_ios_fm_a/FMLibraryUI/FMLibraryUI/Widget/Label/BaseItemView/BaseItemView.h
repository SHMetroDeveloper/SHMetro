//
//  BaseItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  包含 logo ，名字， 状态， 描述


#import <UIKit/UIKit.h>

//描述信息的展示方式
typedef NS_ENUM(NSInteger, BaseItemViewDescType) {
    BASE_ITEM_DESC_TYPE_DEFAULT,  //默认只显示文字
    BASE_ITEM_DESC_TYPE_BOUND_RECT,  //矩形边框
    BASE_ITEM_DESC_TYPE_BOUND_ROUND,  //圆角边框
    BASE_ITEM_DESC_TYPE_RED_BG,  //红底白字
};

@interface BaseItemView : UIButton

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;
- (void) updateViews;

- (void) setInfoWithName:(NSString *) name;
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image;
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image andDesc:(NSString *) desc;
- (void) updateDesc:(NSString *) desc;

- (void) updateStatus:(NSString *) status;
//显示名称和图标
- (void) setInfoWithName:(NSString *) name andImage:(UIImage *) image andDesc:(NSString *) desc andStatus:(NSString *) statusStr;
//设置名字的颜色
- (void) setNameColor:(UIColor *) nameColor;

//设置说明信息颜色
- (void) setDescColor:(UIColor *) descColor;

//设置说明信息字体
- (void) setDescFont:(UIFont *) descFont;

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight;

//设置是否显示向右箭头
- (void) setShowMore:(BOOL) show;

//设置红点
- (void) setShowRedPoint:(BOOL) show;

//设置右侧图标
- (void) setRightImage:(UIImage *) image;

//设置是否显示右侧图标
- (void) setShowRightImage:(BOOL) showRightImage;

//设置右侧图标宽度
- (void) setRightImageWidth:(CGFloat) imgWidth;

//设置是否显示logoImageView 用于左对齐
- (void) setShowLogoImage:(BOOL)showLogoImage;

//设置边框的显示
- (void) setShowBound:(BOOL) show;

//设置logo图标宽度
- (void) setLogoImageWidth:(CGFloat) imgWidth;

//设置左侧区域（name 到边框）的宽度
- (void) setLeftWidth:(CGFloat) width;

//设置描述信息的展示方式
- (void) setDescType:(BaseItemViewDescType) type;
@end
