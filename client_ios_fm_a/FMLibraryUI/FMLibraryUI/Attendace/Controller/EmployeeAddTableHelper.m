//
//  EmployeeAddTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "EmployeeAddTableHelper.h"
#import "EmployeeAddTableViewCell.h"
#import "AttendanceEmployeeSettingEntity.h"
#import "OnMessageHandleListener.h"
#import "CheckItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "OnItemClickListener.h"
#import "AttendanceDbHelper.h"

@interface EmployeeAddTableHelper () <OnItemClickListener>

@property (nonatomic, strong) NSMutableArray * groups;
@property (nonatomic, strong) NSMutableDictionary * employeeDict;//存储执行人数组，以组 ID 为索引

@property (nonatomic, strong) NSMutableArray * groupSelectArray;
@property (nonatomic, strong) NSMutableDictionary * employeeSelectDict;

@property (nonatomic, strong) NSMutableArray * groupExpandArray;

//@property (nonatomic, assign) BOOL groupNSelect;    //无组人员选中状态
//@property (nonatomic, assign) BOOL groupNExpand;    //无组人员展开状态

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) AttendanceDbHelper *dbHelper;
@property (nonatomic, strong) NSMutableArray *existedEmployeeArray;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation EmployeeAddTableHelper
- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    
    _itemHeight = 48;
//    _groupNSelect = NO;
//    _groupNExpand = NO;
    
    _groups = [[NSMutableArray alloc] init];
    _employeeDict = [[NSMutableDictionary alloc] init];
    
    _groupSelectArray = [[NSMutableArray alloc] init];
    _employeeSelectDict = [[NSMutableDictionary alloc] init];
    
    //把已经存在的员工
    _dbHelper = [AttendanceDbHelper getInstance];
    _existedEmployeeArray = [NSMutableArray new];
    _existedEmployeeArray = [_dbHelper queryAllSignPerson];
    for (AttendanceConfigurePerson *employee in _existedEmployeeArray) {
        NSString * key = [[NSString alloc] initWithFormat:@"%lld", employee.emId.longLongValue];
        [_employeeSelectDict setValue:[NSNumber numberWithBool:YES] forKey:key];
    }
}

- (void) clearData {
    if(_groups) {
        [_groups removeAllObjects];
    }
    if(_employeeDict) {
        [_employeeDict removeAllObjects];
    }
    if(_groupSelectArray) {
        [_groups removeAllObjects];
    }
    if(_employeeSelectDict) {
        [_employeeSelectDict removeAllObjects];
    }
    if(_groupExpandArray) {
        [_groupExpandArray removeAllObjects];
    }
}

