//
//  OptionSelectTableViewCell.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 2017/1/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "OptionSelectTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"

@interface OptionSelectTableViewCell ()
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *mColor;
@property (nonatomic, strong) UIFont *mFont;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation OptionSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont fontWithSize:12];
        UIColor *mColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _contentLbl = [UILabel new];
        _contentLbl.font = mFont;
        _contentLbl.textColor = mColor;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_contentLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = 15;
    CGFloat contetnHeight = 35;
    
    [_contentLbl setFrame:CGRectMake(padding, (height-contetnHeight)/2, width-padding*2, contetnHeight)];
    
    [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
}

- (void)updateInfo {
    if (_mColor) {
        _contentLbl.textColor = _mColor;
    }
    if (_mFont) {
        _contentLbl.font = _mFont;
    }
    if (![FMUtils isStringEmpty:_content]) {
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        [_contentLbl setText:_content];
    } else {
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        [_contentLbl setText:_placeHolder];
    }
    
    [self setNeedsLayout];
}

- (void)setContentColor:(UIColor *)mColor {
    _mColor = mColor;
    _contentLbl.textColor = _mColor;
}

- (void)setContentFont:(UIFont *)mFont {
    _mFont = mFont;
    _contentLbl.font = _mFont;
}

- (void)setPlaceHolder:(NSString *)placeholder {
    _placeHolder = placeholder;
    [_contentLbl setText:_placeHolder];
}

- (void)setContent:(NSString *)content {
    _content = content;
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 48;
    return height;
}

@end
