//
//  PatrolHistoryDetailSpotItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryDetailSpotItemView.h"
#import "ColorLabel.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMUtils.h"

@interface PatrolHistoryDetailSpotItemView ()

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) ColorLabel * ignoreCLbl;
@property (readwrite, nonatomic, strong) ColorLabel * exceptionCLbl;
@property (readwrite, nonatomic, strong) ColorLabel * reportCLbl;
@property (readwrite, nonatomic, strong) UIImageView * expandImgView;

@property (readwrite, nonatomic, strong) NSString * spotName;
@property (readwrite, nonatomic, assign) BOOL showIgnore;
@property (readwrite, nonatomic, assign) BOOL showException;
@property (readwrite, nonatomic, assign) BOOL showReport;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) BOOL isExpand;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation PatrolHistoryDetailSpotItemView

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
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        UIFont * mFont = [FMFont getInstance].font42;
        
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        
        _isExpand = NO; //默认收起
        
        _nameLbl = [[UILabel alloc] init];
        _ignoreCLbl = [[ColorLabel alloc] init];
        _exceptionCLbl = [[ColorLabel alloc] init];
        _reportCLbl = [[ColorLabel alloc] init];
        _expandImgView = [[UIImageView alloc] init];
        
        [_ignoreCLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_exceptionCLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_reportCLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        [_nameLbl setFont:mFont];
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        [_ignoreCLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        [_exceptionCLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        [_reportCLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        
        [self updateExpandState];
        
        [self addSubview:_nameLbl];
        [self addSubview:_ignoreCLbl];
        [self addSubview:_exceptionCLbl];
        [self addSubview:_reportCLbl];
        [self addSubview:_expandImgView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGSize ignoreSize = CGSizeMake(0, 0);
    CGSize exceptionSize = CGSizeMake(0, 0);
    CGSize reportSize = CGSizeMake(0, 0);
    CGFloat sepWidth = 5;
    CGFloat originX = width-_paddingRight-_imgWidth - sepWidth * 2;
    
    if(_showReport) {
        reportSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        originX -= reportSize.width;
        [_reportCLbl setFrame:CGRectMake(originX, (height-reportSize.height)/2, reportSize.width, reportSize.height)];
        originX -= sepWidth;
        [_reportCLbl setHidden:NO];
    } else {
        [_reportCLbl setHidden:YES];
    }
    if(_showException) {
        exceptionSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        originX -= exceptionSize.width;
        [_exceptionCLbl setFrame:CGRectMake(originX, (height-exceptionSize.height)/2, exceptionSize.width, exceptionSize.height)];
        originX -= sepWidth;
        [_exceptionCLbl setHidden:NO];
    } else {
        [_exceptionCLbl setHidden:YES];
    }
    if(_showIgnore) {
        ignoreSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        originX -= ignoreSize.width;
        [_ignoreCLbl setFrame:CGRectMake(originX, (height-ignoreSize.height)/2, ignoreSize.width, ignoreSize.height)];
        originX -= sepWidth;
        [_ignoreCLbl setHidden:NO];
        
    } else {
        [_ignoreCLbl setHidden:YES];
    }
    
    [_expandImgView setFrame:CGRectMake(width-_paddingRight-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    CGFloat nameWidth = width - _paddingLeft - _paddingRight - ignoreSize.width - exceptionSize.width - reportSize.width;
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, nameWidth, height)];
    
    [self updateExpandState];
    
    [self updateInfo];
}

- (void) updateExpandState {
    if(_isExpand) {
        [_expandImgView setImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
    } else {
        [_expandImgView setImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
    }
}

- (void) updateInfo {
    [_nameLbl setText:_spotName];
}

- (void) setInfoWithSpotName:(NSString *) spotName
               andShowIgnore:(BOOL) showIgnore
            andShowException:(BOOL) showException
               andShowReport:(BOOL) showReport {
    _spotName = spotName;
    _showIgnore = showIgnore;
    _showException = showException;
    _showReport = showReport;
    [self updateViews];
}

- (void) setExpandState:(BOOL) isExpand {
    _isExpand = isExpand;
    [self updateExpandState];
}

@end
