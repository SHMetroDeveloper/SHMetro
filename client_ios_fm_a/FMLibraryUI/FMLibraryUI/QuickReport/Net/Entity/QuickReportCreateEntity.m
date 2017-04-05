//
//  QuickReportCreateEntity.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "QuickReportCreateEntity.h"
#import "SystemConfig.h"
#import "FMUtilsPackages.h"
#import "MJExtension.h"
#import "QuickReportServiceConfig.h"

@implementation QuickReportCreateRequestParam
- (instancetype)init {
    self = [super init];
    if (self) {
        _equipment = [NSMutableArray new];
        _audioIds = [NSMutableArray new];
        _videoIds = [NSMutableArray new];
        _photoIds = [NSMutableArray new];
    }
    return self;
}

- (NSString *)getUrl {
    NSString * res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], QUICK_REPORT_CREATE_URL];
    return res;
}

@end

@implementation QuickReportCreateResponse

@end
