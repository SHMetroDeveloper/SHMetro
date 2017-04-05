//
//  SystemConfig.m
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "SystemConfig.h"
#import "BasePreference.h"
#import "FMUtils.h"
#import "UserEntity.h"
#import "BaseDataDbHelper.h"
#import "BaseDataEntity.h"

#import "PowerManager.h"
#import "WorkOrderFunctionPermission.h"
#import "RequirementFunctionPermission.h"

NSString * const DATABASE_NAME = @"fm_shang_db";
//NSString * const APP_KEY = @"f564091b4170497d896c5f1a13d5191dda448cee94f82cb3";
//NSString * const APP_SCRETE = @"2b2135961f52df6d0d0bb3198fd5a516b5a2b71b3511ba02";

NSString * const APP_KEY = @"00000000";
NSString * const APP_SCRETE = @"11111111";

//1.0
//uint32_t NOTIFICATION_ACCESS_ID = 2200149461;
//NSString * NOTIFICATION_ACCESS_KEY = @"IC88D2FX16FJ";

//2.0
uint32_t NOTIFICATION_ACCESS_ID = 2200242282;       //推送配置
NSString * NOTIFICATION_ACCESS_KEY = @"IT74YTWL394C";


NSString * MOB_ACCESS_KEY = @"1812b0a87a34c";   //MOB KEY
NSString * MOB_ACCESS_SECRET = @"3509f825b463a9b7ee3c309ea5da16c8";   //短信验证

//高德地图
NSString * MAP_GAODE_KEY = @"58b7b68c33977d9c9589d124ee40b5a4";   //

//Crash 收集
NSString * CRASH_REPORTER_BUGRPT = @"I006515301";   //

//NSString * const DEFAULT_SERVER_URL = @"http://115.29.53.241";     //外部演示
//NSString * const DEFAULT_SERVER_URL = @"http://192.168.6.90:8080";     //
//NSString * const DEFAULT_SERVER_URL = @"https://wechat.fmone.cn";     //
NSString * const DEFAULT_SERVER_URL = @"http://222.66.139.89:80";     //


NSString * SERVER_URL = @"";


static OAuthFM * mOauth = nil;
static NSString* loginName = nil;
static NSString* version = nil;

static NSNumber * currentProjectId = nil;   //当前项目信息
static NSString * currentProjectName = nil;

static NSString * serverID = nil;   //设备ID，服务器唯一标示

@implementation SystemConfig

+ (NSString*) getDeviceType {
    return @"iOS";
}

+ (OAuthFM *) getOauthFM {
    if(!mOauth) {
        mOauth = [[OAuthFM alloc] initWithAppKey:APP_KEY appScrete:APP_SCRETE serverUrl:[SystemConfig getServerAddress] deviceId:[SystemConfig getDeviceType]];
    }
    return mOauth;
}

+ (void) setOauthFM: (OAuthFM*) newOauth {
    mOauth = newOauth;
}

+ (NSString*) getLoginName {
    if(!loginName) {
        loginName = [BasePreference getUserInfoString:@"loginName"];
    }
    return loginName;
}

//获取用户名
+ (NSString *) getCurrentUserName {
    NSString * userName;
    NSNumber * userId = [SystemConfig getUserId];
    UserInfo * user = [[BaseDataDbHelper getInstance] queryUserById:userId];
    userName = user.name;
    return userName;
}


+ (NSString *) getCurrentUserPassword {
    NSNumber * userId = [SystemConfig getUserId];
    NSString * password;
    UserInfo * user = [[BaseDataDbHelper getInstance] queryUserById:userId];
    if(user) {
        password = [user.password copy];
    }
    return password;
}

+ (OAuthUserType) getCurrentUserType {
    OAuthUserType type = OAUTH_USER_LABORER;
    
    OAuthFM * oauth = [SystemConfig getOauthFM];
    if(oauth) {
        OAuthUserInfo * user = [oauth getUserInfo];
        if(user) {
            type = user.userType;
        }
    }
    return type;
}

+ (NSString *) getMapKey {
    NSString * key = MAP_GAODE_KEY;
    return key;
}

//初始化 crash 收集设置
+ (NSString *) getCrashReporterKey {
    NSString * key = CRASH_REPORTER_BUGRPT;
    return key;
}

//获取通知账户
+ (NSString *) getPushAccount{
    NSString *account = [BasePreference getUserInfoString:@"pushAccount"];
    return account;
}

