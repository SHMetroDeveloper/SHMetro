//
//  PatrolTaskItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "PatrolTaskEntity.h"

@interface PatrolTaskItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithName: (NSString*) name
               startTime: (NSString*) startTime
                 endTime: (NSString*) endTime
                    spot: (NSInteger) spotCount
                  device: (NSInteger) deviceCount
                taskType:(PatrolTaskType) type
                isFinish: (BOOL) isFinish
                     syn:(NSNumber *) syn
                  submit: (BOOL) showSubmit;

//- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
+ (CGFloat) calculateHeight;

@end
