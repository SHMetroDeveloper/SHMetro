//
//  BaseTextView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseTextView.h"
#import "UITextView+Placeholder.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"

#import "BaseBundle.h"


@interface BaseTextView ()


@property (readwrite, nonatomic, strong) UIView * topView;     //上标签
@property (readwrite, nonatomic, strong) UIView * leftView;     //左标签
@property (readwrite, nonatomic, assign) BaseTextViewMode leftViewMode; //左标签显示模式
@property (readwrite, nonatomic, assign) BaseTextViewMode topViewMode; //上标签显示模式

@property (readwrite, nonatomic, strong) UITextView * textView;  //输入框

@property (readwrite, nonatomic, strong) UILabel * limitedLbl;    //限制字数输入lbl
@property (readwrite, nonatomic, assign) CGSize limitSize;        //限制Lbl的大小
@property (readwrite, nonatomic, assign) BOOL isLimited;          //是否有字数限制
@property (readwrite, nonatomic, assign) NSInteger maxTextLength; //最大输入字数

@property (readwrite, nonatomic, strong) NSString * desc; //标签文本，在标签View 为nil的时候有效
@property (readwrite, nonatomic, assign) CGFloat labelWidth;//标签宽度
@property (readwrite, nonatomic, assign) BOOL editAble; //是否可编辑
@property (readwrite, nonatomic, assign) BOOL isInited; //是否初始化
@property (readwrite, nonatomic, assign) CGFloat minHeight; //最低高度

@property (readwrite, nonatomic, strong) UIColor * descColor;   //说明性文字标签字体的颜色

@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;
@end

@implementation BaseTextView

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

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        _paddingLeft = 5;       //默认左边距为 5
        _paddingRight = 5;      //默认右边距为 5
        _paddingTop = 5;        //默认上边距
        _paddingBottom = 5;     //默认下边距
        _editAble = YES;        //默认可以编辑
        _minHeight = 30;
        
        _textView = [[UITextView alloc] init];
        _textView.font = [FMFont fontWithSize:14];    //默认字体
        _textView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];                 //默认字体颜色
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        _textView.placeholderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER];
        _textView.delegate = self;
//        _textView.inputAccessoryView = toolBar;
        
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _leftViewMode = BaseTextViewNever;
        _topViewMode = BaseTextViewNever;
        _textView.scrollEnabled = NO;       //不需要滑动
        
        _limitedLbl = [[UILabel alloc] init];
        _limitedLbl.font = [FMFont fontWithSize:14];
        _limitedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _limitedLbl.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_textView];
        [self addSubview:_limitedLbl];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubviews];
}

