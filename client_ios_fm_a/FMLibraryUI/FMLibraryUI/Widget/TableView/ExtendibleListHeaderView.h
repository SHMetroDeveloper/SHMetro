//
//  ExtendibleListHeaderView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  可展开的列表头

#import <UIKit/UIKit.h>
#import "OnListItemButtonClickListener.h"

@protocol OnListSectionHeaderExtendListener;

@interface ExtendibleListHeaderView : UIButton

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
               extend:(BOOL) extend;
//是否处于展开状态
- (BOOL) isExtend;

- (void) setFont:(UIFont*) font;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;

- (void) setOnListSectionHeaderExtendListener:(id<OnListSectionHeaderExtendListener>) listener;

@end

@protocol OnListSectionHeaderExtendListener <NSObject>

- (void) onListSectionHeaderExtend:(UIView *) view extend:(BOOL) extend;

@end