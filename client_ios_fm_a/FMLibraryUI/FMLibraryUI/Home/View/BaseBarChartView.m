//
//  BaseBarChartView.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "BaseBarChartView.h"
#import "UIButton+Bootstrap.h"
#import "ColorsDescLabel.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface BaseBarChartView ()  <ChartViewDelegate>

@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) BarChartView * chartView;
@property (readwrite, nonatomic, strong) ColorsDescLabel * colorDescLbl;

@property (readwrite, nonatomic, strong) NSMutableArray * xValues;  //横坐标

@property (readwrite, nonatomic, strong) NSMutableArray * yValueArrays;//数据
@property (readwrite, nonatomic, strong) NSMutableArray * descArray;    //描述
@property (readwrite, nonatomic, strong) NSMutableArray * colorArray;   //颜色

@property (readwrite, nonatomic, strong) NSString * title;          //标题
@property (readwrite, nonatomic, assign) BaseBarChartColorType colorType;   //颜色类型
@property (readwrite, nonatomic, assign) BaseBarChartType barType;  //图形类型

@property (readwrite, nonatomic, strong) NSString * yValueUnit; //纵坐标的单位

@property (readwrite, nonatomic, assign) CGFloat titleHeight;
@property (readwrite, nonatomic, assign) CGFloat colorDescHeight;

@property (readwrite, nonatomic, assign) BOOL showColorDesc;
@property (readwrite, nonatomic, assign) BOOL isInited;

@end


@implementation BaseBarChartView

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
        
        _yValueUnit = @"";
        
        _colorType = BASE_BAR_CHART_COLOR_ALL_THE_SAME;
        _barType = BASE_BAR_CHART_COMMON;
        _showColorDesc = YES;
        
        UIFont * titleFont = [FMFont getInstance].chartTitleFont;
        
        _titleHeight = 40;
        _colorDescHeight = 30;
        
        _titleLbl = [[UILabel alloc] init];
        _chartView = [[BarChartView alloc] init];
        _colorDescLbl = [[ColorsDescLabel alloc] init];
        
        [_titleLbl setFont:titleFont];
        _titleLbl.textColor = [FMColor getInstance].chartTitleColor;
        
        [self addSubview:_titleLbl];
        [self addSubview:_colorDescLbl];
        [self addSubview:_chartView];
        
        [self initChartView];
    }
}

- (void) initChartView {
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
    _chartView.noDataText = @"";
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    [_chartView setScaleEnabled:NO];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.dragEnabled = YES;
//    _chartView.highlightEnabled = YES;
    
    ChartLegend *l = _chartView.legend;
    [l setEnabled:NO];
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.spaceBetweenLabels = 2.f;
    xAxis.labelTextColor = [FMColor getInstance].chartLabelColor;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.labelTextColor = [FMColor getInstance].chartLabelColor;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 0;//小数点位数
    leftAxis.valueFormatter.negativeSuffix = _yValueUnit;
    leftAxis.valueFormatter.positiveSuffix = _yValueUnit;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15f;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    [rightAxis setEnabled:NO];
    
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat padding  = [FMSize getInstance].defaultPadding;
    CGFloat originY = 0;
    [_titleLbl setFrame:CGRectMake(padding * 2, originY, width-padding*4, _titleHeight)];
    originY += _titleHeight;
    if(_showColorDesc) {
        [_colorDescLbl setFrame:CGRectMake(padding, originY, width-padding*2, _colorDescHeight)];
        originY += _colorDescHeight;
    }
    
    [_chartView setFrame:CGRectMake(0, originY, width, height-originY)];
    
    
    [self updateInfo];
}


- (void) updateInfo {
    [_titleLbl setText:_title];
    
    [self updateChartData];
    [self updateColorDesc];
}

