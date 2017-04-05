//
//  PhoneBindViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"

@interface PhoneBindViewController : BaseViewController

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
//设置手机号
- (void) setPhone:(NSString *) phone;

@end
