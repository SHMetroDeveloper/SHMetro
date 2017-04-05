//
//  AttendanceSettingView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingView.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"


#import "AttendanceSettingHeaderTableViewCell.h"
#import "AttendanceSettingItemTableViewCell.h"
#import "AttendanceSettingLocationTableViewCell.h"
#import "AttendanceSettingShowMoreTableViewCell.h"

typedef NS_ENUM(NSInteger, AttendanceSettingSectionType) {
    ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE,   //签到人员
    ATTENDANCE_SETTING_SECTION_TYPE_LOCATION,   //签到地理位置
    ATTENDANCE_SETTING_SECTION_TYPE_WIFI,       //签到WiFi
    ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH,  //签到蓝牙
};


@interface AttendanceSettingView () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger maxShowCount;   //允许显示数据（人员，wifi，蓝牙，位置）的最大条数

@end

@implementation AttendanceSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxShowCount = 2;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _maxShowCount = 2;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    }
    return self;
}

//判断是否为显示更多
- (BOOL) isShowMoreCell:(NSInteger) section position:(NSInteger) position {
    BOOL res = NO;
    NSInteger count = 1;
    AttendanceSettingSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
            if(_maxShowCount > 0 && _settingDetail.person.count > _maxShowCount) {
                count += _maxShowCount;
                if(position == count) {
                    res = YES;
                }
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
            if(_maxShowCount > 0 && _settingDetail.gps.locations.count > _maxShowCount) {
                count += _maxShowCount;
                if(position == count) {
                    res = YES;
                }
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
            if(_maxShowCount > 0 && _settingDetail.wifi.count > _maxShowCount) {
                count += _maxShowCount;
                if(position == count) {
                    res = YES;
                }
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
            if(_maxShowCount > 0 && _settingDetail.bluetooth.count > _maxShowCount) {
                count += _maxShowCount;
                if(position == count) {
                    res = YES;
                }
            }
            break;
    }
    return res;
}

#pragma mark - Setter
- (void)setSettingDetail:(AttendanceSettingDetail *) settingDetail {
    _settingDetail = settingDetail;
    [self reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (AttendanceSettingSectionType) getSectionType:(NSInteger) section {
    AttendanceSettingSectionType sectionType = ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE;
    switch (section) {
        case 0:
            sectionType = ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE;
            break;
            
        case 1:
            sectionType = ATTENDANCE_SETTING_SECTION_TYPE_LOCATION;
            break;
            
        case 2:
            sectionType = ATTENDANCE_SETTING_SECTION_TYPE_WIFI;
            break;
            
        case 3:
            sectionType = ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH;
            break;
    }
    return sectionType;
}

- (NSInteger) getRowCountBySection:(NSInteger) section {
    NSInteger count = 0;
    AttendanceSettingSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
            count = _settingDetail.person.count;
            if(_maxShowCount > 0 && count > _maxShowCount) {
                count = _maxShowCount;
                count += 1; //show More
            }
            count += 1; //header
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
            if(_settingDetail.gps && _settingDetail.gps.locations) {
                count = _settingDetail.gps.locations.count;
                if(_maxShowCount > 0 && count > _maxShowCount) {
                    count = _maxShowCount;
                    count += 1; //show More
                }
            }
            count += 1; //header
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
            if(_settingDetail.wifi) {
                count = _settingDetail.wifi.count;
                if(_maxShowCount > 0 && count > _maxShowCount) {
                    count = _maxShowCount;
                    count += 1; //show More
                }
            }
            count += 1; //header
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
            if(_settingDetail.bluetooth) {
                count += _settingDetail.bluetooth.count;
                if(_maxShowCount > 0 && count > _maxShowCount) {
                    count = _maxShowCount;
                    count += 1; //show More
                }
            }
            count += 1; //header
            break;
    }
    return count;
}

//判断cell的分割线样式
- (NSMutableDictionary *) getConsumerCellSeperatorStyle:(NSMutableArray *) dataArray andCellPosition:(NSInteger) position {
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    NSNumber *isDotted = [NSNumber numberWithBool:NO];
    NSNumber *isGapped = [NSNumber numberWithBool:NO];
    if (dataArray.count == 1) {
        isDotted = [NSNumber numberWithBool:NO];
        isGapped = [NSNumber numberWithBool:NO];
    } else if (dataArray.count == 2) {
        if (position == 1) {
            isDotted = [NSNumber numberWithBool:YES];
            isGapped = [NSNumber numberWithBool:YES];
        } else {
            isDotted = [NSNumber numberWithBool:NO];
            isGapped = [NSNumber numberWithBool:NO];
        }
    } else if (dataArray.count > 2) {
        if (position == 1) {
            isDotted = [NSNumber numberWithBool:YES];
            isGapped = [NSNumber numberWithBool:YES];
        } else {
            isDotted = [NSNumber numberWithBool:NO];
            isGapped = [NSNumber numberWithBool:YES];
        }
    }
    [resultDic setValue:isDotted forKeyPath:@"isDotted"];
    [resultDic setValue:isGapped forKeyPath:@"isGapped"];
    
    return resultDic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count = [self getRowCountBySection:section];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    if (position == 0) {
        height = [AttendanceSettingHeaderTableViewCell calculateHeight];
    } else if([self isShowMoreCell:section position:position]) {   //显示更多
        height = [AttendanceSettingShowMoreTableViewCell calculateHeight];
    } else {
        AttendanceSettingSectionType sectionType = [self getSectionType:section];
        switch (sectionType) {
            case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
                height = [AttendanceSettingItemTableViewCell calculateHeight];
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
                height = [AttendanceSettingLocationTableViewCell calculateHeight];
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
                height = [AttendanceSettingItemTableViewCell calculateHeight];
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
                height = [AttendanceSettingItemTableViewCell calculateHeight];
                break;
        }
    }
    
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0001;
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 15;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    
    
    if (position == 0) {    //header
        cellIdentifier = @"CellSettingHeader";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        AttendanceSettingHeaderTableViewCell *consumerCell = (AttendanceSettingHeaderTableViewCell *)cell;
        if (!cell) {
            consumerCell = [[AttendanceSettingHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            consumerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        AttendanceSettingSectionType sectionType = [self getSectionType:section];
        __weak typeof(self) weakSelf = self;
        switch (sectionType) {
            case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:{
                consumerCell.actionBlock = ^(){
                    weakSelf.actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_EDIT);
                };
            }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
            {
                consumerCell.actionBlock = ^(){
                    weakSelf.actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_EDIT);
                };
            }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
            {
                consumerCell.actionBlock = ^(){
                    weakSelf.actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_WIFI_EDIT);
                };
            }
                
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
            {
                consumerCell.actionBlock = ^(){
                    weakSelf.actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_EDIT);
                };
            }
                break;
        }
        cell = consumerCell;
    } else if([self isShowMoreCell:section position:position]) {   //显示更多
        cellIdentifier = @"CellShowMore";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            AttendanceSettingShowMoreTableViewCell *consumerCell = [[AttendanceSettingShowMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            consumerCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell = consumerCell;
        }
    } else {
        AttendanceSettingSectionType sectionType = [self getSectionType:section];
        switch (sectionType) {
            case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
                cellIdentifier = @"CellSettingEmployee";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    AttendanceSettingItemTableViewCell *consumerCell = [[AttendanceSettingItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    consumerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = consumerCell;
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
                cellIdentifier = @"CellSettingLocation";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    AttendanceSettingLocationTableViewCell *consumerCell = [[AttendanceSettingLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    consumerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = consumerCell;
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
                cellIdentifier = @"CellSettingWiFi";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    AttendanceSettingItemTableViewCell *consumerCell = [[AttendanceSettingItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    consumerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = consumerCell;
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
                cellIdentifier = @"CellSettingBluetooth";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    AttendanceSettingItemTableViewCell *consumerCell = [[AttendanceSettingItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    consumerCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = consumerCell;
                    cell.backgroundColor = [UIColor blueColor];
                }
                break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    if([self isShowMoreCell:section position:position]) {   //显示更多
        
    } else {
        AttendanceSettingSectionType sectionType = [self getSectionType:section];
        switch (sectionType) {
            case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
                if(position == 0) {
                    AttendanceSettingHeaderTableViewCell *consumerCell = (AttendanceSettingHeaderTableViewCell *)cell;
                    [consumerCell.textLabel setText:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_employee_title" inTable:nil],_settingDetail.person.count]];
                } else {
                    AttendanceConfigurePerson *person = _settingDetail.person[position - 1];
                    AttendanceSettingItemTableViewCell *consumerCell = (AttendanceSettingItemTableViewCell *)cell;
                    
                    NSMutableDictionary *seperatorStyle = [self getConsumerCellSeperatorStyle:_settingDetail.person andCellPosition:position];
                    NSNumber *isDotted = [seperatorStyle valueForKeyPath:@"isDotted"];
                    NSNumber *isGapped = [seperatorStyle valueForKeyPath:@"isGapped"];
                    [consumerCell setIsSeperatorDotted:isDotted.boolValue];
                    [consumerCell setIsAlternated:isGapped.boolValue];
                    
                    [consumerCell setDescriptionColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]];
                    [consumerCell setName:person.name];
                    [consumerCell setDesc:person.org];
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
                if(position == 0) {
                    AttendanceSettingHeaderTableViewCell *consumerCell = (AttendanceSettingHeaderTableViewCell *)cell;
                    [consumerCell.textLabel setText:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_title" inTable:nil]];
                } else {
                    AttendanceLocation *location = _settingDetail.gps.locations[position - 1];
                    AttendanceSettingLocationTableViewCell *consumerCell = (AttendanceSettingLocationTableViewCell *)cell;
                    
                    NSMutableDictionary *seperatorStyle = [self getConsumerCellSeperatorStyle:_settingDetail.gps.locations andCellPosition:position];
                    NSNumber *isDotted = [seperatorStyle valueForKeyPath:@"isDotted"];
                    NSNumber *isGapped = [seperatorStyle valueForKeyPath:@"isGapped"];
                    [consumerCell setIsSeperatorDotted:isDotted.boolValue];
                    [consumerCell setIsGapped:isGapped.boolValue];
                    
                    [consumerCell setIsShowState:NO];
                    [consumerCell setEnable:location.enable];
                    [consumerCell setLocationName:location.name];
                    [consumerCell setLocationDesc:location.desc];
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
                if(position == 0) {
                    AttendanceSettingHeaderTableViewCell *consumerCell = (AttendanceSettingHeaderTableViewCell *)cell;
                    [consumerCell.textLabel setText:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_wifi_title" inTable:nil]];
                } else {
                    AttendanceConfigureWiFi *wifiEntity = nil;
                    wifiEntity = _settingDetail.wifi[position - 1];
                    AttendanceSettingItemTableViewCell *consumerCell = (AttendanceSettingItemTableViewCell *)cell;
                    
                    NSMutableDictionary *seperatorStyle = [self getConsumerCellSeperatorStyle:_settingDetail.wifi andCellPosition:position];
                    NSNumber *isDotted = [seperatorStyle valueForKeyPath:@"isDotted"];
                    NSNumber *isGapped = [seperatorStyle valueForKeyPath:@"isGapped"];
                    [consumerCell setIsSeperatorDotted:isDotted.boolValue];
                    [consumerCell setIsAlternated:isGapped.boolValue];
                    
                    [consumerCell setDescriptionColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
                    [consumerCell setName:wifiEntity.name];
                    [consumerCell setDesc:wifiEntity.mac];
                    
                }
                break;
                
            case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
                if(position == 0) {
                    AttendanceSettingHeaderTableViewCell *consumerCell = (AttendanceSettingHeaderTableViewCell *)cell;
                    [consumerCell.textLabel setText:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_bluetooth_title" inTable:nil]];
                } else {
                    AttendanceConfigureBluetooth *bluetoothEntity = _settingDetail.bluetooth[position - 1];
                    AttendanceSettingItemTableViewCell *consumerCell = (AttendanceSettingItemTableViewCell *)cell;
                    
                    NSMutableDictionary *seperatorStyle = [self getConsumerCellSeperatorStyle:_settingDetail.bluetooth andCellPosition:position];
                    NSNumber *isDotted = [seperatorStyle valueForKeyPath:@"isDotted"];
                    NSNumber *isGapped = [seperatorStyle valueForKeyPath:@"isGapped"];
                    [consumerCell setIsSeperatorDotted:isDotted.boolValue];
                    [consumerCell setIsAlternated:isGapped.boolValue];
                    
                    [consumerCell setDescriptionColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
                    [consumerCell setName:bluetoothEntity.name];
                    [consumerCell setDesc:bluetoothEntity.mac];
                }
                break;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    AttendanceSettingSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case ATTENDANCE_SETTING_SECTION_TYPE_EMPLOYEE:
            if([self isShowMoreCell:section position:position]) {
                _actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_EMPLOYEE_DETAIL);
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_LOCATION:
            if([self isShowMoreCell:section position:position]) {
                _actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_LOCATION_DETAIL);
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_WIFI:
            if([self isShowMoreCell:section position:position]) {
                _actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_WIFI_DETAIL);
            }
            break;
            
        case ATTENDANCE_SETTING_SECTION_TYPE_BLUETOOTH:
            if([self isShowMoreCell:section position:position]) {
                _actionBlock(ATTENDANCE_SETTING_ACTION_TYPE_BLUETOOTH_DETAIL);
            }
            break;
    }
}

@end

