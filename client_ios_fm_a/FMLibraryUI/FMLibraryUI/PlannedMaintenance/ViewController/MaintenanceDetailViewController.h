//
//  MaintenanceDetailViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"

@interface MaintenanceDetailViewController : BaseViewController

- (instancetype) init;

//设置 ID
- (void) setInfoWithPmId:(NSNumber *) pmId todoId:(NSNumber *) todoId;

@end
