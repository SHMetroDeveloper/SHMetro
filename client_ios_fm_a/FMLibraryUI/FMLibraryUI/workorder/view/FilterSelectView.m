//
//  FilterSelectView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FilterSelectView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface FilterSelectView()

@property (nonatomic, strong) UILabel * titleLbl;
@property (nonatomic, strong) UIImageView * checkoutImgView;

@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation FilterSelectView

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
    if (!_isInited) {
        _isInited = YES;
        
        //标题lbl
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont getInstance].font42;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        //checkimageView
        _checkoutImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"checked"]];
        _checkoutImgView.hidden = YES;
        
        [self addSubview:_titleLbl];
        [self addSubview:_checkoutImgView];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (width == 0 || height == 0) {
        return;
    }
    
    CGFloat padding = [FMSize getInstance].padding80;
    padding = 15;
    CGFloat imgWidth = 40*2/5;
    CGFloat imgHeight = 30*2/5;
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleStr andMaxLabelWidth:width];
    
    CGFloat originX = padding;
    CGFloat originY = (height - titleSize.height)/2;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
    
    _checkoutImgView.hidden = _isChecked;
    [_checkoutImgView setFrame:CGRectMake(width - padding - imgWidth, (height - imgHeight)/2, imgWidth, imgHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_titleStr];
}

- (void)setTitleInfoWith:(NSString *)name {
    _titleStr = name;
    
    [self updateViews];
}

- (void)setChecked:(BOOL)checked {
    _isChecked = !checked;
    if (checked) {
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
    } else {
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    }
    [self updateViews];
}

+ (CGFloat) calculateHeightByTitle:(NSString *) titleStr andWidth:(CGFloat) width {
    CGFloat height = 0;
    CGFloat sepHeight = 10;
    
    UILabel * testLbl = [[UILabel alloc] init];
    testLbl.font = [FMFont getInstance].listCodeFont;
    testLbl.text = titleStr;
    
    CGSize realSize = [FMUtils getLabelSizeBy:testLbl andContent:titleStr andMaxLabelWidth:width];
    
    height = realSize.height + sepHeight*2;
    
    return height;
}

@end





