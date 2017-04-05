//
//  LineChartView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "SingleLineChartView.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMColor.h"
#import "FMTheme.h"

@interface SingleLineChartView() <ChartViewDelegate>

@property (readwrite, nonatomic, strong) UILabel * titleLbl;

@property (readwrite, nonatomic, strong) UILabel * allLbl;
@property (readwrite, nonatomic, strong) UILabel * finishLbl;

@property (readwrite, nonatomic, strong) UIImageView * allTagImg;
@property (readwrite, nonatomic, strong) UIImageView * finishTagImg;

@property (readwrite, nonatomic, strong) LineChartView * chartView;


@property (readwrite, nonatomic, strong) NSMutableArray * allArray;
@property (readwrite, nonatomic, strong) NSMutableArray * finishArray;

@property (readwrite, nonatomic, strong) NSMutableArray * month;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end

@implementation SingleLineChartView

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
        
        _allArray = [[NSMutableArray alloc] init];
        _finishArray = [[NSMutableArray alloc] init];
        _month = [[NSMutableArray alloc] init];
        NSDate * nowDate = [NSDate date];
        NSDate * theDate;
        NSTimeInterval oneDay = 24*60*60*1;
        for (int i = 6; i >= 0; i--) {
            theDate = [nowDate initWithTimeIntervalSinceNow:-oneDay*i];
            [_month addObject:[FMUtils getDateStrMMDD:theDate]];
        }
        
        //表格标题
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.font = [FMFont fontWithSize:15];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_order_currently_title" inTable:nil];
        
        _allLbl = [[UILabel alloc] init];
        _allLbl.text = @"工单量";
        _allLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _allLbl.font = [FMFont setFontByPX:28];
        
        _finishLbl = [[UILabel alloc] init];
        _finishLbl.text = @"完成量";
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _finishLbl.font = [FMFont setFontByPX:28];
        
        _allTagImg = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"all_order_tag"]];     //此处需要一张标签图片
        _allTagImg.backgroundColor = [UIColor clearColor];
        
        _finishTagImg = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"finish_order_tag"]];  //此处需要一张标签图片
        _finishTagImg.backgroundColor = [UIColor clearColor];
        
        //线图表格
        [self initChartViews];
        
        [self addSubview:_titleLbl];
        [self addSubview:_allLbl];
        [self addSubview:_finishLbl];
        [self addSubview:_allTagImg];
        [self addSubview:_finishTagImg];
        [self addSubview:_chartView];
        
    }
}

- (void) initChartViews {
    _chartView = [[LineChartView alloc] init];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
    _chartView.noDataText = @"";
    _chartView.dragEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.highlightPerTapEnabled = NO;
    [_chartView setScaleEnabled:NO];
    
    ChartLegend * l = _chartView.legend;
    [l setEnabled:NO];
    
    
    ChartXAxis * xAxis = _chartView.xAxis;     //X轴数据显示设置
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [FMFont setFontByPX:30];
    xAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled = NO;
    xAxis.spaceBetweenLabels = 2.0f;
    xAxis.avoidFirstLastClippingEnabled = YES;  //只有设置了这个参数以后，X轴上最两边的参数才不会被挤掉
    
    
    ChartYAxis * leftAxis = _chartView.leftAxis;     //左边Y轴数据显示设置
    leftAxis.labelFont = [FMFont setFontByPX:30];
    leftAxis.labelCount = 5;
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.zeroLineColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:238/255.0];
    leftAxis.gridColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:238/255.0];
    leftAxis.labelTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 0;//小数点位数
    leftAxis.valueFormatter.negativeSuffix = @"";
    leftAxis.valueFormatter.positiveSuffix = @"";
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15f;
//    leftAxis.customAxisMin = 0;
    leftAxis.axisMinValue = 0;
    
    ChartYAxis * rightAxis = _chartView.rightAxis;    //右边Y轴隐藏
    [rightAxis setEnabled:NO];
    
    
    [_chartView animateWithYAxisDuration:2.5f easingOption:ChartEasingOptionEaseInQuart];
}


- (void) updateViews {
    
    if (!_finishLbl.text || !_allLbl.text) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getSizeByPixel:50];
    CGFloat sepHeight = [FMSize getSizeByPixel:150];
    CGFloat imgWidth = 50*2/5;
    CGFloat imgHeight = 14*2/5 + 1.5;
    
    CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:_titleLbl.text andMaxLabelWidth:width];
    CGSize allSize = [FMUtils getLabelSizeBy:_allLbl andContent:_allLbl.text andMaxLabelWidth:width];
    CGSize finishSize = [FMUtils getLabelSizeBy:_finishLbl andContent:_finishLbl.text andMaxLabelWidth:width];
    
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
    
    originY += titleSize.height + sepHeight;
    originX = (width - padding - allSize.width - finishSize.width - imgWidth*2 - 16);
    
    [_allTagImg setFrame:CGRectMake(originX, originY+(allSize.height - imgHeight)/2, imgWidth, imgHeight)];
    originX += imgWidth + 3;
    
    [_allLbl setFrame:CGRectMake(originX, originY, allSize.width, allSize.height)];
    originX += allSize.width + 10;
    
    [_finishTagImg setFrame:CGRectMake(originX, originY+(finishSize.height - imgHeight)/2, imgWidth, imgHeight)];
    originX += imgWidth + 3;
    
    [_finishLbl setFrame:CGRectMake(originX, originY, finishSize.width, finishSize.height)];
    
    originX = padding;
    originY += finishSize.height + padding;
    
    CGFloat chartHeight = height - sepHeight*2 - padding - titleSize.height - finishSize.height ;
    [_chartView setFrame:CGRectMake(originX, originY, width-padding*2, chartHeight)];
    
    
    [self updateInfo];
}

