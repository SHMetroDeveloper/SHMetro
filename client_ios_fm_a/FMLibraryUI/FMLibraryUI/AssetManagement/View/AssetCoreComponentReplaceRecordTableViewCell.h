//
//  AssetCoreComponentReplaceRecordTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/7.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetCoreComponentDetailEntity.h"

@interface AssetCoreComponentReplaceRecordTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSeperatorGapped:(BOOL) isGapped;

- (void)setCoreReplaced:(BOOL)replaced;

- (void)setCoreComponentReplaceHistory:(AssetCoreComponentReplaceRecord *) replaceRecord;

+ (CGFloat)getItemHeight;

@end