- (void) setGroups:(NSMutableArray *)groups {
    _groups = groups;
    
    if(!_groupSelectArray) {
        _groupSelectArray = [[NSMutableArray alloc] init];
    } else {
        [_groupSelectArray removeAllObjects];
    }
    
    if(!_groupExpandArray) {
        _groupExpandArray = [[NSMutableArray alloc] init];
    } else {
        [_groupExpandArray removeAllObjects];
    }
    
    for(id obj in _groups) {
        [_groupSelectArray addObject:[NSNumber numberWithBool:NO]];
        [_groupExpandArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (NSMutableArray *) getGroups {
    return _groups;
}

//获取无组人员数量
- (NSInteger) getEmployeeCountNotInGroup {
    NSInteger count = 0;
    NSArray * employeeArray = [_employeeDict valueForKeyPath:@"null"];
    count = [employeeArray count];
    return count;
}

//设置属于指定组的执行人数组
- (void) setEmployee:(NSMutableArray *) employeeArray forGroup:(NSNumber *) groupId {
    if(groupId) {
        NSString * key = [[NSString alloc] initWithFormat:@"%lld", groupId.longLongValue];
        [_employeeDict setValue:employeeArray forKey:key];
        if([self isGroupSelect:groupId]) {  //如果组处于被选中状态，则更新组员状态
            for(AttendanceConfigurePerson * person in employeeArray) {
                [self setEmployee:person.emId selected:YES];
            }
        }
    } else {    //无组人员
        NSString * key = @"null";
        [_employeeDict setValue:employeeArray forKey:key];
    }
}


//根据section和postion获取employee
- (AttendanceConfigurePerson *) getEmployeeBySection:(NSInteger) section position:(NSInteger) position {
    AttendanceConfigurePerson * employee;
    if(section >= 0 && section < [_groups count]) {
        AttendanceEmployeeWorkTeamEntity *group = _groups[section];
        if(group) {
            NSMutableArray * array = [self getEmployeeByGroup:group.wtId];
            if(position >= 0 && position < [array count]) {
                employee = array[position];
            }
        }
    }
    return employee;
}

//根据组获取员工
- (NSMutableArray *) getEmployeeByGroup:(NSNumber *) groupId {
    NSMutableArray * array;
    if(groupId) {
        NSString * key = [[NSString alloc] initWithFormat:@"%lld", groupId.longLongValue];
        array = [_employeeDict valueForKey:key];
    }
    return array;
}

//组是否被选中
- (BOOL) isGroupSelect:(NSNumber *) groupId {
    BOOL res = NO;
    if(groupId) {
        NSInteger index = 0;
        NSNumber * tmpNumber;
        for(AttendanceEmployeeWorkTeamEntity * group in _groups) {
            if([group.wtId isEqualToNumber:groupId]) {
                tmpNumber = _groupSelectArray[index];
                res = [tmpNumber boolValue];
                break;
            }
            index++;
        }
    }
    return res;
}

//判断是否存在
- (BOOL) isEmployeeSelected:(NSNumber *) emId {
    BOOL res = NO;
    if(emId) {
        NSString *key = [[NSString alloc] initWithFormat:@"%lld", emId.longLongValue];
        NSNumber *tmp = [_employeeSelectDict valueForKey:key];
        res = tmp.boolValue;
    }
    return res;
}

//将指定人员设置为选中
- (void) setEmployee:(NSNumber *) emId selected:(BOOL) selected {
    if(emId) {
        NSString * key = [[NSString alloc] initWithFormat:@"%lld", emId.longLongValue];
        [_employeeSelectDict setValue:[NSNumber numberWithBool:selected] forKey:key];
    }
}

- (NSMutableArray *) getSelectedEmployeeArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSMutableDictionary * filterDict = [[NSMutableDictionary alloc] init];
    NSNumber * selected = [NSNumber numberWithBool:YES];
    for(NSString * wtKey in _employeeDict) {
        NSArray * emplyeeArray = [_employeeDict valueForKeyPath:wtKey];
        for(AttendanceConfigurePerson * employee in emplyeeArray) {
            if([self isEmployeeSelected:employee.emId]) {
                NSString *key = [[NSString alloc] initWithFormat:@"%lld", employee.emId.longLongValue];
                if(![filterDict valueForKeyPath:key]) {
                    [array addObject:employee];
                    [filterDict setObject:selected forKey:key];
                }
            }
        }
    }
    return array;
}

//获取工作组实体
- (AttendanceEmployeeWorkTeamEntity *) getGroupBySection:(NSInteger) section {
    AttendanceEmployeeWorkTeamEntity * group;
    if(section >= 0 && section < [_groups count]) {
        group = _groups[section];
    }
    return group;
}

- (void) updateSelectStatusOfEmployeeBySection:(NSInteger) section position:(NSInteger) position {
    AttendanceConfigurePerson * employee = [self getEmployeeBySection:section position:position];
    
    if([self isEmployeeSelected:employee.emId]) {
        [self setEmployee:employee.emId selected:NO];
    } else {
        [self setEmployee:employee.emId selected:YES];
    }
    
}

//依据组的状态使其与组员状态保持一致
- (BOOL) updateSelectStatusOfGroupIndex:(NSInteger) section {
    BOOL changed = NO;
    AttendanceEmployeeWorkTeamEntity * group = [self getGroupBySection:section];
    NSMutableArray * array = [self getEmployeeByGroup:group.wtId];
    BOOL select = YES;
    for(AttendanceConfigurePerson * employee in array) {
        if(![self isEmployeeSelected:employee.emId]) {
            select = NO;
            break;
        }
    }
    NSNumber * tmp = _groupSelectArray[section];
    if(tmp.boolValue != select) {
        _groupSelectArray[section] = [NSNumber numberWithBool:select];
        changed = YES;
    }
    return changed;
}

//更新组员状态，使其跟组状态保持一致
- (void) updateSelectStatusOfEmployeeByGroupIndex:(NSInteger) section {
    AttendanceEmployeeWorkTeamEntity * group = _groups[section];
    NSNumber * tmp = _groupSelectArray[section];
    NSMutableArray * array = [self getEmployeeByGroup:group.wtId];
    for(AttendanceConfigurePerson * employee in array) {
        [self setEmployee:employee.emId selected:tmp.boolValue];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger count = [_groups count];
    return count;
}


- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(section >= 0 && section < [_groups count]) {
        AttendanceEmployeeWorkTeamEntity * group = [self getGroupBySection:section];
        NSNumber * expand = _groupExpandArray[section];
        if(expand.boolValue) {
            NSMutableArray * employee = [self getEmployeeByGroup:group.wtId];
            count = [employee count];
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIdentifier = @"Cell";
    
    EmployeeAddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[EmployeeAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(cell) {
        AttendanceConfigurePerson *employee = [self getEmployeeBySection:section position:position];
        cell.tag = position;
        [cell setEmployeeName:employee.name];
        [cell setChecked:[self isEmployeeSelected:employee.emId]];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = [FMSize getInstance].listHeaderHeight;
    return headerHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat headerHeight = [FMSize getInstance].listHeaderHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    NSNumber * expand = _groupExpandArray[section];
    AttendanceEmployeeWorkTeamEntity * group = [self getGroupBySection:section];
    
    CheckItemView * headerView = [[CheckItemView alloc] initWithFrame:CGRectMake(0, 0, width, headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [headerView setOnItemClickListener:self];
    [headerView setShowRightImage:YES];
    if(expand.boolValue) {
        [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
    } else {
        [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
    }
    [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
    if(group) {
        NSNumber * tmp = _groupSelectArray[section];
        NSString * desc = [[NSString alloc] initWithFormat:@"%ld人", group.count];
        [headerView setChecked:tmp.boolValue];
        [headerView setInfoWithName:group.name desc:desc];
    }
    
    SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, headerHeight-seperatorHeight, width-padding*2, seperatorHeight)];
    [headerView addSubview:seperator];
    headerView.tag = section;
    
    return headerView;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    [self updateSelectStatusOfEmployeeBySection:section position:position];
    [self updateSelectStatusOfGroupIndex:section];
    [self notifyNeedUpdate];
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[CheckItemView class]]) {
        NSInteger section = view.tag;
        NSNumber * tmp;
        if(subView) {
            CheckableItemEventType type = subView.tag;
            switch(type) {
                case CHECKABLE_ITEM_EVENT_TYPE_RIGHT_CLICK:
                    tmp = _groupExpandArray[section];
                    _groupExpandArray[section] = [NSNumber numberWithBool:!tmp.boolValue];
                    if(!tmp.boolValue) {
                        [self notifyShowEmployee:section];
                    } else {
                        [self notifyNeedUpdate];
                    }
                    break;
                    
                case CHECKABLE_ITEM_EVENT_TYPE_CHECK_UPDATE:
                    tmp = _groupSelectArray[section];
                    _groupSelectArray[section] = [NSNumber numberWithBool:!tmp.boolValue];
                    [self updateSelectStatusOfEmployeeByGroupIndex:section];
                    [self notifyNeedUpdate];
                    break;
                default:
                    break;
            }
        } else {
            tmp = _groupSelectArray[section];
            _groupSelectArray[section] = [NSNumber numberWithBool:!tmp.boolValue];
            [self updateSelectStatusOfEmployeeByGroupIndex:section];
            [self notifyNeedUpdate];
        }
    }
}


#pragma mark - Notification
- (void) notifyNeedUpdate {
    [self notifyEvent:EMPLOYEE_ADD_TABLE_EVENT_CHECK_UPDATE data:nil];
}

- (void) notifyShowEmployee:(NSInteger) groupIndex {
    AttendanceEmployeeWorkTeamEntity * group = [self getGroupBySection:groupIndex];
    [self notifyEvent:EMPLOYEE_ADD_TABLE_EVENT_SHOW_EMPLOYEE data:group];
}

- (void) notifyEvent:(EmployeeAddTableEventType) type data:(id) data {
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

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

@end
