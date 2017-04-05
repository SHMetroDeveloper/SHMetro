//
//  DottedBubbleView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/21.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "DottedBubbleView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface DottedBubbleView ()

@property (readwrite, nonatomic, strong) CAShapeLayer * bubbleLayer;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, strong) UIBezierPath * bubblePath;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) CGFloat titleHeight;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation DottedBubbleView

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
        
        _titleHeight = [FMSize getInstance].listItemInfoHeight;
        _paddingTop = 5;
        _paddingBottom = 5;
        _paddingLeft = 20;
        _paddingRight = 5;
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont getInstance].defaultFontLevel2;
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.numberOfLines = 0;
        _contentLbl.font = [FMFont getInstance].defaultFontLevel2;
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [self addSubview:_titleLbl];
        [self addSubview:_contentLbl];
        
        [self initBounds];
        
    }
}

- (void) initBounds {
    
    _bubblePath = [UIBezierPath bezierPath];
    _bubblePath.lineWidth = 1;
    
    _bubbleLayer = [CAShapeLayer layer];
    
    _bubbleLayer.strokeColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND_DOTTED] CGColor];
    
    _bubbleLayer.fillColor = nil;
    
    _bubbleLayer.lineWidth = 0.8f;
    
    _bubbleLayer.lineCap = @"square";
    
    _bubbleLayer.lineDashPattern = @[@2, @2];
    
    
    
    [self.layer addSublayer:_bubbleLayer];
    _bubbleLayer.path = _bubblePath.CGPath;
    
    _bubbleLayer.frame = self.bounds;
    
}

- (void) updatePath {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat triangle = 8;  //三角形边长
    CGFloat originX = triangle * sin(M_PI / 3);
    CGFloat cornerRadius = [FMSize getInstance].defaultBorderRadius;
    
    BOOL showCorner = YES;
    
    [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND_DOTTED] set];
    
    [_bubblePath removeAllPoints];
    
    if(showCorner) {
        [_bubblePath moveToPoint:CGPointMake(originX+cornerRadius, 0)];
        
        [_bubblePath addLineToPoint:CGPointMake(width-cornerRadius, 0)];
        [_bubblePath addQuadCurveToPoint:CGPointMake(width, cornerRadius) controlPoint:CGPointMake(width, 0)]; //右上角
        
        [_bubblePath addLineToPoint:CGPointMake(width, height-cornerRadius)];
        [_bubblePath addQuadCurveToPoint:CGPointMake(width-cornerRadius, height) controlPoint:CGPointMake(width, height)];  //右下角
        
        [_bubblePath addLineToPoint:CGPointMake(originX+cornerRadius, height)];
        [_bubblePath addQuadCurveToPoint:CGPointMake(originX, height-cornerRadius) controlPoint:CGPointMake(originX, height)];  //左下角
        
        //三角形
        [_bubblePath addLineToPoint:CGPointMake(originX, (_paddingTop + (_titleHeight - triangle)/2 + triangle))];
        [_bubblePath addLineToPoint:CGPointMake(0, (_paddingTop + _titleHeight/2 ))];
        [_bubblePath addLineToPoint:CGPointMake(originX, (_paddingTop + (_titleHeight - triangle)/2))];
        
        [_bubblePath addLineToPoint:CGPointMake(originX, cornerRadius)];
        [_bubblePath addQuadCurveToPoint:CGPointMake(originX+cornerRadius, 0) controlPoint:CGPointMake(originX, 0)];  //左上角
    } else {
        [_bubblePath moveToPoint:CGPointMake(originX, 0)];
        [_bubblePath addLineToPoint:CGPointMake(width, 0)];
        [_bubblePath addLineToPoint:CGPointMake(width, height)];
        [_bubblePath addLineToPoint:CGPointMake(originX, height)];
        [_bubblePath addLineToPoint:CGPointMake(originX, (_paddingTop + (_titleHeight - triangle)/2 + triangle))];
        [_bubblePath addLineToPoint:CGPointMake(0, (_paddingTop + _titleHeight/2 ))];
        [_bubblePath addLineToPoint:CGPointMake(originX, (_paddingTop + (_titleHeight - triangle)/2))];
        [_bubblePath addLineToPoint:CGPointMake(originX, 0)];
    }
    
    [_bubblePath closePath];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat originY = _paddingTop;
    CGFloat realWidth = width-_paddingLeft-_paddingRight;
    CGFloat itemHeight = 0;
    
    [self updatePath];
    _bubbleLayer.bounds = CGRectMake(0, 0, width, height);
    _bubbleLayer.frame = CGRectMake(0, 0, width, height);
    _bubbleLayer.path = _bubblePath.CGPath;
    
    itemHeight = _titleHeight;
    [_titleLbl setFrame:CGRectMake(_paddingLeft, originY, realWidth, _titleHeight)];
    originY += itemHeight;
    
    itemHeight = height - _paddingTop - _paddingBottom - _titleHeight;
    [_contentLbl setFrame:CGRectMake(_paddingLeft, originY, realWidth, itemHeight)];
    
    [self updateInfo];
}

- (void) updateInfo {
    [_titleLbl setText:_title];
    
//    [_contentLbl setText:_content];
    if (![FMUtils isStringEmpty:_content]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[_content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                              options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attributedString addAttributes:@{NSFontAttributeName:[FMFont getInstance].defaultFontLevel2} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]} range:NSMakeRange(0, attributedString.length)];
        
        //去尾存真(用while循环去掉尾部的所有换行符)
        while([FMUtils isStingEqualIgnoreCaseString1:[[[NSAttributedString alloc] initWithAttributedString:[attributedString attributedSubstringFromRange:NSMakeRange(attributedString.length - 1, 1)]] string] String2:@"\n"]) {
            [attributedString deleteCharactersInRange:NSMakeRange(attributedString.length - 1, 1)];
        }
        
        //去尾存真
        //        NSString *strToDelete = [[[NSAttributedString alloc] initWithAttributedString:[attributedString attributedSubstringFromRange:NSMakeRange(attributedString.length - 1, 1)]] string];
        //        if ([FMUtils isStingEqualIgnoreCaseString1:strToDelete String2:@"\n"]) {
        //            [attributedString deleteCharactersInRange:NSMakeRange(attributedString.length - 1, 1)];
        //        }
        _contentLbl.attributedText = attributedString;
    }
}

- (void) setInfoWithTitle:(NSString *) title content:(NSString *) content {
    _title = title;
    _content = content;
    [self updateInfo];
}

- (CGFloat) getControlPointHeight {
    CGFloat res = 0;
    res = _titleHeight / 2 + _paddingTop;
    return res;
}

+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width {
    CGFloat height = 0;
    
    CGFloat paddingTop = 5;
    CGFloat paddingBottom = 5;
    CGFloat paddingLeft = 20;
    CGFloat paddingRight = 5;
    
    CGFloat titleHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat contentHeight = 0;
    
    CGFloat contentWidth = width-paddingLeft-paddingRight;
    
    UILabel * contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
    contentLbl.numberOfLines = 0;
    contentLbl.font = [FMFont getInstance].defaultFontLevel2;
    
    contentHeight = [FMUtils heightForStringWith:contentLbl value:content andWidth:contentWidth];
    if(contentHeight < titleHeight) {
        contentHeight = titleHeight;
    }
    height = titleHeight + contentHeight + paddingTop + paddingBottom;
    
    return height;
}
@end
