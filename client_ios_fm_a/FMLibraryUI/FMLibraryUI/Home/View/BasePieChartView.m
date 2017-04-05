//
//  BasePieChartView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BasePieChartView.h"
//#import "client_ios_fm_a-Swift.h"
#import "FMColor.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "FMTheme.h"

@interface BasePieChartView ()

@property (readwrite, nonatomic, strong) PieChartView * chartView;

@property (readwrite, nonatomic, strong) UILabel * titleLbl;

@property (readwrite, nonatomic, strong) UILabel * firstLbl;
@property (readwrite, nonatomic, strong) UIButton * firstBtn;

@property (readwrite, nonatomic, strong) UILabel * secondLbl;
@property (readwrite, nonatomic, strong) UIButton * secondBtn;

@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSMutableArray * keyArray;
@property (readwrite, nonatomic, strong) NSMutableArray * valueArray;
@property (readwrite, nonatomic, strong) NSMutableArray * colorArray;

@property (readwrite, nonatomic, assign) CGFloat pieWidth;          //饼状图宽度
@property (readwrite, nonatomic, assign) CGFloat labelWidth;        //颜色标签宽度

@property (readwrite, nonatomic, strong) UIFont * titleFont;
@property (readwrite, nonatomic, strong) UIFont * msgFont;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@property (readwrite, nonatomic, assign) BasePieChartViewDisplayType displayType;        //摆放位置类型，与数据说明文本的相对位置
@end

@implementation BasePieChartView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _paddingLeft = 10;
        _paddingRight = 10;
        _paddingTop = 0;
        _paddingBottom = 0;
        _labelWidth = 15;
        _displayType = PIE_IN_LEFT;     //默认摆在左边
        _pieWidth = 150;
        
        _titleFont = [UIFont fontWithName:@"Helvetica" size:16];
        _msgFont = [UIFont fontWithName:@"Helvetica" size:12];
        
        _colorArray = [[NSMutableArray alloc] initWithObjects:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE], [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE], nil];
        
        _chartView = [[PieChartView alloc] init];
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        
        _firstBtn = [[UIButton alloc] init];
        _firstLbl = [[UILabel alloc] init];
        [_firstBtn.titleLabel setFont:_msgFont];
        _firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _firstBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _labelWidth, 0, 0);
        [_firstBtn addSubview:_firstLbl];
        
        _secondBtn = [[UIButton alloc] init];
        _secondLbl = [[UILabel alloc] init];
        [_secondBtn.titleLabel setFont:_msgFont];
        _secondBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _secondBtn.titleEdgeInsets = UIEdgeInsetsMake(0, _labelWidth, 0, 0);
        [_secondBtn addSubview:_secondLbl];
        
        _titleLbl.font = _titleFont;
        _firstLbl.font = _msgFont;
        _secondLbl.font = _msgFont;
        
        [self initPieView];
        
        [self addSubview:_chartView];
        [self addSubview:_titleLbl];
        [self addSubview:_firstBtn];
        [self addSubview:_secondBtn];
    }
    return self;
}

