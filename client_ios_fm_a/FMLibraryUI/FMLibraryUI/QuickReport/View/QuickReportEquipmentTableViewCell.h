//
//  QuickReportEquipmentTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickReportEquipmentTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void) setSeperatorGapped:(BOOL) isGapped;

- (void) setShowLocation:(BOOL)showLocation;

- (void) setInfoWithCode:(NSString *) code
                    name:(NSString *) name
                location:(NSString *) location;

+ (CGFloat) getItemHeightByShowLocation:(BOOL) show;

@end
