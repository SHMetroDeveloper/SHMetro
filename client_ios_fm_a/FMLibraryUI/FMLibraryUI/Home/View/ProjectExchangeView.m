//
//  ProjectExchangeView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ProjectExchangeView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"

@interface ProjectExchangeView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UIImageView * exchangeImgView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation ProjectExchangeView

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
        
        UIFont * nameFont = [FMFont getInstance].defaultFontLevel1;
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _exchangeImgView = [[UIImageView alloc] init];
        
        _nameLbl.font = nameFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_exchangeImgView setImage:[[FMTheme getInstance] getImageByName:@"down_arrow_white_slim"]];
        
        _nameLbl.userInteractionEnabled = NO;
        _exchangeImgView.userInteractionEnabled = NO;
        
        [self addSubview:_nameLbl];
        [self addSubview:_exchangeImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    CGFloat sepWidth = 10;
//    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat originX = 16;
    if(nameWidth > width-_imgWidth - originX-sepWidth) {
        nameWidth = width-_imgWidth - originX-sepWidth;
    }
    [_nameLbl setFrame:CGRectMake(originX, 0, nameWidth, height)];
    originX += nameWidth + sepWidth;
    
    [_exchangeImgView setFrame:CGRectMake(originX, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setText:_name];
}

- (void) setInfoWithName:(NSString *) name {
    _name = name;
    [self updateViews];
}

+ (CGFloat) calculateWidthBy:(NSString *) name {
    CGFloat width = 0;
    CGFloat padding = 16;
    CGFloat sepWidth = 10;
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel1;
    
    UILabel * nameLbl = [[UILabel alloc] init];
    nameLbl.font = [FMFont getInstance].defaultFontLevel1;
    CGFloat nameWidth = [FMUtils widthForString:nameLbl value:name];
    width = nameWidth + padding + sepWidth + imgWidth;
    return width;
}
@end
