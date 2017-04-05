//
//  AttendanceRecordTableHelper.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceRecordTableHelper.h"
#import "AttendanceRecordTableViewCell.h"
#import "AttendanceRecordEntity.h"
#import "FMSize.h"
#import "FMUtils.h"

@implementation AttendanceRecordTableHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _attendanceRecordList = [NSMutableArray array];
    }
    return self;
}


#pragma mark - UITableView的代理方法

/**
 *  设置表格行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _attendanceRecordList.count;
}


/**
 *  设置表格行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [FMSize getInstance].listItemInfoHeight * 3 + [FMSize getInstance].padding50 * 4;
}


/**
 *  设置表格内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //注册单元格
    AttendanceRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil) {
        
        cell = [[AttendanceRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置单元格内容
    AttendanceRecordEntity *attendanceRecord = _attendanceRecordList[indexPath.row];
    cell.name.text = attendanceRecord.contactName;
    cell.location.text = attendanceRecord.locationName;
    cell.time.text = [FMUtils timeLongToDateString:attendanceRecord.createTime];
    
    return cell;
}

@end
