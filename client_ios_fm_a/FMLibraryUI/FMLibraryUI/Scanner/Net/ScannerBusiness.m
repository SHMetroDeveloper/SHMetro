//
//  ScannerBusiness.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "ScannerBusiness.h"
#import "AttendanceEntity.h"
#import "ScannerNetRequest.h"
#import "MJExtension.h"

ScannerBusiness *scannerBusinessInstance;

@implementation ScannerBusiness

+ (instancetype)getInstance {
    
    if(!scannerBusinessInstance) {
        
        scannerBusinessInstance = [[ScannerBusiness alloc] init];
    }
    return scannerBusinessInstance;
}


/**
 扫一扫签到

 @param personId 被签的委外人员ID
 @param contactId 值班人员ID
 @param contactName 值班人员名字
 @param location 签到位置
 @param createTime 签到时间
 */
- (void)attendanceByPersonId:(NSNumber *)personId
                   contactId:(NSNumber *)contactId
                 contactName:(NSString *)contactName
                    location:(Position *)location
                  createTime:(NSNumber *)createTime
                     Success:(business_success_block)success
                        fail:(business_failure_block)fail {
    
    AttendanceRequest *attendanceRequest = [[AttendanceRequest alloc] initWithPersonId:personId contactId:contactId contactName:contactName location:location createTime:createTime];
    [[ScannerNetRequest getInstance] request:attendanceRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"签到情况：%@", responseObject);
        
        AttendanceResponse *response = [AttendanceResponse mj_objectWithKeyValues:responseObject];
        
        if(success) {
            
            success(SCANNER_BUSINESS_ATTENDANCE, response.data);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(fail) {
            
            fail(SCANNER_BUSINESS_ATTENDANCE, error);
        }
    }];
}

@end
