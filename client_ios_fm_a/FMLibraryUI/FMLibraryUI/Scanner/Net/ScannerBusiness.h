//
//  ScannerBusiness.h
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "BaseBusiness.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, ScannerBusinessType) {
    
    SCANNER_BUSINESS_ATTENDANCE,  //扫一扫签到
};

@interface ScannerBusiness : BaseBusiness

+ (instancetype) getInstance;

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
                        fail:(business_failure_block)fail;

@end
