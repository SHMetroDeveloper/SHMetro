//
//  AttendanceEmployeeDetailViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceEmployeeDetailViewController.h"
#import "FMUtilsPackages.h"
#import "AttendanceEmployeeAddViewController.h"
#import "EmployeeDetailTableHelper.h"
#import "ImageItemView.h"
#import "FMTheme.h"
#import "AttendanceBusiness.h"
#import "AttendanceDbHelper.h"
#import "AttendanceSettingEntity.h"
#import "BaseBundle.h"


@interface AttendanceEmployeeDetailViewController ()<OnMessageHandleListener>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, strong) EmployeeDetailTableHelper * helper;
@property (readwrite, nonatomic, strong) AttendanceBusiness * business;
@property (nonatomic, strong) AttendanceDbHelper * dbHelper;

@end

@implementation AttendanceEmployeeDetailViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_employee" inTable:nil]];
    [self setBackAble:YES];
    if (_isEditable) {
        NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil]];
        [self setMenuWithArray:menuArray];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self gotoAddEmployee];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateList];
    }
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _helper = [[EmployeeDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        _helper.isEditable = _isEditable;
        
        _business = [AttendanceBusiness getInstance];

        _dbHelper = [AttendanceDbHelper getInstance];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.delegate = _helper;
        _tableView.dataSource = _helper;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_no_employee" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:NO];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateList {
    NSMutableArray *array = [_dbHelper queryAllSignPerson];
    [_helper setEmployee:array];
    
    [_tableView reloadData];
    [self updateNotice];
}

- (void) updateNotice {
    if([_helper getEmployeeCount] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) deleteEmployeeFromDB:(NSNumber *) employeeId {
    [_dbHelper deleteSignPersonById:employeeId];
}

- (void) saveEmployeeToDB:(NSMutableArray *) person {
    if (person.count > 0) {
        for (AttendanceConfigurePerson *obj in person) {
            [_dbHelper addSignPerson:obj];
        }
    }
}

#pragma mark - NetWorking
- (void) requestDeleteEmployee:(AttendanceConfigurePerson *) obj position:(NSInteger) position{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [array addObject:obj.emId];
    
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfEmployee:array type:ATTENDANCE_OPERATE_EMPLOYEE_TYPE_DELETE success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf deleteEmployeeFromDB:obj.emId];
        [weakSelf updateList];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_employee_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_employee_delete_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

#pragma mark - OnMessageHandleListener
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([EmployeeDetailTableHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            EmployeeDetailTableEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            AttendanceConfigurePerson * employee;
            NSMutableDictionary * data;
            NSNumber * tmpNumber;
            switch(eventType) {
                case EMPLOYEE_DETAIL_TABLE_EVENT_DELETE:
                    data = [result valueForKeyPath:@"eventData"];
                    employee = [data valueForKeyPath:@"employee"];
                    tmpNumber = [data valueForKeyPath:@"position"];
                    if(employee) {
                        [self requestDeleteEmployee:employee position:tmpNumber.integerValue];
                    }
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([AttendanceEmployeeAddViewController class])]) {
            NSMutableArray * array = [msg valueForKeyPath:@"result"];
            [self saveEmployeeToDB:array];
            [self updateList];
        }
    }
}

#pragma mark - PushEvent
- (void) gotoAddEmployee {
    AttendanceEmployeeAddViewController *VC = [[AttendanceEmployeeAddViewController alloc] init];
    [VC setOnMessageHandleListener:self];
    [self gotoViewController:VC];
}

@end

