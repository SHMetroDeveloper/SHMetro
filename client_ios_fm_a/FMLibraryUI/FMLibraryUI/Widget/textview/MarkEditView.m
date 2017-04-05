//
//  MarkEditView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "MarkEditView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"


@interface MarkEditView ()

@property (readwrite, nonatomic, strong) UIView * leftView;

//标签
@property (readwrite, nonatomic, strong) UILabel * keyLbl;
@property (readwrite, nonatomic, assign) CGFloat labelWidth;

//星号标签
@property (readwrite, nonatomic, strong) UILabel * markLbl;
@property (readwrite, nonatomic, assign) BOOL showMark;

//showMoreImg
@property (readwrite, nonatomic, strong) UIImageView * showDetailImg;
@property (readwrite, nonatomic, assign) BOOL showDetail;

@end

@implementation MarkEditView

- (instancetype) init {
    self = [super init];
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        _keyLbl = [[UILabel alloc] init];
        _markLbl = [[UILabel alloc] init];
        _leftView = [[UIView alloc] init];
        
        UIFont * font = [FMFont getInstance].defaultFontLevel2;
        [_keyLbl setFont:font];
        [_keyLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        
        _markLbl.text = @"*";
        _markLbl.textColor = [UIColor redColor];
        
        _showDetailImg = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"TableViewArrow"]];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_leftView addSubview:_keyLbl];
        [_leftView addSubview:_markLbl];
        
        [self setLeftView:_leftView andLeftViewMode:BaseTextViewAlways];
    }
    return self;
}
- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    if(!_leftView) {
        _leftView = [[UIView alloc] init];
        [self setLeftView:_leftView andLeftViewMode:BaseTextViewAlways];
    }
    if(!_keyLbl) {
        _keyLbl = [[UILabel alloc] init];
        [_leftView addSubview:_keyLbl];
    }
    if(!_markLbl) {
        _markLbl = [[UILabel alloc] init];
        _markLbl.text = @"*";
        _markLbl.textColor = [UIColor redColor];
        [_leftView addSubview:_markLbl];
    }
    [self updateViews];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat markWidth = 14; // 星号宽度
    CGFloat labelWidth = 0;
    if(_labelWidth > 0) {
        labelWidth = _labelWidth;
    } else {
        labelWidth = [FMUtils widthForString:_keyLbl value:_keyLbl.text]+markWidth;
    }
    
    CGFloat textheight = [FMUtils heightForStringWith:_keyLbl value:_keyLbl.text andWidth:labelWidth];
    
    [_leftView setFrame:CGRectMake(self.paddingLeft, (height - textheight)/2, labelWidth, textheight)];
    
    [_keyLbl setFrame:CGRectMake(0, 0, labelWidth - markWidth, textheight)];
    [_markLbl setFrame:CGRectMake(labelWidth - markWidth, 0, markWidth, textheight)];
    if(_showMark) {
        [_markLbl setHidden:NO];
    } else {
        [_markLbl setHidden:YES];
    }
    
}

- (void) updateInfo {
    
}

- (void) setShowMark:(BOOL)showMark {
    _showMark = showMark;
    [self updateViews];
}

- (void) setLabelWithText:(NSString *) labelText andWidth:(CGFloat) labelWidth{
    _keyLbl.text = labelText;
    _labelWidth = labelWidth;
    [self updateViews];
}

- (void) setContent:(NSString *)content {
    [super setContentWith:content];
    [self updateViews];
}

- (void) setOnViewResizeListener:(id<OnViewResizeListener>)listener {
    [super setOnViewResizeListener:listener];
}

- (void) setOnClickedListener:(id<OnClickListener>)listener {
    [super setOnClickedListener:listener];
}
@end
