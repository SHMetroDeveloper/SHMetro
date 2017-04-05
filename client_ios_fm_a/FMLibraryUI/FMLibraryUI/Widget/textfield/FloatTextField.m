//
//  FloatTextField.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/15.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FloatTextField.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMSize.h"

typedef NS_ENUM(NSInteger, FloatLabelType) {
    FLOAT_LABEL_TYPE_PLACEHOLDER,   //作为placeholder
    FLOAT_LABEL_TYPE_LABEL,         //作为顶部标签
};


@interface FloatTextField () <UITextFieldDelegate>

@property (readwrite, nonatomic, strong) UILabel * floatLbl;
@property (readwrite, nonatomic, strong) UITextField * contentTf;
@property (readwrite, nonatomic, strong) UILabel * bottomLine;

@property (readwrite, nonatomic, strong) NSString * placeholder;

@property (readwrite, nonatomic, strong) UIColor * floatColor;
@property (readwrite, nonatomic, strong) UIColor * normalColor;

@property (readwrite, nonatomic, assign) FloatLabelType lblType;    //浮动标签的位置类型

@property (readwrite, nonatomic, assign) CGFloat endScale;  //缩放的比例

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation FloatTextField

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
        
        _lblType = FLOAT_LABEL_TYPE_PLACEHOLDER;
        _floatColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
        _normalColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _endScale = 0.7;
        
        
        _floatLbl = [[UILabel alloc] init];
        _contentTf = [[UITextField alloc] init];
        _bottomLine = [[UILabel alloc] init];
        
        _contentTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentTf.keyboardType = UIKeyboardTypeDefault;
        _contentTf.returnKeyType = UIReturnKeyDone;
        _contentTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _contentTf.autocorrectionType = UITextAutocorrectionTypeNo;
        _contentTf.keyboardAppearance = UIKeyboardAppearanceDark;
        
        _bottomLine.backgroundColor = _floatColor;
        _floatLbl.textColor = _floatColor;
        _floatLbl.font = [FMFont getInstance].defaultFontLevel2;
        _contentTf.font = [FMFont getInstance].defaultFontLevel2;
        _contentTf.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        [_floatLbl setHidden:YES];
        
        _contentTf.delegate = self;
        [_contentTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self addSubview:_contentTf];
        [self addSubview:_floatLbl];
        
        [self addSubview:_bottomLine];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = 0;
    CGFloat lineSize = [FMSize getInstance].inputLineHeight;
    CGFloat floatHeight = height / 4;
    CGFloat contentHeight = height - floatHeight;
    
    if(_lblType == FLOAT_LABEL_TYPE_LABEL) {
        [_floatLbl setHidden:NO];
        [_floatLbl setFrame:CGRectMake(0, originY, width, floatHeight)];
    }
    originY += floatHeight;
    [_contentTf setFrame:CGRectMake(0, originY, width, contentHeight)];
    if(_lblType == FLOAT_LABEL_TYPE_PLACEHOLDER) {
        [_floatLbl setHidden:YES];
        [_floatLbl setFrame:CGRectMake(0, originY, width, contentHeight)];
    }
    
    
    [_bottomLine setFrame:CGRectMake(0, height-lineSize, width, lineSize)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_contentTf setPlaceholder:_placeholder];
    [_floatLbl setText:_placeholder];
}

- (void) setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self updateInfo];
    
    
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [_contentTf addTarget:target action:action forControlEvents:controlEvents];
}


- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [_contentTf removeTarget:target action:action forControlEvents:controlEvents];
}

- (void) setSecureTextEntry:(BOOL) secureTextEntry {
    _contentTf.secureTextEntry = secureTextEntry;
}

- (void) setTextFont:(UIFont *) font {
    _floatLbl.font = font;
    _contentTf.font = font;
}

- (NSString *) getText {
    return _contentTf.text;
}

- (void) setText:(NSString *) text {
    _contentTf.text = text;
    [self checkFloatState];
}

//显示高亮
- (void) showHighlightState {
    [_floatLbl setTextColor:_floatColor];
    [_bottomLine setBackgroundColor:_floatColor];
}

//显示常规状态
- (void) showNormalState {
    [_floatLbl setTextColor:_normalColor];
    [_bottomLine setBackgroundColor:_normalColor];
}

- (void) checkFloatState {
    NSString * content = _contentTf.text;
    if(![FMUtils isStringEmpty:content]) {
        if(_lblType == FLOAT_LABEL_TYPE_PLACEHOLDER) {
            [self showAsLabel];
        }
    } else {
        if(_lblType == FLOAT_LABEL_TYPE_LABEL) {
            [self showAsPlaceHolder];
        }
    }
}

//输入文本变化
- (void) textFieldDidChange:(UITextField *) textField {
    [self checkFloatState];
}

//
- (void) showAsLabel {
    [_floatLbl setHidden:NO];
    _lblType = FLOAT_LABEL_TYPE_LABEL;
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat floatHeight = height / 4;
    CGFloat contentHeight = height - floatHeight;
    [UIView animateWithDuration:0.5 animations:^{
        _floatLbl.transform = CGAffineTransformMake(_endScale, 0, 0, _endScale, -width*(1-_endScale)/2, -contentHeight*(1-_endScale)/2 - floatHeight);
//        _floatLbl.transform = CGAffineTransformMake(_endScale, 0, 0, _endScale, 0, 0);
    }];
}

//
- (void) showAsPlaceHolder {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_contentTf setPlaceholder:@""];
    [UIView animateWithDuration:0.5 animations:^{
        _floatLbl.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    } completion:^(BOOL finished) {
        [_floatLbl setHidden:YES];
        [_contentTf setPlaceholder:_placeholder];
        _lblType = FLOAT_LABEL_TYPE_PLACEHOLDER;
    }];
}

#pragma --- content
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self showHighlightState];
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self showNormalState];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; //这句代码可以隐藏 键盘
    BOOL res = YES;
    return res;
}
@end
