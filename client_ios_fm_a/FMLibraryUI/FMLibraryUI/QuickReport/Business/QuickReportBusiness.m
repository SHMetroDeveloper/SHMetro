//
//  QuickReportBusiness.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/13.
//  Copyright © 2017年 facility. All rights reserved.
//


#import "QuickReportBusiness.h"
#import "MJExtension.h"
#import "QuickReportServiceConfig.h"

QuickReportBusiness *quickBusinessInstance;

@interface QuickReportBusiness ()
@property (readwrite, nonatomic, strong) QuickReportNetRequest *netRequest;
@end

@implementation QuickReportBusiness

+ (instancetype) getInstance {
    if(!quickBusinessInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            quickBusinessInstance = [[QuickReportBusiness alloc] init];
        });
    }
    return quickBusinessInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _netRequest = [QuickReportNetRequest getInstance];
    }
    return self;
}

//上传快速报障信息
- (void)uploadQuickReportInfo:(QuickReportCreateRequestParam *)param success:(business_success_block) success fail:(business_failure_block) fail {
    if(_netRequest) {
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(success) {
                success(BUSINESS_QUICK_REPORT_CREATE, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_QUICK_REPORT_CREATE, error);
            }
        }];
    }
}


@end
