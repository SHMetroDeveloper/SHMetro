//
//  CommonAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "BaseTextView.h"

typedef NS_ENUM(NSInteger, CommonAlertContentOperateType) {
    COMMON_ALERT_OPERATE_TYPE_UNKNOW,
    COMMON_ALERT_OPERATE_TYPE_LEFT,
    COMMON_ALERT_OPERATE_TYPE_RIGHT
};

@interface CommonAlertContentView : UIView<OnViewResizeListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

//设置标题
- (void) setTitleWithText:(NSString *) title;
//设置提示信息
- (void) setEditLabelWithText:(NSString *) text;
//设置按钮上的操作提示
- (void) setOperationButtonText:(NSString *) text;
- (void) setOperationButtonTextArray:(NSMutableArray *) textArray;

//设置键盘样式
- (void) setTextFieldKeyboardType:(UIKeyboardType) keyboardType;

//设置是否只显示一行
- (void) setShowOneLine:(BOOL) show;
//获取用户输入的信息
- (NSString *) getDesc;
//设置信息
- (void) setDesc:(NSString *) desc;
//清除信息
- (void) clearInput;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;


@end