//更新显示报表数据
- (void) updateChartData {
    NSInteger keyCount = [_xValues count];
    NSInteger datasetCount = [_yValueArrays count];
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [self updateColorArray];
    for (NSInteger index = 0; index<datasetCount; index++) {
        NSMutableArray * values = _yValueArrays[index];
        NSString * desc;
        if(index < [_descArray count]) {
            desc = _descArray[index];
        }
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for(NSInteger i =0;i<keyCount;i++) {
            
            if(_barType == BASE_BAR_CHART_COMMON) {
                NSNumber * value = values[i];
                [yVals addObject:[[BarChartDataEntry alloc] initWithValue:value.floatValue xIndex:i]];
            } else if(_barType == BASE_BAR_CHART_STACK) {
                NSMutableArray * stackValues = values[i];
                [yVals addObject:[[BarChartDataEntry alloc] initWithValues:stackValues xIndex:i]];
            }
        }
        BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:yVals label:desc];
        set.barSpace = 0.35f;
        if(_barType == BASE_BAR_CHART_STACK) {
            [set setColors:_colorArray];
        } else {
            if(_colorType == BASE_BAR_CHART_COLOR_EACH_ONE_DIFFERENT) {
                [set setColors:_colorArray];
            } else if(_colorType == BASE_BAR_CHART_COLOR_SET_SAME) {
                UIColor * color = _colorArray[index];
                [set setColor:color];
            }
        }
        [set setDrawValuesEnabled:YES];
        [dataSets addObject:set];
    }
    BarChartData *data = [[BarChartData alloc] initWithXVals:_xValues dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    _chartView.data = data;
    
    
    [_chartView setMaxVisibleValueCount:4];
//    [_chartView setVisibleXRange:4];
}

