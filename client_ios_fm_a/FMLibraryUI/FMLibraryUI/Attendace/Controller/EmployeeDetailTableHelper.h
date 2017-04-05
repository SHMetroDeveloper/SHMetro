//
//  EmployeeDetailTableHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, EmployeeDetailTableEventType) {
    EMPLOYEE_DETAIL_TABLE_EVENT_TYPE_UNKNOW,
    EMPLOYEE_DETAIL_TABLE_EVENT_DELETE,
};

@interface EmployeeDetailTableHelper : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init;

@property (nonatomic, assign) BOOL isEditable;

- (NSInteger) getEmployeeCount;
- (void) setEmployee:(NSMutableArray *) employee;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
