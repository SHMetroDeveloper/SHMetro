//
//  BaseLabelView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/26.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseLabelView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"

@interface BaseLabelView ()

@property (readwrite, nonatomic, strong) UILabel * descLbl;     //左侧标签
@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;
@property (readwrite, nonatomic, strong) UIColor * labelColor;
@property (readwrite, nonatomic, strong) UIColor * contentColor;

@property (readwrite, nonatomic, strong) UIFont * mFont;

@property (readwrite, nonatomic, strong) NSString* desc;
@property (readwrite, nonatomic, strong) NSString* content;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat defaultHeight;

@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;
@end

@implementation BaseLabelView

- (instancetype) init {
    self= [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super  initWithFrame:frame];
    if(self) {
        [self initViews];
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
        _paddingTop = 5;
        _paddingBottom = _paddingTop;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = 0;
        _labelWidth = 0;        //自适应
        _labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC];
        _contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _mFont = [FMFont fontWithSize:13];
        
        _defaultHeight = [FMSize getInstance].listItemInfoHeight;
        
        _descLbl = [[UILabel alloc] init];
        _contentLbl = [[UILabel alloc] init];
        
        _descLbl.textColor = _labelColor;
        _descLbl.font = _mFont;
        _contentLbl.textColor = _contentColor;
        _contentLbl.font = _mFont;
        _contentLbl.numberOfLines = 0;
        
        [self addSubview:_descLbl];
        [self addSubview:_contentLbl];
        
        [self updateViews];
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat labelHeight = 0;
    CGFloat contentHeight = 0;
    CGFloat paddingTop = _paddingTop;
    CGFloat paddingBottom = _paddingBottom;
    CGFloat labelWidth = 0;
    CGFloat sepWidth = 5;
    
    if(width == 0 || height == 0) {
        return;
    }
    
    if(_labelWidth == 0 && ![FMUtils isStringEmpty:_desc]) {
        [_descLbl setFrame:CGRectMake(_paddingLeft, 0, width-_paddingLeft-_paddingRight, height) ];
        labelWidth = [FMUtils widthForString:_descLbl value:_desc];
        labelWidth += sepWidth;
    } else {
        labelWidth = _labelWidth;
    }
    CGFloat paddingLeft =_paddingLeft;
    if(labelWidth > 0) {
        paddingLeft += labelWidth;
    }
    [_descLbl setFrame:CGRectMake(_paddingLeft, 0, labelWidth, height)];
    contentHeight = [FMUtils heightForStringWith:_contentLbl value:_content andWidth:width-paddingLeft-_paddingRight];
    if(labelWidth > 0) {
        labelHeight = [FMUtils heightForStringWith:_descLbl value:_desc andWidth:labelWidth];
        if(height < labelHeight + _paddingTop * 2) {        //用于自动调整 padding 值
            paddingTop = (height - labelHeight) / 2;
            paddingBottom = paddingTop;
        }
        [_descLbl setFrame:CGRectMake(_paddingLeft, paddingTop, labelWidth, labelHeight)];
    }
    
    if(contentHeight > height-paddingTop-paddingBottom || [FMUtils isStringEmpty:_desc]) {   //如果超过这个高度, 或者没有标签信息
        //        _contentLbl.numberOfLines = 1;
        contentHeight = height-paddingTop-paddingBottom;
    }
    
    [_contentLbl setFrame:CGRectMake(paddingLeft, paddingTop, width-paddingLeft-_paddingRight, contentHeight)];
    [self updateInfo];
}

- (void) updateInfo {
    _descLbl.text = _desc;
    _contentLbl.text = _content;
}

//设置标签文本
- (void) setLabelText:(NSString *) labeltext andLabelWidth:(CGFloat) labelWidth {
    if(![FMUtils isStringEmpty:labeltext]) {
        _desc = [labeltext copy];
    } else {
        _desc = @"";
    }
    _labelWidth = labelWidth;
    [self updateViews];
    
}

//设置是否为单行
- (void) setShowOneLine:(BOOL) isOneLine {
    if(isOneLine) {
        _contentLbl.numberOfLines = 1;
    } else {
        _contentLbl.numberOfLines = 0;
    }
}

