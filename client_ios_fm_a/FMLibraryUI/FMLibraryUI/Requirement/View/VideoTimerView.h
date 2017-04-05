//
//  VideoTimerView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnTimerUpdateListener;


@interface VideoTimerView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//判断是否正在计时
- (BOOL) isRunning;

//计数复位
- (void) reset;

//启动计时
- (void) start;

//结束计时
- (void) stop;

//设置最大计时
- (void) setMaxPoint:(NSInteger)maxPoint;

- (void) setOnTimerUpdateListener:(id<OnTimerUpdateListener>) handler;
@end

@protocol OnTimerUpdateListener <NSObject>

@optional
- (void) onTimerStart:(VideoTimerView *) vtimer;
- (void) onTimerFinished:(VideoTimerView *) vtimer;
- (void) onTimerUpdate:(VideoTimerView *) vtimer point:(NSInteger) point;

@end
