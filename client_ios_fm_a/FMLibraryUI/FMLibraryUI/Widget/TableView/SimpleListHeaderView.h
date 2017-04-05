//
//  SimpleListHeaderView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface SimpleListHeaderView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置字体大小
- (void) setTitleFont:(UIFont *)mFont;
//设置字体颜色
- (void) setTitleColor:(UIColor *)mColor;
//设置标题
- (void) setInfoWithText:(NSString *) text;
//设置是否显示上线分割线
- (void) setShowTopLine:(BOOL)showTopLine showBottomLine:(BOOL) showBottomLine;

@end
