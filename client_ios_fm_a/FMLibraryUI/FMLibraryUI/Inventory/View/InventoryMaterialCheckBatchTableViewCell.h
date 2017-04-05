//
//  InventoryMaterialCountBatchTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/2.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryMaterialCheckBatchTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;
@property (nonatomic, assign) BOOL isChecked;

- (void)setInfoWithProvider:(NSString *) provider
                      price:(NSString *) price
            inventoryNumber:(NSNumber *) inventoryNumber
                checkNumber:(NSNumber *) checknumber
              storageInTime:(NSNumber *) storageInTime
                    dueTime:(NSNumber *) dueTime;

+ (CGFloat)getItemHeight;

@end
