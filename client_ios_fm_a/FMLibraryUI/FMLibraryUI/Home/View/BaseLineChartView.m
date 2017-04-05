//
//  BaseLineChartView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseLineChartView.h"
#import "UIButton+Bootstrap.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMColor.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ColorsDescLabel.h"
#import "BaseBundle.h"

@interface BaseLineChartView ()

//@property (readwrite, nonatomic, strong) LineChartView * chartView;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) ColorsDescLabel * colorDescLbl;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;
@property (readwrite, nonatomic, strong) NSMutableArray * valueArray;
@property (readwrite, nonatomic, strong) NSMutableArray * descArray;
@property (readwrite, nonatomic, strong) NSMutableArray * colorArray;


@property (readwrite, nonatomic, strong) UIFont * titleFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (readwrite, nonatomic, assign) CGFloat colorDescHeight;
@property (readwrite, nonatomic, assign) BOOL showColorDesc;

@property (readwrite, nonatomic, assign) BOOL showFilled;   //是否填充
@property (readwrite, nonatomic, assign) BOOL showCubic;   //是否显示曲线

@property (readwrite, nonatomic, assign) NSInteger maxVisuableCount;
@end

@implementation BaseLineChartView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = _paddingLeft;
        _paddingBottom = _paddingLeft;
        _maxVisuableCount = 7;
        _colorDescHeight = 30;
        
        _titleFont = [FMFont getInstance].chartTitleFont;
        _msgFont = [FMFont getInstance].chartDefaultFont;
        _showColorDesc = NO;
        
        _showCubic = YES;
        _showFilled = YES;
        
        
//        _chartView = [[LineChartView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _colorDescLbl = [[ColorsDescLabel alloc] init];
        
        //        _colorDescLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        
        _titleLbl.font = _titleFont;
        _titleLbl.textColor = [FMColor getInstance].chartTitleColor;
        
//        [self addSubview:_chartView];
        [self addSubview:_titleLbl];
        [self addSubview:_colorDescLbl];
        
        [self initChartView];
    }
    return self;
}

- (void) initChartView {
//    //    _chartView.delegate = self;
//    
//    _chartView.descriptionText = @"";
//    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
//    _chartView.noDataText = @"";
//    
////    _chartView.highlightEnabled = YES;
//    _chartView.dragEnabled = YES;
//    [_chartView setScaleEnabled:NO];
//    _chartView.pinchZoomEnabled = NO;
////    _chartView.highlightIndicatorEnabled = YES;
//    _chartView.maxVisibleValueCount = _maxVisuableCount;
//    [_chartView setDoubleTapToZoomEnabled:NO];
//    _chartView.gridBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];   //背景色
//    
//    ChartXAxis *xAxis = _chartView.xAxis;
//    xAxis.labelPosition = XAxisLabelPositionBottom;
//    xAxis.labelTextColor = [FMColor getInstance].chartLabelColor;
//    xAxis.drawAxisLineEnabled = NO;
//    [xAxis setDrawGridLinesEnabled:NO];
//    
//    ChartLegend * legend =  _chartView.legend;
//    [legend setEnabled:NO];
//    
//    // x-axis limit line
//    //    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.f label:@"Index 10"];
//    //    llXAxis.lineWidth = 4.f;
//    //    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
//    //    llXAxis.labelPosition = ChartLimitLabelPositionRight;
//    //    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
//    //
//    //    [_chartView.xAxis addLimitLine:llXAxis];
//    
//    
//    ChartYAxis *leftAxis = _chartView.leftAxis;
//    [leftAxis removeAllLimitLines];
//    //    leftAxis.customAxisMax = 220.f;
//    //    leftAxis.customAxisMin = 0.f;
//    leftAxis.startAtZeroEnabled = YES;
//    leftAxis.drawGridLinesEnabled = NO;     //设置是否显示表格
//    leftAxis.labelTextColor = [FMColor getInstance].chartLabelColor;
//    //    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
//    //    leftAxis.drawLimitLinesBehindDataEnabled = YES;
//    
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    [rightAxis setEnabled:NO];
//    
//    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] font:[UIFont systemFontOfSize:12.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
//    marker.minimumSize = CGSizeMake(80.f, 40.f);
//    //    marker.color = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
////    _chartView.marker = marker;
//    
//    _chartView.legend.enabled = NO;
//    
//    [_chartView animateWithXAxisDuration:1.5 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat sepHeight = 10;
    CGFloat titleHeight = 40;
    CGFloat originY = 10;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat descHeight = 0;
    CGFloat itemHeight = 0;
    if(_showColorDesc) {
        descHeight = _colorDescHeight;
    }
    
    titleHeight = [FMUtils heightForStringWith:_titleLbl value:_title andWidth:width-padding*4];
    
    itemHeight = titleHeight;
    [_titleLbl setFrame:CGRectMake(padding*2 , originY, width-padding*4, itemHeight)];
    originY += itemHeight + sepHeight;
    
    
    if(_showColorDesc) {
        itemHeight = descHeight;
        [_colorDescLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
        originY += itemHeight;
        [_colorDescLbl setHidden:NO];
    } else {
        [_colorDescLbl setHidden:YES];
    }
    
    itemHeight = height - originY;
//    [_chartView setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight;
    
    
    [self updateInfo];
}

- (void) updateColorArray {
    if(!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    NSInteger count = [_valueArray count];
    if([_colorArray count] <= count) {
        [_colorArray removeAllObjects];
        for(NSInteger index=0;index<count;index++) {
//            UIColor * color = [FMColor getRandomColor];
            UIColor * color = [FMColor getChartColorByIndex:index];
            [_colorArray addObject:color];
        }
    }
}

- (void) updateColorDesc {
    if(_showColorDesc) {
        [_colorDescLbl setColors:_colorArray desc:_descArray];
    }
}

- (void) updateLineInfo {
    [self updateColorArray];
    NSInteger count = [_keyArray count];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    BOOL isAllZero = YES;
    NSInteger setCount = [_valueArray count];
    NSInteger index = 0;
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:_keyArray[i]];
    }
    for(index = 0;index<setCount;index++) {
        NSArray * array = _valueArray[index];
        yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++)
        {
            [yVals addObject:[[BarChartDataEntry alloc] initWithValue:[array[i] floatValue] xIndex:i]];
            if(![array[i] isEqualToNumber:[NSNumber numberWithFloat:0]]) {
                isAllZero = NO;
            }
            
        }
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithYVals:yVals];
        
        //    set.lineDashLengths = @[@5.f, @2.5f];//虚线
        UIColor * color = _colorArray[index];
        [set setColor:color];
        [set setCircleColor:color];
        //        [set setCircleHoleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
        set.lineWidth = 1.f;
        set.circleRadius = 3.f;
        //        set.drawCircleHoleEnabled = YES;
        //        set.valueFont = [UIFont systemFontOfSize:9.f];
        //        set.fillAlpha = 65/255.f;
        //        set.fillColor = UIColor.blackColor;
        //        set.label = @"";
        set.drawValuesEnabled = YES;
        set.drawFilledEnabled = _showFilled;
        set.fillColor = color;
        set.drawCubicEnabled = _showCubic;
        set.highlightColor = color;
        [dataSets addObject:set];
    }
    
    
    LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
