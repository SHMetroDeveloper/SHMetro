//
//  MissionListViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EnergyTaskDetailViewController : BaseViewController

- (instancetype)init;

- (void) setInfoWithTitle:(NSString *) title;
- (void) setInfoWithArray:(NSArray *) meters andMeterReadingId:(NSNumber *) meterReadingId;
@end
