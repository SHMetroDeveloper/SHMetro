//
//  AssetCoreComponentDetailBaseInfoTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetCoreComponentDetailEntity.h"

@interface AssetCoreComponentDetailBaseInfoTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCoreComponentDetail:(AssetCoreComponentDetailEntity *) coreComponentDetail;

+ (CGFloat)getItemHeight;

@end

