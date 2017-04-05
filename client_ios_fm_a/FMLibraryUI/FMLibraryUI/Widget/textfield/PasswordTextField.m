//
//  PasswordTextField.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/30.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PasswordTextField.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "LineTextField.h"

@interface PasswordTextField ()

@property (readwrite, nonatomic, strong) UITextField * textField;

@property (readwrite, nonatomic, strong) UILabel * bottomLbl;

@property (readwrite, nonatomic, strong) UIButton * rightButton;
@property (readwrite, nonatomic, strong) UIImageView * rightImgView;
//@property (readwrite, nonatomic, strong) UIView * imgContainerView;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, strong) UIColor * lineColor;

@property (readwrite, nonatomic, assign) BOOL showPassword;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PasswordTextField

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
        
        _btnWidth = 44;
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _lineColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7];
        
        _textField = [[UITextField alloc] init];
        _rightImgView = [[UIImageView alloc] init];
//        _imgContainerView = [[UIView alloc] init];
        _bottomLbl = [[UILabel alloc] init];
        _rightButton = [[UIButton alloc] init];
        
        
        _bottomLbl.backgroundColor = _lineColor;
        
        _rightImgView.userInteractionEnabled = YES;
        
//        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePasswordSwitch:)];
//        [_imgContainerView addGestureRecognizer:tapGesture];
        [_rightButton addTarget:self action:@selector(changePasswordSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        _textField.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _textField.font = [FMFont getInstance].defaultFontLevel2;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        
        [_rightButton addSubview:_rightImgView];
        
        [self addSubview:_textField];
        [self addSubview:_rightButton];
        [self addSubview:_bottomLbl];
    }
}



- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat lineHeight = [FMSize getInstance].seperatorHeight;
    
    [_textField setFrame:CGRectMake(0, 0, width-_btnWidth, height)];
    [_rightButton setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, height)];
    [_rightImgView setFrame:CGRectMake((_btnWidth-_imgWidth)/2, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    [_bottomLbl setFrame:CGRectMake(0, height-lineHeight, width, lineHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_textField becomeFirstResponder];
    if(_showPassword) {
        [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"password_show"]];
        _textField.secureTextEntry = NO;
    } else {
        [_rightImgView setImage:[[FMTheme getInstance] getImageByName:@"password_hidden"]];
        _textField.secureTextEntry = YES;
    }
}

- (void) changePasswordSwitch:(id) sender {
    _showPassword = !_showPassword;
    [self updateInfo];
}


- (NSString *) text {
    return _textField.text;
}

- (void) setLineColor:(UIColor *) color {
    _lineColor = color;
    _bottomLbl.backgroundColor = _lineColor;
}

@end