- (void) updateInfo {
    [self updateChartInfo];
}


- (void) updateChartInfo {
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _month.count; i++) {
        [xVals addObject:_month[i]];
    }
    
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _allArray.count; i++) {
        NSNumber * tmpNumber = _allArray[i];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:tmpNumber.integerValue xIndex:i]];
    }
    
    LineChartDataSet * allSet = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    allSet.axisDependency = AxisDependencyRight;
    [allSet setDrawValuesEnabled:NO];
    [allSet setDrawCirclesEnabled:YES];
    [allSet setDrawCircleHoleEnabled:YES];
    [allSet setDrawCubicEnabled:YES];
    [allSet setCubicIntensity:0.15];
    [allSet setCircleRadius:3];
    [allSet setCircleColor:[UIColor colorWithRed:248/255.0 green:140/255.0 blue:115/255.0 alpha:1]];
    [allSet setCircleHoleColor:[UIColor whiteColor]];
    [allSet setColor:[UIColor colorWithRed:248/255.0 green:140/255.0 blue:115/255.0 alpha:1]];
    allSet.lineWidth = 1.5f;
    allSet.valueFont = [UIFont systemFontOfSize:12.0f];
    NSArray * shadowColor = [NSArray arrayWithObjects:
                             (id)[[[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                             (id)[[[UIColor colorWithRed:0xfa/255.0 green:0x7e/255.0 blue:0x5d/255.0 alpha:1] colorWithAlphaComponent:1] CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)shadowColor, nil);
    allSet.fillAlpha = 1.0f;
    allSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.0f];
    CGGradientRelease(gradient);
    allSet.drawFilledEnabled = YES;
    
    NSMutableArray * yVals2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < _finishArray.count; i ++) {
        NSNumber * tmpNumber = _finishArray[i];
        [yVals2 addObject:[[ChartDataEntry alloc] initWithValue:tmpNumber.integerValue xIndex:i]];
    }
    
    LineChartDataSet * finisheSet = [[LineChartDataSet alloc] initWithYVals:yVals2 label:@"DataSet 2"];
    finisheSet.axisDependency = AxisDependencyRight;
    [finisheSet setDrawValuesEnabled:NO];
    [finisheSet setDrawCirclesEnabled:YES];
    [finisheSet setDrawCircleHoleEnabled:YES];
    [finisheSet setDrawCubicEnabled:YES];
    [finisheSet setCubicIntensity:0.15];
    [finisheSet setCircleRadius:3];
    [finisheSet setCircleColor:[UIColor colorWithRed:112/255.0 green:190/255.0 blue:240/255.0 alpha:1]];
    [finisheSet setCircleHoleColor:[UIColor whiteColor]];
    [finisheSet setColor:[UIColor colorWithRed:112/255.0 green:190/255.0 blue:240/255.0 alpha:1]];
    finisheSet.lineWidth = 1.5f;
    finisheSet.valueFont = [UIFont systemFontOfSize:12.0f];
    NSArray * shadowColor2 = [NSArray arrayWithObjects:
                             (id)[[[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                             (id)[[[UIColor colorWithRed:0x54/255.0 green:0xb5/255.0 blue:0xf4/255.0 alpha:1] colorWithAlphaComponent:1] CGColor], nil];
    CGGradientRef gradient2 = CGGradientCreateWithColors(nil, (CFArrayRef)shadowColor2, nil);
    finisheSet.fillAlpha = 1.0f;
    finisheSet.fill = [ChartFill fillWithLinearGradient:gradient2 angle:90.0f];
    CGGradientRelease(gradient2);
    finisheSet.drawFilledEnabled = YES;
    
    NSMutableArray * dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:allSet];
    [dataSets addObject:finisheSet];
    
    
    LineChartData * data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setDrawValues:NO];
    
    _chartView.data = data;
}

- (void) setChartDataWithAllInfo:(NSMutableArray *) allArray andFinishedInfo:(NSMutableArray *) finisheedArray {
    if (!_allArray) {
        _allArray = [[NSMutableArray alloc] init];
    }
    _allArray = allArray;
    
    if (!_finishArray) {
        _finishArray = [[NSMutableArray alloc] init];
    }
    _finishArray = finisheedArray;
    
    [self updateInfo];
}

+ (CGFloat)calculateHeightByWidth:(CGFloat)width {
    CGFloat height = 0;
    height = 300 + [FMSize getSizeByPixel:150]/2;
    
    return height;
}


@end