- (void) updateSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat originX = _paddingLeft;
    CGFloat originY = _paddingTop;
    CGFloat sepHeight = 0;
    CGFloat defaultTopHeight = 20;
    if(width == 0 || height == 0) {
        return;
    }
    
    if(_topViewMode == BaseTextViewAlways) {
        if(_topView) {
            CGRect topViewRect = _topView.frame;
            topViewRect.origin.x = _paddingLeft;
            topViewRect.size.width = width-_paddingLeft-_paddingRight;
            topViewRect.origin.y = originY;
            _topView.frame = topViewRect;
            if([_topView isKindOfClass:[UILabel class]]) {
                UILabel * topLabel = (UILabel *)_topView;
                [topLabel setText:_desc];
            }
            originY += topViewRect.origin.y + topViewRect.size.height + sepHeight;
        } else {
            UILabel * topLbl = [[UILabel alloc] initWithFrame:CGRectMake(_paddingLeft, _paddingTop, width-_paddingLeft-_paddingRight, defaultTopHeight)];
            topLbl.text = _desc;
            topLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
            topLbl.font = [FMFont getInstance].defaultFontLevel2;
            _topView = topLbl;
            originY += _paddingTop + defaultTopHeight + sepHeight;
            [self addSubview:_topView];
        }
        [_topView setHidden:NO];
    } else {
        [_topView setHidden:YES];
    }
    if(_leftViewMode == BaseTextViewAlways) {
        if(_leftView) {
            CGRect leftViewRect = _leftView.frame;
            leftViewRect.origin.x = _paddingLeft;
            if(leftViewRect.size.height > height - _paddingTop - _paddingBottom) {
                leftViewRect.size.height = height - _paddingTop - _paddingBottom;
            }
            //            leftViewRect.origin.y = (height+originY-leftViewRect.size.height)/2;
            leftViewRect.origin.y = _paddingTop;
            
            _leftView.frame = leftViewRect;
            if([_leftView isKindOfClass:[UILabel class]]) {
                UILabel * leftLabel = (UILabel *)_leftView;
                [leftLabel setText:_desc];
            }
            originX += leftViewRect.size.width;
            [_leftView setHidden:NO];
        } else {
            UILabel * leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(_paddingLeft, _paddingTop, width-_paddingLeft-_paddingRight, defaultTopHeight)];
            leftLbl.text = _desc;
            leftLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
            leftLbl.font = [FMFont getInstance].defaultFontLevel2;
            _leftView = leftLbl;
            if(_labelWidth == 0) {
                _labelWidth = [FMUtils widthForString:leftLbl value:_desc];
            }
            [_leftView setFrame:CGRectMake(_paddingLeft, _paddingTop, _labelWidth-_paddingLeft, defaultTopHeight)];
            originX = _labelWidth;
            [self addSubview:_leftView];
        }
        [_leftView setHidden:NO];
    } else {
        [_leftView setHidden:YES];
    }
    
    
    if (_isLimited) {
        _limitedLbl.hidden = NO;
        _limitSize = [FMUtils getLabelSizeBy:_limitedLbl andContent:_limitedLbl.text andMaxLabelWidth:width];
    } else {
        _limitedLbl.hidden = YES;
        _limitSize = CGSizeZero;
    }
    
    CGRect inputFrame = CGRectMake(originX, originY, width - _paddingRight - originX, height-originY-_paddingBottom - _limitSize.height);
    [_textView setFrame:inputFrame];
    
    [_limitedLbl setFrame:CGRectMake(originX, originY + (height-originY-_paddingBottom - _limitSize.height), width - _paddingRight - originX, _limitSize.height)];
    
}

- (void) updateInfo {
    
}

- (void)setMaxTextLength:(NSInteger) maxlength {
    _maxTextLength = maxlength;
    _isLimited = YES;
    _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_limited" inTable:nil],_maxTextLength];
}

- (void)setLimitedFont:(UIFont *)font andTextColor:(UIColor *)color {
    _limitedLbl.font = font;
    _limitedLbl.textColor = color;
}

- (void) setEditAble:(BOOL) editable {
    _editAble = editable;
    [_textView setEditable:_editAble];
//    [_textField setE]
}

- (void) setShowBounds:(BOOL) show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
}

//设置显示圆角
- (void) setShowCorner:(BOOL) show {
    if(show) {
//        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        self.layer.cornerRadius = 2;
    } else {
        self.layer.cornerRadius = 0;
    }
}

//设置内容的字体大小
- (void) setContentFont:(UIFont *)font {
    _textView.font = font;
}

//设置内容的字体颜色
- (void) setContentColor:(UIColor *)color {
    _textView.textColor = color;
    _textView.textColor = color;
}


- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if(_leftView) {
        [_leftView setBackgroundColor:backgroundColor];
        [_textView setBackgroundColor:backgroundColor];
    }
}

- (void) setMinHeight:(CGFloat) minHeight {
    _minHeight = minHeight;
}

- (NSString *) getContent {
    return _textView.text;;
}

- (void) setContentWith:(NSString *) content {
    if(![FMUtils isObjectNull:content] && ![content isEqualToString:_textView.text]) {
        _textView.text = content;
        [self checkInputAndUpdateTextView];
        [self updateSubviews];
    }
}

- (void) setFont:(UIFont*) textFont {
    _textView.font = textFont;
    [self checkInputAndUpdateTextView];
}

- (void) setPaddingLeft:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    _paddingLeft = left;
    _paddingRight = right;
    _paddingTop = top;
    _paddingBottom = bottom;
    [self updateSubviews];
}

- (void) setLeftView:(UIView *) leftView andLeftViewMode:(BaseTextViewMode) leftViewMode {
    _leftViewMode = leftViewMode;
    _leftView = leftView;
    [self addSubview:_leftView];
    
    [self updateSubviews];
}

