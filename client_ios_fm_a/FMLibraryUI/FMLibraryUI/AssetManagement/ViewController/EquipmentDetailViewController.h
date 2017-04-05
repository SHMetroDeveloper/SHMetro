//
//  EquipmentDetailViewController.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PullTableView.h"

@interface EquipmentDetailViewController : BaseViewController <PullTableViewDelegate>

- (instancetype)initWithEquipmentID:(NSNumber * ) equID;

- (void) setUuid:(NSString *)uuid;

- (void) setEditable:(BOOL)editable;

@end
