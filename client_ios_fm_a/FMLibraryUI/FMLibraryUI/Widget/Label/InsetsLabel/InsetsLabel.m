//
//  InsetsLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "InsetsLabel.h"
#import "FMFont.h"
#import "FMTheme.h"


@interface InsetsLabel ()

//边距
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation InsetsLabel

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

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _paddingTop = 15;
        _paddingLeft = 15;
        _paddingBottom = 10;
        _paddingRight = 10;
        
        [self setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [self setFont:[FMFont getInstance].defaultFontLevel2];
    }
}

- (void) drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(_paddingTop, _paddingLeft, _paddingBottom, _paddingRight);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void) setPaddingTop:(CGFloat) paddingTop paddingLeft:(CGFloat) paddingLeft {
    _paddingTop = paddingTop;
    _paddingLeft = paddingLeft;
    [self setNeedsLayout];
    
}



@end
