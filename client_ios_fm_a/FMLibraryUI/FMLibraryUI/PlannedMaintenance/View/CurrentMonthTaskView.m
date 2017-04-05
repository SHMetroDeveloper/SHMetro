//
//  CurrentMonthTaskView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/23.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "CurrentMonthTaskView.h"

#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface CurrentMonthTaskView()

@property (readwrite, nonatomic, strong) UILabel * finishedLbl;
@property (readwrite, nonatomic, strong) UILabel * missedLbl;
@property (readwrite, nonatomic, strong) UILabel * undoLbl;
@property (readwrite, nonatomic, strong) UILabel * processingLbl;

@property (readwrite, nonatomic, assign) NSInteger finishCount;
@property (readwrite, nonatomic, assign) NSInteger missedCount;
@property (readwrite, nonatomic, assign) NSInteger undoCount;
@property (readwrite, nonatomic, assign) NSInteger processingCount;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end


@implementation CurrentMonthTaskView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont * mfont = [FMFont fontWithSize:12];
        CGFloat radius = [FMSize getInstance].defaultBorderRadius;
        
        //已完成lbl
        _finishedLbl = [[UILabel alloc] init];
        _finishedLbl.numberOfLines = 1;
        _finishedLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        _finishedLbl.layer.cornerRadius = radius;
        _finishedLbl.layer.masksToBounds = YES;
        _finishedLbl.textAlignment = NSTextAlignmentCenter;
        _finishedLbl.font = mfont;
        _finishedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        //漏检lbl
        _missedLbl = [[UILabel alloc] init];
        _missedLbl.numberOfLines = 1;
        _missedLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
        _missedLbl.layer.cornerRadius = radius;
        _missedLbl.layer.masksToBounds = YES;
        _missedLbl.textAlignment = NSTextAlignmentCenter;
        _missedLbl.font = mfont;
        _missedLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        //未开始lbl
        _undoLbl = [[UILabel alloc] init];
        _undoLbl.numberOfLines = 1;
        _undoLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _undoLbl.layer.cornerRadius = radius;
        _undoLbl.layer.masksToBounds = YES;
        _undoLbl.textAlignment = NSTextAlignmentCenter;
        _undoLbl.font = mfont;
        _undoLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        //处理中lbl
        _processingLbl = [[UILabel alloc] init];
        _processingLbl.numberOfLines = 1;
        _processingLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        _processingLbl.layer.cornerRadius = radius;
        _processingLbl.layer.masksToBounds = YES;
        _processingLbl.textAlignment = NSTextAlignmentCenter;
        _processingLbl.font = mfont;
        _processingLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        [self addSubview:_finishedLbl];
        [self addSubview:_missedLbl];
        [self addSubview:_undoLbl];
        [self addSubview:_processingLbl];
    }
}

- (void) updateViews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat sepWidth = 8;
    
    CGFloat originX = padding;
    CGFloat originY = padding;
    
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat labelWidth = (width - sepWidth*3 - padding*2)/4;
    CGFloat labelHeight = 30;
    CGFloat sepHeight = (height - labelHeight)/2;
    originY = sepHeight;
    
    [_finishedLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += sepWidth + labelWidth;
    
    [_missedLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += sepWidth + labelWidth;
    
    [_undoLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originX += sepWidth + labelWidth;
    
    [_processingLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    
    [self updateInfo];
}

- (void)updateInfo {
    [_finishedLbl setText:[NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"ppm_status_finished" inTable:nil],_finishCount]];
    [_missedLbl setText:[NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"ppm_status_missed" inTable:nil],_missedCount]];
    [_undoLbl setText:[NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"ppm_status_undo" inTable:nil],_undoCount]];
    [_processingLbl setText:[NSString stringWithFormat:@"%@(%ld)",[[BaseBundle getInstance] getStringByKey:@"ppm_status_process" inTable:nil],_processingCount]];
}

- (void)setNumberOfTaskFinished:(NSInteger)finished
                         missed:(NSInteger)missed
                           undo:(NSInteger)undo
                     processing:(NSInteger)processing {
    if (finished) {
        _finishCount = finished;
    } else {
        _finishCount = 0;
    }
    
    if (missed) {
        _missedCount = missed;
    } else {
        _missedCount = 0;
    }
    
    if (undo) {
        _undoCount = undo;
    } else {
        _undoCount = 0;
    }
    
    if (processing) {
        _processingCount = processing;
    } else {
        _processingCount = 0;
    }
    
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getSizeByPixel:50];
    CGFloat labelHeight = [FMSize getSizeByPixel:90];
    
    height = sepHeight*2 + labelHeight;
    
    return height;
}

@end






