//
//  BaseTextField.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseTextField.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"

@interface BaseTextField ()

@property (readwrite, nonatomic, assign) CGFloat labelWidth;    // 文本框左侧到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;   //标签或者图标到左边界的距离
@property (readwrite, nonatomic, assign) CGFloat paddingRight;  //文本框到右边界的距离宽度

@property (readwrite, nonatomic, assign) CGRect leftViewRect;
@property (readwrite, nonatomic, strong) NSString * labelText;
@property (readwrite, nonatomic, strong) UILabel * leftLabel;
@property (readwrite, nonatomic, strong) UIFont * labelFont;
@property (readwrite, nonatomic, strong) UIColor * labelColor;


@property (readwrite, nonatomic, strong) UIImage * labelImg;
@property (readwrite, nonatomic, strong) UIImageView * leftImgView;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation BaseTextField

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        
        [self updateSubviews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubviews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _labelWidth = 0;        //默认自动计算
        _paddingLeft = 5;       //默认左边距为 5
        _paddingRight = 5;      //默认右边距为 5
        _labelFont = [FMFont getInstance].defaultFontLevel2;
        self.font = [FMFont getInstance].defaultFontLevel2;
        self.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.returnKeyType =UIReturnKeyDone;
    }
}

- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    if(_labelText) {
        if(!_leftLabel) {
            _leftLabel = [[UILabel alloc] init];
            [_leftLabel setTextAlignment:NSTextAlignmentLeft];
            _leftLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
            self.leftView = _leftLabel;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        _leftLabel.font = _labelFont;
        if(_labelWidth != 0) {
            _leftViewRect = CGRectMake(_paddingLeft, 0, _labelWidth-_paddingLeft, height);
           [_leftLabel setFrame:_leftViewRect];
        } else {//如果没有进行设置则依据计算结果自动处理
            _leftViewRect = CGRectMake(_paddingLeft, 0, width-_paddingLeft-_paddingRight, height);
            [_leftLabel setFrame:_leftViewRect];
            _labelWidth = [FMUtils widthForString:_leftLabel value:_labelText] ;
            _labelWidth += _paddingLeft;
            _leftViewRect = CGRectMake(_paddingLeft, 0, _labelWidth-_paddingLeft, height);
            [_leftLabel setFrame:_leftViewRect];
            
        }
        
        
        [_leftLabel setHidden:NO];
    } else {
        [_leftLabel setHidden:YES];
    }
    if(_labelImg) {
        if(!_leftImgView) {
            _leftImgView = [[UIImageView alloc] init];
            self.leftView = _leftImgView;
            self.leftViewMode = UITextFieldViewModeAlways;
        }
        if(_labelWidth != 0) {
            _leftViewRect = CGRectMake(_paddingLeft, (height - _labelWidth + _paddingLeft)/2, _labelWidth-_paddingLeft, _labelWidth-_paddingLeft);
            [_leftImgView setFrame:_leftViewRect];
        } else {
            _labelWidth = height - 5 * 2;
            _leftViewRect = CGRectMake(_paddingLeft, (height - _labelWidth + _paddingLeft)/2, _labelWidth-_paddingLeft, _labelWidth-_paddingLeft);
            [_leftImgView setFrame:_leftViewRect];
        }
        
        
        [_leftImgView setHidden:NO];
    } else {
        [_leftImgView setHidden:YES];
    }
    
    
    
    [self updateInfo];
}

- (CGRect) leftViewRectForBounds:(CGRect) bounds {
    return _leftViewRect;
}

- (void) updateInfo {
    if(_labelText) {
        _leftLabel.text = _labelText;
    }
    if(_labelImg) {
        _leftImgView.image = _labelImg;
    }
    
}

- (void) setLabelWithText:(NSString*) labelText {
    _labelText = labelText;
    [self updateSubviews];
}

- (void) setLabelFont:(UIFont*) labelFont {
    _labelFont = labelFont;
    [self updateSubviews];
}

//设置左侧文本颜色
- (void) setLabelColor:(UIColor *) labelColor {
    _labelColor = labelColor;
    _leftLabel.textColor = labelColor;
}

- (void) setLabelWithImage:(UIImage*) labelImg {
    _labelImg = labelImg;
    [self updateSubviews];
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right andLabelWidth:(CGFloat) labelWidth {
    _labelWidth = labelWidth;
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubviews];
}

- (void) setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
}
@end
