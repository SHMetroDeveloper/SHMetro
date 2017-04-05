//
//  BaseRadioBoxView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnValueChangedListener.h"

@interface BaseRadioBoxView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setTitle:(NSString *) title;
- (void) setInfoWith:(NSMutableArray *) descArray;

- (NSInteger) getSelectedIndex;
- (void) setSelectIndex:(NSInteger) index;

- (void) setShowBound:(BOOL) showBound;

- (void) setOnValueChangedListener:(id<OnValueChangedListener>) listener;

+ (CGFloat) calculateHeightByCount:(NSInteger) count;

@end
