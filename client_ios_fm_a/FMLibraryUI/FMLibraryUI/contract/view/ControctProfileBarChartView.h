//
//  ControctProfileBarChartView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControctProfileBarChartView : UICollectionReusableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setContractStatistics:(NSMutableArray <NSNumber *> *) array;

@end
