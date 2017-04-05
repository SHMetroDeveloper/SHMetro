//
//  MarqueeView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawMarqueeView;

typedef enum : NSUInteger {
    
    kDrawMarqueeLeft,
    kDrawMarqueeRight,
    
} EDrawMarqueeViewDirection;

@protocol DrawMarqueeViewDelegate <NSObject>

@optional

- (void)drawMarqueeView:(DrawMarqueeView *)drawMarqueeView animationDidStopFinished:(BOOL)finished;

@end


@interface DrawMarqueeView : UIView

/**
 *  DrawMarqueeView's delegate.
 */
@property (nonatomic, weak) id <DrawMarqueeViewDelegate> delegate;

/**
 *  Marquee's speed.
 */
@property (nonatomic) CGFloat                    speed;

/**
 *  Marquee's direction.
 */
@property (nonatomic) EDrawMarqueeViewDirection  marqueeDirection;

/**
 *  Add the contentView to show.
 *
 *  @param view The ContentView.
 */
- (void)addContentView:(UIView *)view;

/**
 *  Start the animation.
 */
- (void)startAnimation;

/**
 *  Stop the animation.
 */
- (void)stopAnimation;

/**
 *  Pause the animation.
 */
- (void)pauseAnimation;

/**
 *  Resume the animation.
 */
- (void)resumeAnimation;

@end
