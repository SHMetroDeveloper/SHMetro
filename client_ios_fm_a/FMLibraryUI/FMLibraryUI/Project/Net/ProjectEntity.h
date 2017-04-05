//
//  ProjectEntity.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "BaseResponse.h"

typedef NS_ENUM(NSInteger, PfmProjectType) {
    PROJECT_TYPE_ASSET, //资产
    PROJECT_TYPE_PFM, //PFM
    PROJECT_TYPE_MIX, //混合
};

//项目组
@interface ProjectGroup : NSObject
@property (readwrite, nonatomic, strong) NSNumber * groupId;    //组ID
@property (readwrite, nonatomic, strong) NSString * groupName;       //组名字
@property (readwrite, nonatomic, strong) NSString * groupDesc;       //组描述
@property (readwrite, nonatomic, strong) NSMutableArray * projects; //项目
- (instancetype) init;
@end

//项目
@interface Project : NSObject
@property (readwrite, nonatomic, strong) NSNumber * projectId;  //项目ID
@property (readwrite, nonatomic, strong) NSString * name;       //项目名称
@property (readwrite, nonatomic, strong) NSString * code;       //项目编号
@property (readwrite, nonatomic, strong) NSString * type;       //项目类型
@property (readwrite, nonatomic, strong) NSNumber * imgId;      //项目logo 的ID
@property (readwrite, nonatomic, assign) NSInteger msgCount;      //项目logo 的ID
@end


@interface BaseDataGetProjectListParam : BaseRequest
@property (readwrite, nonatomic, strong) NSNumber * userId;
//@property (readwrite, nonatomic, strong) NSNumber * type;
- (instancetype) initWith:(NSNumber*) userId;
- (NSString*) getUrl;
@end


@interface ProjectResponse : BaseResponse
@property (readwrite, nonatomic, strong) NSMutableArray * data;
@end
