//
//  LineTextField.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/30.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  底部为线的 输入框

#import <UIKit/UIKit.h>


@interface LineTextField : UITextField

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) initViews;
- (void) updateViews;

- (void) setLineColor:(UIColor *) color;



@end
