//
//  FMChartView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "FMChartView.h"
#import "FMTheme.h"
#import "FMColor.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
//#import "client_ios_fm_a-Swift.h"
//#import <Charts/Charts.h>
#import "BaseLineChartView.h"
#import "BaseBundle.h"

@interface FMChartView () <ChartViewDelegate>
@property (readwrite, nonatomic, strong) UIImageView * logoImgView;
@property (readwrite, nonatomic, strong) UILabel * logoDescLbl;
@property (readwrite, nonatomic, strong) UILabel * finishedCountLbl;
@property (readwrite, nonatomic, strong) UILabel * totalCountLbl;
@property (readwrite, nonatomic, strong) UILabel * dailyCoundDescLbl;
@property (readwrite, nonatomic, strong) LineChartView * chartView;

@property (readwrite, nonatomic, strong) UIView * tagView;     //底部日期标签
@property (readwrite, nonatomic, strong) UILabel * firstLbl;
@property (readwrite, nonatomic, strong) UILabel * secondLbl;
@property (readwrite, nonatomic, strong) UILabel * thirdLbl;
@property (readwrite, nonatomic, strong) UILabel * fourthLbl;

@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;
@property (readwrite, nonatomic, strong) NSMutableArray * finishedArray;
@property (readwrite, nonatomic, strong) NSMutableArray * totalArray;


@property (readwrite, nonatomic, assign) NSInteger finishedCount;
@property (readwrite, nonatomic, assign) NSInteger totalCount;

@property (readwrite, nonatomic, assign) CGFloat doneLabelWidth;
@property (readwrite, nonatomic, assign) CGFloat doneLabelHeight;

@property (readwrite, nonatomic, assign) CGFloat totalLabelWidth;
@property (readwrite, nonatomic, assign) CGFloat totalLabelHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@end


@implementation FMChartView

- (instancetype)init {
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
        
        //logoview
        _logoImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"todayOrderCount"]];

        //logo标签desc
        _logoDescLbl = [[UILabel alloc] init];
        _logoDescLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_title_today_order" inTable:nil];
        _logoDescLbl.textColor = [UIColor whiteColor];
        _logoDescLbl.textAlignment = NSTextAlignmentLeft;
        _logoDescLbl.font = [FMFont getInstance].font44;
        
        
        //已完成lbl
        _finishedCountLbl = [[UILabel alloc] init];
        _finishedCountLbl.textAlignment = NSTextAlignmentRight;
        _finishedCountLbl.textColor = [UIColor whiteColor];
        _finishedCountLbl.font = [FMFont setFontByPX:140];
        
        
        //总数lbl
        _totalCountLbl = [[UILabel alloc] init];
        _totalCountLbl.textAlignment = NSTextAlignmentLeft;
        _totalCountLbl.textColor = [UIColor whiteColor];
        _totalCountLbl.font = [FMFont setFontByPX:100];
        
        
        //desc
        _dailyCoundDescLbl = [[UILabel alloc] init];
        _dailyCoundDescLbl.text = [[BaseBundle getInstance] getStringByKey:@"chart_desc_finish_all" inTable:nil];
        _dailyCoundDescLbl.font = [FMFont setFontByPX:36];
        _dailyCoundDescLbl.textColor = [UIColor whiteColor];
        _dailyCoundDescLbl.textAlignment = NSTextAlignmentCenter;
        
        //线图
        [self initChartView];
        
        
        //X轴日期标签
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = [UIColor clearColor];
        
        UIFont * dateFont = [FMFont setFontByPX:30];
        UIColor * dateTodayColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _firstLbl = [[UILabel alloc] init];
        _firstLbl.textColor = [UIColor whiteColor];
        _firstLbl.font = dateFont;
        _firstLbl.textAlignment = NSTextAlignmentCenter;
        _firstLbl.backgroundColor = [UIColor clearColor];
        
        _secondLbl = [[UILabel alloc] init];
        _secondLbl.textColor = [UIColor whiteColor];
        _secondLbl.font = dateFont;
        _secondLbl.textAlignment = NSTextAlignmentCenter;
        _secondLbl.backgroundColor = [UIColor clearColor];
        
        _thirdLbl = [[UILabel alloc] init];
        _thirdLbl.textColor = [UIColor whiteColor];
        _thirdLbl.font = dateFont;
        _thirdLbl.textAlignment = NSTextAlignmentCenter;
        _thirdLbl.backgroundColor = [UIColor clearColor];
        
        _fourthLbl = [[UILabel alloc] init];
        _fourthLbl.textColor = dateTodayColor;
        _fourthLbl.font = dateFont;
        _fourthLbl.textAlignment = NSTextAlignmentCenter;
        _fourthLbl.backgroundColor = [UIColor clearColor];
        
        [_tagView addSubview:_firstLbl];
        [_tagView addSubview:_secondLbl];
        [_tagView addSubview:_thirdLbl];
        [_tagView addSubview:_fourthLbl];
        
        [self addSubview:_logoImgView];
        [self addSubview:_logoDescLbl];
        [self addSubview:_finishedCountLbl];
        [self addSubview:_totalCountLbl];
        [self addSubview:_dailyCoundDescLbl];
        [self addSubview:_chartView];
        [self addSubview:_tagView];
    
        [self updateInfo];
    }
}


