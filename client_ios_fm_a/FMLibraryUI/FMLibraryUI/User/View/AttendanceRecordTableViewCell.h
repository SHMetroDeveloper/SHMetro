//
//  AttendanceRecordTableViewCell.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceRecordTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel; //签到值班员文字
@property (nonatomic,strong) UILabel *locationLabel; //签到位置文字
@property (nonatomic,strong) UILabel *timeLabel; //签到时间文字

@property (nonatomic,strong) UILabel *name; //签到值班员
@property (nonatomic,strong) UILabel *location; //签到位置
@property (nonatomic,strong) UILabel *time; //签到时间

@end
