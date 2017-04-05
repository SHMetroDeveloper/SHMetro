//
//  UserEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSUInteger, UserType) {
    
    USER_TYPE_HQ, //总部
    USER_TYPE_OUTSOURCE, //委外
    USER_TYPE_CIRCUIT, //线路部
    USER_TYPE_STATION, //车站
};

@interface UserEntity : NSObject

@end

@interface UserInfo : NSObject

@property (readwrite, nonatomic, strong) NSNumber *pictureId; //用户头像ID
@property (readwrite, nonatomic, strong) NSNumber *userId; //用户ID
@property (readwrite, nonatomic, strong) NSNumber *emId; //执行人ID
@property (readwrite, nonatomic, strong) NSString *email; //邮箱
@property (readwrite, nonatomic, strong) NSString *organizationName; //部门名称
@property (readwrite, nonatomic, strong) NSString *emDescription; //描述
@property (readwrite, nonatomic, strong) NSNumber *organizationId; //部门ID
@property (readwrite, nonatomic, strong) NSString *name; //用户名字
@property (readwrite, nonatomic, strong) NSString *phone; //电话号码
@property (readwrite, nonatomic, strong) NSString *position; //岗位
@property (readwrite, nonatomic, strong) NSString *activited; //是否激活
@property (readwrite, nonatomic, strong) NSString *number;
@property (readwrite, nonatomic, strong) NSString *extension;
@property (readwrite, nonatomic, strong) NSString *locationName; //位置名称
@property (readwrite, nonatomic, strong) Position *location; //位置
@property (readwrite, nonatomic, strong) NSString * skills; //技能
@property (readwrite, nonatomic, strong) NSString * title;
@property (readwrite, nonatomic, strong) NSNumber * type; //类型
@property (readwrite, nonatomic, strong) NSNumber * qrcodeId; //二维码图片ID

@property (readwrite, nonatomic, strong) NSString * loginName; //用户名
@property (readwrite, nonatomic, strong) NSString * password; //密码
@property (readwrite, nonatomic, strong) NSNumber * projectId; //项目ID

- (instancetype) init;

@end

@interface UserInfoResponse : BaseResponse

@property (readwrite, nonatomic, strong) UserInfo * data;

@end

//用户组信息
@interface UserGroup : NSObject

@property (readwrite, nonatomic, strong) NSNumber * emId;   //执行人ID
@property (readwrite, nonatomic, strong) NSNumber * groupId;    //组ID
@property (readwrite, nonatomic, strong) NSString * groupName;  //组名

@end
