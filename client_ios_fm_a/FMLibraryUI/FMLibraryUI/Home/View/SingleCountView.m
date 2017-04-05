//
//  SingleCountView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "SingleCountView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface SingleCountView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * countLbl;

@property (readwrite, nonatomic, strong) NSString * name;

@property (readwrite, nonatomic, assign) NSInteger count;

@property (readwrite, nonatomic, assign) CGFloat nameHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation SingleCountView

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
        
        _nameHeight = [FMSize getInstance].listItemInfoHeight;
        
        _nameLbl = [[UILabel alloc] init];
        _countLbl = [[UILabel alloc] init];
        
        [_countLbl setTextAlignment:NSTextAlignmentCenter];
        
        [_nameLbl setFont:[FMFont getInstance].defaultFontLevel3];
        [_countLbl setFont:[FMFont getInstance].chartCountFont];
        
        [_nameLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
        [_countLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_nameLbl];
        [self addSubview:_countLbl];
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
    CGFloat padding = [FMSize getInstance].defaultPadding;
    [_nameLbl setFrame:CGRectMake(padding, originY, width-padding * 2, _nameHeight)];
    originY += _nameHeight;
    
    [_countLbl setFrame:CGRectMake(0, originY, width, (height-_nameHeight))];
    
    [self updateInfo];
}

- (void) updateInfo {
    
    if(_name) {
        [_nameLbl setText:_name];
    }
    [_countLbl setText:[[NSString alloc] initWithFormat:@"%ld", _count]];
    
}

- (void) setInfoWithName:(NSString *)name count:(NSInteger)count{
    _name = name;
    _count = count;
    
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

@end

