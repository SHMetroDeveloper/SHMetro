//
//  ContractStatusBarChartView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/11/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractStatusBarChartView.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import <Charts/Charts.h>

@interface ContractStatusBarChartView () <ChartViewDelegate>

@property (readwrite, nonatomic, strong) BarChartView * chartView;

@property (readwrite, nonatomic, strong) NSMutableArray * yValueArrays;
@property (readwrite, nonatomic, strong) NSArray * statusArray;

@property (nonatomic, strong) ChartXAxis *xAxis;
@property (nonatomic, strong) ChartYAxis *leftAxis;


@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation ContractStatusBarChartView

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
        
        [self initChartView];
        
        _yValueArrays = [NSMutableArray new];
        _statusArray = @[[[BaseBundle getInstance] getStringByKey:@"contract_status_undo" inTable:nil],
                         [[BaseBundle getInstance] getStringByKey:@"contract_status_executing" inTable:nil],
                         [[BaseBundle getInstance] getStringByKey:@"contract_status_verfied" inTable:nil],
                         [[BaseBundle getInstance] getStringByKey:@"contract_status_terminated" inTable:nil],
                         [[BaseBundle getInstance] getStringByKey:@"contract_status_closed" inTable:nil],
                         ];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_chartView];
    }
}



- (void) initChartView {
    _chartView = [[BarChartView alloc] init];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
    _chartView.noDataText = @"";
    _chartView.drawBarShadowEnabled = NO;
    [_chartView setScaleEnabled:NO];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.dragEnabled = YES;
    _chartView.highlightPerTapEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    _chartView.highlightPerDragEnabled = NO;
    //    _chartView.backgroundColor = [UIColor whiteColor];
    
    ChartLegend *l = _chartView.legend;   //图表说明
    [l setEnabled:NO];
    
    _xAxis = _chartView.xAxis;     //X轴数据显示设置
    _xAxis.labelPosition = XAxisLabelPositionBottom;
    _xAxis.labelFont = [FMFont setFontByPX:30];
    _xAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _xAxis.drawGridLinesEnabled = NO;
    _xAxis.drawAxisLineEnabled = YES;
    _xAxis.drawLimitLinesBehindDataEnabled = YES;
    _xAxis.spaceBetweenLabels = 5.0f;
    _xAxis.axisLineColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    
    _leftAxis = _chartView.leftAxis;     //左边Y轴数据显示设置
    _leftAxis.labelFont = [FMFont setFontByPX:30];
    //    _leftAxis.labelCount = 5;
    //    _leftAxis.spaceTop = [_leftAxis getRequiredHeightSpace];
    _leftAxis.drawAxisLineEnabled = YES;
    _leftAxis.drawGridLinesEnabled = NO;
    _leftAxis.zeroLineColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    _leftAxis.axisLineColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    _leftAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
    _leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    _leftAxis.valueFormatter.maximumFractionDigits = 0;//小数点位数
    _leftAxis.valueFormatter.negativeSuffix = @"";
    _leftAxis.valueFormatter.positiveSuffix = @"";
    _leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    _leftAxis.axisMinValue = 0;
    
    
    ChartYAxis * rightAxis = _chartView.rightAxis;    //右边Y轴隐藏
    [rightAxis setEnabled:NO];
    
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat padding = [FMSize getInstance].padding50;
    
    [_chartView setFrame:CGRectMake(padding, 0, width-padding*2, height-padding)];
}


- (void) updateBarChartByInfo:(NSMutableArray *) array {
    NSArray *sortedArray = [array sortedArrayUsingComparator:^(NSNumber *number1,NSNumber *number2) {
        NSInteger val1 = [number1 intValue];
        NSInteger val2 = [number2 intValue];
        if (val1 > val2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    //    NSMutableArray *res = [[NSMutableArray alloc] init];
    //    for (NSNumber *val in array) {
    //        BOOL exist = NO;
    //        for(NSNumber *tmp in res) {
    //            if([tmp isEqualToNumber:val]) {
    //                exist = YES;
    //                break;
    //            }
    //        }
    //        if(!exist) {
    //            [res addObject:val];
    //        }
    //    }
    
    NSNumber *resNumber = [sortedArray firstObject];
    if (resNumber.integerValue == 1) {
        _leftAxis.axisMaxValue = 5;
    }
    if (resNumber.integerValue > 1 && resNumber.integerValue < 6) {
        _leftAxis.labelCount = resNumber.integerValue;
    }
    if (resNumber.integerValue > 5 && resNumber.integerValue < 10) {
        _leftAxis.labelCount = 5;
    }
}



- (void)updateInfo {
    //更新Y轴上的count参数
    [self updateBarChartByInfo:_yValueArrays];
    if (!_statusArray || !_yValueArrays) {
        return;
    }
    
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _statusArray.count; i++) {
        [xVals addObject:_statusArray[i]];
    }
    
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _yValueArrays.count; i ++) {
        NSNumber * tmpNumber = _yValueArrays[i];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:tmpNumber.integerValue xIndex:i]];
    }
    
    BarChartDataSet * set1 = [[BarChartDataSet alloc] initWithYVals:yVals];
    set1.barSpace = 0.55f;
    set1.colors = @[[UIColor colorWithRed:205/255.0 green:193/255.0 blue:233/255.0 alpha:255/255.0],
                    [UIColor colorWithRed:205/255.0 green:193/255.0 blue:233/255.0 alpha:255/255.0],
                    [UIColor colorWithRed:205/255.0 green:193/255.0 blue:233/255.0 alpha:255/255.0],
                    [UIColor colorWithRed:205/255.0 green:193/255.0 blue:233/255.0 alpha:255/255.0],
                    [UIColor colorWithRed:205/255.0 green:193/255.0 blue:233/255.0 alpha:255/255.0],
                    ];
    set1.drawValuesEnabled = YES;
    set1.valueFormatter = [[NSNumberFormatter alloc] init];
    set1.valueTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    set1.valueFont = [FMFont setFontByPX:32];
    
    
    NSMutableArray * dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData * data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    _chartView.data = data;
    
    [_chartView setVisibleXRangeWithMinXRange:1 maxXRange:5];
    
    [_chartView animateWithYAxisDuration:1.5f easingOption:ChartEasingOptionEaseInQuart];
    
    [self updateViews];
}

- (void) setContracts:(NSMutableArray <ContractTypeAmount *> *) array {
    if (!_yValueArrays) {
        _yValueArrays = [[NSMutableArray alloc] init];
    } else {
        [_yValueArrays removeAllObjects];
    }
    
    NSInteger undo = 0;
    NSInteger expired = 0;
    NSInteger process = 0;
    NSInteger terminated = 0;
    NSInteger unPassed = 0;
    NSInteger passed = 0;
    NSInteger closed = 0;
    
    for (ContractTypeAmount *typeAmount in array) {
        undo += typeAmount.undo;
        expired = typeAmount.expired;
        process = typeAmount.process;
        terminated = typeAmount.terminated;
        unPassed = typeAmount.unPassed;
        passed = typeAmount.passed;
        closed = typeAmount.closed;
    }
    [_yValueArrays addObject:[NSNumber numberWithInteger:undo]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:expired]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:process]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:terminated]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:unPassed]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:passed]];
    [_yValueArrays addObject:[NSNumber numberWithInteger:closed]];
    
    [self updateInfo];
}

@end
