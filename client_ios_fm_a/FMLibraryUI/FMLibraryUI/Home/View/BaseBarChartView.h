//
//  BaseBarChartView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

//颜色类型
typedef NS_ENUM(NSInteger, BaseBarChartColorType) {
    BASE_BAR_CHART_COLOR_ALL_THE_SAME,          //所有的都用同一种颜色
    BASE_BAR_CHART_COLOR_EACH_ONE_DIFFERENT,    //每一个都不一样
    BASE_BAR_CHART_COLOR_SET_SAME,              //每一组数据的颜色都不同
};

//柱状图类型
typedef NS_ENUM(NSInteger, BaseBarChartType) {
    BASE_BAR_CHART_COMMON,          //常用类型
    BASE_BAR_CHART_STACK,           //Stack Bar Chart
};


@interface BaseBarChartView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置信息的标题以及横坐标
- (void) setInfoWithTitle:(NSString *) title andXvalues:(NSMutableArray *) values;

//设置颜色类型
- (void) setColorType:(BaseBarChartColorType)colorType;

//设置图形类型
- (void) setBarType:(BaseBarChartType)barType;

//设置是否显示颜色标签
- (void) setShowColorDesc:(BOOL)showColorDesc;

//设置纵坐标的描述（一般是单位）
- (void) setUnitOfYValue:(NSString *) desc;

//添加一组数据
- (void) addDataArray:(NSMutableArray *) array withDesc:(NSString *) desc;

//供 stack bar Chart 使用
- (void) addStackDataArray:(NSMutableArray *) array withDescArray:(NSMutableArray*) descArray;

//清除历史数据
- (void) clearAllData;

//设置是否显示边框
- (void) setShowBound:(BOOL) showBound;

@end
