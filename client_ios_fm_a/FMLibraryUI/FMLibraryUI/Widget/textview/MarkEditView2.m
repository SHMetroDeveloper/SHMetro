//
//  ReportBaseItemView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MarkEditView2.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseTextView.h"
#import "BaseBundle.h"

@interface MarkEditView2()

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * markedLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UITextField * textField;
@property (readwrite, nonatomic, strong) UIImageView * nextGenerationImgView;

@property (readwrite, nonatomic, assign) BOOL isMarked;
@property (readwrite, nonatomic, assign) BOOL showMore;
@property (readwrite, nonatomic, assign) BOOL canEditable;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, strong) NSString * titleStr;
@property (readwrite, nonatomic, strong) NSString * descStr;

@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;

@end

@implementation MarkEditView2

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
    if (!_isInited) {
        _isInited = YES;
        
        
        //标题信息
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.font = [FMFont setFontByPX:44];
        
        //必填标签
        _markedLbl = [[UILabel alloc] init];
        _markedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _markedLbl.font = [FMFont setFontByPX:60];
        _markedLbl.textAlignment = NSTextAlignmentLeft;
        _markedLbl.text = @"*";
        _markedLbl.hidden = YES;
        
        //信息展示lbl
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _descLbl.font = [FMFont setFontByPX:38];
        _descLbl.textAlignment = NSTextAlignmentRight;
        _descLbl.numberOfLines = 1;
        _descLbl.hidden = YES;
        
        //信息输入框
        _textField = [[UITextField alloc] init];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [FMFont setFontByPX:38];
        _textField.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.hidden = YES;
        //向右箭头
        _nextGenerationImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    
        [self addSubview:_titleLbl];
        [self addSubview:_markedLbl];
        [self addSubview:_descLbl];
        [self addSubview:_textField];
        [self addSubview:_nextGenerationImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if (width == 0 || height == 0) {
        return;
    }
    
    //设置键盘的toolBar
    UIView * toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    toolBar.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    UIButton * doBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 60 , 5, 40, 30)];
    [doBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_finish" inTable:nil] forState:UIControlStateNormal];
    [doBtn setTitleColor:[UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1] forState:UIControlStateNormal];
    [doBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doBtn addTarget:self action:@selector(finishEdit) forControlEvents:UIControlEventTouchUpInside];
    doBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel1;
    [toolBar addSubview:doBtn];
    _textField.inputAccessoryView = toolBar;
    
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleStr andMaxLabelWidth:width];
    
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat sepHeight = (height - titleSize.height)/2;
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    CGFloat labelWidth = 200;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
    
    [_markedLbl setFrame:CGRectMake(originX+titleSize.width+5, originY+5, 8, titleSize.height)];
    
    [_descLbl setFrame:CGRectMake(width-[FMSize getSizeByPixel:106]-labelWidth, originY, labelWidth, titleSize.height)];
    
    [_textField setFrame:CGRectMake(width-[FMSize getSizeByPixel:106]-labelWidth, originY, labelWidth, titleSize.height)];
    
    [_nextGenerationImgView setFrame:CGRectMake(width-titleSize.height-padding, originY, titleSize.height, titleSize.height)];
}

- (void) updateInfo {
    [_titleLbl setText:_titleStr];
    [_descLbl setText:_descStr];
    [_textField setText:_descStr];
    
    [self updateViews];
}

- (void) setTitle:(NSString *)title andDescription:(NSString *)desc {
    _titleStr = title;
    _descStr = desc;
    
    [self updateInfo];
}

- (void) setEditable:(BOOL)editable showMore:(BOOL) showmore isMarked:(BOOL) ismarked {
    if (editable) {
        _textField.hidden = NO;
        _descLbl.hidden = YES;
    } else {
        _textField.hidden = YES;
        _descLbl.hidden = NO;
    }
    
    if (showmore) {
        _nextGenerationImgView.hidden = NO;
    } else {
        _nextGenerationImgView.hidden = YES;
    }
    
    if (ismarked) {
        _markedLbl.hidden = NO;
    } else {
        _markedLbl.hidden = YES;
    }
    
    [self updateViews];
}

- (NSString *) getContent{
    NSString * result;
    if (_textField.text) {
        result = _textField.text;
    } else {
        result = _descLbl.text;
    }
    return result;
}

#pragma mark - 注销键盘
- (void) finishEdit {
    [_textField resignFirstResponder];
}

#pragma mark - 设置点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}

- (void) actiondo:(UIView *) v {
    if(_clickListener) {
        [_clickListener onClick:self];
    }
}

@end
