//
//  RadioItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/12.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "RadioItemView.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"

@interface RadioItemView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, assign) BOOL isChecked;    //是否选中


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIButton * checkBtn;
@property (readwrite, nonatomic, strong) UIImageView * btnImageView;

@property (readwrite, nonatomic, assign) CGFloat buttonWidth;
@property (readwrite, nonatomic, assign) CGFloat buttonImageWidth;

@property (readwrite, nonatomic, weak) id<OnListItemButtonClickListener> listener;

@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@end

@implementation RadioItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        if(!_nameFont) {
            _nameFont  = [FMFont getInstance].defaultFontLevel2;
        }
        
        
        _buttonWidth = [FMSize getInstance].imgWidthLevel1;
        _buttonImageWidth = [FMSize getInstance].imgWidthLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _checkBtn = [[UIButton alloc] init];
        _btnImageView = [[UIImageView alloc] init];
        
        [_checkBtn addTarget:self action:@selector(onCheckButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self updateSubViews];
        
        [_checkBtn addSubview:_btnImageView];
        
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
    [_btnImageView setFrame:CGRectMake((_buttonWidth - _buttonImageWidth)/2, (_buttonWidth - _buttonImageWidth)/2, _buttonImageWidth, _buttonImageWidth)];
    
    [_nameLbl setFont:_nameFont];
    
    if(_name) {
        _nameLbl.text = _name;
    }
    [self updateCheckButton]; 
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
        [_btnImageView setImage:[[FMTheme getInstance] getImageByName:@"btn_radio_on"]];
    } else {
        [_btnImageView setImage:[[FMTheme getInstance] getImageByName:@"btn_radio_off"]];
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
