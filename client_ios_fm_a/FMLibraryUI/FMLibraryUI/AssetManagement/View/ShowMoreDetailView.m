//
//  ShowMoreDetailView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ShowMoreDetailView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface ShowMoreDetailView()

@property (readwrite, nonatomic, strong) UILabel * contentLbl;

@property (readwrite, nonatomic, strong) UIImageView * showMoreTagView;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ShowMoreDetailView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.font = [FMFont setFontByPX:42];
        _contentLbl.text = [[BaseBundle getInstance] getStringByKey:@"cell_show_all_detail" inTable:nil];
        _contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _showMoreTagView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        [self addSubview:_contentLbl];
        [self addSubview:_showMoreTagView];
    }
}


- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat originX = padding;
    CGSize contentSize = [FMUtils getLabelSizeBy:_contentLbl andContent:_contentLbl.text andMaxLabelWidth:width];
    CGFloat imageWidth = [FMSize getInstance].imgWidthLevel3;
    
    [_contentLbl setFrame:CGRectMake(originX, 0, contentSize.width, height)];
    
    [_showMoreTagView setFrame:CGRectMake(width-imageWidth-padding, (height - imageWidth)/2, imageWidth, imageWidth)];
}

+ (CGFloat)calculateHeight {
    CGFloat height = [FMSize getSizeByPixel:150];
    return height;
}


@end




