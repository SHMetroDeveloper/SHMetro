//
//  CheckableItemView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/18.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "CheckableItemView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"


@interface CheckableItemView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, assign) BOOL isChecked;    //是否选中


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIImageView * checkImgView;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;


@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@end

@implementation CheckableItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSubViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initSubViews];
        [self updateSubViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) initSubViews {
    if(!_isInited) {
        _isInited = YES;
        
        _nameFont  = [FMFont getInstance].defaultFontLevel2;
        
        
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _checkImgView = [[UIImageView alloc] init];
        
        [self addSubview:_nameLbl];
        [self addSubview:_checkImgView];
    }
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width ==0 || height == 0) {
        return;
    }
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, width - _paddingLeft - _paddingRight - _imgWidth, height)];
    [_checkImgView setFrame:CGRectMake(width-_paddingRight-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    
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
        [_checkImgView setImage:[[FMTheme getInstance] getImageByName:@"btn_check_on"]];
    } else {
        [_checkImgView setImage:[[FMTheme getInstance] getImageByName:@"btn_check_off"]];
    }
}

#pragma - onclick 事件
- (void) actiondo:(UIView *) v {
    [self notifyViewClicked];
    
}

- (void) notifyViewClicked {
    if(_listener) {
        [_listener onClick:self];
    }
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
}

- (BOOL) isChecked {
    return _isChecked;
}

- (void) setChecked:(BOOL) isChecked {
    _isChecked = isChecked;
    [self updateInfo];
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

