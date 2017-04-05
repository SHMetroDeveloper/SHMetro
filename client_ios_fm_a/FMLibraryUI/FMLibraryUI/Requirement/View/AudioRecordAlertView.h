//
//  AudioRecordAlertView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnClickListener.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, RecordButtonType) {
    RECORD_BUTTON_TYPE_START,
    RECORD_BUTTON_TYPE_STOP,
    RECORD_BUTTON_TYPE_PLAY,
    RECORD_BUTTON_TYPE_PAUSE,
    
    RECORD_BUTTON_CANCEL,
    RECORD_BUTTON_DONE,
};

@interface AudioRecordAlertView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect) frame;


- (void) clearAll;
- (void) updateMetersWithAveragePower:(CGFloat)power;
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) getRecordViewHeight;

@end
