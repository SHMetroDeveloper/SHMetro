//
//  InventoryStorageInEditMaterialBatchTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryMaterialBatchTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSNumber *dueTime;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *amount;

+ (CGFloat)getItemHeight;

@end
