//
//  FMChartView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/10.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMChartView : UIView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
-(void)setFrame:(CGRect)frame;

- (void) setInfoWithDateKeys:(NSMutableArray *)keys;

- (void) setFinishedInfoWithArray:(NSMutableArray *)array;

- (void) setTotalInfoWithArray:(NSMutableArray *)array;

//清除历史数据
- (void) clear;

@end
