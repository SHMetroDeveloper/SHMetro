//
//  ContractEquipmentTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractEquipmentTableViewCell : UITableViewCell

- (void)setSeperatorGapped:(BOOL)isGapped;

- (void)setEquipmentCode:(NSString *)code;

- (void)setEquipmentName:(NSString *)name;

- (void)setEquipmentLocation:(NSString *)location;

+ (CGFloat)getItemHeight;

@end
