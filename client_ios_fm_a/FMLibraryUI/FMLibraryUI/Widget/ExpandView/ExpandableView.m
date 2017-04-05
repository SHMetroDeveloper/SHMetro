//
//  ExpandableView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  

#import "ExpandableView.h"


@interface ExpandableView ()

@property (readwrite, nonatomic, assign) BOOL isExpand;
@property (readwrite, nonatomic, strong) id<OnViewExpandStateChangeListener> extendListener;

@end

@implementation ExpandableView

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
    }
    return self;
}

//获取收起状态下得高度
- (CGFloat) getHeightForStateNormal {
    return 0;
}

//获取展开状态下得高度
- (CGFloat) getHeightForStateExpand {
    return 0;
}

- (CGFloat) getCurrentHeight {
    if(_isExpand) {
        return [self getHeightForStateExpand];
    } else {
        return [self getHeightForStateNormal];
    }
}

- (BOOL) isExpand {
    return _isExpand;
}

//设置展开状态
- (void) setExpand:(BOOL) isExpand {
    _isExpand = isExpand;
}

- (void) updateExpandState:(BOOL) isExpand {
    if(_isExpand != isExpand) {
        _isExpand = isExpand;
        [self notifyExpandStateChanged];
    }
}

- (void) notifyExpandStateChanged {
    if(_extendListener) {
        [_extendListener onExpandStateChanged:self state:_isExpand];
    }
}

- (void) setOnViewExpandStateChangeListener:(id<OnViewExpandStateChangeListener>) listener {
    _extendListener = listener;
}



@end
