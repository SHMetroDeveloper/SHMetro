//
//  InventoryWarehouseTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryWarehouseQueryTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;

- (void)setInfoWithName:(NSString *) name
                contact:(NSString *) contact
               location:(NSString *) location
                   type:(NSString *) type
                 amount:(NSString *) amount;

+ (CGFloat)getItemHeight;

@end
