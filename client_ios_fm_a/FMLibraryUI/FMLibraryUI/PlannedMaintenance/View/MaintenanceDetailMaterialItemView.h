//
//  MaintenanceDetailMaterialItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintenanceDetailMaterialModel.h"

@interface MaintenanceDetailMaterialItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(MaintenanceDetailMaterialModel *) model;

@end
