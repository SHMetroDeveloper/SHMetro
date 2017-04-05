//
//  ColorNoticeView.h
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ColorNoticeStyle) {
    COLOR_NOTICE_STYLE_DEFAULT,
    COLOR_NOTICE_STYLE_SUCCESS,
    COLOR_NOTICE_STYLE_INFO,
    COLOR_NOTICE_STYLE_WARNING,
    COLOR_NOTICE_STYLE_ERROR,
};

typedef NS_ENUM(NSInteger, ColorNoticeEventType) {
    COLOR_NOTICE_EVENT_TYPE_UNKNOW,
    COLOR_NOTICE_EVENT_TYPE_LEFT_CLICK, //点击了左侧按钮
    COLOR_NOTICE_EVENT_TYPE_RIGHT_CLICK,//点击了右侧按钮
};

@interface ColorNoticeView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithStyle:(ColorNoticeStyle) style content:(NSString *) content;
- (void) setLeftButtonTitle:(NSString *) leftTitle rightButtonTitle:(NSString *) rightTitle;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

//计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width;
@end
