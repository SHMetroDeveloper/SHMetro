//
//  AttendanceRecordTableHelper.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/14.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttendanceRecordTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *attendanceRecordList;

- (instancetype)init;

@end
