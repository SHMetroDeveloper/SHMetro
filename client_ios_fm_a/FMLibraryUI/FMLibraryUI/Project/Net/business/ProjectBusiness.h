//
//  ProjectBusiness.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseBusiness.h"
#import "ProjectEntity.h"

typedef NS_ENUM(NSInteger, ProjectBusinessType) {
    BUSINESS_PROJECT_UNKNOW,   //
    BUSINESS_PROJECT_GET_PROJECTS,       //获取所有项目信息
};


@interface ProjectBusiness : BaseBusiness

//获取项目业务的实例对象
+ (instancetype) getInstance;

//获取项目列表
- (void) getProjectsWith:(NSNumber *) userId Success:(business_success_block) success fail:(business_failure_block) fail;


@end
