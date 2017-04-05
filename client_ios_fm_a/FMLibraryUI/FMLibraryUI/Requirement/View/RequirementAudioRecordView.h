//
//  RequirementAudioRecordView.h
//  client_ios_fm_a
//
//  Created by Master on 16/7/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface RequirementAudioRecordView : UIView <OnItemClickListener>

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

- (void) setDurationTimesArray:(NSMutableArray<NSNumber *> *) durationArray;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) calculateAudioRecordViewHeightByCount:(NSInteger) count;

@end
