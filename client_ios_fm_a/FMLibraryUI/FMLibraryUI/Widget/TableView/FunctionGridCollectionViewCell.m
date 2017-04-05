//
//  BaseCollectionViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 2/10/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "FunctionGridCollectionViewCell.h"
#import "FMTheme.h"

@interface FunctionGridCollectionViewCell ()
@end

@implementation FunctionGridCollectionViewCell

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
    }
    return self;
}

- (void) initViews {
    if(!_functionView) {
        _functionView = [[FunctionItemGridView alloc] init];
        [self addSubview:_functionView];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_functionView setFrame:CGRectMake(0, 0, width, height)];
}

@end
