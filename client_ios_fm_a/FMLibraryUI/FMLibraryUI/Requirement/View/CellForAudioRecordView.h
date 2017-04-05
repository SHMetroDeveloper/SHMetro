//
//  CellForAudioRecordView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/17.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, AudioDetailButtonType) {
    AUDIO_PLAY_BUTTON_TYPE,
    AUDIO_DELETE_BUTTON_TYPE,
};


@interface CellForAudioRecordView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void) setEditable:(BOOL ) isEditable;

- (void) setDuriationTime:(NSNumber *) seconds;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) getItemHeight;

@end
