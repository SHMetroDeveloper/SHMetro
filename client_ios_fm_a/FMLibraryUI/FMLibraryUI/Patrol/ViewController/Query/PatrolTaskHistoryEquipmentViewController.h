//
//  PatrolTaskHistoryEquipmentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PatrolTaskHistoryEntity.h"
#import "OnItemClickListener.h"

@interface PatrolTaskHistoryEquipmentViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, OnItemClickListener>

- (instancetype) init;
- (void) setInfoWithEquipment:(PatrolTaskHistoryEquipment *) equip andLocation:(Position *) location;

@end
