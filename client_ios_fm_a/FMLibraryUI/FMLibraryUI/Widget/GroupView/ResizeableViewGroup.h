//
//  ResizeableViewGroup.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

//#import "ResizeableView.h"
//
//
//@interface ResizeableViewGroup : ResizeableView <OnViewResizeListener>
//
//- (instancetype) init;
//- (instancetype) initWithFrame:(CGRect) frame;
//- (void) setFrame:(CGRect)frame;
//
////设置内部对齐方式
//- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;
//
//
//@end

#import "ResizeableView.h"
#import "OnClickListener.h"

@interface ResizeableViewGroup : ResizeableView <OnViewResizeListener, OnClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

//设置内部对齐方式
- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;
- (void) setOnViewClickedListener:(id<OnClickListener>) listener;

@end

