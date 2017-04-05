//
//  CommonAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  包含一个编辑框和一个按钮, 最小高度需要 250

#import "CommonAlertContentView.h"
#import "BaseTextView.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMTheme.h"


@interface CommonAlertContentView ()
@property (readwrite, nonatomic, strong) UIView * titleContainerView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;    //
@property (readwrite, nonatomic, strong) UIScrollView * descContainerView;
@property (readwrite, nonatomic, strong) BaseTextView * descTV;
@property (readwrite, nonatomic, strong) UIView * controlContainerView;

@property (readwrite, nonatomic, strong) UIButton * leftDoBtn;
@property (readwrite, nonatomic, strong) UIButton * rightDoBtn;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat minDescHeight;
@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnHeight;
@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) BOOL showOneLine;  //只显示一行

@property (readwrite, nonatomic, assign) NSInteger btnCount;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation CommonAlertContentView

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
        
        _minDescHeight = 120;
        _titleHeight = 40;
        _controlHeight = 50;
        _btnHeight = 40;
        _padding = [FMSize getInstance].defaultPadding;
        
    
        _titleContainerView = [[UIView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        
        _descContainerView = [[UIScrollView alloc] init];
        _descTV = [[BaseTextView alloc] init];
        _controlContainerView = [[UIView alloc] init];
        _leftDoBtn = [[UIButton alloc] init];
        _rightDoBtn = [[UIButton alloc] init];
        
        _descContainerView.delaysContentTouches = NO;
        _descContainerView.showsVerticalScrollIndicator = YES;
        
        _titleContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _descTV.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        _descTV.backgroundColor = [UIColor whiteColor];
        [_descTV setShowBounds:YES];
        [_descTV setContentFont:[FMFont setFontByPX:38]];
        
        [_descTV setOnViewResizeListener:self];
        
        _leftDoBtn.tag = COMMON_ALERT_OPERATE_TYPE_LEFT;
        _rightDoBtn.tag = COMMON_ALERT_OPERATE_TYPE_RIGHT;
        
//        _controlContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_leftDoBtn addTarget:self action:@selector(onLeftDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightDoBtn addTarget:self action:@selector(onRightDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        [_rightDoBtn.titleLabel setFont:[FMFont getInstance].defaultFontLevel2];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];

        [_titleContainerView addSubview:_titleLbl];
        
        [_descContainerView addSubview:_descTV];
        [_controlContainerView addSubview:_leftDoBtn];
        [_controlContainerView addSubview:_rightDoBtn];
        
        [self addSubview:_titleContainerView];
        [self addSubview:_descContainerView];
        [self addSubview:_controlContainerView];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat itemHeight;
    CGFloat leftBtnWidth;
    CGFloat rightBtnWidth;
    CGFloat originY = 0;
    
    //输入框
    CGFloat marginLeft = 13;
    CGFloat marginTop = 17;
    CGFloat marginBottom = 20;
    
    
    [_titleContainerView setFrame:CGRectMake(0, originY, width, _titleHeight)];
    [_titleLbl setFrame:CGRectMake(_padding, 0, width-_padding * 2, _titleHeight)];
    originY += _titleHeight;
    
    
    [_descContainerView setFrame:CGRectMake(0, originY, width, height-_controlHeight-_titleHeight)];
    
    if(_showOneLine) {
        itemHeight = _btnHeight;
    } else {
        itemHeight = CGRectGetHeight(_descTV.frame);
        if(itemHeight < _minDescHeight) {
            itemHeight = _minDescHeight;
        }
    }
    [_descTV setFrame:CGRectMake(marginLeft, marginTop, width-marginLeft * 2, itemHeight)];
    originY = marginTop + itemHeight + marginBottom;
    
    _descContainerView.contentSize = CGSizeMake(width, originY);
    
    [_controlContainerView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    if(_btnCount > 1) {
        leftBtnWidth = (width-marginLeft * 2 - marginLeft)/2;
        rightBtnWidth = width-marginLeft * 2 - marginLeft - leftBtnWidth;
    } else if(_btnCount > 0) {
        leftBtnWidth = width-marginLeft * 2;
        rightBtnWidth = 0;
    }
    [_leftDoBtn setFrame:CGRectMake(marginLeft, 0, leftBtnWidth, _btnHeight)];
    [_rightDoBtn setFrame:CGRectMake(marginLeft * 2 + leftBtnWidth, 0, rightBtnWidth, _btnHeight)];
    
//    [_leftDoBtn grayStyle];
//    [_rightDoBtn successStyle];
}

- (void) setTitleWithText:(NSString *) title {
    [_titleLbl setText:title];
}

- (void) setEditLabelWithText:(NSString *) text {
    [_descTV setTopDesc:text];
}

- (void) setTextFieldKeyboardType:(UIKeyboardType) keyboardType {
    [_descTV setKeyboardType:keyboardType];
}

- (void) setOperationButtonText:(NSString *) text {
    [_leftDoBtn setTitle:text forState:UIControlStateNormal];
    [_leftDoBtn setTitle:text forState:UIControlStateHighlighted];
    _btnCount = 1;
    [_leftDoBtn successStyle];
    
}

- (void) setOperationButtonTextArray:(NSMutableArray *) textArray {
    
    NSInteger count = [textArray count];
    _btnCount = count > 2?2:count;
    NSString * text;
    
    if(_btnCount > 1) {
        text = textArray[0];
        [_leftDoBtn setTitle:text forState:UIControlStateNormal];
        [_leftDoBtn setTitle:text forState:UIControlStateHighlighted];
        
        text = textArray[1];
        [_rightDoBtn setTitle:text forState:UIControlStateNormal];
        [_rightDoBtn setTitle:text forState:UIControlStateHighlighted];
        
        [_leftDoBtn grayStyle];
        [_rightDoBtn successStyle];
        
        
    } else if(_btnCount > 0) {
        text = textArray[0];
        [_leftDoBtn setTitle:text forState:UIControlStateNormal];
        [_leftDoBtn setTitle:text forState:UIControlStateHighlighted];
        [_leftDoBtn successStyle];
    }
}

- (void) setTextFieldKeyboardType {
    
}

//设置是否只显示一行
- (void) setShowOneLine:(BOOL) show {
    _showOneLine = show;
}

- (NSString *) getDesc {
    return [_descTV getContent];
}
//设置信息
- (void) setDesc:(NSString *) desc {
    [_descTV setContentWith:desc];
}

- (void) clearInput{
    [_descTV setContentWith:@""];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener {
    _clickListener = listener;
}

- (void) onLeftDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_leftDoBtn];
    }
}

- (void) onRightDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_rightDoBtn];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _descTV && !_showOneLine) {
        CGRect frame = _descTV.frame;
        frame.size = newSize;
        _descTV.frame = frame;
        [self updateViews];
    }
}
@end