- (void) updateColorArray {
    NSInteger count = 0;
    NSInteger index = 0;
    if(!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    if(_barType == BASE_BAR_CHART_STACK) {
        if(_yValueArrays && [_yValueArrays count]) {
            NSMutableArray * values = _yValueArrays[0];
            if(values && [values count] > 0) {
                NSArray * stackValues = values[0];
                count = [stackValues count];
                if(count > 0 && [_colorArray count] < count) {
                    [_colorArray removeAllObjects];
                    for(index=0;index<count;index++) {
//                        UIColor * color = [FMColor getRandomColor];
                        UIColor * color = [FMColor getChartColorByIndex:index];
                        [_colorArray addObject:color];
                    }
                }
            }
        }
    } else if(_barType == BASE_BAR_CHART_COMMON) {
        if(_colorType == BASE_BAR_CHART_COLOR_ALL_THE_SAME) {
            //如果都是一样的颜色，就可以考虑用系统默认的颜色
        } else if(_colorType == BASE_BAR_CHART_COLOR_EACH_ONE_DIFFERENT) {
            count = [_xValues count];
            if(count > 0 && [_colorArray count] < count) {
                [_colorArray removeAllObjects];
                for(index=0;index<count;index++) {
//                    UIColor * color = [FMColor getRandomColor];
                    UIColor * color = [FMColor getChartColorByIndex:index];
                    [_colorArray addObject:color];
                }
            }
        } else if(_colorType == BASE_BAR_CHART_COLOR_SET_SAME) {
            count = [_yValueArrays count];
            if(count > 0 && [_colorArray count] < count) {
                [_colorArray removeAllObjects];
                for(index=0;index<count;index++) {
//                    UIColor * color = [FMColor getRandomColor];
                    UIColor * color = [FMColor getChartColorByIndex:index];
                    [_colorArray addObject:color];
                }
            }
        }
    }
}

- (void) updateColorDesc {
    NSMutableArray * colorArray;
    NSMutableArray * descArray;
    NSInteger count = 0;
    NSInteger index = 0;
    
    if(_showColorDesc) {
        colorArray = [[NSMutableArray alloc] init];
        descArray = [[NSMutableArray alloc] init];
        [self updateColorArray];
        if(_barType == BASE_BAR_CHART_STACK) {
            if(_yValueArrays && [_yValueArrays count]) {
                NSMutableArray * values = _yValueArrays[0];
                if(values && [values count] > 0) {
                    NSArray * stackValues = values[0];
                    count = [stackValues count];
                    for(index=0;index<count;index++) {
                        UIColor * color = _colorArray[index];
                        NSString * desc = _descArray[index];
                        [colorArray addObject:color];
                        [descArray addObject:desc];
                    }
                }
            }
        } else if(_barType == BASE_BAR_CHART_COMMON){
            if(_colorType == BASE_BAR_CHART_COLOR_ALL_THE_SAME) {
                //如果都是一样的颜色，就可以考虑用系统默认的颜色
            } else if(_colorType == BASE_BAR_CHART_COLOR_EACH_ONE_DIFFERENT) {
                count = [_xValues count];
                for(index=0;index<count;index++) {
                    UIColor * color = _colorArray[index];
                    NSString * desc = _descArray[index];
                    [colorArray addObject:color];
                    [descArray addObject:desc];
                }
                
            } else if(_colorType == BASE_BAR_CHART_COLOR_SET_SAME) {
                count = [_yValueArrays count];
                for(index=0;index<count;index++) {
                    UIColor * color = _colorArray[index];
                    NSString * desc = _descArray[index];
                    [colorArray addObject:color];
                    [descArray addObject:desc];
                }
            }
        }
        
        
        [_colorDescLbl setHidden:NO];
        [_colorDescLbl setColors:colorArray desc:descArray];
    } else {
        [_colorDescLbl setHidden:YES];
    }
}

//设置信息的标题以及横坐标
- (void) setInfoWithTitle:(NSString *) title andXvalues:(NSMutableArray *) values {
    _title = title;
    _xValues = values;
}

//设置颜色类型
- (void) setColorType:(BaseBarChartColorType)colorType {
    _colorType = colorType;
    [self updateViews];
}

//设置图形类型
- (void) setBarType:(BaseBarChartType)barType {
    _barType = barType;
    [self updateViews];
}

- (void) setShowColorDesc:(BOOL)showColorDesc {
    _showColorDesc = showColorDesc;
    
    [self updateViews];
}

- (void) setUnitOfYValue:(NSString *) desc {
    _yValueUnit = desc;
    if(_chartView) {
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.valueFormatter.negativeSuffix = _yValueUnit;
        leftAxis.valueFormatter.positiveSuffix = _yValueUnit;
    }
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

//根据 _colorType 类型获取 包含 count 个颜色值的数组
- (NSMutableArray *) getColorArray:(NSInteger) count {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    for(index=0;index<count;index++) {
        UIColor * color = [FMColor getRandomColor];
        [array addObject:color];
    }
    return array;
}

//添加一组数据
- (void) addDataArray:(NSMutableArray *) array withDesc:(NSString *) desc {
    if(!_yValueArrays) {
        _yValueArrays = [[NSMutableArray alloc] init];
    }
    [_yValueArrays addObject:array];
    if(!_descArray) {
        _descArray = [[NSMutableArray alloc] init];
    }
    if(desc) {
        [_descArray addObject:desc];
    }
    [self updateInfo];
}

//供 stack bar Chart 使用
- (void) addStackDataArray:(NSMutableArray *) array withDescArray:(NSMutableArray*) descArray {
    if(!_yValueArrays) {
        _yValueArrays = [[NSMutableArray alloc] init];
    }
    [_yValueArrays addObject:array];
    _descArray = descArray;
    [self updateInfo];
}

//清除历史数据
- (void) clearAllData {
    if(_yValueArrays) {
        [_yValueArrays removeAllObjects];
    } else {
        _yValueArrays = [[NSMutableArray alloc] init];
    }
    
    if(!_descArray) {
        _descArray = [[NSMutableArray alloc] init];
    } else {
        [_descArray removeAllObjects];
    }
}



#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

//- (float)barChartRendererChartYMax:(BarChartRenderer * __nonnull)renderer {
//    return 100;
//}
//- (float)barChartRendererChartYMin:(BarChartRenderer * __nonnull)renderer {
//    return 1;
//}

@end