- (void) initPieView {
    _chartView.usePercentValuesEnabled = YES;
//    _chartView.holeTransparent = YES;
//    _chartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _chartView.drawCenterTextEnabled = NO;
    _chartView.drawHoleEnabled = NO;
    _chartView.holeRadiusPercent = 0.58f;
    
    _chartView.transparentCircleRadiusPercent = 0.61f;
    _chartView.descriptionText = @"";
    _chartView.rotationAngle = 0.f;
    _chartView.rotationEnabled = NO;
//    _chartView.highlightEnabled = NO;
    _chartView.userInteractionEnabled = NO;
    
    ChartLegend *l = _chartView.legend;
    l.enabled = NO;
    
    
    [_chartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat sepWidth = 0;
    CGFloat sepHeight = 10;
    CGFloat msgHeight = 40;
    CGFloat titleHeight = 40;
    CGFloat titleWidth = 0;
    CGFloat originY = 10;
    
    if(_displayType == PIE_IN_RIGHT) {
        _pieWidth = height;
        if(_pieWidth * 3 > width*2) {
            _pieWidth = width*2/3;
        }
        [_chartView setFrame:CGRectMake(width - _paddingRight - _pieWidth, (height-_pieWidth)/2, _pieWidth, _pieWidth)];
        [_titleLbl setFrame:CGRectMake(_paddingLeft , _paddingTop , width-_paddingLeft-_paddingRight-_pieWidth-sepWidth, titleHeight)];
        titleWidth = [FMUtils widthForString:_titleLbl value:_title];
        if(titleWidth < width-_paddingLeft-_paddingRight-_pieWidth-sepWidth) {
            titleWidth = width-_paddingLeft-_paddingRight-_pieWidth-sepWidth;
        }
        [_titleLbl setFrame:CGRectMake(_paddingLeft, _paddingTop, titleWidth, titleHeight)];
        
        [_firstBtn setFrame:CGRectMake(_paddingLeft , (height - sepHeight-msgHeight*2)/2, width-_paddingLeft-_paddingRight-_pieWidth-sepWidth, msgHeight)];
        [_firstLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
        
        [_secondBtn setFrame:CGRectMake(_paddingLeft , (height +sepHeight)/2, width-_paddingLeft-_paddingRight-_pieWidth-sepWidth, msgHeight)];
        [_secondLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
    } else if(_displayType == PIE_IN_LEFT){
        _pieWidth = height;
        if(_pieWidth * 3 > width*2) {
            _pieWidth = width*2/3;
        }
        [_chartView setFrame:CGRectMake(_paddingLeft, (height-_pieWidth)/2, _pieWidth, _pieWidth)];
        [_titleLbl setFrame:CGRectMake(_paddingLeft , _paddingTop, width-_paddingLeft-_paddingRight, titleHeight)];
        titleWidth = [FMUtils widthForString:_titleLbl value:_title];
        if(titleWidth < width-_paddingLeft-_paddingRight-_pieWidth-sepWidth) {
            titleWidth = width-_paddingLeft-_paddingRight-_pieWidth-sepWidth;
        }
        [_titleLbl setFrame:CGRectMake(width-_paddingRight-titleWidth , _paddingTop, titleWidth, titleHeight)];
        
        [_firstBtn setFrame:CGRectMake(_paddingLeft + _pieWidth + sepWidth , (height - sepHeight-msgHeight*2)/2, width-_paddingLeft-_paddingRight-_pieWidth-sepWidth, msgHeight)];
        [_firstLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
        
        [_secondBtn setFrame:CGRectMake(_paddingLeft + _pieWidth + sepWidth , (height +sepHeight)/2, width-_paddingLeft-_paddingRight-_pieWidth-sepWidth, msgHeight)];
        [_secondLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
        
    } else if(_displayType == PIE_IN_TOP) {
        _pieWidth = width;
        if(_pieWidth * 3 > height*2) {
            _pieWidth = height*2/3;
        }
        
        titleHeight = [FMUtils heightForStringWith:_titleLbl value:_title andWidth:width-_paddingLeft-_paddingRight];
        [_titleLbl setFrame:CGRectMake(_paddingLeft , originY, width-_paddingLeft-_paddingRight, titleHeight)];
        originY += titleHeight;
        if(originY + _pieWidth + (msgHeight + sepHeight) * 2 > height) {
            _pieWidth = height - (originY  + (msgHeight + sepHeight) * 2);
        }
        
        [_chartView setFrame:CGRectMake((width-_pieWidth)/2, originY, _pieWidth, _pieWidth)];
        originY += _pieWidth;
        
        
        [_firstBtn setFrame:CGRectMake(_paddingLeft , originY, width-_paddingLeft-_paddingRight, msgHeight)];
        [_firstLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
        
        originY += msgHeight + sepHeight;
        
        [_secondBtn setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, msgHeight)];
        [_secondLbl setFrame:CGRectMake(0, 0, _labelWidth, msgHeight)];
        originY += msgHeight + sepHeight;
        
    }
    [_firstBtn defaultStyle];
    [_secondBtn defaultStyle];
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
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:_title];
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
    [_chartView highlightValues:nil];
}

- (void) updateInfo {
    NSInteger count = [_keyArray count];
    _titleLbl.text = _title;
    if(count > 0) {
        [_firstBtn setTitle:[[NSString alloc] initWithFormat:(@"%@:%ld"), _keyArray[0], [_valueArray[0] integerValue]] forState:UIControlStateNormal];
        [_firstLbl setBackgroundColor:_colorArray[0]];
    }
    if(count > 1) {
        [_secondBtn setTitle:[[NSString alloc] initWithFormat:(@"%@:%ld"), _keyArray[1], [_valueArray[1] integerValue]] forState:UIControlStateNormal];
        [_secondLbl setBackgroundColor:_colorArray[1]];
    }
    [self updatePieInfo];
}


- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values
           andDisplayType:(BasePieChartViewDisplayType) displayType {
    
    _title = title;
    _keyArray = keys;
    _valueArray = values;
    _displayType = displayType;
    [self updateViews];
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
