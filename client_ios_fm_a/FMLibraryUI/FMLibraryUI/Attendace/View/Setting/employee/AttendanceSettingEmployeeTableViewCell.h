//
//  AttendanceSettingEmployeeTableViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceSettingEmployeeTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, strong) NSString *employeeName;
@property (nonatomic, strong) NSString *workTeamName;
@property (nonatomic, strong) NSString *employeeDesc;

+ (CGFloat) calculateHeight;
@end
