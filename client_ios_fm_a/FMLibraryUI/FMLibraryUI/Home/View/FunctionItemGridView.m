//
//  ProjectItemGridView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/15.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FunctionItemGridView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMTheme.h"

@interface FunctionItemGridView ()

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, assign) NSInteger amount;  //角标数量
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * message;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) UIImage * logo;


@property (readwrite, nonatomic, strong) UIImageView * projectLogoImgView;
@property (readwrite, nonatomic, strong) UILabel * projectNameLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;

@property (readwrite, nonatomic, strong) UIImageView * rightLbl;
@property (readwrite, nonatomic, strong) UIImageView * bottomLbl;

@property (readwrite, nonatomic, assign) CGFloat logoWidth;

@property (readwrite, nonatomic, assign) CGFloat statusHeight;

@property (readwrite, nonatomic, assign) BOOL showRightLine;
@property (readwrite, nonatomic, assign) BOOL showBottomLine;

@property (readwrite, nonatomic, weak) id<OnClickListener> listener;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation FunctionItemGridView

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
        
        _logoWidth = [FMSize getInstance].functionItemLogoWidth;
        _statusHeight = 18;
        
        UIFont * nameFont = [FMFont fontWithSize:13];
        UIFont * statusFont = [FMFont fontWithSize:10];
        
        _projectLogoImgView = [[UIImageView alloc] init];
        _projectNameLbl = [[UILabel alloc] init];
        
        _statusLbl = [[UILabel alloc] init];
        
        _rightLbl = [[UIImageView alloc] init];
        [_rightLbl setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
        
        _bottomLbl = [[UIImageView alloc] init];
        [_bottomLbl setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] width:1 height:1]];
        
        _projectNameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        [_projectNameLbl setFont:nameFont];
        [_projectNameLbl setTextAlignment:NSTextAlignmentCenter];
    
        [_statusLbl setFont:statusFont];
        _statusLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        _statusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        _statusLbl.layer.cornerRadius = _statusHeight / 2;
        _statusLbl.clipsToBounds = YES;
        
//        [self setImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND] width:1 height:1] forState:UIControlStateHighlighted];
        
//        [self setBackgroundImage:[FMUtils buttonImageFromColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8] width:1 height:1] forState:UIControlStateHighlighted];
        
        [self addSubview:_projectLogoImgView];
        [self addSubview:_projectNameLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_rightLbl];
        [self addSubview:_bottomLbl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat statusWidth = 0;
    CGFloat sepHeight = 10;
    CGFloat lineSize = [FMSize getInstance].seperatorHeight;
    CGFloat padding = _statusHeight * 7/ 8;    //与图标重叠位置的宽度
    CGFloat nameHeight = [FMUtils heightForStringWith:_projectNameLbl value:_name andWidth:width];
    CGFloat paddingTop = (height - _logoWidth-nameHeight-sepHeight)/2;
    
    
    [_projectLogoImgView setFrame:CGRectMake((width-_logoWidth)/2, paddingTop, _logoWidth, _logoWidth)];
    [_projectNameLbl setFrame:CGRectMake(0, paddingTop+_logoWidth+sepHeight, width, nameHeight)];
    
    if(_amount > 0) {
        NSString * strStatus = [self getStateDesc];
        statusWidth = [FMUtils widthForString:_statusLbl value:strStatus] + 8;
        if(statusWidth < _statusHeight) {
            statusWidth = _statusHeight;
        }
        [_statusLbl setFrame:CGRectMake((width+_logoWidth)/2-padding, paddingTop + padding-_statusHeight, statusWidth, _statusHeight)];
        [_statusLbl setHidden:NO];
    } else {
        [_statusLbl setHidden:YES];
    }
    
    [_rightLbl setFrame:CGRectMake(width-lineSize, 0, lineSize, height)];
    [_bottomLbl setFrame:CGRectMake(0, height-lineSize, width, lineSize)];
    [self updateInfo];
}


- (void) setShowRightLine:(BOOL) show {
    _showRightLine = show;
}

- (void) setShowBottomLine:(BOOL) show {
    _showBottomLine = show;
}

- (void) setInfoWithLogo:(UIImage*)logo name:(NSString*) name message: (NSString*)message time:(NSString*) time state:(NSInteger) state {
    _logo = logo;
    _name = name;
    _message = message;
    _time = time;
    _amount = state;
    [self updateViews];
}

- (void) setState:(NSInteger) state {
    _amount = state;
    [self updateViews];
}


- (void) setNameFont:(UIFont *) nameFont {
    [_projectNameLbl setFont:nameFont];
}

- (void) setStatusFont:(UIFont *) statusFont {
    [_projectNameLbl setFont:statusFont];
}

- (NSString *) getStateDesc {
    NSString * strStatus = nil;
    if(_amount > 0) {
        if(_amount <100) {
            strStatus = [[NSString alloc] initWithFormat:@"%ld", _amount];
        } else {
            strStatus = @"99+";
        }
    }
    
    return strStatus;
}

- (void) updateInfo {
    [_projectLogoImgView setImage:_logo];
    [_projectNameLbl setText:_name];
    
    if(_amount > 0) {
        NSString * strStatus = [self getStateDesc];
        
        [_statusLbl setText:strStatus];
    }
    
    if(_showRightLine) {
        [_rightLbl setHidden:!_showRightLine];
    }
    if(_showBottomLine) {
        [_bottomLbl setHidden:!_showBottomLine];
    }
}

- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:gesture];
    }
    _listener = listener;
}

- (void) onClicked:(id) gesture {
    if(_listener) {
        [_listener onClick:self];
    }
}

@end
