//
//  VerticalLabelView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  展示 描述+ 内容，垂直方向展示（一般用于点击选择信息的按钮）

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface VerticalLabelView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setDesc:(NSString *) desc;
- (void) setContent:(NSString *) content;
- (void) setPlaceholder:(NSString *) placeholder;

- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
