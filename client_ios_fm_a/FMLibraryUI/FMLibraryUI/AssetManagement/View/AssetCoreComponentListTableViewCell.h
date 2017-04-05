//
//  AssetCoreComponentTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCoreComponentListTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSeperatorGapped:(BOOL)isGapped;

- (void)setEquipmentCode:(NSString *)code
                 andName:(NSString *)name;

+ (CGFloat)getItemHeight;

@end
