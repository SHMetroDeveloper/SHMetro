//
//  BaseStarRatingView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 10/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BaseStarRatingView.h"
#import "FMUtilsPackages.h"
#import "HCSStarRatingView.h"

@interface BaseStarRatingView ()

@property (readwrite, nonatomic, strong) UILabel *nameLbl;
@property (readwrite, nonatomic, strong) HCSStarRatingView *ratingView;

@property (readwrite, nonatomic, assign) CGFloat nameWidth;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation BaseStarRatingView

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
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font42;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _ratingView = [[HCSStarRatingView alloc] init];
        _ratingView.maximumValue = 5;
        _ratingView.minimumValue = 0.5f;
        _ratingView.allowsHalfStars = YES;
        _ratingView.emptyStarImage = [[FMTheme getInstance]  getImageByName:@"rate_star_empty"];
        _ratingView.halfStarImage = [[FMTheme getInstance]  getImageByName:@"rate_star_half"];
        _ratingView.filledStarImage = [[FMTheme getInstance]  getImageByName:@"rate_star_filled"];
        _ratingView.spacing = 13;
        
        [self addSubview:_nameLbl];
        [self addSubview:_ratingView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat ratingWidth = 180.0f;
    CGSize nameSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font42 andContent:_nameLbl.text andMaxWidth:MAXFLOAT];
    
    CGFloat originX = padding;
    [_nameLbl setFrame:CGRectMake(originX, (height-nameSize.height)/2, width-padding*3-ratingWidth, nameSize.height)];
    
    [_ratingView setFrame:CGRectMake(width-ratingWidth-padding, 7, ratingWidth, height - 14)];
}

//设置进度 (0 ~ 10)
- (void) setRating:(NSInteger) rating {
    _ratingView.value = rating;
}

//设置名称
- (void) setName:(NSString *) name {
    [_nameLbl setText:name];
//    [self updateInfo];
    [self updateViews];
}

//获取当前评级
- (CGFloat) getRateValue {
    CGFloat rateValue = 0;
    rateValue = _ratingView.value * 2;
    return rateValue;
}

@end