- (void) initChartView {
    _chartView = [[LineChartView alloc] init];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = [[BaseBundle getInstance] getStringByKey:@"chart_no_data" inTable:nil];
    _chartView.noDataText = @"";
    _chartView.dragEnabled = NO;
    [_chartView setScaleEnabled:NO];
    _chartView.pinchZoomEnabled = NO;
    _chartView.highlightPerTapEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    
    ChartXAxis * xAxis = _chartView.xAxis;
    xAxis.labelPosition = ChartLimitLabelPositionLeftBottom;
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.labelFont = [FMFont setFontByPX:30];
    [xAxis setDrawGridLinesEnabled:NO];
    [xAxis setDrawAxisLineEnabled:NO];
    xAxis.spaceBetweenLabels = 1;
    xAxis.avoidFirstLastClippingEnabled = YES;
    [xAxis setEnabled:NO];

    
    
    ChartYAxis * leftAxis = _chartView.leftAxis;
    [leftAxis setEnabled:NO];
    
    ChartYAxis * rightAxis = _chartView.rightAxis;
    [rightAxis setEnabled:NO];
    
    ChartLegend * legend = _chartView.legend;
    [legend setEnabled:NO];
    
    [_chartView.viewPortHandler setMaximumScaleX:1.0f];
    [_chartView.viewPortHandler setMinimumScaleX:1.0f];
    
    [_chartView animateWithYAxisDuration:2.5f easingOption:ChartEasingOptionEaseInQuart];
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    if (height == 0 || width == 0) {
        return;
    }
    
    //添加渐变色背景
    CAGradientLayer * gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[[UIColor colorWithRed:0x2f/255.0 green:0x99/255.0 blue:0xcf/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                       (id)[[[UIColor colorWithRed:0x3e/255.0 green:0xc1/255.0 blue:0xbc/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                       nil];
//    [gradient setLocations:@[@0.5]];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(width/1000, 1.0);
    [self.layer insertSublayer:gradient atIndex:0];
    
    
    //logoDesc
    CGSize logoDescSize = [FMUtils getLabelSizeBy:_logoDescLbl andContent:_logoDescLbl.text andMaxLabelWidth:width];
    
    //计算完成数lbl的size
    CGSize finishSize = [FMUtils getLabelSizeBy:_finishedCountLbl andContent:[NSString stringWithFormat:@"%d/",_finishedCount] andMaxLabelWidth:width];
    
    //计算总数lbl的size
    CGSize totalSize = [FMUtils getLabelSizeBy:_totalCountLbl andContent:[NSString stringWithFormat:@"%d",_totalCount] andMaxLabelWidth:width];

    //计算描述lbl的size
    CGSize descSize = [FMUtils getLabelSizeBy:_dailyCoundDescLbl andContent:_dailyCoundDescLbl.text andMaxLabelWidth:width];
    
    //日期标签
    CGSize dateLblSize = [FMUtils getLabelSizeBy:_firstLbl andContent:[_keyArray firstObject] andMaxLabelWidth:width];

    
    
    CGFloat sepHeight = 10;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat sepWidth = 5;
    CGFloat imgWidth = 17;
    CGFloat descLblHeight = 20;
    CGFloat paddingBottom = 10;
    CGFloat tagHeight = 20;
    CGFloat paddingLeft = 20;
    
    CGFloat paddingWidth = (width - dateLblSize.width*4 -paddingLeft *2)/3;
    
    originY = 35;
    originX = paddingLeft;
    
    
    [_logoImgView setFrame:CGRectMake(originX, originY, imgWidth, imgWidth)];
    [_logoDescLbl setFrame:CGRectMake(originX+imgWidth+sepWidth, originY + (imgWidth - descLblHeight)/2 , logoDescSize.width, logoDescSize.height)];
    originY += logoDescSize.height;
    originX = (width - finishSize.width - totalSize.width)/2;
    
    [_finishedCountLbl setFrame:CGRectMake(originX, originY, finishSize.width, finishSize.height)];
    originX += finishSize.width;
    
    [_totalCountLbl setFrame:CGRectMake(originX, originY + finishSize.height - totalSize.height - 3, totalSize.width, totalSize.height)];
    originY += finishSize.height;
    
    [_dailyCoundDescLbl setFrame:CGRectMake((width - descSize.width)/2, originY, descSize.width, descSize.height)];
    originY += descSize.height + sepHeight/2;

    originX = paddingLeft + dateLblSize.width / 2 - 10;//10 -> charview 展示的内部边距
    [_chartView setFrame:CGRectMake(originX, originY , width-originX*2, height - originY - paddingBottom - 10)];
    
    originX = paddingLeft;
    [_tagView setFrame:CGRectMake(originX, height - tagHeight - 3 - 5, width-originX*2, tagHeight)];
    
    originX = 0;
    [_firstLbl setFrame:CGRectMake(originX, (tagHeight-dateLblSize.height)/2, dateLblSize.width, dateLblSize.height)];
    originX += paddingWidth + dateLblSize.width;
    
    [_secondLbl setFrame:CGRectMake(originX, (tagHeight-dateLblSize.height)/2, dateLblSize.width, dateLblSize.height)];
    originX += paddingWidth + dateLblSize.width;
    
    [_thirdLbl setFrame:CGRectMake(originX, (tagHeight-dateLblSize.height)/2, dateLblSize.width, dateLblSize.height)];
    originX += paddingWidth + dateLblSize.width;
    
    [_fourthLbl setFrame:CGRectMake(originX, (tagHeight-dateLblSize.height)/2, dateLblSize.width, dateLblSize.height)];
    originX += paddingWidth + dateLblSize.width;
    
    [_firstLbl sizeToFit];
    [_secondLbl sizeToFit];
    [_thirdLbl sizeToFit];
    [_fourthLbl sizeToFit];

    [self updateInfo];
}

- (void) updateInfo {
    [_finishedCountLbl setText:[NSString stringWithFormat:@"%d/",_finishedCount]];
    [_totalCountLbl setText:[NSString stringWithFormat:@"%d",_totalCount]];
    [self updateLineInfo];
}

- (void) updateLineInfo {
    if ([_finishedArray count] == 0) {
        return;
    }
    
    NSMutableArray * xVals = [[NSMutableArray alloc] init];
    for (int i = 0;  i < [_keyArray count]; i ++) {
        [xVals addObject:_keyArray[i]];
    }
    
    NSMutableArray * yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_totalArray count]; i ++) {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:[_totalArray[i] doubleValue] xIndex:i]];
    }
    
    
    LineChartDataSet * set = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
    [set setColor:[UIColor whiteColor]];
    [set setCircleColor:[UIColor whiteColor]];
    set.lineWidth = 1.0f;
    set.circleRadius = 2.5f;
    set.cubicIntensity = 0.15f;
    set.drawCubicEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:12.0f];
    set.valueTextColor = [UIColor whiteColor];
    set.drawValuesEnabled = YES;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    set.valueFormatter = formatter;
    
    NSArray * shadowColor = [NSArray arrayWithObjects:
                             (id)[[[UIColor whiteColor] colorWithAlphaComponent:0] CGColor],
                             (id)[[[UIColor whiteColor] colorWithAlphaComponent:1] CGColor], nil];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)shadowColor, nil);
    
    set.fillAlpha = 1.0f;
    set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.0f];
    CGGradientRelease(gradient);
    
    set.drawFilledEnabled = YES;
    set.lineDashPhase = 100;
    
    
    NSMutableArray * dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set];
    
    
    LineChartData * data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _chartView.data = data;
    
}

