//
//  BaseNoticeView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/18.
//  Copyright © 2016年 flynn. All rights reserved.
//
// 消息提示框，需要配合 BaseAlertView 使用

#import <UIKit/UIKit.h>

@interface BaseNoticeView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithTitle:(NSString *) title message:(NSString *) msg;

+ (CGSize) calculateSizeByTitle:(NSString *) title content:(NSString *) content width:(CGFloat) width;
@end
