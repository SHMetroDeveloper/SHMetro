//
//  LineChartView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@interface SingleLineChartView : UIView

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

-(void)setFrame:(CGRect)frame;

//给表赋值，allArray里面存7天内每天的所有表单数量 finishedArray里面存7天内每天完成的表单数量（用nsnumber）
- (void) setChartDataWithAllInfo:(NSMutableArray *) allArray andFinishedInfo:(NSMutableArray *) finisheedArray;

+ (CGFloat)calculateHeightByWidth:(CGFloat)width;

@end
