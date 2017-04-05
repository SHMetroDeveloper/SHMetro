//
//  ResizeableView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  height 值可变的 view

#import <UIKit/UIKit.h>

@protocol OnViewResizeListener;

@interface ResizeableView : UIView

@property (readwrite, nonatomic, strong) id<OnViewResizeListener> resizeListener;   //view大小变化的代理
@property (readwrite, nonatomic, assign) CGFloat defaultHeight;                     //默认高度


- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect)frame;

//子类通过重写该方法来计算当前所需高度
- (CGFloat) getCurrentHeight;

//调用该方法向外发通知
- (void) notifyViewNeedResized:(CGSize) newSize;


//设置 View 大小改变的事件代理
- (void) setOnViewResizeListener:(id<OnViewResizeListener>) listener;

@end


//大小变化监听的接口
@protocol OnViewResizeListener <NSObject>
- (void) onViewSizeChanged:(UIView *) view newSize:(CGSize) newSize;
@end
