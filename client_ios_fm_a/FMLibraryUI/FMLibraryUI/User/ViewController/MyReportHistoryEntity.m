//
//  MyReportHistoryEntity.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MyReportHistoryEntity.h"
#import "SystemConfig.h"
#import "UserServerConfig.h"
#import "WorkOrderServerConfig.h"
#import "FMUtils.h"
#import "MJExtension.h"

@implementation MyReportSearchCondition
- (instancetype) init {
    self = [super init];
    if(self) {
        _priority = [[NSMutableArray alloc] init];
        _status = [[NSMutableArray alloc] init];
        _emId = [SystemConfig getUserId];   //默认为当前登录用户ID，与报障ID一样
    }
    return self;
}
@end

@implementation MyReportRequestParam

- (instancetype)initWithRequestPage:(NetPageParam *)page {
    self = [super init];
    if (self) {
        _searchCondition = [[MyReportSearchCondition alloc] init];
        
        _page = [[NetPageParam alloc] init];
        _page.pageNumber = [page.pageNumber copy];
        _page.pageSize = [page.pageSize copy];
    }
    return self;
}

- (NSString*) getUrl {
    
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], GET_MY_REPORT_URL];
    return res;
}

@end

@implementation MyReportHistory

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
//创建时间
- (NSString *) getCreateTimeStr {
    NSString * res = @"";
    if (![FMUtils isObjectNull:_createDateTime] && ![_createDateTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_createDateTime];
        res = [FMUtils getMinuteStrWithoutYear:date];
    }
    return res;
}
@end

@implementation MyreportHistoryResponseData
+ (NSDictionary *) mj_objectClassInArray {
    return @{
             @"contents" : @"MyReportHistory"
             };
}
@end

@implementation MyreportHistoryResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        self.data = [[MyreportHistoryResponseData alloc] init];
    }
    return self;
}

@end