//获取实际的推送账号地址， 地址 = 名称 + "@" + 服务器ID
+ (NSString *) getPushAcountPath {
    NSString * res;
    if(serverID) {
        
        NSString * account = [SystemConfig getPushAccount];
        if([FMUtils isStringEmpty:account]) {
            account = loginName;
        }
        if(account) {
            res = [[NSString alloc] initWithFormat:@"%@@%@", account, serverID];
            
        }
    }
    res = [res lowercaseString];    //统一采用小写形式
    return res;
}

//获取服务器ID
+ (NSString *) getServerId {
    return serverID;
}

//保存服务器ID
+ (void) saveServerId:(NSString *) serverId {
    serverID = serverId;
}

//保存通知账户
+ (void) savePushAccount:(NSString *) account {
    [BasePreference saveUserInfoKey:@"pushAccount" stringValue:account];
}

//获取当前用户的 UserId
+ (NSNumber *) getUserId {
    NSNumber * userId;
    userId = [NSNumber numberWithInteger:[[SystemConfig getOauthFM] getUserInfo].userId];
    return userId;
}

//获取当前用户的 emId
+ (NSNumber *) getEmployeeId {
    NSNumber * emId;
    NSNumber* userId = [SystemConfig getUserId];
    if(userId) {
        UserInfo * user = [[BaseDataDbHelper getInstance] queryUserById:userId];
        if(user) {
            emId = user.emId;
        }
    }
    return emId;
}

+ (void) setLoginName:(NSString*) name {
    loginName = name;
    [BasePreference saveUserInfoKey:@"loginName" stringValue:loginName];
}

//保存当前项目的ID
+ (void) setCurrentProjectId:(NSNumber *) projectId {
    currentProjectId = projectId;
    [BasePreference saveUserInfoKey:@"currentProjectId" numberValue:currentProjectId];
}

//获取当前项目的ID
+ (NSNumber *) getCurrentProjectId {
    if(!currentProjectId) {
        currentProjectId = [BasePreference getUserInfoNumber:@"currentProjectId"];
    }
    return currentProjectId;
}

//保存当前项目的名称
+ (void) setCurrentProjectName:(NSString *) projectName {
    currentProjectName = projectName;
    [BasePreference saveUserInfoKey:@"currentProjectName" stringValue:currentProjectName];
}

//获取当前项目的名称
+ (NSString *) getCurrentProjectName {
    if(!currentProjectName) {
        currentProjectName = [BasePreference getUserInfoString:@"currentProjectName"];
    }
    return currentProjectName;
}

//获取服务器地址信息
+ (NSString *) getServerAddress {
    if([FMUtils isStringEmpty:SERVER_URL]) {
        SERVER_URL = [BasePreference getUserInfoString:@"serverAddress"];
        if([FMUtils isStringEmpty:SERVER_URL]) {
            SERVER_URL = [DEFAULT_SERVER_URL copy];
        }
    }
    return SERVER_URL;
}

//保存服务器地址信息
+(void) setServerAddress:(NSString *) serverAddress {
    if(![FMUtils isStringEmpty:serverAddress] && ![serverAddress isEqualToString:SERVER_URL]) {
        SERVER_URL = [serverAddress copy];
        [BasePreference saveUserInfoKey:@"serverAddress" stringValue:SERVER_URL];
        
    }
}


//获取软件当前版本号
+ (NSString *) getCurrentVersion {
    version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
    return version;
}

+ (NSString *) getProductName {
    NSString* prodName =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return prodName;
}

+ (NSString *) getQrCodeSeperatorString {
    return @"|";
}


//获取上次获取离线数据的时间
+ (NSNumber *) getPreRequestDate {
    DownloadRecord * record = [[BaseDataDbHelper getInstance] queryDownloadRecordByType:BASE_DATA_TYPE_ALL];
    NSNumber * preRequestDate;
    if(record) {
        preRequestDate = record.preRequestDate;
    } else {
        preRequestDate = [NSNumber numberWithLong:0];
    }
    return preRequestDate;
}

//获取推送通知 AccessId
+ (uint32_t) getAccessId {
    return NOTIFICATION_ACCESS_ID;
}

//获取推送 AccessKey
+ (NSString *) getAccessKey {
    return NOTIFICATION_ACCESS_KEY;
}

+ (NSString *) getMobAppKey {
    return MOB_ACCESS_KEY;
}

+ (NSString *) getMobAppSecret {
    return MOB_ACCESS_SECRET;
}

