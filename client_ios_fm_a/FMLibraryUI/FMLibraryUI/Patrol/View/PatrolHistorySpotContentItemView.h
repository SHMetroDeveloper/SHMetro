//
//  PatrolHistorySpotContentItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnListItemButtonClickListener.h"

@interface PatrolHistorySpotContentItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                  result:(NSString*) result
                  normal:(NSString*) normalStr
                  report:(NSString*) reportStr;

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;
- (void) setFont:(UIFont*) font;

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener;

@end
