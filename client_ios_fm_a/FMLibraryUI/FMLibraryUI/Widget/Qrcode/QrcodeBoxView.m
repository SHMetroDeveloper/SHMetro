//
//  QrcodeBoxView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "QrcodeBoxView.h"
#import "FMTheme.h"

@interface QrcodeBoxView ()

@property (readwrite, nonatomic, strong) UILabel * topBorderLbl;      //上边框
@property (readwrite, nonatomic, strong) UILabel * leftBorderLbl;     //左边框
@property (readwrite, nonatomic, strong) UILabel * bottomBorderLbl;   //下边框
@property (readwrite, nonatomic, strong) UILabel * rightBorderLbl;    //右边框

//角落的三角形
@property (readwrite, nonatomic, strong) UILabel * topLeftLbl;      //左上角
@property (readwrite, nonatomic, strong) UILabel * middleTopLeftLbl;

@property (readwrite, nonatomic, strong) UILabel * topRightLbl;     //右上角
@property (readwrite, nonatomic, strong) UILabel * middleTopRightLbl;

@property (readwrite, nonatomic, strong) UILabel * bottomLeftLbl;      //左下角
@property (readwrite, nonatomic, strong) UILabel * middleBottomLeftLbl;

@property (readwrite, nonatomic, strong) UILabel * bottomRightLbl;     //右上角
@property (readwrite, nonatomic, strong) UILabel * middleBottomRightLbl;

@property (readwrite, nonatomic, assign) CGFloat topWidth;      //上标签的 宽度
@property (readwrite, nonatomic, assign) CGFloat topHeight;     //上标签的高度

@property (readwrite, nonatomic, assign) CGFloat borderHeight;     //边框的高度

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation QrcodeBoxView

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
        
        _topWidth = 20;
        _topHeight= 2;
        _borderHeight = 0.4;
        
        UIColor * borderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L7];
        UIColor * boundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_QRCODE_BOUND];
        
        _topBorderLbl = [[UILabel alloc] init];
        _leftBorderLbl = [[UILabel alloc] init];
        _bottomBorderLbl = [[UILabel alloc] init];
        _rightBorderLbl = [[UILabel alloc] init];
        
        _topLeftLbl = [[UILabel alloc] init];
        _middleTopLeftLbl = [[UILabel alloc] init];
        
        _topRightLbl = [[UILabel alloc] init];
        _middleTopRightLbl = [[UILabel alloc] init];
        
        _bottomLeftLbl = [[UILabel alloc] init];
        _middleBottomLeftLbl = [[UILabel alloc] init];
        
        _bottomRightLbl = [[UILabel alloc] init];
        _middleBottomRightLbl = [[UILabel alloc] init];
        
        _topBorderLbl.backgroundColor = borderColor;
        _leftBorderLbl.backgroundColor = borderColor;
        _bottomBorderLbl.backgroundColor = borderColor;
        _rightBorderLbl.backgroundColor = borderColor;
        
        _topLeftLbl.backgroundColor = boundColor;
        _middleTopLeftLbl.backgroundColor = boundColor;
        _topRightLbl.backgroundColor = boundColor;
        _middleTopRightLbl.backgroundColor = boundColor;
        _bottomLeftLbl.backgroundColor = boundColor;
        _middleBottomLeftLbl.backgroundColor = boundColor;
        _bottomRightLbl.backgroundColor = boundColor;
        _middleBottomRightLbl.backgroundColor = boundColor;
        
        [self addSubview:_topBorderLbl];
        [self addSubview:_leftBorderLbl];
        [self addSubview:_bottomBorderLbl];
        [self addSubview:_rightBorderLbl];
        
        [self addSubview:_topLeftLbl];
        [self addSubview:_middleTopLeftLbl];
        
        [self addSubview:_topRightLbl];
        [self addSubview:_middleTopRightLbl];
        
        [self addSubview:_bottomLeftLbl];
        [self addSubview:_middleBottomLeftLbl];
        
        [self addSubview:_bottomRightLbl];
        [self addSubview:_middleBottomRightLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    [_topBorderLbl setFrame:CGRectMake(0, 0, width, _borderHeight)];
    [_leftBorderLbl setFrame:CGRectMake(0, 0, _borderHeight, height)];
    [_bottomBorderLbl setFrame:CGRectMake(0, (height-_borderHeight), width, _borderHeight)];
    [_rightBorderLbl setFrame:CGRectMake((width-_borderHeight), 0, _borderHeight, height)];
    
    [_topLeftLbl setFrame:CGRectMake(0, 0, _topWidth, _topHeight)];
    [_middleTopLeftLbl setFrame:CGRectMake(0, 0, _topHeight, _topWidth)];
    
    [_topRightLbl setFrame:CGRectMake((width - _topWidth), 0, _topWidth, _topHeight)];
    [_middleTopRightLbl setFrame:CGRectMake((width - _topHeight), 0, _topHeight, _topWidth)];
    
    [_bottomLeftLbl setFrame:CGRectMake(0, (height-_topHeight), _topWidth, _topHeight)];
    [_middleBottomLeftLbl setFrame:CGRectMake(0, (height-_topWidth), _topHeight, _topWidth)];
    
    
    [_bottomRightLbl setFrame:CGRectMake((width - _topWidth), (height-_topHeight), _topWidth, _topHeight)];
    [_middleBottomRightLbl setFrame:CGRectMake((width - _topHeight), (height-_topWidth), _topHeight, _topWidth)];
    
    [self updateInfo];
}

- (void) updateInfo {

}


@end
