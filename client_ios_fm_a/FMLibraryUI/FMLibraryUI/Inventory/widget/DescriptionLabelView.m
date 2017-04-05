//
//  DescriptionLabelView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 2016/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "DescriptionLabelView.h"
#import "FMUtilsPackages.h"

@interface DescriptionLabelView ()
@property (nonatomic, assign) BOOL isInited;
@end

@implementation DescriptionLabelView

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
        
        _descLbl = [UILabel new];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        _descLbl.numberOfLines = 1;
        
        _contentLbl = [UILabel new];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        [self addSubview:_descLbl];
        [self addSubview:_contentLbl];
    }
}

- (void) updateView {
    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGSize descSize = [FMUtils getLabelSizeBy:_descLbl andContent:_descLbl.text andMaxLabelWidth:width];
    [_descLbl setFrame:CGRectMake(originX, originY, descSize.width, descSize.height)];
    originX += descSize.width;
    
    CGSize contentSize = [FMUtils getLabelSizeBy:_contentLbl andContent:_contentLbl.text andMaxLabelWidth:width-descSize.width];
    [_contentLbl setFrame:CGRectMake(originX, originY, width-descSize.width, contentSize.height)];
}

- (void)setDesc:(NSString *)desc {
    _descLbl.text = @"";
    if (![FMUtils isStringEmpty:desc]) {
        _descLbl.text = desc;
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

@end
