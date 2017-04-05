//
//  SingleBarChartView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleBarChartView : UIView

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
-(void)setFrame:(CGRect)frame;

//设置每月的工单量数据 array里面存的是nsnumber
- (void) setMonthlyWorkOrderCountInfoWith:(NSMutableArray *) array;

+ (CGFloat)calculateHeightByWidth:(CGFloat)width;

@end
