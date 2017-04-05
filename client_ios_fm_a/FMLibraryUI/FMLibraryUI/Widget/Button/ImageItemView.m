//
//  ImageItemView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/5/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ImageItemView.h"
#import "FMUtils.h"
#import "FMTheme.h"

@interface ImageItemView ()

@property (readwrite, nonatomic, strong) UIButton * logoBtn;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;

@property (readwrite, nonatomic, strong) UIImage * logoImg;
@property (readwrite, nonatomic, strong) UIImage * logoImgHighlight;
@property (readwrite, nonatomic, strong) NSString * name;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, strong) UIFont * nameFont;
@property (readwrite, nonatomic, assign) CGFloat logoWidth;
@property (readwrite, nonatomic, assign) CGFloat logoHeight;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ImageItemView

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

- (void) initSettings {
    _logoHeight = _logoWidth = 32;
    _nameFont = [UIFont fontWithName:@"Helvetica" size:14];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        [self initSettings];
        _logoBtn = [[UIButton alloc] init];
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = _nameFont;
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [_logoBtn addTarget:self action:@selector(onLogoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_logoBtn];
        [self addSubview:_nameLbl];
    }
}

- (void) updateViews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat nameHeight = 0;
    CGFloat sepHeight = 0;
    
    [_nameLbl setFrame:CGRectMake(0, 0, width-_paddingLeft-_paddingRight, 40)];
    nameHeight = [FMUtils heightForStringWith:_nameLbl value:_name andWidth:width-_paddingLeft-_paddingRight];
    
    sepHeight = (height - nameHeight - _logoHeight) / 3;
    [_logoBtn setFrame:CGRectMake((width-_logoWidth)/2, sepHeight, _logoWidth, _logoHeight)];
    [_nameLbl setFrame:CGRectMake(_paddingLeft, _logoHeight + sepHeight*2, width-_paddingLeft-_paddingRight, nameHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    if(_logoImg) {
        [_logoBtn setImage:_logoImg forState:UIControlStateNormal];
    }
    if(_logoImgHighlight) {
        [_logoBtn setImage:_logoImgHighlight forState:UIControlStateHighlighted];
    }
    [_nameLbl setText:_name];
}

- (void) setInfoWithName:(NSString *)name andLogo:(UIImage *)logoImg {
    _logoImg = logoImg;
    _logoImgHighlight = nil;
    _name = name;
    [self updateViews];
}

- (void) setInfoWithName:(NSString *) name andLogo:(UIImage *) logoImg andHighlightLogo:(UIImage *) logoHighlight {
    _logoImg = logoImg;
    _logoImgHighlight = logoHighlight;
    _name = name;
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat)paddingRight {
    [self updateViews];
}

- (void) setLogoWidth:(CGFloat)logoWidth {
    _logoWidth = logoWidth;
    _logoHeight = _logoWidth;
    [self updateViews];
}

//设置logo图标宽度高度
- (void) setLogoWidth:(CGFloat)logoWidth andLogoHeight:(CGFloat) logoHeight {
    _logoWidth = logoWidth;
    _logoHeight = logoHeight;
    [self updateViews];
}

- (void) setTextColor:(UIColor *) color {
    _nameLbl.textColor = color;
}

- (void) setText:(NSString *) text {
    _nameLbl.text = text;
}

//设置点击事件监听
- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
    
}

- (void) onClicked:(id) sender {
    if(_listener) {
        [_listener onClick:self];
    }
}

- (void) onLogoBtnClicked {
    if(_listener) {
        [_listener onClick:self];
    }
}

@end