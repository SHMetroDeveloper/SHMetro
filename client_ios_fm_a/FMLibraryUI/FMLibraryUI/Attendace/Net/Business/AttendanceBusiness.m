//
//  AttendanceBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceBusiness.h"
#import "AttendanceNetRequest.h"
#import "AttendanceEmployeeSettingEntity.h"
#import "AttendanceSettingEntity.h"
#import "MJExtension.h"

AttendanceBusiness * attendanceBusinessInstance;

@interface AttendanceBusiness ()

@property (readwrite, nonatomic, strong) AttendanceNetRequest * netRequest;

@end

@implementation AttendanceBusiness
    
+ (instancetype) getInstance {
    if(!attendanceBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            attendanceBusinessInstance = [[AttendanceBusiness alloc] init];
        });
    }
    return attendanceBusinessInstance;
}
    
- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [AttendanceNetRequest getInstance];
    }
    return self;
}
    
//获取工作组
- (void) getGroupsSuccess:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        AttendanceEmployeeWorkTeamRequestParam * param = [[AttendanceEmployeeWorkTeamRequestParam alloc] init];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            AttendanceEmployeeWorkTeamResponse * response = [AttendanceEmployeeWorkTeamResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_ATTENDANCE_GET_GROUPS, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_ATTENDANCE_GET_GROUPS, error);
            }
        }];
    }
}
    
//获取工作组内人员， wtId 值为空时获取无组人员
- (void) getEmployeeofGroup:(NSNumber *) wtId success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        AttendanceEmployeeWorkEmployeeRequestParam * param = [[AttendanceEmployeeWorkEmployeeRequestParam alloc] init];
        param.wtId = wtId;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
            AttendanceEmployeeWorkEmployeeResponse * response = [AttendanceEmployeeWorkEmployeeResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_ATTENDANCE_GET_EMPLOYEE, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_ATTENDANCE_GET_EMPLOYEE, error);
            }
        }];
    }
}

//获取签到配置信息
- (void) getSignSettingInfoSuccess:(business_success_block) success fail:(business_failure_block) fail{
    if (_netRequest) {
        AttendanceSettingDetailListRequestParam *param = [[AttendanceSettingDetailListRequestParam alloc] init];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AttendanceSettingResponse *response = [AttendanceSettingResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_ATTENDANCE_GET_SIGN_SETTING_LIST, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_ATTENDANCE_GET_SIGN_SETTING_LIST, error);
            }
        }];
    }
}

//获取签到历史记录
- (void) getSignHistoryByParam:(AttendanceSignHistoryRequestParam *) param Success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AttendanceSignHistoryResponse *response = [AttendanceSignHistoryResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_ATTENDANCE_GET_SIGN_HISTORY, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_ATTENDANCE_GET_SIGN_HISTORY, error);
            }
        }];
    }
}

//签入操作
- (void) attendanceOperateSign:(AttendanceOperateSignRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(BUSINESS_ATTENDANCE_OPERATE_SIGN_IN,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ATTENDANCE_OPERATE_SIGN_IN,error);
            }
        }];
    }
}

//签出操作
//- (void) attendanceOperateSignOut:(AttendanceOperateSignOutRequestParam *) param success:(business_success_block) success fail:(business_failure_block) fail {
//    if (_netRequest) {
//        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if (success) {
//                success(BUSINESS_ATTENDANCE_OPERATE_SIGN_OUT,responseObject);
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (fail) {
//                fail(BUSINESS_ATTENDANCE_OPERATE_SIGN_OUT,error);
//            }
//        }];
//    }
//}

//考勤人员
- (void) setRuleOfEmployee:(NSMutableArray *) array type:(AttendanceOperateEmployeeType) type success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        AttendanceOperateEmployeeRequestParam * param = [[AttendanceOperateEmployeeRequestParam alloc] init];
        param.type = type;
        param.person = array;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(BUSINESS_ATTENDANCE_SETTING_EMPLOYEE,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ATTENDANCE_SETTING_EMPLOYEE,error);
            }
        }];
    }
}

//设置签到 wifi
- (void) setRuleOfWifi:(NSMutableArray *) wifiArray sType:(AttendanceOperateWifiType) type success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        AttendanceOperateWiFiRequestParam * param = [[AttendanceOperateWiFiRequestParam alloc] init];
        param.type = type;
        param.wifi = wifiArray;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            AttendanceOperateWiFiResponse * response = [AttendanceOperateWiFiResponse mj_objectWithKeyValues:responseObject];
            if (success) {
                success(BUSINESS_ATTENDANCE_SETTING_WIFI,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ATTENDANCE_SETTING_WIFI,error);
            }
        }];
    }
}

//设置签到 蓝牙
- (void) setRuleOfBluetooth:(NSMutableArray *) bluetoothArray sType:(AttendanceOperateBluetoothType) type success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        AttendanceOperateBluetoothRequestParam * param = [[AttendanceOperateBluetoothRequestParam alloc] init];
        param.type = type;
        param.bluetooth = bluetoothArray;
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                AttendanceOperateBluetoothResponse * response = [AttendanceOperateBluetoothResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_ATTENDANCE_SETTING_BLUETOOTH,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ATTENDANCE_SETTING_BLUETOOTH,error);
            }
        }];
    }
}

//设置签到 地址
- (void) setRuleOfLocation:(NSMutableArray *) array sType:(AttendanceOperateLocationType) type accuracy:(NSInteger) accuracy success:(business_success_block) success fail:(business_failure_block) fail {
    if (_netRequest) {
        AttendanceOperateLocationRequestParam * param = [[AttendanceOperateLocationRequestParam alloc] init];
        param.type = type;
        param.location = array;
        param.accuracy = accuracy;
        
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                AttendanceOperateLocationResponse * response = [AttendanceOperateLocationResponse mj_objectWithKeyValues:responseObject];
                success(BUSINESS_ATTENDANCE_SETTING_LOCATION,response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (fail) {
                fail(BUSINESS_ATTENDANCE_SETTING_LOCATION,error);
            }
        }];
    }
}

@end
