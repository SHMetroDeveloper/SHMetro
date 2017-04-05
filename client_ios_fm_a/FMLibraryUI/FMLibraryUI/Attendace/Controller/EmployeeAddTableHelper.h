//
//  EmployeeAddTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, EmployeeAddTableEventType) {
    EMPLOYEE_ADD_TABLE_EVENT_TYPE_UNKNOW,
    EMPLOYEE_ADD_TABLE_EVENT_SHOW_EMPLOYEE, //查看 employee
    EMPLOYEE_ADD_TABLE_EVENT_CHECK_UPDATE,  //选择更新
};

@interface EmployeeAddTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

- (void) setGroups:(NSMutableArray *)groups;
- (void) setEmployee:(NSMutableArray *) employeeArray forGroup:(NSNumber *) groupId;

//获取工作组信息
- (NSMutableArray *) getGroups;

//获取组内执行人
- (NSMutableArray *) getEmployeeByGroup:(NSNumber *) groupId;

//获取所选择的执行人
- (NSMutableArray *) getSelectedEmployeeArray;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
