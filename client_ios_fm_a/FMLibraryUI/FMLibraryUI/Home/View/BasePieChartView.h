//
//  BasePieChartView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

typedef NS_ENUM (NSInteger, BasePieChartViewDisplayType) {
    PIE_IN_LEFT,
    PIE_IN_RIGHT,
    PIE_IN_TOP
};

@interface BasePieChartView : UIView

- (instancetype) initWithFrame:(CGRect) frame;

- (void) setInfoWithTitle:(NSString *) title
                  andKeys:(NSMutableArray *) keys
                andValues:(NSMutableArray *) values
           andDisplayType:(BasePieChartViewDisplayType) displayType;

@end
