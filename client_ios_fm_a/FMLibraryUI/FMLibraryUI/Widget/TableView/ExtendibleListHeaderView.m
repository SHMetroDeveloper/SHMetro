//
//  ExtendibleListHeaderView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ExtendibleListHeaderView.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface ExtendibleListHeaderView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, assign) BOOL isExtend;    //是否处于展开状态


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIImageView * extendImgView;
@property (readwrite, nonatomic, strong) UILabel * indicator;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, strong) UIFont * nameFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, weak) id<OnListSectionHeaderExtendListener> listener;


@end

@implementation ExtendibleListHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        if(!_nameFont) {
            _nameFont  = [UIFont fontWithName:@"Helvetica" size:20];
        }
        _imgWidth = 32;
        _nameLbl = [[UILabel alloc] init];
        _extendImgView = [[UIImageView alloc] init];
        _indicator = [[UILabel alloc] init];
        [self updateSubViews];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_nameLbl];
        [self addSubview:_extendImgView];
        [self addSubview:_indicator];
        
        [self addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
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
    _imgWidth = 32;
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, width - _paddingLeft - _paddingRight - _imgWidth, height)];
    [_extendImgView setFrame:CGRectMake(width-_paddingRight-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    [_indicator setFrame:CGRectMake(0, height-1, width, 1)];
    [_indicator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
    
    [_nameLbl setFont:_nameFont];
    
    if(_name) {
        _nameLbl.text = _name;
    }
    [self updateImage];
    
    
}

- (void) setInfoWithName:(NSString*) name
                  extend:(BOOL) extend{
    _name = name;
    _isExtend = extend;
    [self updateInfo];
}

- (void) updateInfo {
    _nameLbl.text = _name;
    [self updateImage];
}
- (void) updateImage {
    if(_isExtend) {
        [_extendImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
    } else {
        [_extendImgView setImage:[[FMTheme getInstance] getImageByName:@"icon_pre"]];
    }
}

- (void) setOnListSectionHeaderExtendListener:(id<OnListSectionHeaderExtendListener>) listener {
    _listener = listener;
}

- (void) changeState {
    _isExtend = !_isExtend;
    [self updateImage];
    if(_listener) {
        [_listener onListSectionHeaderExtend:self extend:_isExtend];
    }
}

- (BOOL) isChecked {
    return _isExtend;
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

