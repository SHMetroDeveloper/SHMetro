//
//  AttendanceSettingItemTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceSettingItemTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) UIColor *descriptionColor;

@property (nonatomic, assign) BOOL isSeperatorDotted;
@property (nonatomic, assign) BOOL isAlternated;

+ (CGFloat) calculateHeight;

@end
