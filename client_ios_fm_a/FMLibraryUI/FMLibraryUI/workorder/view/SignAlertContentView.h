//
//  SignAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "BaseTextView.h"

typedef NS_ENUM(NSInteger, SignAlertContentOperateType) {
    SIGN_ALERT_OPERATE_TYPE_UNKNOW,
    SIGN_ALERT_OPERATE_TYPE_SIGN,   //签字
    SIGN_ALERT_OPERATE_TYPE_OK,     //OK
};

@interface SignAlertContentView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置标题
- (void) setTitleWithText:(NSString *) title;
//设置提示信息
- (void) setDescWithText:(NSString *) text;

//设置签字图片
- (void) setSignImg:(UIImage *)signImg;

//设置签字图片
- (void) setSignImgWithUrl:(NSURL *) url;

//设置按钮上的操作提示
- (void) setOperationButtonText:(NSString *) text;


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;


@end

