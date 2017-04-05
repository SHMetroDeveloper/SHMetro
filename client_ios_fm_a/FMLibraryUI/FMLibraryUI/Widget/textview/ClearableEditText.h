//
//  ClearableEditText.h
//  JieMianKuangJia
//
//  Created by admin on 15/4/8.
//  Copyright (c) 2015年 bill zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearableEditText : UIView

- (void) setFrame:(CGRect )frame;

- (void) setPlaceHoler:(NSString *)str;

- (void) setbackgroundimage:(UIImage *)image;

//设置textfield中内容为密码
- (void) secureTextEntry:(BOOL)secure;

- (void) setKeyboard:(UIKeyboardType)keyboardType;

- (void) setValue:(NSString *)value;

- (NSString *) getValue;

@end
