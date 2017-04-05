//
//  PasswordTextField.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/30.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "LineTextField.h"

@interface PasswordTextField : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (NSString *) text;

- (void) setLineColor:(UIColor *) color;

@end
