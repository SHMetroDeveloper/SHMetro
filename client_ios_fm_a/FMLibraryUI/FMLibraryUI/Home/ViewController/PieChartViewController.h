//
//  PieChartViewController.h
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 17/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "BaseViewController.h"
#import <Charts/Charts.h>
#import "OnClickListener.h"

@interface PieChartViewController : BaseViewController<OnClickListener>

- (instancetype) init;
//- (instancetype) initWithVcType:(BaseVcType)vcType param:(NSDictionary *)param;

@end
