//
//  CaptionTextField.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  带标题的输入框, 最佳高度为 92

#import <UIKit/UIKit.h>
#import "OnClickListener.h"

@interface CaptionTextField : UIView

@property (nonatomic, assign) UIKeyboardType keyboardType;

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setTitle:(NSString *) title;
- (void) setPlaceholder:(NSString *) placeholder;
- (void) setText:(NSString *) text;
- (void) setDesc:(NSString *) desc;

- (void) setTitleAttributedString:(NSMutableAttributedString *) attributedString;
- (void) setPlaceholderAttributedString:(NSMutableAttributedString *) attributedString;

- (void) setEditable:(BOOL) editable;

//设置只显示一行
- (void) setShowOneLine:(BOOL) isOneLine;

//设置是否必须（显示红色星号）
- (void) setShowMark:(BOOL) showMark;

- (void) setDetegate:(id<UITextFieldDelegate>) delegate;

- (void) setOnClickListener:(id<OnClickListener>) listener;

- (NSString *) text;

@end
