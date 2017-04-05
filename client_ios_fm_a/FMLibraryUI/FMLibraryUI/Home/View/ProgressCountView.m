//
//  ProgressCountView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ProgressCountView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"

@interface ProgressCountView ()

@property (readwrite, nonatomic, strong) UILabel * finishedLbl;
@property (readwrite, nonatomic, strong) UILabel * allLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;

@property (readwrite, nonatomic, assign) NSInteger allCount;        //总数
@property (readwrite, nonatomic, assign) NSInteger finishedCount;   //完成数
@property (readwrite, nonatomic, strong) NSString * desc;           //标题

@property (readwrite, nonatomic, assign) CGFloat progressWidth;     //进度条宽度
@property (readwrite, nonatomic, strong) UIColor* progressNormalColor;     //颜色
@property (readwrite, nonatomic, strong) UIColor* progressHighlightColor;  //颜色

//@property (readwrite, nonatomic, assign) CGFloat progress;  //进度

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat finishedHeight;
@property (readwrite, nonatomic, assign) CGFloat allHeight;
@property (readwrite, nonatomic, assign) CGFloat descHeight;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ProgressCountView

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
        [self setNeedsLayout];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _titleHeight = 14;
        _finishedHeight = 18;
        _allHeight = 14;
        _descHeight = 30;
        _progressWidth = 5;
        _progressNormalColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8];
        _progressHighlightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        _padding = 10;
        
        
        //完成的数字
        _finishedLbl = [[UILabel alloc] init];
        [_finishedLbl setFont:[UIFont fontWithName:@"Helvetica" size:22]];
        _finishedLbl.textAlignment = NSTextAlignmentRight;
        _finishedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];  //默认颜色
        
        //总数
        _allLbl = [[UILabel alloc] init];
        [_allLbl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        _allLbl.textAlignment = NSTextAlignmentLeft;
        _allLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];   //默认颜色
        
        //圆中描述信息
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont setFontByPX:28];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];   //设置默认颜色
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_menu_finish" inTable:nil];
        
        //底部描述信息
        _descLbl = [[UILabel alloc] init];
        [_descLbl setFont:[FMFont fontWithSize:15]];
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        [self addSubview:_finishedLbl];
        [self addSubview:_allLbl];
        [self addSubview:_titleLbl];
        [self addSubview:_descLbl];
    }
}

- (void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat circleWidth = width < height-_descHeight ? (width-_padding * 2) : (height-_descHeight - _padding * 2);
    CGFloat radius = circleWidth / 2;
    
    CGFloat xCenter = width / 2;
    CGFloat yCenter = (height - _descHeight) / 2;
    CGFloat progress = 0;
    if(_allCount > 0) {
        progress = _finishedCount * 1.0 / _allCount;
    }
    
    
    UIGraphicsPushContext(context);
    
    // 进度环边框
    [_progressNormalColor set];
    CGFloat w = radius * 2;
    CGFloat h = w;
    CGFloat x = xCenter-radius;
    CGFloat y = yCenter-radius;
    CGContextAddEllipseInRect(context, CGRectMake(x, y, w, h));
    CGContextFillPath(context); //填充
//    CGContextStrokePath(ctx); //划线，不填充
    
    // 进度环
    [_progressHighlightColor set];
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xCenter, 0);
    CGFloat start = - M_PI * 0.5;
    CGFloat to =  start + M_PI * 2 * progress; // 初始值
    CGContextAddArc(context, xCenter, yCenter, radius, start, to, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // 遮罩
    [[UIColor whiteColor] set];
    CGFloat maskW = (radius - _progressWidth) * 2;
    CGFloat maskH = maskW;
    CGFloat maskX = xCenter - maskW/2;
    CGFloat maskY = yCenter - maskH/2;
    CGContextAddEllipseInRect(context, CGRectMake(maskX, maskY, maskW, maskH));
    CGContextFillPath(context);
    
    UIGraphicsPopContext();
    
}

- (void) layoutSubviews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = 5;
    
    CGFloat circleWidth = width < height-_descHeight ? (width-_padding * 2) : (height-_descHeight - _padding * 2);
    [_descLbl setFrame:CGRectMake(0, height-_descHeight, width, _descHeight)];
    
    CGFloat originY = (height-_finishedHeight - _titleHeight-_descHeight-sepHeight)/2;
    [_finishedLbl setFrame:CGRectMake((width-circleWidth)/2, originY, circleWidth/2, _finishedHeight)];
    
    [_allLbl setFrame:CGRectMake(width/2, originY, circleWidth/2, _allHeight)];
    originY += _finishedHeight + sepHeight;
    
    [_titleLbl setFrame:CGRectMake((width - circleWidth*2/3)/2, originY, circleWidth*2/3, _titleHeight)];
    

    
    
    [self updateInfo];
}

- (void) updateInfo {
    
    if(_finishedCount > 0 || _allCount > 0) {
        [_finishedLbl setTextColor:_progressHighlightColor];
        [_allLbl setTextColor:_progressHighlightColor];
    }
    NSString * strFinished = [[NSString alloc] initWithFormat:@"%ld", _finishedCount];
    [_finishedLbl setText:strFinished];
    
    NSString * strAll = [[NSString alloc] initWithFormat:@"/%ld", _allCount];
    [_allLbl setText:strAll];
    
    [_descLbl setText:_desc];
}

//设置完成数和总数
- (void) setInfoWithCountFinished:(NSInteger) finishedCount all:(NSInteger) allCount {
    _finishedCount = finishedCount;
    _allCount = allCount;
    [self updateInfo];
    [self setNeedsDisplay];
}
//设置标题
- (void) setDesc:(NSString *)desc andDescColor:(UIColor *)descColor {
    _desc = desc;
    _descLbl.textColor = descColor;
    [self setNeedsLayout];
    [self updateInfo];
}
//设置进度条颜色
- (void) setProgressColor:(UIColor *) progressColor {
    _progressHighlightColor = progressColor;
    
    [self setNeedsDisplay];
}

@end
