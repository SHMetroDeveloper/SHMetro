//
//  AttendanceRecordTableViewCell.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceRecordTableViewCell.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "Masonry.h"
#import "FMFont.h"
#import "BaseBundle.h"

@implementation AttendanceRecordTableViewCell


/**
 自定义Cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat labelHeight = [FMSize getInstance].listItemInfoHeight;
        CGFloat labelPadding = [FMSize getInstance].padding50;
        
        //签到值班员文字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [[BaseBundle getInstance] getStringByKey:@"my_attendance_record_name" inTable:nil];
        _nameLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _nameLabel.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(labelPadding);
            make.top.equalTo(self.contentView.mas_top).offset(labelPadding);
            make.height.equalTo(@(labelHeight));
            make.width.equalTo(@80);
        }];
        
        //签到位置文字
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.text = [[BaseBundle getInstance] getStringByKey:@"my_attendance_record_location" inTable:nil];
        _locationLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _locationLabel.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_nameLabel.mas_left);
            make.top.equalTo(_nameLabel.mas_bottom).offset(labelPadding);
            make.height.equalTo(@(labelHeight));
            make.width.equalTo(@70);
        }];
        
        //签到时间文字
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = [[BaseBundle getInstance] getStringByKey:@"my_attendance_record_time" inTable:nil];
        _timeLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _timeLabel.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_nameLabel.mas_left);
            make.top.equalTo(_locationLabel.mas_bottom).offset(labelPadding);
            make.height.equalTo(@(labelHeight));
            make.width.equalTo(@70);
        }];
        
        //签到值班员
        _name = [[UILabel alloc] init];
        _name.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _name.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_nameLabel.mas_right);
            make.top.equalTo(_nameLabel.mas_top);
            make.height.equalTo(_nameLabel.mas_height);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        //签到位置
        _location = [[UILabel alloc] init];
        _location.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _location.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_location];
        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_locationLabel.mas_right);
            make.top.equalTo(_locationLabel.mas_top);
            make.height.equalTo(_locationLabel.mas_height);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        //签到时间
        _time = [[UILabel alloc] init];
        _time.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _time.font = [FMFont getInstance].font38;
        [self.contentView addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_timeLabel.mas_right);
            make.top.equalTo(_timeLabel.mas_top);
            make.height.equalTo(_timeLabel.mas_height);
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
    return self;
}

@end
