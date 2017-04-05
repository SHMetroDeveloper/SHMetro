//
//  CaptionTextView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "CaptionTextView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseTextView.h"

@interface CaptionTextView () <OnViewResizeListener>

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * markLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) BaseTextView * textView;

@property (readwrite, nonatomic, strong) SeperatorView * bottomLine;

@property (readwrite, nonatomic, strong) NSString * title;

@property (readwrite, nonatomic, assign) CGFloat minTextHeight; //描述信息的最小高度

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) BOOL showMark;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation CaptionTextView


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
        _minTextHeight = 130;
        
        
        _titleLbl = [[UILabel alloc] init];
        _markLbl = [[UILabel alloc] init];
        _textView = [[BaseTextView alloc] init];
        
        _bottomLine = [[SeperatorView alloc] init];
        
        
//        _titleLbl.font = [FMFont fontWithSize:16];
        _titleLbl.font = [FMFont setFontByPX:44];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _markLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        _markLbl.text = @"*";
        
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = [FMFont fontWithSize:13];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _descLbl.textAlignment = NSTextAlignmentLeft;
        
        
//        _textView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _textView.font = [FMFont fontWithSize:13];
//        [_textView setCon]
        _textView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_textView setOnViewResizeListener:self];
        [_textView setMinHeight:_minTextHeight];
        [_textView setPaddingLeft:_paddingLeft - 5];
//        [_textView setContentFont:[FMFont fontWithSize:14]];
        [_textView setContentFont:[FMFont setFontByPX:38]];

        
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [self addSubview:_titleLbl];
        [self addSubview:_descLbl];
        [self addSubview:_markLbl];
        [self addSubview:_textView];
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
    CGFloat topHeight = 44;
    CGFloat titleHeight = topHeight -_paddingTop;
    CGFloat sepWidth = 6;
    
    CGFloat titleWidth = [FMUtils widthForString:_titleLbl value:_title];
    CGFloat markWidth = 10;
    CGFloat descHeight = 35;
    CGFloat originX = _paddingLeft;
    
    CGFloat originY = 0;
    [_titleLbl setFrame:CGRectMake(originX, _paddingTop, titleWidth, titleHeight)];
    originX += titleWidth + sepWidth;
    
    if(_showMark) {
        [_markLbl setFrame:CGRectMake(_paddingLeft+titleWidth+sepWidth, _paddingTop*2, markWidth, topHeight-_paddingTop*2)];
        originX += markWidth + sepWidth;
    }
    
    
    [_descLbl setFrame:CGRectMake(originX, _paddingTop+(titleHeight - descHeight), width-_paddingLeft-originX, descHeight)];
    
    originY += topHeight;
    
    CGFloat textHeight = CGRectGetHeight(_textView.frame);
    if(textHeight == 0) {
        textHeight = _minTextHeight;
    }
    [_textView setFrame:CGRectMake(0, topHeight, width, textHeight)];
    
    [_bottomLine setFrame:CGRectMake(0, height-lineHeight, width, lineHeight)];
    originY += textHeight;
    
    if(originY != height) {
        [self notifyViewNeedResized:CGSizeMake(width, originY)];
    }
    
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    if(_showMark) {
        [_markLbl setHidden:NO];
    } else {
        [_markLbl setHidden:YES];
    }
}


- (void) setTitle:(NSString *) title {
    _title = [title copy];
    [self updateViews];
}
- (void) setPlaceholder:(NSString *) placeholder {
    [_textView setTopDesc:placeholder];
}
- (void) setText:(NSString *) text {
    [_textView setContentWith:text];
}

- (void) setDesc:(NSString *)desc  {
    [_descLbl setText:desc];
}

//设置是否必须（显示红色星号）
- (void) setShowMark:(BOOL) showMark {
    _showMark = showMark;
    [self updateInfo];
}

- (void) setEditable:(BOOL) editable {
    [_textView setEditAble:editable];
}

- (void) setMinTextHeight:(CGFloat)minTextHeight {
    if(_minTextHeight != minTextHeight) {
        _minTextHeight = minTextHeight;
        [_textView setMinHeight:_minTextHeight];
        [self updateViews];
    }
}

- (NSString *) text {
    return [_textView getContent];
}

- (void) setTag:(NSInteger)tag {
    [super setTag:tag];
    [_textView setTag:tag];
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    [_textView setOnClickedListener:listener];
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _textView) {
        CGRect frame = _textView.frame;
        frame.size = newSize;
        _textView.frame = frame;
        [self updateViews];
    }
}

@end