#pragma mark Interface method

- (void) setInfoWithDateKeys:(NSMutableArray *)keys {
    if (!_keyArray) {
        _keyArray = [[NSMutableArray alloc] init];
    }
    _keyArray = keys; // 存放了日期信息
    [_keyArray replaceObjectAtIndex:1 withObject:@""];
    [_keyArray replaceObjectAtIndex:3 withObject:@""];
    [_keyArray replaceObjectAtIndex:5 withObject:@""];
    
    _firstLbl.text = _keyArray[0];
    _secondLbl.text = _keyArray[2];
    _thirdLbl.text = _keyArray[4];
    _fourthLbl.text = _keyArray[6];
}

- (void) setFinishedInfoWithArray:(NSMutableArray *)array {
    if(!_finishedArray) {
        _finishedArray = [[NSMutableArray alloc] init];
    }
    _finishedArray = array; //存放了已完成工单量
    _finishedCount = [[array lastObject] integerValue];
}

- (void) setTotalInfoWithArray:(NSMutableArray *)array {
    if (!_totalArray) {
        _totalArray = [[NSMutableArray alloc] init];
    }
    _totalArray = array;    //存放了所有工单量
    _totalCount = [[array lastObject] integerValue];
    [self updateViews];
}


- (void) clear {
    if(_keyArray) {
        [_keyArray removeAllObjects];
    }
    if(_finishedArray) {
        [_finishedArray removeAllObjects];
    }
    if (_totalArray) {
        [_totalArray removeAllObjects];
    }
}

#pragma mark Private method

- (CGSize) getLabelSize:(UILabel *) label ByString:(NSString *) content {
    [label setText:content];
    [label sizeToFit];
    CGSize realSize = label.frame.size;
    return realSize;
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

@end

