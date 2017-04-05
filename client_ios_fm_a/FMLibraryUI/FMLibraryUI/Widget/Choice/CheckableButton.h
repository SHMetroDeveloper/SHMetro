//
//  CheckableButton.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnStateChangeListener;

@interface CheckableButton : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) successStyle;
- (void) errorStyle;
- (void) noticeStyle;
- (void) defaultStyle;

- (BOOL) isChecked;
- (void) setChecked:(BOOL) checked;

- (void) setOnStateChangeListener:(id<OnStateChangeListener>) listener;

@end

@protocol OnStateChangeListener <NSObject>

- (void) onStateChange:(CheckableButton *) btn newState:(BOOL) checked;

@end
