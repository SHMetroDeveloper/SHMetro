//
//  ProjectEntity.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ProjectEntity.h"
#import "SystemConfig.h"
#import "BaseDataServerConfig.h"
#import "MJExtension.h"

@implementation ProjectGroup
- (instancetype) init {
    self = [super init];
    if(self) {
        _projects = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"projects" : @"Project"
             };
}
@end

@implementation Project
@end

@implementation ProjectResponse
- (instancetype) init {
    self = [super init];
    if(self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : @"ProjectGroup"
             };
}

@end


@implementation BaseDataGetProjectListParam

- (instancetype) initWith:(NSNumber *)userId {
    self = [super init];
    if(self) {
        _userId = userId;
//        _type = [NSNumber numberWithInteger:PROJECT_TYPE_MIX];
    }
    return self;
}

- (NSString*) getUrl {
    NSString* res = [[NSString alloc] initWithFormat:@"%@%@", [SystemConfig getServerAddress], BASE_DATA_GET_PROJECT_LIST_URL];
    return res;
}

@end