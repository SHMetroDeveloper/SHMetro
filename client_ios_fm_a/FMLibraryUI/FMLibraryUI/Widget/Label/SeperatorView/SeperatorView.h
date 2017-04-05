//
//  SeperatorView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

//分割线，
@interface SeperatorView : UILabel

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;
- (void) setLineColor:(UIColor *) color;

//显示上分割线
- (void) setShowTopBound:(BOOL) showTop;

//显示下分割线
- (void) setShowBottomBound:(BOOL) showBottom;

//显示左分割线
- (void) setShowLeftBound:(BOOL) showLeft;

//显示右分割线
- (void) setShowRightBound:(BOOL) showRight;

//是否显示为虚线，需要在 setFrame 之后调用，否则虚线显示会有点问题
- (void) setDotted:(BOOL)isDotted;

@end
