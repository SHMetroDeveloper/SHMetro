//
//  FilterButton.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/8/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FilterButton.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface FilterButton ()

@property (readwrite, nonatomic, strong) UIImageView * imageFilter;
@property (readwrite, nonatomic, assign) CGFloat imageWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat sepWidth;
@property (readwrite, nonatomic, assign) CGFloat radius;
@property (readwrite, nonatomic, strong) UIFont* mFont;
@property (readwrite, nonatomic, strong) UIColor* bgColor;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation FilterButton

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
        
        _radius = 8;
        _bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _imageWidth = [FMSize getInstance].imgWidthLevel2;
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _sepWidth = [FMSize getInstance].defaultPadding/2;
        _mFont = [FMFont getInstance].defaultFontLevel2;
        
//        _imageFilter = [[UIImageView alloc] initWithFrame:CGRectMake(_paddingLeft, 0, _imageWidth, _imageWidth)];
        _imageFilter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_imageFilter setImage:[[FMTheme getInstance] getImageByName:@"icon_fliter_little"]];
        [_imageFilter setHighlightedImage:[[FMTheme getInstance] getImageByName:@""]];
        
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.titleLabel setFont:_mFont];
//        [self setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_filter" inTable:nil] forState:UIControlStateNormal];
        self.backgroundColor = _bgColor;
        
        self.layer.cornerRadius = self.frame.size.width/2;
        
        
//        self.layer.shadowOffset = CGSizeMake(1, 1);
//        self.layer.shadowOpacity = 0.7;
//        self.layer.shadowRadius = 0.5f;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self addSubview:_imageFilter];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    //设置button的图片与阴影
    [_imageFilter setFrame:CGRectMake((width - width/3)/2, (height - height/3)/2, width/3, height/3)];
    self.layer.cornerRadius = width/2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
//    [_imageFilter setFrame:CGRectMake(_paddingLeft, (height-_imageWidth)/2, _imageWidth, _imageWidth)];
//    self.contentEdgeInsets = UIEdgeInsetsMake(0, (_imageWidth + _paddingLeft + _sepWidth), 0, 0);
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(_radius, _radius)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.layer.mask = maskLayer;
    
}
@end