- (void) setLabelFont:(UIFont *) labelFont andColor:(UIColor *) labelColor {
    if(labelFont) {
        _descLbl.font = labelFont;
    }
    if(labelColor) {
        _descLbl.textColor = labelColor;
    }
}

- (void) setBoundsColor:(UIColor *) boundColor {
    self.layer.borderColor = [boundColor CGColor];
}


//设置内容的对齐格式
- (void) setContentAlignment:(NSTextAlignment) alignment {
    [_contentLbl setTextAlignment:alignment];
}

//设置标签的对齐格式
- (void) setLabelAlignment:(NSTextAlignment) alignment {
    [_descLbl setTextAlignment:alignment];
}

//设置正文
- (void) setContent:(NSString *) content {
    if(![FMUtils isStringEmpty:content]) {
        _content = [content copy];
    } else {
        _content = @"";
    }
    [self updateViews];
}

//设置内容颜色
- (void) setContentColor:(UIColor *) textColor {
    _contentColor = textColor;
    [_contentLbl setTextColor:_contentColor];
}

- (void) setContentFont:(UIFont *) font {
    _contentLbl.font = font;
    [self updateViews];
}


- (void) setShowBounds:(BOOL) showBounds {
    if(showBounds) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}


#pragma - onclick 事件
- (void) actiondo:(UIView *) v {
    [self notifyViewClicked];
    
}

- (void) notifyViewClicked {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}
//设置点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}

+ (CGFloat) calculateHeightByInfo:(NSString *) content
                             font:(UIFont *) contentFont
                             desc:(NSString *) desc
                        labelFont:(UIFont *) labelFont
                    andLabelWidth:(CGFloat) labelWidth
                         andWidth:(CGFloat) width {
    CGFloat paddingTop = 5;
    CGFloat paddingBottom = 5;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = 0;
    CGFloat height = 0;
    CGFloat defaultHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat sepWidth = 5;
    UILabel * testLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-paddingLeft-paddingRight-labelWidth, defaultHeight)];
    
    UIFont * defaultFont = [FMFont fontWithSize:13];
    
    if(labelFont) {
        testLbl.font = labelFont;
    } else {
        testLbl.font = defaultFont;
    }
    if(labelWidth == 0 && ![FMUtils isStringEmpty:desc]) {
        CGFloat realLabelWidth = [FMUtils widthForString:testLbl value:desc];
        labelWidth = realLabelWidth;
        labelWidth += sepWidth;
    }
    
    [testLbl setFrame:CGRectMake(0, 0, width-paddingLeft-paddingRight-labelWidth, defaultHeight)];
    
    testLbl.text = content;
    if(contentFont) {
        testLbl.font = contentFont;
    } else {
        testLbl.font = defaultFont;
    }
    
    testLbl.numberOfLines = 0;
    height = paddingTop + paddingBottom + [FMUtils heightForStringWith:testLbl value:content andWidth:width-paddingLeft-paddingRight-labelWidth];
    if(height < defaultHeight) {
        height = defaultHeight;
    }
    return height;
}

//在只展示一行的情况下计算所需宽度
+ (CGFloat) calculateWidthByInfo:(NSString *) content font:(UIFont *) contentFont desc:(NSString *) desc labelFont:(UIFont *) labelFont andLabelWidth:(CGFloat) labelWidth {

    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = 0;
    
    CGFloat sepWidth = 5;
    UILabel * testLbl = [[UILabel alloc] init];
    UIFont * defaultFont = [FMFont fontWithSize:13];
    testLbl.numberOfLines = 1;
    
    if(labelFont) {
        testLbl.font = labelFont;
    } else {
        testLbl.font = defaultFont;
    }
    if(labelWidth == 0) {
        CGFloat realLabelWidth = [FMUtils widthForString:testLbl value:desc];
        labelWidth = realLabelWidth;
        labelWidth += sepWidth;
    }
    
    
    testLbl.text = content;
    if(contentFont) {
        testLbl.font = contentFont;
    } else {
        testLbl.font = defaultFont;
    }
    CGFloat contentWidth = [FMUtils widthForString:testLbl value:content];
    
    CGFloat width = paddingLeft + paddingRight + labelWidth + contentWidth;
    return width;

}

@end
