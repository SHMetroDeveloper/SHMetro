//
//  OnClicklistener.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  view 点击事件

#import <UIKit/UIKit.h>

@protocol OnClickListener <NSObject>

- (void) onClick:(UIView *) view;

@end