////    _chartView.data = data;
//    
//    if(isAllZero) {
//        ChartYAxis * yAxis = _chartView.leftAxis;
//        NSNumberFormatter * formater = [[NSNumberFormatter alloc] init];
//        formater.numberStyle = kCFNumberFormatterDecimalStyle;
//        yAxis.valueFormatter = formater;
//    }
//    
//        [_chartView setMaxVisibleValueCount:_maxVisuableCount]; //_maxVisuableCount
//    [_chartView setVisibleXRange:_maxVisuableCount];    //设置能看见的记录的个数
}

- (void) updateInfo {
    _titleLbl.text = _title;
    [self updateLineInfo];
    [self updateColorDesc];
}

- (void) setShowColorDesc:(BOOL)showColorDesc {
    _showColorDesc = showColorDesc;
    [self updateViews];
}

- (void) setShowCubic:(BOOL)showCubic {
    _showCubic = showCubic;
    [self updateViews];
}

- (void) setShowFilled:(BOOL)showFilled {
    _showFilled = showFilled;
    [self updateViews];
}

- (void) setShowBound:(BOOL) showBound {
    if(showBound) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        self.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    } else {
        self.layer.borderWidth = 0;
    }
}


- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values {
    
    _title = title;
    _keyArray = keys;
    if(!_valueArray) {
        _valueArray = [[NSMutableArray alloc] init];
    }
    [_valueArray addObject:values];
    [self updateViews];
}

- (void) setInfoWithTitle:(NSString *)title andKeys:(NSMutableArray *)keys {
    _title = title;
    _keyArray = keys;
    
}

- (void) addDataArray:(NSMutableArray *)array desc:(NSString *)desc {
    if(!_valueArray) {
        _valueArray = [[NSMutableArray alloc] init];
    }
    [_valueArray addObject:array];
    if(!_descArray) {
        _descArray = [[NSMutableArray alloc] init];
    }
    [_descArray addObject:desc];
    [self updateViews];
}

- (void) clear {
    if(_valueArray) {
        [_valueArray removeAllObjects];
    }
    if(_descArray) {
        [_descArray removeAllObjects];
    }
    if(_keyArray) {
        [_keyArray removeAllObjects];
    }
}

- (void) setPaddingLeft:(CGFloat)paddingLeft
          andPaddingTop:(CGFloat) paddingTop
        andPaddingRight:(CGFloat) paddingRight
       andPaddingBottom:(CGFloat) paddingBottom{
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    _paddingTop = paddingTop;
    _paddingBottom = paddingBottom;
    [self updateViews];
}

@end

