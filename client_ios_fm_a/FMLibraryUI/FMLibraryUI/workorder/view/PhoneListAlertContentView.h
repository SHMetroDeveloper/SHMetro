//
//  PhoneListAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/8.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "OnMessageHandleListener.h"
#import "BaseViewController.h"



@interface PhoneListAlertContentView : UIView<UITableViewDataSource, UITableViewDelegate>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;


//设置手机号
- (void) setPhones:(NSArray *)phones;

//
- (void) setOnPhoneDelegate:(BaseViewController *) baseVC;

//获取高度
- (CGFloat) getSuitableHeight;

@end
