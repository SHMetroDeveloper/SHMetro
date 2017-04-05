//
//  TaskAlertView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

// contentView 的位置
typedef NS_ENUM(NSInteger, AlertContentPosition) {
    ALERT_CONTENT_POSITION_BOTTOM,  //底部
    ALERT_CONTENT_POSITION_TOP,     //顶部
};

@interface TaskAlertView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key;
- (void) removeContentViewByKey:(NSString *) key;
- (void) showType:(NSString *) key;

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key andPadding:(CGFloat)padding andHeight:(CGFloat)height;

- (void) setContentView:(UIView *) contentView withKey:(NSString *) key andHeight:(CGFloat)height andPosition:(AlertContentPosition) position;

- (void) setContentHeight:(CGFloat) height withKey:(NSString *) key;

//设置是否显示渐变色背景
- (void) setShowGradientBackground:(BOOL) showGradient;

//- (void) setPadding:(CGFloat) padding andPaddingTop:(CGFloat) paddingtop;

//显示
- (void) show;

//移动到顶部显示，用于键盘出现的时候
- (void) moveToTopWithHeight:(CGFloat) height andPadding:(CGFloat) paddingTop;

//用于键盘出现的时候向上移动,保持高度不变
- (void) moveUp:(CGFloat) moveHeight;

//移动到顶部显示，用于键盘隐藏的时候
- (void) reset;

//关闭
- (void) close;

- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
