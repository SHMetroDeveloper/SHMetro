//
//  DescriptionLabelView2.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "DescriptionLabelView2.h"
#import "FMUtilsPackages.h"

@interface DescriptionLabelView2()
@property (nonatomic, assign) BOOL isInited;
@end

@implementation DescriptionLabelView2

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateView];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _titleLbl = [UILabel new];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        _titleLbl.numberOfLines = 1;
        
        _contentLbl = [UILabel new];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
    }
}

- (void) updateView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    
    CGSize titleSize = [FMUtils getLabelSizeByFont:_titleLbl.font andContent:_titleLbl.text andMaxWidth:width];
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
    originX += titleSize.width;
    
    CGSize contentSize = [FMUtils getLabelSizeByFont:_contentLbl.font andContent:_contentLbl.text andMaxWidth:width-titleSize.width];
    [_contentLbl setFrame:CGRectMake(originX, originY, width-titleSize.width, contentSize.height)];
    
    if (height < contentSize.height) {
        CGRect tmpRect = self.frame;
        tmpRect.size.height = contentSize.height;
        self.frame = tmpRect;
    }
}

- (void)setTitle:(NSString *)title {
    _titleLbl.text = @"";
    if (![FMUtils isStringEmpty:title]) {
        _titleLbl.text = title;
    }
    
    [self updateView];
}

- (void)setContent:(NSString *)content {
    _contentLbl.text = @"";
    if (![FMUtils isStringEmpty:content]) {
        _contentLbl.text = content;
    }
    
    [self updateView];
}

- (CGFloat) getHeight {
    CGFloat height = CGRectGetHeight(self.frame);
    return height;
}

@end
