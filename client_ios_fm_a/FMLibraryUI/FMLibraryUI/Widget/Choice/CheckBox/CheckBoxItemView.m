//
//  PatrolHistoryFilterItemSpotStatusView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "CheckBoxItemView.h"
#import "FMUtils.h"
#import "FMTheme.h"

@interface CheckBoxItemView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, assign) BOOL isChecked;    //是否选中


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIButton * checkBtn;

@property (readwrite, nonatomic, assign) CGFloat buttonWidth;
@property (readwrite, nonatomic, weak) id<OnListItemButtonClickListener> listener;

@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@end

@implementation CheckBoxItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        if(!_nameFont) {
            _nameFont  = [UIFont fontWithName:@"Helvetica" size:14];
        }
        
        _buttonWidth = 32;
        
        _nameLbl = [[UILabel alloc] init];
        _checkBtn = [[UIButton alloc] init];
        
        
        [_checkBtn addTarget:self action:@selector(onCheckButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self updateSubViews];
    
        [self addSubview:_nameLbl];
        [self addSubview:_checkBtn];
    }
    return self;
}

- (void) updateSubViews {
    if(!_nameFont) {
        _nameFont  = [UIFont fontWithName:@"Helvetica" size:14];
    }
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    _buttonWidth = 32;
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, width - _paddingLeft - _paddingRight - _buttonWidth, height)];
    [_checkBtn setFrame:CGRectMake(width-_paddingRight-_buttonWidth, (height-_buttonWidth)/2, _buttonWidth, _buttonWidth)];
    
    
    [_nameLbl setFont:_nameFont];
    
    if(_name) {
        _nameLbl.text = _name;
    }
    if(_isChecked) {
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_on"] forState:UIControlStateNormal];
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_on_light"] forState:UIControlStateHighlighted];
    } else {
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_off"] forState:UIControlStateNormal];
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_off_light"] forState:UIControlStateHighlighted];
    }
    
    
}

- (void) setInfoWithName:(NSString*) name
               isChecked:(BOOL) isChecked {
    _name = name;
    _isChecked = isChecked;
    [self updateInfo];
}

- (void) updateInfo {
    _nameLbl.text = _name;
    [self updateCheckButton];
}
- (void) updateCheckButton {
    if(_isChecked) {
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_on"] forState:UIControlStateNormal];
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_on_light"] forState:UIControlStateHighlighted];
    } else {
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_off"] forState:UIControlStateNormal];
        [_checkBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_check_off_light"] forState:UIControlStateHighlighted];
    }
}

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener {
    _listener = listener;
}

- (void) onCheckButtonClicked {
    _isChecked = !_isChecked;
    [self updateCheckButton];
    if(_listener) {
        [_listener onButtonClick:self view:_checkBtn];
    }
}

- (BOOL) isChecked {
    return _isChecked;
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


