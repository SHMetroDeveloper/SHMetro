//
//  WorkOrderDetailEquipmentViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/14.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"

@interface WorkOrderDetailEquipmentViewController : BaseViewController

- (instancetype) init;

- (void) setWoId:(NSNumber *)woId;
- (void) setEquipments:(NSMutableArray *)equipments;
- (void) setEditable:(BOOL)editable;
@end
