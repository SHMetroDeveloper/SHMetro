//
//  LimitTextView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/9.
//  Copyright © 2016年 flynn. All rights reserved.
//
// 有最大字数限制的 textview

#import <UIKit/UIKit.h>
#import "BaseTextView.h"

@interface LimitTextView : ResizeableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setContent:(NSString *) content;
- (NSString *) getContent;

- (void) setMaxCapacity:(NSInteger) capacity;

@end
