//
//  AppDelegate.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/10.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "BaseViewController.h"
#import "MainViewController.h"
#import "ZWIntroductionViewController.h"
#import "LoginViewController.h"
#import "BasePreference.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "DXAlertView.h"
#import "WorkOrderServerConfig.h"
#import "IQKeyboardManager.h"
#import <SMS_SDK/SMSSDK.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <Bugrpt/NTESCrashReporter.h>
#import "MainLoginViewController.h"
#import "BaseBundle.h"

#import "TestMainViewController.h"

@interface AppDelegate ()

@property (readwrite, nonatomic, strong) UIViewController *rootController;
@property (readwrite, nonatomic, strong) LoginViewController * loginVC;
//@property (readwrite, nonatomic, strong) TestMainViewController *loginVC;
@property (readwrite, nonatomic, assign) CGRect mainBound;
@property (readwrite, nonatomic, strong) NSData * pushToken;

@property (readwrite, nonatomic, assign) BOOL showNotificationNotice;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    dispatch_async(dispatch_get_main_queue(), ^{
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        manager.enable = YES;
        manager.shouldResignOnTouchOutside = YES;
        manager.shouldToolbarUsesTextFieldTintColor = YES;
        manager.enableAutoToolbar = YES;
        manager.shouldShowTextFieldPlaceholder = NO;
    });
    
    
    [self initXGWithLaunchOptions:launchOptions];
    
    //初始化 Mobi 配置，主要是短信验证码使用
    [SMSSDK registerApp:[SystemConfig getMobAppKey]
             withSecret:[SystemConfig getMobAppSecret]];
    
    //初始化地图
    [self initMap];
    
    //初始化 crash 收集
    [self initCrashReporter];
    
    //初始化消息系统消息监听
    [self initBaseNotificationHandler];
    
    _mainBound = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:_mainBound];
    if(launchOptions && [launchOptions valueForKeyPath:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
        _loginVC = [[LoginViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:[launchOptions valueForKeyPath:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    } else {
        _loginVC = [[LoginViewController alloc] init];
    }
    _loginVC = [[TestMainViewController alloc] init];
    
    BOOL isNotFirstLogin = [BasePreference getUserInfoNumber:@"notFirstLogin"].boolValue;
    if(!isNotFirstLogin) {
        NSArray *coverImageNames = @[@"guide_01_txt", @"guide_02_txt", @"guide_03_txt", @"guide_04_txt"];
        NSArray *backgroundImageNames = @[@"guide_01_bg", @"guide_02_bg", @"guide_03_bg", @"guide_04_bg"];
        self.rootController = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    } else {
       self.rootController = _loginVC;
    }
    [BasePreference saveUserInfoKey:@"notFirstLogin" numberValue:[NSNumber numberWithBool:YES]];
    
    _rootController = [[MainLoginViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    [self.rootController.navigationController setNavigationBarHidden:YES animated:YES];
    
    return YES;
}

- (void) initBaseNotificationHandler {
    NSString * name = [BaseViewController getBaseNotificationNameByType:BASE_NOTIFICATION_LOGOUT];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoOut)
                                                 name:name object:nil];
}

- (void) logoOut {
    BOOL res = NO;
    for(UIViewController * tmpVC in [self.rootController.navigationController viewControllers]) {
        if([tmpVC isKindOfClass:[LoginViewController class]]) {
            res = YES;
            [self.rootController.navigationController popToViewController:tmpVC animated:NO];
            break;
        }
    }
    if(!res) {
        if([self.rootController.navigationController.viewControllers count] > 0) {
            UIViewController * tmpVC =self.rootController.navigationController.viewControllers[0];
            [self.rootController.navigationController popToViewController:tmpVC animated:NO];
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//        return UIInterfaceOrientationMaskAll;
//    
//    else  /* iphone */
    
        return UIInterfaceOrientationMaskPortrait ;
}



- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                       settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                       categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


- (void) initXGWithLaunchOptions:(NSDictionary *) launchOptions {
    [XGPush startApp:[SystemConfig getAccessId] appKey:[SystemConfig getAccessKey]];
        //注销之后需要再次注册前的准备
        void (^successCallback)(void) = ^(void){
            //如果变成需要注册状态
            if(![XGPush isUnRegisterStatus])
            {
                //iOS8注册push方法
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
                float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
                if(sysVer < 8){
                    [self registerPush];
                }
                else{
                    [self registerPushForIOS8];
                }
    #else
                //iOS8之前注册push方法
                //注册Push服务，注册后才能收到推送
                [self registerPush];
    #endif
            }
        };
        [XGPush initForReregister:successCallback];
    
        //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    
        //推送反馈(app不在前台运行时，点击推送激活时)
        //[XGPush handleLaunching:launchOptions];
    
        //推送反馈回调版本示例
        void (^successBlock)(void) = ^(void){
            //成功之后的处理
            NSLog(@"[XGPush]handleLaunching's successBlock");
        };
    
        void (^errorBlock)(void) = ^(void){
            //失败之后的处理
            NSLog(@"[XGPush]handleLaunching's errorBlock");
        };
    
        //角标清0
//    NSNumber * userId = [SystemConfig getUserId];
//    NSInteger count = [[NotificationDbHelper getInstance] queryAllNotificationUnReadBy:userId project:nil];
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    
        //清除所有通知(包含本地通知)
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
        [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
}

- (void) pushLocalNotification:(NSString *) msg {
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
    
    NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
    [dicUserInfo setValue:[NSNumber numberWithInteger:2] forKey:@"type"];
    NSDictionary *userInfo = dicUserInfo;
    
    [XGPush localNotification:fireDate alertBody:msg badge:2 alertAction:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] userInfo:userInfo];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"type" userInfoValue:@"2"];
    NSLog(@"接收到消息。");
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
//    UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    _pushToken = deviceToken;
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
}

- (void) unRegisterDevice {
    [XGPush setAccount:@"*"];
}

- (void) registerDevice {
    NSLog(@"注册设备。");
    if(_pushToken) {
//        NSString * account = [SystemConfig getPushAccount];
        NSString * account = [SystemConfig getPushAcountPath];
        
        void (^successBlock)(void) = ^(void){
            //成功之后的处理
            NSLog(@"[XGPush Demo]register successBlock");
            NSLog(@"设备注册成功。");
        };
        
        void (^errorBlock)(void) = ^(void){
            //失败之后的处理
            NSLog(@"[XGPush Demo]register errorBlock");
            NSLog(@"设备注册失败。");
            [SystemConfig savePushAccount:@""];
        };
        
        
        [XGPush setAccount:account];
        NSLog(@"----注册的账号:%@", account);
        
        //注册设备
        //    XGSetting *setting = (XGSetting *)[XGSetting getInstance];
        //    [setting setChannel:@"appstore"];
        //    [setting setGameServer:@"巨神峰"];
        
        NSString * deviceTokenStr = [XGPush registerDevice:_pushToken successCallback:successBlock errorCallback:errorBlock];
        
        //如果不需要回调
        //[XGPush registerDevice:deviceToken];
        
        //打印获取的deviceToken的字符串
        NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
    }
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}


- (void) showNotificationNotice:(NSDictionary *) userInfo {
    UIViewController * rootVC = [FMUtils getRootViewController];
    if([rootVC isKindOfClass:[BaseViewController class]]) {
    
    }
    if(currentBaseVC) {
        [currentBaseVC didReceivedNotification];
    }
    if(!_showNotificationNotice) {
        NSNumber * projectId = [userInfo valueForKeyPath:@"projectId"];
        if(projectId && ![projectId isEqualToNumber:[NSNumber numberWithInteger:0]]) {
            NSNumber * currentProjectId = [SystemConfig getCurrentProjectId];
            if(currentProjectId && [projectId isEqualToNumber:currentProjectId]) {//如果是当前项目的通知，则提示是否去处理
                DXAlertView * alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notification_notify_process" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_yes" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_wait" inTable:nil] viewController:rootVC];
                alert.leftBlock = ^() {
                    NSLog(@"现在处理任务。");
                    if(currentBaseVC) {
                        NSNumber * tmpNumber = [userInfo valueForKeyPath:@"type"];
                        NSInteger type = tmpNumber.integerValue;
                        NSInteger key = [BaseViewController getKeyByType:type];
                        if(type == NOTIFICATION_ITEM_TYPE_ORDER) {
                            tmpNumber = [userInfo valueForKeyPath:@"woStatus"];
                            WorkOrderStatus status = [tmpNumber integerValue];
                            key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:status];
                        } else if(type == NOTIFICATION_ITEM_TYPE_INVENTORY) {
                            tmpNumber = [userInfo valueForKeyPath:@"reservationId"];
                            if(tmpNumber) { //预定单
                                key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_INVENTORY andSubType:INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_RESERVATION];
                            } else {
                                tmpNumber = [userInfo valueForKeyPath:@"inventoryId"];
                                if(tmpNumber) {//物资
                                    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_INVENTORY andSubType:INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_MATERIAL];
                                }
                            }
                            
                        }
                        [currentBaseVC handleNotificationOfType:key withParam:userInfo];
                    }
                };
                alert.rightBlock = ^() {
                    NSLog(@"稍后去处理任务。");
                };
                alert.dismissBlock = ^() {
                    _showNotificationNotice = NO;
                };
                [alert show];
                _showNotificationNotice = YES;
            } else {    //如果不是当前项目的通知，做出提示
                
                [currentBaseVC showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"notification_notify_other_project" inTable:nil] time:DIALOG_ALIVE_TIME_LONG];
            }
        }
    }
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    [self showNotificationNotice:userInfo];
    
    //回调版本示例
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
}

//初始化地图配置
- (void) initMap {
    [AMapServices sharedServices].apiKey = [SystemConfig getMapKey];
}

//初始化crash收集设置
- (void) initCrashReporter {
    [[NTESCrashReporter sharedInstance] initWithAppId:[SystemConfig getCrashReporterKey]];
}

@end
