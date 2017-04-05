//
//  ColorLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ColorLabel.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"

@interface ColorLabel ()

@property (readwrite, nonatomic, strong) UILabel * contentLabel;

@property (readwrite, nonatomic, strong) NSString * content;


@property (readwrite, nonatomic, strong) UIFont * mFont;    //字体

@property (readwrite, nonatomic, strong) UIColor * textColor;   //文本色
@property (readwrite, nonatomic, strong) UIColor * borderColor; //边框色
@property (readwrite, nonatomic, strong) UIColor * bgColor;//背景色

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL showBorder;
@end

@implementation ColorLabel

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

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _showBorder = YES;
        
        _textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _borderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _bgColor = [UIColor clearColor];
        
        _mFont = [FMFont setFontByPX:32];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = _mFont;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        
        self.layer.cornerRadius = [FMSize getInstance].colorLblBorderRadius;
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.clipsToBounds = YES;
        
        [self addSubview:_contentLabel];
        [self updateBackground];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    [_contentLabel setFrame:CGRectMake(0, 0, width, height)];
    [self updateInfo];
}

- (void) updateInfo {
    _contentLabel.text = _content;
}

- (void) updateBackground {
    [self setImage:[FMUtils buttonImageFromColor:_bgColor width:1 height:1]];
}

//设置文本
- (void) setInfoWithText:(NSString *) text {
    _content = [text copy];
    [self updateViews];
}

- (void) setContent:(NSString *) text {
    _content = [text copy];
    [self updateViews];
}

//设置文本颜色
- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor {
    _textColor = textColor;
    _borderColor = borderColor;
    _bgColor = [UIColor clearColor];
    
    _contentLabel.textColor = _textColor;
    
    if(_showBorder) {
        self.layer.borderColor = [_borderColor CGColor];
    }
    [self updateBackground];
}

- (void) setTextColor:(UIColor *) textColor andBorderColor:(UIColor *) borderColor andBackgroundColor:(UIColor *) backgroundColor {
    _textColor = textColor;
    _borderColor = borderColor;
    _bgColor = backgroundColor;
    
    _contentLabel.textColor = _textColor;
    if(_showBorder) {
        self.layer.borderColor = [_borderColor CGColor];
    }
    [self updateBackground];
}

- (void) setShowCorner:(BOOL) isCircle {
    if(isCircle) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].colorLblBorderRadius;
    } else {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = 0;
    }
}

+ (CGSize) calculateSizeByInfo:(NSString *) text {
    CGFloat width = 0;
    CGFloat height = 0;
    CGSize size;
    CGFloat defaultWidth = 100;
    CGFloat defaultHeight = 40;
    CGFloat paddingLeft = 4;
    CGFloat paddingRight = 4;
    CGFloat paddingTop = 3;
    CGFloat paddingBottom = 3;
    UIFont * font = [FMFont setFontByPX:32];;
    
    CGRect frame = CGRectMake(0, 0, defaultWidth, defaultHeight);
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    
    height = [FMUtils heightForStringWith:label value:@"test" andWidth:defaultWidth] + paddingTop + paddingBottom;
    frame.size.height = height;
    [label setFrame:frame];
    width = [FMUtils widthForString:label value:text] + paddingLeft + paddingRight;
    
    size = CGSizeMake(width, height);
    return size;
}

@end
