//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  带图标的 list header

#import <UIKit/UIKit.h>
#import "OnListItemButtonClickListener.h"

@protocol OnListSectionHeaderClickListener;

@interface BaseListHeaderView : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                   image:(UIImage*) rightImage;

- (void) setInfoWithName:(NSString*) name
                    desc:(NSString *) desc
                   image:(UIImage*) rightImage;

- (void) setFont:(UIFont*) font;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;

- (void) setOnListSectionHeaderClickListener:(id<OnListSectionHeaderClickListener>) listener;

@end

@protocol OnListSectionHeaderClickListener <NSObject>

- (void) onListSectionHeaderClick:(UIView *) view;

@end
