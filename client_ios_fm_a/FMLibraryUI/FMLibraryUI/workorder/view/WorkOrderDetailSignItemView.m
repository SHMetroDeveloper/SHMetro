//
//  WorkOrderDetailSignItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailSignItemView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "FMFont.h"
#import "UIImageView+AFNetworking.h"
#import "FMTheme.h"

@interface WorkOrderDetailSignItemView ()

@property (readwrite, nonatomic, strong) UILabel * typeLbl;
@property (readwrite, nonatomic, strong) UIImageView * signImgView;

@property (readwrite, nonatomic, strong) NSString * type;
@property (readwrite, nonatomic, strong) UIImage * signImg;
@property (readwrite, nonatomic, strong) NSURL * signImgUrl;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat imgHeight;

@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation WorkOrderDetailSignItemView

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
        
        _imgWidth = 100;
        _imgHeight = 50;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = [FMSize getInstance].defaultPadding;
        
        _typeLbl = [[UILabel alloc] init];
        _signImgView = [[UIImageView alloc] init];
        
        [_typeLbl setFont:[FMFont getInstance].defaultFontLevel2];
        [_typeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        [self addSubview:_typeLbl];
        [self addSubview:_signImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemWidth = 0;
    CGFloat sepWidth = [FMSize getInstance].defaultPadding;
    [_typeLbl setFrame:CGRectMake(_paddingLeft, (height-itemHeight)/2, width-_paddingLeft-_paddingRight, itemHeight)];
    
    itemWidth = [FMUtils widthForString:_typeLbl value:_type];
    [_typeLbl setFrame:CGRectMake(_paddingLeft, (height-itemHeight)/2, itemWidth, itemHeight)];
    
    [_signImgView setFrame:CGRectMake(_paddingLeft+sepWidth+itemWidth, (height - _imgHeight)/2, _imgWidth, _imgHeight)];
    
    [self updateInfo];
    
}

- (void) updateInfo {
    [_typeLbl setText:_type];
    if(_signImg) {
        [_signImgView setImage:_signImg];
    } else {
        [_signImgView setImageWithURL:_signImgUrl];
    }
    
}

- (void) setInfoWithType:(NSString *) type image:(UIImage *) signImg {
    _type = type;
    _signImg = signImg;
    [self updateViews];
}

- (void) setInfoWithType:(NSString *) type imageUrl:(NSURL *) signImgUrl {
    _type = type;
    _signImgUrl = signImgUrl;
    [self updateViews];
}

- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

@end
