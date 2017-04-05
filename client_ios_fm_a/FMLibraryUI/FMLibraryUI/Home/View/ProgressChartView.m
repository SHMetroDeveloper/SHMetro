//
//  ProgressChartView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/15.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ProgressChartView.h"
#import "ProgressCountView.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"

@interface ProgressChartView()

@property (readwrite, nonatomic, strong) ProgressCountView * processCountView;     //处理的工单
@property (readwrite, nonatomic, strong) ProgressCountView * dispatchCountView;    //派工的工单
@property (readwrite, nonatomic, strong) ProgressCountView * validateCountView;    //待审核的工单

@property (readwrite, nonatomic, strong) UILabel * titleLbl;    //今日工单概况

@property (readwrite, nonatomic, strong) NSMutableArray * finishedArray;
@property (readwrite, nonatomic, strong) NSMutableArray * allArray;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ProgressChartView

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
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        //今日工单概况
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_order_today" inTable:nil];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.font = [FMFont fontWithSize:15];
        
        
        //处理和未处理的工单量
        _processCountView = [[ProgressCountView alloc] init];
        [_processCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_process" inTable:nil] andDescColor:[UIColor colorWithRed:0x8e/255.0 green:0xca/255.0 blue:0x00/255.0 alpha:1]];
        [_processCountView setProgressColor:[UIColor colorWithRed:0x8e/255.0 green:0xca/255.0 blue:0x00/255.0 alpha:1]];
//        _processCountView.layer.borderWidth = 0.0f;
//        _processCountView.layer.borderColor = [UIColor clearColor].CGColor;
        
        //派工和未派工的工单量
        _dispatchCountView = [[ProgressCountView alloc] init];
        [_dispatchCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_dispatch" inTable:nil] andDescColor:[UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1]];
        [_dispatchCountView setProgressColor:[UIColor colorWithRed:0x10/255.0 green:0xae/255.0 blue:0xff/255.0 alpha:1]];
//        _dispatchCountView.layer.borderWidth = 0.0f;
//        _dispatchCountView.layer.borderColor = [UIColor clearColor].CGColor;
        
        //审核和未审核的工单量
        _validateCountView = [[ProgressCountView alloc] init];
        [_validateCountView setDesc:[[BaseBundle getInstance] getStringByKey:@"chart_type_validate" inTable:nil] andDescColor:[UIColor colorWithRed:0xff/255.0 green:0x9d/255.0 blue:0x00/255.0 alpha:1]];
        [_validateCountView setProgressColor:[UIColor colorWithRed:0xff/255.0 green:0x9d/255.0 blue:0x00/255.0 alpha:1]];
//        _validateCountView.layer.borderWidth = 0.0f;
//        _validateCountView.layer.borderColor = [UIColor clearColor].CGColor;
        
//        _processCountView.backgroundColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//        _dispatchCountView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
//        _validateCountView.backgroundColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        
        
        [self addSubview:_titleLbl];
        [self addSubview:_processCountView];
        [self addSubview:_dispatchCountView];
        [self addSubview:_validateCountView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if (width == 0 || height == 0) {
        return;
    }
    
    CGFloat padding = [FMSize getInstance].padding20;
    CGFloat sepHeight = [FMSize getSizeByPixel:68];
    CGFloat labelHeight = 30;
    CGFloat countViewWidth = (width - [FMSize getInstance].padding20*2)/3;
    countViewWidth = (NSInteger) countViewWidth;
    CGFloat countViewHeight = height - labelHeight - sepHeight - [FMSize getSizeByPixel:100];
    
    CGFloat originX = [FMSize getSizeByPixel:50];
    CGFloat originY = 15;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, width-padding, labelHeight)];
    originY += labelHeight + [FMSize getSizeByPixel:100];
    originX = padding;
    
    [_processCountView setFrame:CGRectMake(originX, originY, countViewWidth, countViewHeight)];
    originX += countViewWidth;
    
    [_dispatchCountView setFrame:CGRectMake(originX, originY, countViewWidth, countViewHeight)];
    originX += countViewWidth;
    
    [_validateCountView setFrame:CGRectMake(originX, originY, countViewWidth, countViewHeight)];
    originX += countViewWidth;
    
    [self updateInfo];
}

- (void) updateInfo {
    NSNumber * tmpNumber;
    NSNumber * tmpNumber2;
    if (_finishedArray.count > 0 && _allArray.count > 0) {
        
        tmpNumber = _finishedArray[0];
        tmpNumber2 = _allArray[0];
        [_processCountView setInfoWithCountFinished:tmpNumber.integerValue all:tmpNumber2.integerValue];
        
        tmpNumber = _finishedArray[1];
        tmpNumber2 = _allArray[1];
        [_dispatchCountView setInfoWithCountFinished:tmpNumber.integerValue all:tmpNumber2.integerValue];
        
        tmpNumber = _finishedArray[2];
        tmpNumber2 = _allArray[2];
        [_validateCountView setInfoWithCountFinished:tmpNumber.integerValue all:tmpNumber2.integerValue];
        
    } else {
        [_processCountView setInfoWithCountFinished:0 all:0];
        [_dispatchCountView setInfoWithCountFinished:0 all:0];
        [_validateCountView setInfoWithCountFinished:0 all:0];
    }
}

- (void) setInfoWidthFinishenArray:(NSMutableArray *)finish andAllArray:(NSMutableArray *)all {
    if (!_finishedArray) {
        _finishedArray = [[NSMutableArray alloc] init];
    }
    if (!_allArray) {
        _allArray = [[NSMutableArray alloc] init];
    }
    _finishedArray = finish;
    _allArray = all;
    
    [self updateInfo];
}

+ (CGFloat)calculateHeightByWidht:(CGFloat)width {
    CGFloat height = 0;
    CGFloat sepHeight = [FMSize getSizeByPixel:68];
    height = sepHeight + 160 + [FMSize getSizeByPixel:100];
    
    return height;
}



@end





