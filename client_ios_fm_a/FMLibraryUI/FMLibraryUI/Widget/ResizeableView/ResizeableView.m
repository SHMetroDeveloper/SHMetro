//
//  ResizeableView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "ResizeableView.h"


@interface ResizeableView ()


@end

@implementation ResizeableView

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        _defaultHeight = frame.size.height;
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    _defaultHeight = frame.size.height;
}

- (CGFloat) getCurrentHeight {
    return _defaultHeight;
}

- (void) notifyViewNeedResized:(CGSize) newSize {
    if(_resizeListener) {
        [_resizeListener onViewSizeChanged:self newSize:newSize];
    }
}


- (void) setOnViewResizeListener:(id<OnViewResizeListener>) listener {
    _resizeListener = listener;
//    CGSize newSize = CGSizeMake(self.frame.size.width, [self getCurrentHeight]);
//    [_resizeListener onViewSizeChanged:self newSize:newSize];
}

@end
