//
//  InventoryProviderTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryProviderTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL seperatorGapped;

- (void)setInfoWithName:(NSString *) name
                contact:(NSString *) contact
                  phone:(NSString* ) phone
               location:(NSString *) location;

+ (CGFloat)getItemHeight;

@end
