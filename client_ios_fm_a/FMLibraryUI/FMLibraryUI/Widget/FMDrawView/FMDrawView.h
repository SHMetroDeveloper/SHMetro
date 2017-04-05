//
//  FMDrawView.h
//  SignUpTest
//
//  Created by 林江锋 on 16/3/7.
//  Copyright © 2016年 Master_Lyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, FMDrawButtonType){
    FMDRAW_BUTTON_DONE,
    FMDRAW_BUTTON_CANCEL,
};

@interface FMDrawView : UIView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;


//设置画板背景图片
- (void)setDrawBoardBackgroundImage:(UIImage *) image;
//设置画笔粗细颜色
- (void)setDrawLineWidth:(CGFloat) width andLineColor:(UIColor *) color;
//获取屏幕截图
- (UIImage *)getScreenshots;
//清除屏幕
- (void) clearScreenShots;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
