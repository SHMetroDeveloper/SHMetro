//
//  InventoryStorageInTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InventoryStorageInTableViewCell.h"

typedef void(^HeaderActionBlock)();
typedef void(^MaterialEditActionBlock)(NSNumber *inventoryId);
typedef void(^MaterialDeleteActionBlock)(NSNumber *position);

@interface InventoryStorageInTableView : UITableView

- (void)setWareHouseName:(NSString *) name;

@property (nonatomic, assign) TableViewType tableViewType;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) HeaderActionBlock actionBlock;
@property (nonatomic, copy) MaterialEditActionBlock editBlock;
@property (nonatomic, copy) MaterialDeleteActionBlock deleteBlock;

- (void) setAmount:(NSNumber *)amount forMaterial:(NSNumber *)inventoryId;
@end
