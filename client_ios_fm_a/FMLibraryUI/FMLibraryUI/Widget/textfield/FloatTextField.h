//
//  FloatTextField.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/15.
//  Copyright © 2016年 flynn. All rights reserved.
//
// 带浮动效果的输入框 输入信息之后 placeholder 会缩到左上角

#import <UIKit/UIKit.h>

@interface FloatTextField : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setPlaceholder:(NSString *)placeholder;
- (void) setTextFont:(UIFont *) font;

//需要在 Frame 设置完成之后再调用，否则动画会出问题
- (void) setText:(NSString *) text;
- (void) setSecureTextEntry:(BOOL) secureTextEntry;

- (NSString *) getText;

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents;


@end
