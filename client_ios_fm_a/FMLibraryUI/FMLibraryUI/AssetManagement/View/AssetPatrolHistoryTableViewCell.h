//
//  AssetPatrolHistoryTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/8.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetPatrolRecordEntity.h"

@interface AssetPatrolHistoryTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSeperatorGapped:(BOOL)isGapped;

- (void)setPatrolHistory:(AssetPatrolRecordEntity *) patrolHistory;

+ (CGFloat)getItemHeight;

@end
