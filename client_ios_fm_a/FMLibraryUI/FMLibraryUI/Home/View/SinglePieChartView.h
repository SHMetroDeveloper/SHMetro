//
//  SinglePieChartView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>


@interface SinglePieChartView : UIView

- (instancetype) initWithFrame:(CGRect) frame;

- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values;

- (void) setColorArray:(NSMutableArray *)colorArray;

@end

