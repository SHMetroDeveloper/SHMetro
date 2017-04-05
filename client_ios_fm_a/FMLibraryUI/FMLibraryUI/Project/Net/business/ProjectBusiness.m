//
//  ProjectBusiness.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ProjectBusiness.h"
#import "BaseDataNetRequest.h"
#import "MJExtension.h"

ProjectBusiness * projectBusinessInstance;

@interface ProjectBusiness ()

@property (readwrite, nonatomic, strong) BaseDataNetRequest * netRequest;

@end

@implementation ProjectBusiness
//获取项目业务的实例对象
+ (instancetype) getInstance {
    if(!projectBusinessInstance) {
        projectBusinessInstance = [[ProjectBusiness alloc] init];
    }
    return projectBusinessInstance;
}

- (instancetype) init {
    self = [super init];
    if(self) {
        _netRequest = [BaseDataNetRequest getInstance];
    }
    return self;
}

//获取项目列表
- (void) getProjectsWith:(NSNumber *) userId Success:(business_success_block) success fail:(business_failure_block) fail {
    
    if(_netRequest) {
        BaseDataGetProjectListParam * param = [[BaseDataGetProjectListParam alloc] initWith:userId];
        [_netRequest request:param success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            ProjectResponse * response = [ProjectResponse mj_objectWithKeyValues:responseObject];
            if(success) {
                success(BUSINESS_PROJECT_GET_PROJECTS, response.data);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail) {
                fail(BUSINESS_PROJECT_GET_PROJECTS, error);
            }
        }];
    }
}
@end