//是否需要工单
+ (BOOL) needShowOrder {
    BOOL res = NO;
//    PowerManager * manager = [PowerManager getInstance];
//    if([manager getPermissionTypeOfFunctionByMajorKey:WORK_ORDER_FUNCTION minorKey:nil] != FUNCTION_ACCESS_PERMISSION_NONE) {
        res = YES;
//    }
    return res;
}

//是否需要需求
+ (BOOL) needShowRequirement {
    BOOL res = NO;
//    PowerManager * manager = [PowerManager getInstance];
//    if([manager getPermissionTypeOfFunctionByMajorKey:REQUIREMENT_FUNCTION minorKey:nil] != FUNCTION_ACCESS_PERMISSION_NONE) {
        res = YES;
//    }
    return res;
}

//是否需要资产
+ (BOOL) needShowAsset {
    BOOL res = NO;
//    PowerManager * manager = [PowerManager getInstance];
    res = YES;
    return res;
}

//保存签到位置的精准度
+ (void) saveSignLocationAccurancy:(NSInteger) accurancy {
    [BasePreference saveUserInfoKey:@"signAccurancy" numberValue:[NSNumber numberWithInteger:accurancy]];
}

//获取签到位置的精准度
+ (NSInteger) getSignLocationAccurancy {
    NSInteger res = 0;
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"signAccurancy"];
    res = tmpNumber.integerValue;
    return res;
}

//清除当前用户设置
+ (void) clearCurrentUserSetting {
    [BasePreference clearUserInfoKey:@"notFirstLogin"]; //首次登陆标志
    [BasePreference clearUserInfoKey:@"autoLogin"];
    [BasePreference clearUserInfoKey:@"lastUser"];
    [BasePreference clearUserInfoKey:@"loginName"];
    [BasePreference clearUserInfoKey:@"currentProjectId"];
    [BasePreference clearUserInfoKey:@"currentProjectName"];
}

//缓存管理设置
+ (void) setClearFile:(BOOL) enable { //设置是否需要清除文件
    [BasePreference saveUserInfoKey:@"cacheFile" numberValue:[NSNumber numberWithBool:enable]];
}
+ (BOOL) needClearFile {                 //查询是否需要清除文件
    BOOL res = YES; //默认需要清除文件
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"cacheFile"];
    if(tmpNumber) {
        res = tmpNumber.boolValue;
    }
    return res;
}
+ (void) setClearBaseData:(BOOL) enable {    //设置是否需要清除基础数据
    [BasePreference saveUserInfoKey:@"cacheBaseData" numberValue:[NSNumber numberWithBool:enable]];
}
+ (BOOL) needClearBaseData {                 //查询是否需要清除基础数据
    BOOL res = NO; //默认不需要清除基础数据
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"cacheBaseData"];
    if(tmpNumber) {
        res = tmpNumber.boolValue;
    }
    return res;
}
+ (void) setClearPatrolTask:(BOOL) enable {    //设置是否需要清除巡检任务
    [BasePreference saveUserInfoKey:@"cachePatrolTask" numberValue:[NSNumber numberWithBool:enable]];
}
+ (BOOL) needClearPatrolTask {                 //查询是否需要清除巡检任务
    BOOL res = NO; //默认不需要清除巡检任务
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"cachePatrolTask"];
    if(tmpNumber) {
        res = tmpNumber.boolValue;
    }
    return res;
}
+ (void) setClearBaseSetting:(BOOL) enable {    //设置是否需要清除基础设置
    [BasePreference saveUserInfoKey:@"cacheBaseSetting" numberValue:[NSNumber numberWithBool:enable]];
}
+ (BOOL) needClearBaseSetting {                //查询是否需要清除基础设置
    BOOL res = NO; //默认不需要清除基础设置
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"cacheBaseSetting"];
    if(tmpNumber) {
        res = tmpNumber.boolValue;
    }
    return res;
}
+ (void) setClearNotification:(BOOL) enable {    //设置是否需要清除推送记录
    [BasePreference saveUserInfoKey:@"cacheNotification" numberValue:[NSNumber numberWithBool:enable]];
}
+ (BOOL) needClearNotification {                 //查询是否需要清除推送记录
    BOOL res = NO; //默认不需要清除消息记录
    NSNumber * tmpNumber = [BasePreference getUserInfoNumber:@"cacheNotification"];
    if(tmpNumber) {
        res = tmpNumber.boolValue;
    }
    return res;
}

@end
