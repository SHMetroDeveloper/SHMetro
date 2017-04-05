//
//  BaseLineChartView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface BaseLineChartView : UIView

- (instancetype) initWithFrame:(CGRect) frame;

- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values;

- (void) setInfoWithTitle:(NSString *)title andKeys:(NSMutableArray *)keys;

- (void) addDataArray:(NSMutableArray *) array desc:(NSString *) desc;

//清除历史数据
- (void) clear;

- (void) setShowColorDesc:(BOOL)showColorDesc;

//设置是否显示曲线
- (void) setShowCubic:(BOOL)showCubic;

//设置是否填充 X 轴
- (void) setShowFilled:(BOOL)showFilled;

- (void) setShowBound:(BOOL) showBound;

@end

