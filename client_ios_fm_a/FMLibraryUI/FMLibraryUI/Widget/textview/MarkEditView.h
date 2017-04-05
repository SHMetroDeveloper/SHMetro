//
//  MarkEditView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextView.h"
#import "OnClickListener.h"
#import "ResizeableView.h"


@interface MarkEditView : BaseTextView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

- (void) setLabelWithText:(NSString *) labelText andWidth:(CGFloat) labelWidth;

- (void) setContent:(NSString *)content;

- (void) setShowMark:(BOOL)showMark;

- (void) setOnViewResizeListener:(id<OnViewResizeListener>)listener;

@end

