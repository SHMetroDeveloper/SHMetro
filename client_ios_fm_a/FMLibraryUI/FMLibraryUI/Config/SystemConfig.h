//
//  SystemConfig.h
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthFM.h"

// Debug Logging
#if 1 // Set to 1 to enable debug logging
#define FMLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define FMLog(x, ...)
#endif



@interface SystemConfig : NSObject

//获取设备类型
+ (NSString*) getDeviceType;

//获取信息
+ (OAuthFM *) getOauthFM;

//保存认证信息
+ (void) setOauthFM: (OAuthFM*) newOauth;

//获取当前用户登录名
+ (NSString*) getLoginName;

//保存用户登录名
+ (void) setLoginName:(NSString*) loginName;

//获取用户名
+ (NSString *) getCurrentUserName;

//获取当前用户的密码
+ (NSString *) getCurrentUserPassword;

//获取当前用户的类型
+ (OAuthUserType) getCurrentUserType;

//获取地图的 key
+ (NSString *) getMapKey;

//初始化 crash 收集设置
+ (NSString *) getCrashReporterKey;

//获取登陆用户名
+ (NSString *) getPushAccount;

//获取实际的推送账号地址， 地址 = 名称 + "@" + 服务器ID
+ (NSString *) getPushAcountPath;

//保存通知账户
+ (void) savePushAccount:(NSString *) account;

//获取服务器ID
+ (NSString *) getServerId;

//保存服务器ID
+ (void) saveServerId:(NSString *) serverId;

//获取当前用户的 UserId
+ (NSNumber *) getUserId;

//获取当前用户的 emId
+ (NSNumber *) getEmployeeId;



//保存当前项目的ID
+ (void) setCurrentProjectId:(NSNumber *) projectId;

//获取当前项目的ID
+ (NSNumber *) getCurrentProjectId;


//保存当前项目的名称
+ (void) setCurrentProjectName:(NSString *) projectName;

//获取当前项目的名称
+ (NSString *) getCurrentProjectName;


//获取服务器地址
+ (NSString *) getServerAddress;

//保存服务器地址信息
+(void) setServerAddress:(NSString *) serverAddress;

//获取软件当前版本号
+ (NSString *) getCurrentVersion;

//获取产品的名字
+ (NSString *) getProductName;

//获取二维码 间隔符
+ (NSString *) getQrCodeSeperatorString;

//获取上次获取离线数据的时间
+ (NSNumber *) getPreRequestDate;

//获取推送通知 AccessId
+ (uint32_t) getAccessId;

//获取推送 AccessKey
+ (NSString *) getAccessKey;

//短信验证配置
+ (NSString *) getMobAppKey;
+ (NSString *) getMobAppSecret;

//是否需要工单
+ (BOOL) needShowOrder;
//是否需要需求
+ (BOOL) needShowRequirement;
//是否需要资产
+ (BOOL) needShowAsset;

//保存签到位置的精准度
+ (void) saveSignLocationAccurancy:(NSInteger) accurancy;

//获取签到位置的精准度
+ (NSInteger) getSignLocationAccurancy;

//清除当前用户设置
+ (void) clearCurrentUserSetting;

//缓存管理设置
+ (void) setClearFile:(BOOL) enable;    //设置是否需要清除文件
+ (BOOL) needClearFile;                 //查询是否需要清除文件
+ (void) setClearBaseData:(BOOL) enable;    //设置是否需要清除基础数据
+ (BOOL) needClearBaseData;                 //查询是否需要清除基础数据
+ (void) setClearPatrolTask:(BOOL) enable;    //设置是否需要清除巡检任务
+ (BOOL) needClearPatrolTask;                 //查询是否需要清除巡检任务
+ (void) setClearBaseSetting:(BOOL) enable;    //设置是否需要清除基础设置
+ (BOOL) needClearBaseSetting;                 //查询是否需要清除基础设置
+ (void) setClearNotification:(BOOL) enable;    //设置是否需要清除推送记录
+ (BOOL) needClearNotification;                 //查询是否需要清除推送记录

@end

extern NSString * const DATABASE_NAME;
extern NSString * const APP_KEY;
extern NSString * const APP_SCRETE;
