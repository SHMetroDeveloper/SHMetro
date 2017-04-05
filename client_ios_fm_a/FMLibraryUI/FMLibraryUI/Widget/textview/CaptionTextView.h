//
//  CaptionTextView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  高度最好设置大于 174
//

#import <UIKit/UIKit.h>
#import "ResizeableView.h"
#import "OnClickListener.h"

@interface CaptionTextView : ResizeableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setTitle:(NSString *) title;
- (void) setPlaceholder:(NSString *) placeholder;
- (void) setText:(NSString *) text;
- (void) setDesc:(NSString *) desc;

- (void) setEditable:(BOOL) editable;

- (void) setMinTextHeight:(CGFloat)minTextHeight;

//设置是否必须（显示红色星号）
- (void) setShowMark:(BOOL) showMark;

- (NSString *) text;

- (void) setOnClickListener:(id<OnClickListener>) listener;
@end
