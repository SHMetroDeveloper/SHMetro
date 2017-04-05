//
//  AttendanceEmployeeAddViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceEmployeeAddViewController.h"
#import "FMColor.h"
#import "EmployeeAddTableHelper.h"
#import "AttendanceBusiness.h"
#import "AttendanceEmployeeSettingEntity.h"
#import "AttendanceDbHelper.h"
#import "BaseBundle.h"
@interface AttendanceEmployeeAddViewController () <OnMessageHandleListener>

@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UITableView * employeeTableView;

@property (nonatomic, strong) EmployeeAddTableHelper * helper;
@property (nonatomic, strong) AttendanceBusiness * business;

@property (nonatomic, strong) NSMutableArray * employeeArray;

@property (nonatomic, strong) AttendanceDbHelper *dbHelper;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;


@end

@implementation AttendanceEmployeeAddViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_employee_add" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self saveSelectedEmployee];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self requestGroups];   //请求工作组列表
    [self requestEmployeeForGroup:nil];//请求无组人员
}

- (void) initLayout {
    if(!_mainContainerView) {
        _helper = [[EmployeeAddTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        _business = [[AttendanceBusiness alloc] init];
        
        _dbHelper = [AttendanceDbHelper getInstance];
        
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [FMColor getInstance].mainBackground;
        
        _employeeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, realWidth, realHeight)];
        _employeeTableView.delaysContentTouches = NO;
        _employeeTableView.backgroundColor = [FMColor getInstance].mainWhite;
        _employeeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _employeeTableView.dataSource = _helper;
        _employeeTableView.delegate = _helper;
        
        [_mainContainerView addSubview:_employeeTableView];
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateList {
    [_employeeTableView reloadData];
}

//请求工作组
- (void) requestGroups {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business getGroupsSuccess:^(NSInteger key, id object) {
        NSMutableArray * groups = object;
        [weakSelf.helper setGroups:groups];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

//请求工作组下的人员
- (void) requestEmployeeForGroup:(NSNumber *) groupId {
    __weak typeof(self) weakSelf = self;
    [_business getEmployeeofGroup:groupId success:^(NSInteger key, id object) {
        NSMutableArray * employeeArray  = object;
        [weakSelf.helper setEmployee:employeeArray forGroup:groupId];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

//请求上传执行人
- (void) requestSaveSelectedEmployee {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(AttendanceConfigurePerson * employee in _employeeArray) {
        [array addObject:employee.emId];
    }
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfEmployee:array type:ATTENDANCE_OPERATE_EMPLOYEE_TYPE_ADD success:^(NSInteger key, id object) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_employee_add_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf handleResult];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_employee_add_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) saveSelectedEmployee {
    if (!_employeeArray) {
        _employeeArray = [NSMutableArray new];
    }
    NSMutableArray *existedEmployeeArray = [_dbHelper queryAllSignPerson];
    NSMutableArray *selectedEmployeeArray = [_helper getSelectedEmployeeArray];
    //过滤已经添加的人员
    for (AttendanceConfigurePerson *selectedPersopn in selectedEmployeeArray) {
        BOOL isExisted = NO;
        for (AttendanceConfigurePerson *existedPerson in  existedEmployeeArray) {
            if ([selectedPersopn.emId isEqualToNumber:existedPerson.emId]) {
                isExisted = YES;
            }
        }
        if (!isExisted) {
            [_employeeArray addObject:selectedPersopn];
        }
    }
    
    if (selectedEmployeeArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_employee_add_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else if (selectedEmployeeArray.count > 0 && _employeeArray.count == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_employee_add_new" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        [self requestSaveSelectedEmployee];
    }
}

#pragma mark - OnMessageHandleListener
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        [msg setValue:_employeeArray forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([EmployeeAddTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            EmployeeAddTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            NSNumber * tmpNumber;
            NSMutableArray * tmpArray;
            NSDictionary * tmpDictionary;
            AttendanceEmployeeWorkTeamEntity * group;
            switch(eventType) {
                case EMPLOYEE_ADD_TABLE_EVENT_CHECK_UPDATE:
                    [self updateList];
                    break;
                case EMPLOYEE_ADD_TABLE_EVENT_SHOW_EMPLOYEE:
                    group = [result valueForKeyPath:@"eventData"];
                    tmpArray = [_helper getEmployeeByGroup:group.wtId];
                    if([tmpArray count] == 0) {
                        [self requestEmployeeForGroup:group.wtId];
                    } else {
                        [self updateList];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

@end

