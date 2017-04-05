//
//  ContractStatusBarChartView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/11/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractStatisticsEntity.h"

@interface ContractStatusBarChartView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setContracts:(NSMutableArray <ContractTypeAmount *> *) array;

@end

