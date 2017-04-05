//
//  QrcodeScanLineView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "QrcodeScanLineView.h"

@interface QrcodeScanLineView ()

@property (readwrite, nonatomic, strong) CAGradientLayer * gradient;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end


@implementation QrcodeScanLineView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _gradient = [CAGradientLayer layer];
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor blackColor].CGColor,
                           (id)[UIColor greenColor].CGColor,
                           (id)[UIColor blackColor].CGColor,
                           nil];
        
        [self.layer insertSublayer:_gradient atIndex:0];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_gradient setFrame:CGRectMake(0, 0, width, height)];
}

@end
