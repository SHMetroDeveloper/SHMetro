//
//  AssetPatrolTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetPatrolTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setSeperatorGapped:(BOOL)isGapped;

- (void)setPatrolInfoWith:(NSString *)name
                 finished:(BOOL)finished;

+ (CGFloat)getItemHeight;

@end
