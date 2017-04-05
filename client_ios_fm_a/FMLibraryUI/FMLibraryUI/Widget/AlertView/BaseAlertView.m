//
//  BaseAlertView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseAlertView.h"
#import "FMSize.h"

@interface BaseAlertView ()

@property (readwrite, nonatomic, strong) UIView * containerView;

@property (readwrite, nonatomic, strong) UIView * contentView;

@property (readwrite, nonatomic, assign) CGFloat defaultContentHeight; //默认高度
@property (readwrite, nonatomic, assign) CGFloat contentHeight; //高度
@property (readwrite, nonatomic, assign) CGFloat padding;   //左右边距

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@end

@implementation BaseAlertView

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
        
        _padding = 20;
        _defaultContentHeight = 200;
        
        _containerView = [[UIView alloc] init];
        
        _containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        self.backgroundColor = [UIColor greenColor];
        
        [self addSubview:_containerView];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_containerView setFrame:CGRectMake(0, 0, width, height)];
    CGFloat contentHeight;
    if(_contentHeight == 0) {
        contentHeight = _defaultContentHeight;
    } else {
        contentHeight = _contentHeight;
    }
    [_contentView setFrame:CGRectMake(_padding, (height-contentHeight)/2, width-_padding * 2, contentHeight)];
    
}

//设置内容
- (void) setContentView:(UIView *) contentView {
    if(_contentView) {
        [_contentView setHidden:YES];
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    [_containerView addSubview:_contentView];
    [self updateViews];
}

//设置左右边距
- (void) setPadding:(CGFloat) padding {
    _padding = padding;
    [self updateViews];
}

//设置内容高度
- (void) setContentHeight:(CGFloat) height {
    _contentHeight = height;
    [self updateViews];
}

#pragma mark - 展示弹出框
- (void) show {
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat time = [FMSize getInstance].defaultAnimationDuration;
    CGFloat contentHeight = _contentHeight;
    if(contentHeight == 0) {
        contentHeight = _defaultContentHeight;
    }
    [self setHidden:NO];
    [_contentView setHidden:NO];
    _contentView.alpha = 0;
    [UIView animateWithDuration:time
                     animations:^{
                         [_contentView setFrame:CGRectMake(_padding, (height-contentHeight)/2, width-_padding * 2, contentHeight)];
                         _contentView.alpha = 1;
                     }];
}

#pragma mark - 隐藏弹出框
- (void) close {
    CGFloat time = [FMSize getInstance].defaultAnimationDuration;
    CGFloat endScale = 0.5;
    [UIView animateWithDuration:time animations:^{
        _contentView.transform = CGAffineTransformMake(endScale, 0, 0, endScale, 0, 0);
        _contentView.alpha = 0;
    }completion:^(BOOL finished) {
        [self setHidden:YES];
        [_contentView setHidden:YES];
        [self restoreContentView];
    }];
}

//contentViews 复位
- (void) restoreContentView {
    CGFloat endScale = 1;
    CGFloat time = [FMSize getInstance].defaultAnimationDuration;
    [UIView animateWithDuration:time animations:^{
        _contentView.transform = CGAffineTransformMake(endScale, 0, 0, endScale, 0, 0);
    }];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClose:)];
        [self addGestureRecognizer:gesture];
    }
    _listener = listener;
}

- (void) onClose:(id) gesture {
    if(_listener) {
        [_listener onClick:self];
    }
}

@end
