//
//  AudioPlayAlertView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, PlayBtnType) {
    PLAY_BUTTON_TYPE_PLAY = 0,
    PLAY_BUTTON_TYPE_STOP = 1,
};

@interface AudioPlayAlertView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect) frame;

- (void) clearAll;
- (void) setDurationTime:(float)sumTime;
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) getPlayViewHeight;

@end