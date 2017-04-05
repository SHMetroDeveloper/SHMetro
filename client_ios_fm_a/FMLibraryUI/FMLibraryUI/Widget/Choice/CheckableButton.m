//
//  CheckableButton.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/16.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "CheckableButton.h"
#import "FMTheme.h"

@interface CheckableButton ()

@property (readwrite, nonatomic, assign) BOOL checked;
@property (readwrite, nonatomic, assign) BOOL showBorder;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) UIColor * themeColor;
@property (readwrite, nonatomic, strong) UIFont * mFont;
@property (readwrite, nonatomic, weak) id<OnStateChangeListener> stateListener;

@end

@implementation CheckableButton

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
    if(!_isInited) {
        _isInited = YES;
        
        _checked = NO;
        _showBorder = YES;
        _mFont = [UIFont fontWithName:@"Helvetica" size:14];
        
        [self.titleLabel setFont:_mFont];
        
        self.layer.cornerRadius = 4;
        [self addTarget:self action:@selector(onClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) updateViews {
    if(_showBorder) {
        self.layer.borderColor = [_themeColor CGColor];
        self.layer.borderWidth = 1;
    } else {
        self.layer.borderWidth = 0;
    }
    if(_checked) {
        self.backgroundColor = _themeColor;
        [self setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:_themeColor forState:UIControlStateNormal];
    }
}

- (void) successStyle {
    _themeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    [self updateViews];
}
- (void) errorStyle {
    _themeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    [self updateViews];
}
- (void) noticeStyle {
    _themeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    [self updateViews];
}
- (void) defaultStyle {
    _themeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    [self updateViews];
}

- (BOOL) isChecked {
    return _checked;
}
- (void) setChecked:(BOOL) checked {
    _checked = checked;
    [self updateViews];
}

- (void) onClicked {
    _checked = !_checked;
    [self updateViews];
    if(_stateListener) {
        [_stateListener onStateChange:self newState:_checked];
    }
}

- (void) setOnStateChangeListener:(id<OnStateChangeListener>) listener {
    _stateListener = listener;
}

@end
