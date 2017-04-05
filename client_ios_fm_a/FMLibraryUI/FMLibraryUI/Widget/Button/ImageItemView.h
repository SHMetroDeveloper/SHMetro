//
//  ImageItemView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface ImageItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置图标和名字
- (void) setInfoWithName:(NSString *) name andLogo:(UIImage *) logoImg;

//设置图标和名字
- (void) setInfoWithName:(NSString *) name andLogo:(UIImage *) logoImg andHighlightLogo:(UIImage *) logoHighlight;

//设置对齐格式
- (void) setPaddingLeft:(CGFloat) paddingLeft
        andPaddingRight:(CGFloat) paddingRight;

//设置logo图标宽度
- (void) setLogoWidth:(CGFloat)logoWidth;

//设置logo图标宽度高度
- (void) setLogoWidth:(CGFloat)logoWidth andLogoHeight:(CGFloat) logoHeight;

//设置文本颜色
- (void) setTextColor:(UIColor *) color;


- (void) setText:(NSString *) text;

//设置点击事件监听
- (void) setOnClickListener:(id<OnClickListener>) listener;

@end