- (void) setLeftDesc:(NSString *) leftDesc andLabelWidth:(CGFloat) labelWidth{
    if(leftDesc) {
        _leftViewMode = BaseTextViewAlways;
        _desc = leftDesc;
        _labelWidth = labelWidth;
        [self updateSubviews];
    }
}

- (void) setTopView:(UIView *) topView andTopViewMode:(BaseTextViewMode) topViewMode {
    _topViewMode = topViewMode;
    _topView = topView;
    [self addSubview:_topView];
    
    [self updateSubviews];
}

- (void) setTopDesc:(NSString *) topDesc {
    if(topDesc) {
//        _topViewMode = BaseTextViewAlways;
//        _desc = topDesc;
        _textView.placeholder = topDesc;
        [self updateSubviews];
    }
}

//设置键盘样式
- (void) setKeyboardType:(UIKeyboardType) KeyboardType {
    _textView.keyboardType = KeyboardType;
}

- (void) setDescColor:(UIColor *) color {
    _descColor = [color copy];
    if(_topViewMode == BaseTextViewAlways) {
        if([_topView isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)_topView;
            [label setTextColor:_descColor];
        }
    } else if(_leftViewMode == BaseTextViewAlways) {
        if([_leftView isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)_leftView;
            [label setTextColor:_descColor];
        }
    }
}

//
- (CGFloat) getTopViewHeight {
    CGFloat height = 0;
    if(_topViewMode == BaseTextViewAlways) {
        if(_topView) {
            CGFloat sepHeight = 5;
            CGRect frame = _topView.frame;
            height = CGRectGetHeight(frame) + sepHeight;
        }
    }
    return height;
}


- (CGFloat) getCurrentHeight {
    CGFloat inputHeight = self.defaultHeight;
    NSString * text = _textView.text;
    if(![FMUtils isStringEmpty:text]) {
        inputHeight = [FMUtils heightForTextViewWith:_textView];
        inputHeight += _paddingTop + _paddingBottom + _limitSize.height;
        inputHeight += [self getTopViewHeight];
    }
    return inputHeight;
}

- (void) checkInputAndUpdateTextView {
    CGFloat height = [self getCurrentHeight];
    CGFloat realHeight = CGRectGetHeight(self.frame);
    if(height < _minHeight) {
        height = _minHeight;
    }
    if(realHeight!=height ) {
        if(height != realHeight) {
            CGFloat width = CGRectGetWidth(self.frame);
            CGSize newSize = CGSizeMake(width, height);
            [self notifyViewNeedResized:newSize];
        }
    }
}

- (void)limitTextLength:(UITextView *)textView {
        NSString * lang = [[_textView.nextResponder textInputMode] primaryLanguage]; //获取输入方式
        if ([lang isEqualToString:@"zh-Hans"]) {  //中文状态下输入
            UITextRange * selectRange = [_textView markedTextRange];
            UITextPosition * position = [_textView positionFromPosition:selectRange.start offset:0];
            if (!position) {
                if (_textView.text.length > _maxTextLength) {
                    _textView.text = [_textView.text substringToIndex:_maxTextLength];
                    _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_full" inTable:nil],_maxTextLength];
                } else {
                    _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_limited" inTable:nil],_maxTextLength - _textView.text.length];
                }
            } else {
//                NSLog(@"有高亮，正在输入");
            }
        } else {  //英文状态下输入
            if (_textView.text.length > _maxTextLength) {
                _textView.text = [_textView.text substringToIndex:_maxTextLength];
                _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_full" inTable:nil],_maxTextLength];
            } else {
                _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_limited" inTable:nil],_maxTextLength - _textView.text.length];
            }
        }
}

- (void)textViewDidChange:(UITextView *)textView {
    if(_textView == textView) {
        [self checkInputAndUpdateTextView];
        if (_isLimited) {
            [self limitTextLength:textView];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void) finishEdit {
    NSLog(@"完成输入");
//    [self endEditing:YES];
    [_textView resignFirstResponder];
}

- (void) setOnClickedListener:(id<OnClickListener>) listener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [_textView addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}

- (BOOL) resignFirstResponder {
    return [_textView resignFirstResponder];
}

- (void) actiondo:(UIView *) v {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}

@end

