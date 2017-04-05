//
//  SeperatorView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "SeperatorView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"

@interface SeperatorView ()

@property (readwrite, nonatomic, strong) UIImageView * topLbl;
@property (readwrite, nonatomic, strong) UIImageView * bottomLbl;
@property (readwrite, nonatomic, strong) UIImageView * leftLbl;
@property (readwrite, nonatomic, strong) UIImageView * rightbl;

@property (readwrite, nonatomic, strong) UIImageView * dotLbl;  //虚线

@property (readwrite, nonatomic, assign) CGFloat boundHeighgt;


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL isDotted;

@end


@implementation SeperatorView

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
        
        
        UIColor * boundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
        _boundHeighgt = [FMSize getInstance].defaultBorderWidth;
        
        _topLbl = [[UIImageView alloc] init];
        _bottomLbl = [[UIImageView alloc] init];
        _leftLbl = [[UIImageView alloc] init];
        _rightbl = [[UIImageView alloc] init];
        _dotLbl = [[UIImageView alloc] init];
        
        [_topLbl setHidden:NO];
        [_bottomLbl setHidden:YES];
        [_leftLbl setHidden:YES];
        [_rightbl setHidden:YES];
        [_dotLbl setHidden:YES];
        
        
        [_topLbl setImage:[FMUtils buttonImageFromColor:boundColor width:1 height:1]];
        [_bottomLbl setImage:[FMUtils buttonImageFromColor:boundColor width:1 height:1]];
        [_leftLbl setImage:[FMUtils buttonImageFromColor:boundColor width:1 height:1]];
        [_rightbl setImage:[FMUtils buttonImageFromColor:boundColor width:1 height:1]];
        [_dotLbl setImage:[FMUtils buttonImageFromColor:boundColor width:1 height:1]];
        
        self.clipsToBounds = YES;
        
        [self addSubview:_leftLbl];
        [self addSubview:_rightbl];
        [self addSubview:_bottomLbl];
        [self addSubview:_topLbl];
        [self addSubview:_dotLbl];
        
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat lineSize = _boundHeighgt;
    if(lineSize < 1) {
        lineSize = 1;
    }
    
    [_leftLbl setFrame:CGRectMake(0, 0, lineSize, height)];
    [_rightbl setFrame:CGRectMake(width-lineSize, 0, lineSize, height)];
    [_topLbl setFrame:CGRectMake(0, 0, width, 0.4)];
    [_bottomLbl setFrame:CGRectMake(0, height-lineSize, width, lineSize)];
    [_dotLbl setFrame:CGRectMake(0, 0, width, lineSize)];
    
    if(_isDotted) {
        [_dotLbl setHidden:NO];
        
        [_leftLbl setHidden:YES];
        [_rightbl setHidden:YES];
        [_topLbl setHidden:YES];
        [_bottomLbl setHidden:YES];
        
        UIGraphicsBeginImageContext(_dotLbl.frame.size);
        [_dotLbl.image drawInRect:CGRectMake(0, 0, _dotLbl.frame.size.width, _dotLbl.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        CGFloat lengths[] = {2,2};     //虚线间隔
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] CGColor]);  //间隔颜色
        
        CGContextSetLineDash(line, 0, lengths, 2);
        CGContextMoveToPoint(line, 0.0, height);
        CGContextAddLineToPoint(line, width, height);
        CGContextStrokePath(line);
        _dotLbl.image = UIGraphicsGetImageFromCurrentImageContext();
    } else {
        [_dotLbl setHidden:YES];
        if(_leftLbl.isHidden && _rightbl.isHidden && _topLbl.isHidden && _bottomLbl.isHidden) {
            [_topLbl setHidden:NO];
        }
    }
    
}

- (void) setLineColor:(UIColor *) color {
    self.backgroundColor = color;
    
    [_topLbl setImage:[FMUtils buttonImageFromColor:color width:1 height:1]];
    [_bottomLbl setImage:[FMUtils buttonImageFromColor:color width:1 height:1]];
    [_leftLbl setImage:[FMUtils buttonImageFromColor:color width:1 height:1]];
    [_rightbl setImage:[FMUtils buttonImageFromColor:color width:1 height:1]];
    [_dotLbl setImage:[FMUtils buttonImageFromColor:color width:1 height:1]];
}

- (void) setDotted:(BOOL)isDotted {
    _isDotted = isDotted;
    [self updateViews];
}

//显示上分割线
- (void) setShowTopBound:(BOOL) showTop {
    [_topLbl setHidden:!showTop];
}

//显示下分割线
- (void) setShowBottomBound:(BOOL) showBottom {
    [_bottomLbl setHidden:!showBottom];
}

//显示左分割线
- (void) setShowLeftBound:(BOOL) showLeft {
    [_leftLbl setHidden:!showLeft];
}

//显示右分割线
- (void) setShowRightBound:(BOOL) showRight {
    [_rightbl setHidden:!showRight];
}

@end