//
//  SingleBarChartView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "SingleBarChartView.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMColor.h"

@interface SingleBarChartView ()
//<ChartViewDelegate>

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
//@property (readwrite, nonatomic, strong) BarChartView * chartView;

@property (readwrite, nonatomic, strong) NSMutableArray * yValueArrays;
@property (readwrite, nonatomic, strong) NSArray * months;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation SingleBarChartView

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
        
        if (!_yValueArrays) {
            _yValueArrays = [[NSMutableArray alloc] init];
        }
        
        _months = @[@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月"];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [FMFont fontWithSize:15];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_order_monthly" inTable:nil];
        [self initChartView];
        
        [self addSubview:_titleLbl];
//        [self addSubview:_chartView];
    }
}

- (void) initChartView {
//    _chartView = [[BarChartView alloc] init];
//    _chartView.delegate = self;
//    _chartView.descriptionText = @"";
//    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
//    _chartView.noDataText = @"";
//    _chartView.drawBarShadowEnabled = NO;
//    [_chartView setScaleEnabled:NO];
//    _chartView.drawGridBackgroundEnabled = NO;
//    _chartView.pinchZoomEnabled = NO;
//    _chartView.doubleTapToZoomEnabled = NO;
//    _chartView.dragEnabled = YES;
//    _chartView.highlightPerTapEnabled = NO;
//    _chartView.drawValueAboveBarEnabled = YES;
//    
//    
//    ChartLegend *l = _chartView.legend;   //图表说明
//    [l setEnabled:NO];
//    
//    
//    ChartXAxis * xAxis = _chartView.xAxis;     //X轴数据显示设置
//    xAxis.labelPosition = XAxisLabelPositionBottom;
//    xAxis.labelFont = [FMFont setFontByPX:30];
//    xAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.drawAxisLineEnabled = NO;
//    xAxis.spaceBetweenLabels = 2.0f;
//    
//    
//    
//    ChartYAxis * leftAxis = _chartView.leftAxis;     //左边Y轴数据显示设置
//    leftAxis.labelFont = [FMFont setFontByPX:30];
//    leftAxis.labelCount = 5;
//    leftAxis.drawAxisLineEnabled = NO;
//    leftAxis.zeroLineColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:238/255.0];
//    leftAxis.gridColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:238/255.0];
//    leftAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
//    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
//    leftAxis.valueFormatter.maximumFractionDigits = 0;//小数点位数
//    leftAxis.valueFormatter.negativeSuffix = @"";
//    leftAxis.valueFormatter.positiveSuffix = @"";
//    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//    leftAxis.spaceTop = 0.15f;
////    leftAxis.customAxisMin = 0;
//    leftAxis.axisMinValue = 0;
//    
//    
//    ChartYAxis * rightAxis = _chartView.rightAxis;    //右边Y轴隐藏
//    [rightAxis setEnabled:NO];
    
}

- (void) updateViews {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat sepHeight = [FMSize getSizeByPixel:20];
    CGFloat padding = [FMSize getInstance].padding50;
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    CGFloat chartHeight = height - sepHeight - titleSize.height - [FMSize getSizeByPixel:120] - [FMSize getSizeByPixel:60];
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
    originY += titleSize.height + [FMSize getSizeByPixel:60];
    
//    [_chartView setFrame:CGRectMake(originX, originY, width - padding*2, chartHeight)];
    originY += chartHeight + [FMSize getSizeByPixel:120];
    
    [self updateInfo];
}


- (void) updateInfo {
    [self updateChartData];
}


//设置数据
- (void) updateChartData {
    if (!_months || !_yValueArrays) {
        return;
    }
    
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _yValueArrays.count; i++) {
        [xVals addObject:_months[i]];
    }
    
//    NSMutableArray * yVals = [[NSMutableArray alloc] init];
//    for (int i = 0; i < _yValueArrays.count; i ++) {
//        NSNumber * tmpNumber = _yValueArrays[i];
//        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:tmpNumber.integerValue xIndex:i]];
//    }
//    
//    BarChartDataSet * set1 = [[BarChartDataSet alloc] initWithYVals:yVals];
//    set1.barSpace = 0.45;
//    set1.colors = [FMColor getChartColorsByCount:[_yValueArrays count]];;
//    set1.drawValuesEnabled = YES;
//    set1.valueFormatter = [[NSNumberFormatter alloc] init];
//    set1.valueTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
//    set1.valueFont = [FMFont setFontByPX:32];
//    
//    
//    NSMutableArray * dataSets = [[NSMutableArray alloc] init];
//    [dataSets addObject:set1];
//    
//    BarChartData * data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
//    _chartView.data = data;
//    
//    [_chartView setVisibleXRangeWithMinXRange:1 maxXRange:5];
//    
//    [_chartView animateWithYAxisDuration:1.5f easingOption:ChartEasingOptionEaseInQuart];
}


- (void) setMonthlyWorkOrderCountInfoWith:(NSMutableArray *) array {
    if (!_yValueArrays) {
        _yValueArrays = [[NSMutableArray alloc] init];
    }
    _yValueArrays = array;
    
    [self updateInfo];
}

+ (CGFloat)calculateHeightByWidth:(CGFloat)width {
    CGFloat height = 0;
    height = 240;
    
    return height;
}

@end

