//
//  ExpandableView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  可展开收起的 view

#import <UIKit/UIKit.h>

@protocol OnViewExpandStateChangeListener;

@interface ExpandableView : UIView

- (instancetype) initWithFrame:(CGRect) frame;

//获取当前的高度
- (CGFloat) getCurrentHeight;

//获取当前的展开状态
- (BOOL) isExpand;

//获取收起状态下得高度---子类通过重写该方法来计算收起状态所需高度
- (CGFloat) getHeightForStateNormal;

//获取展开状态下得高度---子类通过重写该方法来计算展开状态所需高度
- (CGFloat) getHeightForStateExpand;

//更新展开状态---子类扩展状态改变时必须使用本方法进行设置
- (void) updateExpandState:(BOOL) isExpand;

//设置状态改变监听器
- (void) setOnViewExpandStateChangeListener:(id<OnViewExpandStateChangeListener>) listener;

@end

@protocol OnViewExpandStateChangeListener <NSObject>

- (void) onExpandStateChanged:(UIView *) view state:(BOOL) isExpand;

@end
