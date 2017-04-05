//
//  MarqueeView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "DrawMarqueeView.h"

@interface DrawMarqueeView () <CAAnimationDelegate> {
    
    CGFloat _width;
    CGFloat _height;
    
    CGFloat _animationViewWidth;
    CGFloat _animationViewHeight;
    
    BOOL    _stoped;
    UIView *_contentView;
}

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, assign) BOOL isNotFirstAnimated;

@end

@implementation DrawMarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _width  = frame.size.width;
        _height = frame.size.height;
        
        self.speed               = 1.f;
        self.marqueeDirection    = kDrawMarqueeLeft;
        self.layer.masksToBounds = YES;
        self.animationView       = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
        [self addSubview:self.animationView];
    }
    
    return self;
}

- (void)addContentView:(UIView *)view {
    
    [_contentView removeFromSuperview];
    
    view.frame               = view.bounds;
    _contentView             = view;
    self.animationView.frame = view.bounds;
    [self.animationView addSubview:_contentView];
    
    _animationViewWidth  = self.animationView.frame.size.width;
    _animationViewHeight = self.animationView.frame.size.height;
}

- (void)startAnimation {
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
    _stoped = NO;
    
//    CGPoint pointRightCenter = CGPointMake(_width + _animationViewWidth / 2.f, _animationViewHeight / 2.f);
//    CGPoint pointLeftCenter  = CGPointMake(-_animationViewWidth / 2, _animationViewHeight / 2.f);
    
    CGPoint pointRightCenter = CGPointZero;
    CGPoint pointLeftCenter  = CGPointZero;
    if (!_isNotFirstAnimated) {
        _isNotFirstAnimated = YES;
        pointRightCenter = CGPointMake(_animationViewWidth / 2.f, _animationViewHeight / 2.f);
        pointLeftCenter  = CGPointMake(- _animationViewWidth / 2, _animationViewHeight / 2.f);
    } else {
        pointRightCenter = CGPointMake(_width + _animationViewWidth / 2.f, _animationViewHeight / 2.f);
        pointLeftCenter  = CGPointMake(- _animationViewWidth / 2, _animationViewHeight / 2.f);
    }
    
    CGPoint fromPoint        = self.marqueeDirection == kDrawMarqueeLeft ? pointRightCenter : pointLeftCenter;
    CGPoint toPoint          = self.marqueeDirection == kDrawMarqueeLeft ? pointLeftCenter  : pointRightCenter;
    
    
    self.animationView.center = fromPoint;
    if (_animationViewWidth <= self.frame.size.width) {
        self.animationView.center = CGPointMake(_animationViewWidth/2, _animationViewHeight/2);
        fromPoint = CGPointMake(_animationViewWidth/2, _animationViewHeight/2);
        toPoint = CGPointMake(_animationViewWidth/2, _animationViewHeight/2);
    }
    UIBezierPath *movePath    = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:toPoint];
    
    
    if (_isNotFirstAnimated) {
        //在设定完第一遍动画路径之后，为之后的动画做准备
        pointRightCenter = CGPointMake(_width + _animationViewWidth / 2.f, _animationViewHeight / 2.f);
        pointLeftCenter  = CGPointMake(- _animationViewWidth / 2, _animationViewHeight / 2.f);
        
        fromPoint        = self.marqueeDirection == kDrawMarqueeLeft ? pointRightCenter : pointLeftCenter;
        toPoint          = self.marqueeDirection == kDrawMarqueeLeft ? pointLeftCenter  : pointRightCenter;
        
        self.animationView.center = fromPoint;
    }

    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path                 = movePath.CGPath;
    moveAnimation.removedOnCompletion  = YES;
    moveAnimation.duration             = (fromPoint.x - toPoint.x) / 20.f * (1 / self.speed);
    moveAnimation.delegate             = self;
    [self.animationView.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
}

- (void)stopAnimation {
    _stoped = YES;
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(drawMarqueeView:animationDidStopFinished:)]) {
        
        [self.delegate drawMarqueeView:self animationDidStopFinished:flag];
    }
    
    if (flag && !_stoped) {
        
        [self startAnimation];
    }
}

- (void)pauseAnimation {
    
    [self pauseLayer:self.animationView.layer];
}

- (void)resumeAnimation {
    
    [self resumeLayer:self.animationView.layer];
}

- (void)pauseLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed               = 0.0;
    layer.timeOffset          = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime     = layer.timeOffset;
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    layer.beginTime               = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
}

@end
