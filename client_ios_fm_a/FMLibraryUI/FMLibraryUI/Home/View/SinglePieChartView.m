//
//  SinglePieChartView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "SinglePieChartView.h"
//#import "client_ios_fm_a-Swift.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMColor.h"
#import "ColorsDescLabel.h"
#import "FMTheme.h"


@interface SinglePieChartView ()

@property (readwrite, nonatomic, strong) PieChartView * chartView;
@property (readwrite, nonatomic, strong) ColorsDescLabel * colorsLbl;

@property (readwrite, nonatomic, strong) UILabel * titleLbl;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;
@property (readwrite, nonatomic, strong) NSMutableArray * valueArray;
@property (readwrite, nonatomic, strong) NSMutableArray * colorArray;
@property (readwrite, nonatomic, strong) NSMutableArray * colorLblArray;

@property (readwrite, nonatomic, assign) CGFloat pieWidth;          //饼状图宽度

@property (readwrite, nonatomic, strong) UIFont * titleFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@end

@implementation SinglePieChartView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = 0;
        _paddingBottom = 0;
        _pieWidth = 150;
        
        _titleFont = [FMFont getInstance].chartTitleFont;
        _msgFont = [FMFont getInstance].chartDefaultFont;

        
        _chartView = [[PieChartView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _colorsLbl = [[ColorsDescLabel alloc] init];
        [_colorsLbl setLayoutType:COLOR_DESC_LAYOUT_VERTICAL];
        
        _titleLbl.font = _titleFont;
        _titleLbl.textColor = [FMColor getInstance].chartTitleColor;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self initPieView];
        
        [self addSubview:_chartView];
        [self addSubview:_titleLbl];
        [self addSubview:_colorsLbl];
    }
    return self;
}

- (void) initPieView {
    _chartView.usePercentValuesEnabled = YES;
//    _chartView.holeTransparent = YES;
//    _chartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _chartView.drawCenterTextEnabled = NO;
    _chartView.drawHoleEnabled = YES;           //是否显示中心圆
    _chartView.holeRadiusPercent = 0.58f;
    _chartView.noDataText = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
    
    _chartView.transparentCircleRadiusPercent = 0.61f;
    _chartView.descriptionText = @"";
    _chartView.rotationAngle = 0.f;
    _chartView.rotationEnabled = NO;
//    _chartView.highlightEnabled = YES;
    _chartView.userInteractionEnabled = NO;
    
    ChartLegend *l = _chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.form = ChartLegendFormSquare;
    l.formSize = 8.f;
    l.formToTextSpace = 4.f;
    l.xEntrySpace = 6.f;
    l.textColor = [FMColor getInstance].chartDefaultColor;
    [l setEnabled:NO];
    
    [_chartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat titleHeight = [FMSize getInstance].listItemInfoHeight;

    _pieWidth = height-titleHeight;
    if(_pieWidth * 3 > width*2) {
        _pieWidth = width*2/3;
    }
    [_chartView setFrame:CGRectMake(_paddingLeft, titleHeight + (height-titleHeight-_pieWidth)/2, (width-_paddingLeft-_paddingRight)*2/3, _pieWidth)];
    [_titleLbl setFrame:CGRectMake(_paddingLeft , _paddingTop, width-_paddingLeft-_paddingRight, titleHeight)];
    [_colorsLbl setFrame:CGRectMake(_paddingLeft+(width-_paddingLeft-_paddingRight)*2/3, 0, (width-_paddingLeft-_paddingRight)/3, height)];
    
    [self updateInfo];
}

- (void) updatePieInfo {
    NSInteger count = [_keyArray count];
    if(count < 2) {
        return;
    }
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:[_valueArray[i] floatValue] xIndex:i]];
    }
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:_keyArray[i]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@""];
    dataSet.sliceSpace = 3.f;   //块之间的分割区域宽度
    
    // add a lot of colors
    
    
    dataSet.colors = _colorArray;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    [_colorsLbl setColors:_colorArray desc:_keyArray];
    [_chartView highlightValues:nil];
}

- (void) updateInfo {
    _titleLbl.text = _title;
    [self updatePieInfo];
}


- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values{
    
    _title = title;
    _keyArray = keys;
    _valueArray = values;
    if(_keyArray && [_keyArray count] > 0) {
        if(!_colorArray) {
            _colorArray = [[NSMutableArray alloc] init];
        }
        if([_colorArray count] < [_keyArray count]) {
            NSInteger index = [_colorArray count];
            NSInteger count = [_keyArray count];
            for(;index<count;index++) {
//                UIColor * color = [FMColor getRandomColor];
                UIColor * color = [FMColor getChartColorByIndex:index];
                [_colorArray addObject:color];
            }
        }
        
    }
    [self updateViews];
}

- (void) setColorArray:(NSMutableArray *)colorArray {
    _colorArray = colorArray;
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
