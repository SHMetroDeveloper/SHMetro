//
//  BaseCountView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseCountView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface BaseCountView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * firstCountLbl;
@property (readwrite, nonatomic, strong) UILabel * firstDescLbl;
@property (readwrite, nonatomic, strong) UILabel * secondCountLbl;
@property (readwrite, nonatomic, strong) UILabel * secondDescLbl;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * firstDesc;
@property (readwrite, nonatomic, strong) NSString * secondDesc;

@property (readwrite, nonatomic, assign) NSInteger firstCount;
@property (readwrite, nonatomic, assign) NSInteger secondCount;

@property (readwrite, nonatomic, assign) CGFloat nameHeight;
@property (readwrite, nonatomic, assign) CGFloat countHeight;
@property (readwrite, nonatomic, assign) CGFloat descHeight;
@property (readwrite, nonatomic, assign) CGFloat sepHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation BaseCountView

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
        
        _nameHeight = [FMSize getInstance].chartItemHeaderHeaght;
        _countHeight = [FMSize getInstance].chartItemCountHeaght;
        _descHeight = [FMSize getInstance].chartItemDescHeaght;
        _sepHeight = 0;
        
        _nameLbl = [[UILabel alloc] init];
        _firstCountLbl = [[UILabel alloc] init];
        _firstDescLbl = [[UILabel alloc] init];
        _secondCountLbl = [[UILabel alloc] init];
        _secondDescLbl = [[UILabel alloc] init];
        
        
        [_nameLbl setTextAlignment:NSTextAlignmentCenter];
        [_firstCountLbl setTextAlignment:NSTextAlignmentCenter];
        [_firstDescLbl setTextAlignment:NSTextAlignmentCenter];
        [_secondCountLbl setTextAlignment:NSTextAlignmentCenter];
        [_secondDescLbl setTextAlignment:NSTextAlignmentCenter];
        
        [_nameLbl setFont:[FMFont getInstance].defaultFontLevel2];
        [_firstCountLbl setFont:[FMFont getInstance].chartCountFont];
        [_firstDescLbl setFont:[FMFont getInstance].defaultFontLevel3];
        [_secondCountLbl setFont:[FMFont getInstance].chartCountFont];
        [_secondDescLbl setFont:[FMFont getInstance].defaultFontLevel3];
        
        [_nameLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
        [_nameLbl setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        [_firstCountLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_firstDescLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        [_secondCountLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_secondDescLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_nameLbl];
        [self addSubview:_firstCountLbl];
        [self addSubview:_firstDescLbl];
        [self addSubview:_secondCountLbl];
        [self addSubview:_secondDescLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat originY = 0;
    CGFloat paddingTop = (height - _nameHeight - _countHeight - _descHeight) / 2;
    [_nameLbl setFrame:CGRectMake(0, originY, width, _nameHeight)];
    originY += _nameHeight + paddingTop;
    
    [_firstCountLbl setFrame:CGRectMake(0, originY, width/2, _countHeight)];
    [_secondCountLbl setFrame:CGRectMake(width/2, originY, width/2, _countHeight)];
    originY += _countHeight + _sepHeight;
    
    [_firstDescLbl setFrame:CGRectMake(0, originY, width/2, _descHeight)];
    [_secondDescLbl setFrame:CGRectMake(width/2, originY, width/2, _descHeight)];
    originY += _descHeight + paddingTop;
    
    [self updateInfo];
}

- (void) updateInfo {
    
    if(_name) {
        [_nameLbl setText:_name];
    }
    [_firstCountLbl setText:[[NSString alloc] initWithFormat:@"%ld", _firstCount]];
    [_secondCountLbl setText:[[NSString alloc] initWithFormat:@"%ld", _secondCount]];
    
    if(_firstDesc) {
        [_firstDescLbl setText:_firstDesc];
    }
    if(_secondDesc) {
        [_secondDescLbl setText:_secondDesc];
    }
}

- (void) setInfoWithName:(NSString *)name count1:(NSInteger)count1 count2:(NSInteger)count2 {
    _name = name;
    _firstCount = count1;
    _secondCount = count2;
    
    [self updateInfo];
}

- (void) setDescForCountFirst:(NSString *)fistCountName second:(NSString *)secondCountName {
    _firstDesc = fistCountName;
    _secondDesc = secondCountName;
    [self updateInfo];
}


- (void) showBorder:(BOOL) show {
    if(show) {
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void) setNameColor:(UIColor *) color {
    [_nameLbl setBackgroundColor:color];
}

@end
