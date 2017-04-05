//
//  WorkOrderDetailContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailContentItemView.h"
#import "FMUtils.h"
#import "BaseLabelView.h"
#import "SystemConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMSize.h"
#import "FMFont.h"


@interface WorkOrderDetailContentItemView ()

@property (readwrite, nonatomic, strong) NSString * content;    //工作内容

@property (readwrite, nonatomic, strong) BaseLabelView * contentLbl;
@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, strong) UIFont * font;

@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation WorkOrderDetailContentItemView

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
        
        
        _font = [FMFont fontWithSize:13];
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _contentLbl = [[BaseLabelView alloc] init];
        
        [self addSubview:_contentLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat originY = sepHeight;
    CGFloat itemHeight = 0;
    if(width == 0 || height == 0) {
        return;
    }
    
    itemHeight = [BaseLabelView calculateHeightByInfo:_content font:_font desc:nil labelFont:_font andLabelWidth:0 andWidth:width - _paddingLeft - _paddingRight];
    [_contentLbl setFrame:CGRectMake(_paddingLeft, originY, width - _paddingLeft - _paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}



- (void) setInfoWithContent:(NSString *) content{
    if(![FMUtils isStringEmpty:content]) {
        _content = content;
    } else {
        _content = @"";
    }
    [self updateViews];
}


- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateViews];
}

- (void) updateInfo {
    [_contentLbl setContent:_content];
}

+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    UIFont * font = [FMFont fontWithSize:13];
    if(![FMUtils isStringEmpty:content]) {
        height = [BaseLabelView calculateHeightByInfo:content font:font desc:nil labelFont:font andLabelWidth:0 andWidth:(width - paddingLeft-paddingRight)] + sepHeight * 2;
    }
    return height;
}

@end


