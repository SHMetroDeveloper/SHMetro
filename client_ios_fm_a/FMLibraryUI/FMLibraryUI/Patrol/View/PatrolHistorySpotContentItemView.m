//
//  PatrolHistorySpotContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistorySpotContentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "UIButton+Bootstrap.h"
#import "FMSize.h"
#import "FMFont.h"

@interface PatrolHistorySpotContentItemView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, strong) NSString * result;    //检测结果
@property (readwrite, nonatomic, strong) NSString * normalStr;  //正常
@property (readwrite, nonatomic, strong) NSString * reportStr;  //正常


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * resultLbl;
@property (readwrite, nonatomic, strong) UILabel * normalLbl;
@property (readwrite, nonatomic, strong) UIButton * reportBtn;

@property (readwrite, nonatomic, weak) id<OnListItemButtonClickListener> listener;

@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat buttonWidth;

@end

@implementation PatrolHistorySpotContentItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        if(!_nameFont) {
            _nameFont  = [FMFont getInstance].defaultFontLevel2;
        }
        _buttonWidth = 60;
        
        _nameLbl = [[UILabel alloc] init];
        _resultLbl = [[UILabel alloc] init];
        _normalLbl = [[UILabel alloc] init];
        _reportBtn = [[UIButton alloc] init];
        
        _resultLbl.textAlignment = NSTextAlignmentCenter;
        _normalLbl.textAlignment = NSTextAlignmentCenter;
        
        [_reportBtn addTarget:self action:@selector(onReportButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_reportBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK] forState:UIControlStateNormal];
        
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [self updateSubViews];
        
        [self addSubview:_nameLbl];
        [self addSubview:_resultLbl];
        [self addSubview:_normalLbl];
        [self addSubview:_reportBtn];
    }
    return self;
}

- (void) updateSubViews {
    if(!_nameFont) {
        _nameFont  = [FMFont getInstance].defaultFontLevel2;
    }
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    _buttonWidth = 50;
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, width - _paddingLeft - _paddingRight - _buttonWidth*3, height)];
    [_resultLbl setFrame:CGRectMake(width - _paddingRight - _buttonWidth*3, 0, _buttonWidth, height)];
    [_normalLbl setFrame:CGRectMake(width - _paddingRight - _buttonWidth*2, 0, _buttonWidth, height)];
    [_reportBtn setFrame:CGRectMake(width-_paddingRight-_buttonWidth, (height-_buttonWidth)/2, _buttonWidth, _buttonWidth)];
    
    [_nameLbl setFont:_nameFont];
    [_resultLbl setFont:_nameFont];
    [_normalLbl setFont:_nameFont];
    [_reportBtn.titleLabel setFont:_nameFont];
    
    [self updateInfo];
    
}

- (void) setInfoWithName:(NSString*) name
                  result:(NSString*) result
                  normal:(NSString*) normalStr
                  report:(NSString*) reportStr {
    _name = name;
    _result = result;
    _normalStr = normalStr;
    _reportStr = reportStr;
    [self updateInfo];
}

- (void) updateInfo {
    if(_name) {
        _nameLbl.text = _name;
    }
    if(_result) {
        [_resultLbl setHidden:NO];
        _resultLbl.text = _result;
    } else {
        [_resultLbl setHidden:YES];
    }
    if(_normalStr) {
        [_normalLbl setHidden:NO];
        _normalLbl.text = _normalStr;
    } else {
        [_normalLbl setHidden:YES];
    }
    if(_reportStr) {
        [_reportBtn setHidden:NO];
        [_reportBtn setTitle:_reportStr forState:UIControlStateNormal];
    } else {
        [_reportBtn setHidden:YES];
    }

}

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener {
    _listener = listener;
}

- (void) onReportButtonClicked {
    if(_listener) {
        [_listener onButtonClick:self view:_reportBtn];
    }
}


- (void) setFont:(UIFont*) font {
    _nameFont = font;
    _nameLbl.font = _nameFont;
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right {
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubViews];
}

@end



