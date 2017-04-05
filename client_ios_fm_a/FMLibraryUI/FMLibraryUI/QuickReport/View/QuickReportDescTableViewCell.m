//
//  QuickReportDescTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportDescTableViewCell.h"
#import "FMUtilsPackages.h"
#import "UITextView+Placeholder.h"
#import "SeperatorView.h"
//#import "BaseTextView.h"

@interface QuickReportDescTableViewCell () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *limitedLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) NSInteger maxTextLength;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation QuickReportDescTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _textView = [[UITextView alloc] init];
        _textView.font = [FMFont fontWithSize:14];    //默认字体
        _textView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];                 //默认字体颜色
        _textView.placeholderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER];
        _textView.delegate = self;
        
        _limitedLbl = [[UILabel alloc] init];
        _limitedLbl.font = [FMFont fontWithSize:14];
        _limitedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _limitedLbl.textAlignment = NSTextAlignmentRight;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_textView];
        [self.contentView addSubview:_limitedLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat minTextHeight = 150;
    CGFloat paddingTop = 5;
    CGFloat padding = 11;
    CGFloat labelHeight = 17;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = padding;
    CGFloat originY = paddingTop;
    
    [_textView setFrame:CGRectMake(originX, originY, width-padding*2, minTextHeight)];
    originY += minTextHeight;
    
    [_limitedLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    
    [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
}

- (void)updateInfo {
    [_textView setPlaceholder:_placeHolder];
    if (![FMUtils isStringEmpty:_placeHolder]) {
        [_textView setPlaceholder:_placeHolder];
    }
    
    if (![FMUtils isStringEmpty:_content]) {
        [_textView setText:_content];
    }
    
    [self setNeedsLayout];
}

- (void)setTextPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    [self updateInfo];
}

//设置最大字数限制
- (void)setMaxTextLength:(NSInteger) maxlength{
    _maxTextLength = maxlength;
    _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_limited" inTable:nil],_maxTextLength];
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self updateInfo];
}

- (NSString *)getContent {
    NSString *res = [_textView text];
    return res;
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
//            NSLog(@"有高亮，正在输入");
        }
    } else {  //英文状态下输入
        if (_textView.text.length > _maxTextLength) {
            _textView.text = [_textView.text substringToIndex:_maxTextLength];
            _limitedLbl.text = [NSString  stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_full" inTable:nil],_maxTextLength];
        } else {
            _limitedLbl.text = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"base_text_view_limited" inTable:nil],_maxTextLength - _textView.text.length];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self limitTextLength:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    return YES;
}

+ (CGFloat) getItemHeight  {
    CGFloat height = 0;
    CGFloat minTextHeight = 150;
    CGFloat paddingTop = 5;
    CGFloat labelHeight = 17;
    
    height = paddingTop*2 + labelHeight + minTextHeight;
    
    return height;
}

@end

