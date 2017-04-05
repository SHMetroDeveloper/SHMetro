//
//  BaseTabbarView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, BaseTabbarStyle) {
    BASE_TABBAR_STYLE_DEFAULT,  //默认样式
    BASE_TABBAR_STYLE_BOTTOM_LINE,  //底部一条线样式
};

@interface BaseTabbarView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithArray:(NSArray *) array;
- (void) setSelected:(NSInteger) position;

- (void) setStyle:(BaseTabbarStyle)style;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
