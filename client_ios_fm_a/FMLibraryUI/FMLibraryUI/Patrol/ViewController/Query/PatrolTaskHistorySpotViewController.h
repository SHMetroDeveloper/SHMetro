//
//  PatrolTaskHistorySpotViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检历史记录---点位详情

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "PatrolTaskEntity.h"
#import "OnListItemButtonClickListener.h"
#import "CustomAlertView.h"
#import "WorkOrderHistoryEntity.h"

@interface PatrolTaskHistorySpotViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, OnListItemButtonClickListener, CustomAlertViewDelegate>
- (instancetype) init;
- (void) setSpotName:(NSString *) spotName
        andEquipment:(Equipment *) equip
           andDevice:(NSMutableArray*) devices
        andWorkOrder:(WorkOrderHistory *) workOrder;
@end
