//
//  AttendanceEntity.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AttendanceEntity.h"
#import "ScannerServerConfig.h"
#import "SystemConfig.h"

@implementation AttendanceEntity

@end


@implementation AttendanceResponse

@end


/**
 签到的请求实体
 */
@implementation AttendanceRequest

- (instancetype)initWithPersonId:(NSNumber *)personId
                       contactId:(NSNumber *)contactId
                     contactName:(NSString *)contactName
                        location:(Position *)location
                      createTime:(NSNumber *)createTime {
    
    self = [super init];
    if (self) {
        
        _personId = personId;
        _contactId = contactId;
        _contactName = contactName;
        _location = location;
        _createTime = createTime;
    }
    return self;
}


- (NSString *)getUrl {
    
    NSString *url = [self wrapUrl:[[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], SCANNER_ATTENDANCE_URL]];
    
    return url;
}

@end
