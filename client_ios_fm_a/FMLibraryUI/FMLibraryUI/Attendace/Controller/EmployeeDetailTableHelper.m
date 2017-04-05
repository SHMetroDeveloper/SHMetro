//
//  EmployeeDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "EmployeeDetailTableHelper.h"
#import "AttendanceSettingEmployeeTableViewCell.h"
#import "AttendanceSettingEntity.h"
#import "BaseBundle.h"
//#import "AttendanceEmployeeSettingEntity.h"


@interface EmployeeDetailTableHelper ()
@property (readwrite, nonatomic, strong) NSMutableArray * employeeArray;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation EmployeeDetailTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    _itemHeight = 48;
    _employeeArray = [[NSMutableArray alloc] init];
}

- (void) clearData {
    if(_employeeArray) {
        [_employeeArray removeAllObjects];
    }
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
}

- (void) setEmployee:(NSMutableArray *)employee {
    _employeeArray = employee;
}

- (NSInteger) getEmployeeCount {
    return [_employeeArray count];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_employeeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = _itemHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    if (!cell) {
        AttendanceSettingEmployeeTableViewCell *consumerCell  = [[AttendanceSettingEmployeeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell = consumerCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[AttendanceSettingEmployeeTableViewCell class]]) {
        AttendanceSettingEmployeeTableViewCell *consumerCell = (AttendanceSettingEmployeeTableViewCell *)cell;
        AttendanceConfigurePerson *employee = _employeeArray[position];
        [consumerCell setEmployeeName:employee.name];
        [consumerCell setIsGapped:YES];
        if (position == _employeeArray.count - 1) {
            [consumerCell setIsGapped:NO];
        }
        [consumerCell setWorkTeamName:@""];
        [consumerCell setEmployeeDesc:employee.org];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AttendanceConfigurePerson *employee = weakSelf.employeeArray[indexPath.row];
        NSMutableDictionary *dataDic = [NSMutableDictionary new];
        [dataDic setValue:employee forKeyPath:@"employee"];
        [dataDic setValue:[NSNumber numberWithInteger:indexPath.row] forKeyPath:@"position"];
        [weakSelf notifyDeleteEmployee:dataDic];
    }];
    
    if (_isEditable) {
        return @[deleteAction];
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _isEditable;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

- (void) notifyDeleteEmployee:(NSMutableDictionary *) data {
    [self notifyEvent:EMPLOYEE_DETAIL_TABLE_EVENT_DELETE data:data];
}

- (void) notifyEvent:(EmployeeDetailTableEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

@end

