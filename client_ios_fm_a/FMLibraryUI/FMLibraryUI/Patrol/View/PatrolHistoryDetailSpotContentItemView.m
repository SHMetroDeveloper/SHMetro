//
//  PatrolHistoryDetailSpotContentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryDetailSpotContentItemView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "ColorLabel.h"

@interface PatrolHistoryDetailSpotContentItemView ()

@property (readwrite, nonatomic, strong) UILabel * contentLabel;
@property (readwrite, nonatomic, strong) ColorLabel * reportLabel;
@property (readwrite, nonatomic, strong) ColorLabel * leakLabel;
@property (readwrite, nonatomic, strong) ColorLabel * exceptionLabel;
@property (readwrite, nonatomic, strong) ColorLabel * exceptionStatusLabel; //异常状态，如停机

@property (readwrite, nonatomic, strong) NSString * content;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL showReport;
@property (readwrite, nonatomic, assign) BOOL showLeak;
@property (readwrite, nonatomic, assign) BOOL showException;
@property (readwrite, nonatomic, assign) BOOL showExceptionStatus;//是否显示异常状态

@property (readwrite, nonatomic, assign) PatrolEquipmentExceptionStatus exceptionStatus;
@end

@implementation PatrolHistoryDetailSpotContentItemView

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
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        UIFont * mFont = [FMFont getInstance].font38;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]];
        [_contentLabel setFont:mFont];
        
        _reportLabel = [[ColorLabel alloc] init];
        _leakLabel = [[ColorLabel alloc] init];
        _exceptionLabel = [[ColorLabel alloc] init];
        _exceptionStatusLabel = [[ColorLabel alloc] init];
        
        [_reportLabel setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_leakLabel setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_exceptionLabel setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        [_exceptionStatusLabel setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        
        
        [_reportLabel setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        [_leakLabel setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        [_exceptionLabel setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        
        [self addSubview:_contentLabel];
        [self addSubview:_reportLabel];
        [self addSubview:_leakLabel];
        [self addSubview:_exceptionLabel];
        [self addSubview:_exceptionStatusLabel];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    if(width == 0 || height == 0) {
        return;
    }
    CGSize reportSize = CGSizeMake(0, 0);
    CGSize leakSize = CGSizeMake(0, 0);
    CGSize exceptionSize = CGSizeMake(0, 0);
    CGFloat sepWidth = 5;
//    CGFloat originX = width - _paddingRight;
    CGFloat originX = width - _paddingRight - [FMSize getInstance].imgWidthLevel2 - sepWidth * 2;
    
    if(_showExceptionStatus) {
        CGSize statusSize = [ColorLabel calculateSizeByInfo:[PatrolServerConfig getEquipmentStatusDescription:_exceptionStatus]];
        [_exceptionStatusLabel setFrame:CGRectMake(originX-statusSize.width, (height-statusSize.height)/2, statusSize.width, statusSize.height)];
    }
    
    if(_showReport) {
        [_reportLabel setHidden:NO];
        reportSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        [_reportLabel setFrame:CGRectMake(originX-reportSize.width, (height-reportSize.height)/2, reportSize.width, reportSize.height)];
        originX -= reportSize.width + sepWidth;
    } else {
        [_reportLabel setHidden:YES];
    }
    
    if(_showException) {
        [_exceptionLabel setHidden:NO];
        exceptionSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        [_exceptionLabel setFrame:CGRectMake(originX-exceptionSize.width, (height-exceptionSize.height)/2, exceptionSize.width, exceptionSize.height)];
        originX -= exceptionSize.width + sepWidth;
    } else {
        [_exceptionLabel setHidden:YES];
    }
    
    if(_showLeak) {
        [_leakLabel setHidden:NO];
        leakSize = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        [_leakLabel setFrame:CGRectMake(originX-leakSize.width, (height-leakSize.height)/2, leakSize.width, leakSize.height)];
        originX -= leakSize.width + sepWidth;
    } else {
        [_leakLabel setHidden:YES];
    }
    
    [_contentLabel setFrame:CGRectMake(_paddingLeft, 0, originX-_paddingLeft, height)];
    
    [self updateInfo];
    
}

- (void) updateInfo {
    [_contentLabel setText:_content];
    if(_showExceptionStatus) {
        [_exceptionStatusLabel setHidden:NO];
        [_exceptionStatusLabel setContent:[PatrolServerConfig getEquipmentStatusDescription:_exceptionStatus]];
    } else {
        [_exceptionStatusLabel setHidden:YES];
    }
}

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    [self updateViews];
}

- (void) setInfoWith:(NSString *) content
           hasReport:(BOOL) hasReport
             hasLeak:(BOOL) hasLeak
        hasException:(BOOL) hasException {
    _content = content;
    _showReport = hasReport;
    _showLeak = hasLeak;
    _showException = hasException;
    _showExceptionStatus = NO;
    [self updateViews];
}

- (void) setInfoWith:(NSString *) content
           exceptionStatus:(PatrolEquipmentExceptionStatus) exceptionStatus {
    _showExceptionStatus = YES;
    _content = content;
    _exceptionStatus = exceptionStatus;
    _showReport = NO;
    _showLeak = NO;
    _showException = NO;
    [self updateViews];
}

@end
