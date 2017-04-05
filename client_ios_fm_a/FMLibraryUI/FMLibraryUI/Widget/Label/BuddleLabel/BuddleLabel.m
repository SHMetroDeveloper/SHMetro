//
//  BuddleLabel.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BuddleLabel.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMImage.h"

@interface BuddleLabel ()

@property (readwrite, nonatomic, strong) UIImageView * bgImgView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;

@property (readwrite, nonatomic, assign) CGFloat buddleLeft;
@property (readwrite, nonatomic, assign) CGFloat buddleTop;
@property (readwrite, nonatomic, assign) CGFloat buddleRight;
@property (readwrite, nonatomic, assign) CGFloat buddleBottom;

@property (readwrite, nonatomic, strong) UIFont * titleFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation BuddleLabel

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
        
        _titleHeight = 30;
        _buddleLeft = 19;
        _buddleTop = 6;
        
        _bgImgView = [[UIImageView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _contentLbl = [[UILabel alloc] init];
        
        _contentLbl.numberOfLines = 0;
        
        _titleFont = [FMFont getInstance].defaultFontLevel2;
        _msgFont = [FMFont getInstance].defaultFontLevel2;
        
        [_titleLbl setFont:_titleFont];
        [_contentLbl setFont:_msgFont];
        
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
//        UIImage *buddleImg = [[UIImage imageNamed:@"buddle1"] stretchableImageWithLeftCapWidth:_buddleLeft topCapHeight:_buddleTop];
        
        
        UIImage *buddleImg = [[FMImage getInstance].bubbleImgDotted getImage];
        [_bgImgView setImage:buddleImg];
        
        [self addSubview:_bgImgView];
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_bgImgView setFrame:CGRectMake(0, 0, width, height)];
    [_titleLbl setFrame:CGRectMake(_buddleLeft, _buddleTop, width-_buddleLeft-_buddleRight, _titleHeight)];
    [_contentLbl setFrame:CGRectMake(_buddleLeft, _buddleTop+_titleHeight, width-_buddleLeft-_buddleRight, height-_buddleTop-_buddleBottom-_titleHeight)];
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    [_contentLbl setText:_content];
}

- (void) setInfoWithTitle:(NSString *) title content:(NSString *) content {
    _title = title;
    _content = content;
    [self updateViews];
}

+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width {
    CGFloat height = 0;
    CGFloat buddleLeft = 21;
    CGFloat buddleTop = 14;
    CGFloat buddleRight = 21;
    CGFloat buddleBottom = 14;
    CGFloat titleHeight = 30;
    CGFloat contentHeight = 0;
    CGFloat contentWidth = width-buddleLeft-buddleRight;
    UILabel * contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, titleHeight)];
    contentLbl.numberOfLines = 0;
    contentLbl.font = [FMFont getInstance].defaultFontLevel2;
    
    contentHeight = [FMUtils heightForStringWith:contentLbl value:content andWidth:contentWidth];
    if(contentHeight < titleHeight) {
        contentHeight = titleHeight;
    }
    
    height = buddleTop + buddleBottom + titleHeight + contentHeight;
    
    return height;
}

@end
