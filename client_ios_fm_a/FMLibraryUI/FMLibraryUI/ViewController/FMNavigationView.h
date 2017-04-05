//
//  FMNavigationView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnFMNavigationViewListener;

@interface FMNavigationView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置是否显示返回按钮
- (void) setShowBackButton: (BOOL) show;

//设置是否显示标题
- (void) setShowTitle: (BOOL) show;

//设置是否显示菜单
- (void) setShowMenu: (BOOL) show;

//设置是否显示边框
- (void) setShowBound:(BOOL) show;

//设置标题
- (void) setTitle:(NSString*) title;

//设置图片标题
- (void) setTitleWithImage:(UIImage*) imgTitle;

//设置返回按钮
- (void) setBackBarWithView:(UIView *) backView andbackWidth:(CGFloat) backWidth;

//设置菜单
- (void) setMenuWithArray: (NSArray*) menuArray;

//设置导航栏背景色
- (void) setBackgroundWith:(UIColor *)backgroundColor;

//设置标题颜色
- (void) setTitleColor:(UIColor *) titleColor;

//设置是否显示阴影
- (void) setShowShadow:(BOOL) showShadow;

//设置事件监听器
- (void) setOnFMNavigationViewListener: (NSObject<OnFMNavigationViewListener> *) listener;

@end

@protocol OnFMNavigationViewListener <NSObject>

//返回键被按下
- (void) onBackButtonPressed;

//菜单按钮被按下
- (void) onMenuItemClicked: (NSInteger) position;

@end
