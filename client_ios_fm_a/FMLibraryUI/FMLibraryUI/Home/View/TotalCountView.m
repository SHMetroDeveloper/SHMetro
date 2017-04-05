//
//  TotalCountView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "TotalCountView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface TotalCountView()

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UILabel * finishedLbl;
@property (readwrite, nonatomic, strong) UILabel * allLbl;

@property (readwrite, nonatomic, strong) NSString * finishStr;
@property (readwrite, nonatomic, strong) NSString * allStr;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation TotalCountView

- (instancetype)init{
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
        [self updateViews];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        //表格标题
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.font = [FMFont fontWithSize:15];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_order_total_count" inTable:nil];
        
        //完成数lbl
        _finishedLbl = [[UILabel alloc] init];
        _finishedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _finishedLbl.font = [FMFont setFontByPX:140];
        _finishedLbl.textAlignment = NSTextAlignmentRight;
        
        //总数lbl
        _allLbl = [[UILabel alloc] init];
        _allLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _allLbl.font = [FMFont setFontByPX:100];
        _allLbl.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_titleLbl];
        [self addSubview:_finishedLbl];
        [self addSubview:_allLbl];
    }
}


- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat sepHeight = [FMSize getSizeByPixel:150];
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    CGSize finishSize = [FMUtils getLabelSizeBy:_finishedLbl andContent:_finishStr andMaxLabelWidth:width];
    CGSize allSize = [FMUtils getLabelSizeBy:_allLbl andContent:_allStr andMaxLabelWidth:width];
    
    CGFloat originX = [FMSize getInstance].padding50;
    CGFloat originY = sepHeight;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];

    originX = (width - finishSize.width - allSize.width)/2;
    originY = (height - sepHeight - titleSize.height - finishSize.height)/2 + sepHeight +titleSize.height;
    [_finishedLbl setFrame:CGRectMake(originX, originY, finishSize.width, finishSize.height)];
    
    originX += finishSize.width;
    originY += (finishSize.height - allSize.height) - 4;
    [_allLbl setFrame:CGRectMake(originX, originY, allSize.width, allSize.height)];
    
    [self updateInfo];
}

- (void) updateInfo {
    _finishedLbl.text = _finishStr;
    _allLbl.text = _allStr;
}

- (void) setInfoWithFinished:(NSInteger)finished andAll:(NSInteger)all {
    
    _finishStr = [NSString stringWithFormat:@"%ld/",finished];
    _allStr = [NSString stringWithFormat:@"%ld",all];
    
    [self updateViews];
}

+ (CGFloat)calculateHeightByWidth:(CGFloat)width {
    CGFloat height = 0;
    
    height = 200;
    
    return height;
}

@end




