//
//  CaptionTextField.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "CaptionTextField.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseLabelView.h"

@interface CaptionTextField () <OnClickListener>

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * markLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) UITextField * textField;
@property (readwrite, nonatomic, strong) BaseLabelView * textLbl; //不可用于不可编辑时展示内容

@property (readwrite, nonatomic, strong) SeperatorView * bottomLine;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSMutableAttributedString *attributedString;
@property (readwrite, nonatomic, strong) NSString * placeHolder;
@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) BOOL showMark;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@end

@implementation CaptionTextField


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
        _paddingTop = 7;
        _paddingLeft = 17;
        
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont fontWithSize:15];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = [FMFont fontWithSize:13];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _descLbl.textAlignment = NSTextAlignmentLeft;
        
        
        _markLbl = [[UILabel alloc] init];
        _markLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        _markLbl.text = @"*";
        
        
        _textField = [[UITextField alloc] init];
        _textField.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _textField.font = [FMFont fontWithSize:13];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _textField.keyboardType = _keyboardType;
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _paddingLeft, 20)];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        
        _textLbl = [[BaseLabelView alloc] init];
        [_textLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        _textLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_textLbl setHidden:YES];
//        [_textLbl setShowOneLine:YES];
        [_textLbl setOnClickListener:self];
        
        
        _bottomLine = [[SeperatorView alloc] init];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [self addSubview:_titleLbl];
        [self addSubview:_markLbl];
        [self addSubview:_descLbl];
        [self addSubview:_textField];
        [self addSubview:_textLbl];
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
    
    CGFloat lineHeight = [FMSize getInstance].seperatorHeight;
    CGFloat topHeight = height * 11 / 23;
    CGFloat titleHeight = topHeight -_paddingTop;
    CGFloat sepWidth = 6;
    
    CGFloat titleWidth = 0;
    if (![FMUtils isStringEmpty:_title]) {
        titleWidth = [FMUtils widthForString:_titleLbl value:_title];
    } else if (_attributedString) {
        titleWidth = width;
    }
    
    CGFloat markWidth = 10;
    CGFloat descHeight = 35;
    CGFloat originX = _paddingLeft;
    
    [_titleLbl setFrame:CGRectMake(originX, _paddingTop, titleWidth, titleHeight)];
    originX += titleWidth + sepWidth;
    
    if(_showMark) {
        [_markLbl setFrame:CGRectMake(_paddingLeft+titleWidth+sepWidth, _paddingTop*2, markWidth, topHeight-_paddingTop*2)];
        originX += markWidth + sepWidth;
    }
    
    
    [_descLbl setFrame:CGRectMake(originX, _paddingTop+(titleHeight - descHeight), width-_paddingLeft-originX, descHeight)];
    [_textField setFrame:CGRectMake(0, topHeight, width, height-topHeight)];
    [_textLbl setFrame:CGRectMake(0, topHeight, width, height-topHeight)];
    
    [_bottomLine setFrame:CGRectMake(0, height-lineHeight, width, lineHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    if (![FMUtils isStringEmpty:_title]) {
        [_titleLbl setText:_title];
    } else if (_attributedString) {
        [_titleLbl setAttributedText:_attributedString];
    }
    
    //默认提示
    if([FMUtils isStringEmpty:[_textField text]] && ![FMUtils isStringEmpty:_placeHolder]) {
        [_textLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER]];
        [_textLbl setContent:_placeHolder];
    } else {
        [_textLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        [_textLbl setContent:[_textField text]];
    }
    
    if(_showMark) {
        [_markLbl setHidden:NO];
    } else {
        [_markLbl setHidden:YES];
    }
    
    if(![FMUtils isStringEmpty:_desc]) {
        [_descLbl setHidden:NO];
        [_descLbl setText:_desc];
    } else {
        [_descLbl setHidden:YES];
        
    }
}


- (void) setTitle:(NSString *) title {
    _title = [title copy];
    [self updateViews];
}

- (void) setTitleAttributedString:(NSMutableAttributedString *) attributedString {
    if (!_attributedString) {
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    _attributedString = [attributedString copy];
    [self updateViews];
}

- (void) setPlaceholder:(NSString *) placeholder {
    _placeHolder = [placeholder copy];
    [_textField setPlaceholder:placeholder];
}

- (void) setPlaceholderAttributedString:(NSMutableAttributedString *) attributedString {
    if (attributedString) {
        [_textField setAttributedPlaceholder:attributedString];
    }
}

- (void) setText:(NSString *) text {
    [_textField setText:text];
    [self updateInfo];
}

- (void) setDesc:(NSString *) desc {
    _desc = desc;
    [self updateInfo];
}

//设置是否必须（显示红色星号）
- (void) setShowMark:(BOOL) showMark {
    _showMark = showMark;
    [self updateViews];
}

- (void) setEditable:(BOOL) editable {
    if(editable) {
        [_textField setHidden:NO];
        [_textLbl setHidden:YES];
    } else {
        [_textField setHidden:YES];
        [_textLbl setHidden:NO];
    }
    [_textField setEnabled:editable];
}

- (void) setShowOneLine:(BOOL) isOneLine {
    [_textLbl setShowOneLine:isOneLine];
}

- (void) setDetegate:(id<UITextFieldDelegate>) delegate {
    _textField.delegate = delegate;
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    _listener = listener;
}

- (NSString *) text {
    return _textField.text;
}


- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _textField.keyboardType = keyboardType;
}

- (void) onClick:(UIView *)view {
    if(view == _textLbl) {
        [_listener onClick:self];
    }
}
@end
