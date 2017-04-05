//
//  SimpleListHeaderView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/5/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "SimpleListHeaderView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "SeperatorView.h"

@interface SimpleListHeaderView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;
@property (readwrite, nonatomic, strong) SeperatorView * bottomSeperator;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, strong) NSString * name;

@property (readwrite, nonatomic, assign) BOOL showTopLine;  //显示上分割线
@property (readwrite, nonatomic, assign) BOOL showBottomLine;//显示下分割线

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation SimpleListHeaderView

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
        
        _paddingTop = 15;
        _paddingBottom = 7;
        _paddingLeft = 15;
        _paddingRight = _paddingLeft;
        
        _showTopLine = NO;
        _showBottomLine = YES;
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].defaultFontLevel2;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _topSeperator = [[SeperatorView alloc] init];
        _bottomSeperator = [[SeperatorView alloc] init];
        
        [_topSeperator setHidden:YES];
        
        [self addSubview:_nameLbl];
        [self addSubview:_topSeperator];
        [self addSubview:_bottomSeperator];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, _paddingTop, width-_paddingLeft-_paddingRight, height-_paddingTop-_paddingBottom)];
    
    [_topSeperator setFrame:CGRectMake(0, 0, width, seperatorHeight)];
    [_bottomSeperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    [self updateInfo];
}

- (void) updateInfo {
    if(_name) {
        [_nameLbl setText:_name];
    } else {
        [_nameLbl setText:@""];
    }
    [_topSeperator setHidden:!_showTopLine];
    [_bottomSeperator setHidden:!_showBottomLine];
}

- (void) setTitleFont:(UIFont *)mFont {
    _nameLbl.font = mFont;
}

- (void) setTitleColor:(UIColor *)mColor {
    _nameLbl.textColor = mColor;
}

- (void) setInfoWithText:(NSString *)text {
    _name = text;
    [self updateInfo];
}

- (void) setShowTopLine:(BOOL)showTopLine showBottomLine:(BOOL) showBottomLine {
    _showTopLine = showTopLine;
    _showBottomLine = showBottomLine;
    [self updateInfo];
}

@end
