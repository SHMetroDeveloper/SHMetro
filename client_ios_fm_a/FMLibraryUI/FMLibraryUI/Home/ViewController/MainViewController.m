//
//  MainViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/11.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "MainViewController.h"
#import "PieChartViewController.h"
#import "UserViewController.h"
#import "FunctionsGridViewController.h"
#import "Systemconfig.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "WorkOrderDetailViewController.h"
#import "EquipmentDetailViewController.h"
#import "MaintenanceDetailViewController.h"
#import "WorkOrderDetailViewController.h"
#import "ContractDetailViewController.h"
#import "BulletinDetailViewController.h"
#import "ReservationDetailViewController.h"
#import "InventoryMaterialDetailViewController.h"

#import "BaseDataDbHelper.h"
#import "UserNetRequest.h"
#import "UserRequest.h"
#import "WorkOrderNetRequest.h"
#import "UserServerConfig.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "MessageViewController.h"
#import "FMNavigationViewController.h"
#import "NotificationDbHelper.h"
#import "UITabBar+badge.h"
#import "FMTheme.h"
#import "PowerBusiness.h"
#import "PowerManager.h"
#import "PatrolFunctionPermission.h"
#import "WorkOrderFunctionPermission.h"
#import "RequirementFunctionPermission.h"
#import "InventoryFunctionPermission.h"
#import "PlannedMaintenanceFunctionPermission.h"
#import "AssetFunctionPermission.h"
#import "EnergyFunctionPermission.h"
#import "AttendanceFunctionPermission.h"
#import "ReportFunctionPermission.h"
#import "ContractFunctionPermission.h"
#import "BulletinFunctionPermission.h"
#import "ScannerFunctionPermission.h"
#import "UserBusiness.h"
#import "CommonBusiness.h"
#import "DXAlertView.h"
#import "BaseDataDownloader.h"
#import "MBProgressHUD.h"

@interface MainViewController () <OnMessageHandleListener, UITabBarControllerDelegate, LoginListener>

@property (readwrite, nonatomic, assign) CGFloat tabBarHeight;
@property (readwrite, nonatomic, assign) BaseVcType vcType;
@property (readwrite, nonatomic, strong) NSDictionary * param;
@property (readwrite, nonatomic, assign) OAuthUserType userType;
@property (readwrite, nonatomic, strong) PowerBusiness * powerBusiness;
@property (readwrite, nonatomic, strong) PowerManager * powerManager;
@property (nonatomic, strong) UpdateRecord * record;//基础数据更新记录
@property (readwrite, nonatomic, strong) MessageViewController * msgVC;

@property (nonatomic, strong) BaseDataDownloader * downloader;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation MainViewController

- (instancetype) init {
    self = [super init];
    if(self) {
        _vcType = BASE_VC_TYPE_COMMON;
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super init];
    if(self) {
        _vcType = BASE_VC_TYPE_COMMON;
        self.view.frame = frame;
        [self initViews];
    }
    return self;
}

- (instancetype) initWithType:(BaseVcType) type param:(NSDictionary *) param {
    self = [super init];
    if(self) {
        _vcType = type;
        _param = param;
        [self initViews];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initProjectExchangeHandler];
    [self registerFunction];
    [self initData];
    [self initBadgeHandler];
    [self requestUserInfo];
    [self requestFunctionPermission];
    [self requestBaseDataUpdateInfo];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
//鉴于用户在不同项目中所对应的执行人信息不一致，此处需要在切换项目的时候重新获取用户信息
- (void) initProjectExchangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CurrentProjectChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateWhenProjectChanged)
                                                 name: @"CurrentProjectChanged"
                                               object: nil];
}

- (void) initData {
    _tabBarHeight = [FMSize getInstance].tabbarHeight;
    _userType = [SystemConfig getCurrentUserType];
    _powerBusiness = [PowerBusiness getInstance];
    
    _downloader = [BaseDataDownloader getInstance];
    [_downloader setTaskListener:self withType:BASE_TASK_TYPE_DOWNLOAD_ALL];
}

- (void) initViews {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.tabBarHeight);
    FMNavigationViewController *firstViewController = nil;
    BOOL showTask = YES;
    

    BaseViewController* homeVC;
//    if(_vcType == BASE_VC_TYPE_NOTIFICATION_TRANSIT) {  //接收到通知
//        if(_userType == OAUTH_USER_MANAGER || _userType == OAUTH_USER_LEADER) {  //领导层和管理层
//            PieChartViewController* chartVC = [[PieChartViewController alloc] initWithVcType:_vcType param:_param];
//            homeVC = chartVC;
//            showTask = NO;
//        } else
//        {        //员工
//            HomeViewController* taskVC = [[HomeViewController alloc] initWithVcType:_vcType param:_param];
//            
//            [taskVC setTabChangeListener:self];
//            homeVC = taskVC;
//            showTask = YES;
//        }
//    } else {
//        if(_userType == OAUTH_USER_MANAGER || _userType == OAUTH_USER_LEADER) {
//            PieChartViewController* chartVC = [[PieChartViewController alloc] init];
//            homeVC = chartVC;
//            showTask = NO;
//        } else {
//            HomeViewController* taskVC = [[HomeViewController alloc] init];
//            [taskVC setTabChangeListener:self];
//            homeVC = taskVC;
//            showTask = YES;
//        }
//    }
    _msgVC = [[MessageViewController alloc] init];
    [_msgVC setOnMessageHandleListener:self];
    
    homeVC = _msgVC;

    firstViewController = [[FMNavigationViewController alloc] initWithRootViewController:homeVC];
    
    FunctionsGridViewController * functionsVC = [[FunctionsGridViewController alloc] initWithFrame:frame];
    FMNavigationViewController *secondViewController = [[FMNavigationViewController alloc] initWithRootViewController:functionsVC];
    
    UserViewController * userVC = [[UserViewController alloc] initWithFrame:frame];
    FMNavigationViewController *thirdController = [[FMNavigationViewController alloc] initWithRootViewController:userVC];
    
    self.viewControllers = [NSArray arrayWithObjects:firstViewController, secondViewController, thirdController, nil];
    
    self.delegate = self;
    
    UITabBar *tabBar = self.tabBar;
    tabBar.tintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    tabBar.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_TABBAR_BG];
    

    UIImage *img = [FMUtils buttonImageFromColor:[UIColor clearColor] width:CGRectGetWidth(self.view.frame) height:1];
    [tabBar setShadowImage:img];
    [tabBar setBackgroundImage:[[UIImage alloc] init]];
    tabBar.layer.borderWidth = [FMSize getInstance].seperatorHeight;
    tabBar.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    if(showTask) {
        tabBarItem1.title = [[BaseBundle getInstance] getStringByKey:@"tabbar_messages" inTable:nil];
        [tabBarItem1 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_task_selected"]];
        [tabBarItem1 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_task_unselected"]];
    } else {
        tabBarItem1.title = [[BaseBundle getInstance] getStringByKey:@"tabbar_chart" inTable:nil];
        [tabBarItem1 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_chart_selected"]];
        [tabBarItem1 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_chart_unselected"]];
    }
    tabBarItem2.title = [[BaseBundle getInstance] getStringByKey:@"tabbar_function" inTable:nil];
    tabBarItem3.title = [[BaseBundle getInstance] getStringByKey:@"tabbar_me" inTable:nil];
    
    
    
    [tabBarItem2 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_function_selected"]];
    [tabBarItem2 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_function_unselected"]];
    
    [tabBarItem3 setSelectedImage:[[FMTheme getInstance] getImageByName:@"tabhost_user_selected"]];
    [tabBarItem3 setImage:[[FMTheme getInstance] getImageByName:@"tabhost_user_unselected"]];

    PatrolTaskUnFinishedViewController * targetPatrolVC = [[PatrolTaskUnFinishedViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    WorkOrderDetailViewController * targetOrderVC = [[WorkOrderDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    WorkOrderDetailViewController * targetHistoryOrderVC = [[WorkOrderDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    EquipmentDetailViewController * targetAssetVC = [[EquipmentDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    MaintenanceDetailViewController * targetMaintenanceVC = [[MaintenanceDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    
    ContractDetailViewController * targetContractVC = [[ContractDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    BulletinDetailViewController * targetBulletionVC = [[BulletinDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    
    ReservationDetailViewController * targetReservationVC = [[ReservationDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    
    InventoryMaterialDetailViewController * targetMaterialVC = [[InventoryMaterialDetailViewController alloc] initWithVcType:BASE_VC_TYPE_NOTIFICATION_TRANSIT param:nil];
    
    NSInteger key;
    
    key = [BaseViewController getKeyByType:NOTIFICATION_ITEM_TYPE_PATROL];
    [BaseViewController registerNotificationType:key targetVC:targetPatrolVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_CREATE];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_DISPACHED];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_PROCESS];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_STOP];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_TERMINATE];
    [BaseViewController registerNotificationType:key targetVC:targetHistoryOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_FINISH];
    [BaseViewController registerNotificationType:key targetVC:targetHistoryOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_VALIDATATION];
    [BaseViewController registerNotificationType:key targetVC:targetHistoryOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_CLOSE];
    [BaseViewController registerNotificationType:key targetVC:targetHistoryOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_APPROVE];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_ORDER andSubType:ORDER_STATUS_STOP_N];
    [BaseViewController registerNotificationType:key targetVC:targetOrderVC];
    
    key = [BaseViewController getKeyByType:NOTIFICATION_ITEM_TYPE_ASSET];
    [BaseViewController registerNotificationType:key targetVC:targetAssetVC];
    
    key = [BaseViewController getKeyByType:NOTIFICATION_ITEM_TYPE_MAINTENANCE];
    [BaseViewController registerNotificationType:key targetVC:targetMaintenanceVC];
    
    key = [BaseViewController getKeyByType:NOTIFICATION_ITEM_TYPE_CONTRACT];
    [BaseViewController registerNotificationType:key targetVC:targetContractVC];
    
    key = [BaseViewController getKeyByType:NOTIFICATION_ITEM_TYPE_BULLETION];
    [BaseViewController registerNotificationType:key targetVC:targetBulletionVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_INVENTORY andSubType:INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_RESERVATION];
    [BaseViewController registerNotificationType:key targetVC:targetReservationVC];
    
    key = [BaseViewController getKeyByMainType:NOTIFICATION_ITEM_TYPE_INVENTORY andSubType:INVENTORY_NOTIFICATION_SUB_ITEM_TYPE_MATERIAL];
    [BaseViewController registerNotificationType:key targetVC:targetMaterialVC];
}

#pragma mark - 功能模块注册
//初始化模块权限设置
- (void) registerFunction {
    _powerManager = [PowerManager getInstance];
    
    PatrolFunctionPermission * patrolFunction = [PatrolFunctionPermission getInstance];
    WorkOrderFunctionPermission * orderFunction = [WorkOrderFunctionPermission getInstance];
    RequirementFunctionPermission * requirementFunction = [RequirementFunctionPermission getInstance];
    InventoryFunctionPermission * inventoryFunction =  [InventoryFunctionPermission getInstance];
    PlannedMaintenanceFunctionPermission * ppmunction =  [PlannedMaintenanceFunctionPermission getInstance];
    AssetFunctionPermission * assetFunction =  [AssetFunctionPermission getInstance];
    EnergyFunctionPermission * energyFunction =  [EnergyFunctionPermission getInstance];
    AttendanceFunctionPermission * attendanceFunction = [AttendanceFunctionPermission getInstance];
    ReportFunctionPermission * reportFunction = [ReportFunctionPermission getInstance];
    ContractFunctionPermission * contractFunction = [ContractFunctionPermission getInstance];
    BulletinFunctionPermission * bulletinFunction = [BulletinFunctionPermission getInstance];
    ScannerFunctionPermission *scannerFunction = [ScannerFunctionPermission getInstance];
    
    [_powerManager registerFunction:patrolFunction];
    [_powerManager registerFunction:orderFunction];
    [_powerManager registerFunction:requirementFunction];
    [_powerManager registerFunction:inventoryFunction];
    [_powerManager registerFunction:ppmunction];
    [_powerManager registerFunction:assetFunction];
    [_powerManager registerFunction:energyFunction];
    [_powerManager registerFunction:attendanceFunction];
    [_powerManager registerFunction:reportFunction];
    [_powerManager registerFunction:contractFunction];
    [_powerManager registerFunction:bulletinFunction];
    [_powerManager registerFunction:scannerFunction];
}

//复位权限设置
- (void) resetFunction {
    [PatrolFunctionPermission initFunctionPermission];
    [WorkOrderFunctionPermission initFunctionPermission];
    [RequirementFunctionPermission initFunctionPermission];
    [InventoryFunctionPermission initFunctionPermission];
    [PlannedMaintenanceFunctionPermission initFunctionPermission];
    [AssetFunctionPermission initFunctionPermission];
    [EnergyFunctionPermission initFunctionPermission];
    [AttendanceFunctionPermission initFunctionPermission];
    [ReportFunctionPermission initFunctionPermission];
    [ContractFunctionPermission initFunctionPermission];
    [BulletinFunctionPermission initFunctionPermission];
    [ScannerFunctionPermission initFunctionPermission];
}


- (void) initBadgeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notificationBadgeUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateNotificationBadge:)
                                                 name: @"notificationBadgeUpdate"
                                               object: nil];
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSDictionary * msgDict = (NSDictionary *)msg;
        
        BaseTaskType taskType = [[msgDict valueForKeyPath:@"taskType"] integerValue];
        BaseTaskStatus taskStatus = [[msgDict valueForKeyPath:@"taskStatus"] integerValue];
        NSNumber * taskProgress = [msgDict valueForKeyPath:@"taskProgress"];
        NSString * strNotice = @"";
        CGFloat progress = taskProgress.floatValue;
        NSString * strTimeNow = [FMUtils timeLongToDateString:[FMUtils getTimeLongNow]];
        UIColor * statusColor;
        NSLog(@"%ld --- %.1f", taskType, taskProgress.floatValue);
        if(taskStatus == BASE_TASK_STATUS_TYPE_FINISH) {    //指定类型的任务下载完成
            
        } else {
            switch(taskStatus) {
                case BASE_TASK_STATUS_INIT:
                    strNotice = [[BaseBundle getInstance] getStringByKey:@"download_un_downloaded" inTable:nil];
                    statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED];
                    break;
                case BASE_TASK_STATUS_HANDLING:
                    strNotice = [[NSString alloc] initWithFormat:@"%@ %.1f%@", [[BaseBundle getInstance] getStringByKey:@"download_downloading" inTable:nil], progress, @"%"];
                    statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNUPDATED];
                    break;
                case BASE_TASK_STATUS_FINISH_SUCCESS:
                    strNotice = [[BaseBundle getInstance] getStringByKey:@"download_success" inTable:nil];
                    statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_DOWNLOADED];
                    break;
                case BASE_TASK_STATUS_FINISH_FAIL:
                    strNotice = [[BaseBundle getInstance] getStringByKey:@"download_fail" inTable:nil];
                    statusColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DOWNLOAD_STATUS_UNDOWNLOADED];
                    break;
                default:
                    break;
            }
            switch(taskType) {
                case BASE_TASK_TYPE_DOWNLOAD_ORG:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.departmentNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_SERVICE_TYPE:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.serviceTypeNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_LOCATION:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.locationNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_PRIORITY:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.priorityTypeNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_FLOW:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.workFlowNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_DEVICE:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.deviceNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_DEVICE_TYPE:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.deviceTypeNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_REQUIREMENT_TYPE:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.requirementTypeNew = NO;
                    }
                    break;
                case BASE_TASK_TYPE_DOWNLOAD_FAILURE_REASON_TYPE:
                    if(taskStatus == BASE_TASK_STATUS_FINISH_SUCCESS) {
                        _record.failureReasonNew = NO;
                    }
                    break;
                default:
                    break;
            }
            if(_record && ![_record isNewData]) {//如果数据都为最新的数据了就更新获取数据的时间
                [self hideLoadingDialog];
            }
        }
    }
}

- (void) updateBadge:(NSInteger) tabIndex desc:(NSString *) info {
    UITabBar *tabBar = self.tabBar;
//    if(tabIndex >= 0 && tabIndex < [tabBar.items count]) {
//        UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:tabIndex];
//        [tabBarItem setBadgeValue:info];
//    }
    [tabBar showBadgeOnItemIndex:tabIndex desc:info];
}


- (void) updateNotificationBadge:(NSNotification *) notification {
    NSNumber *tmpNumber = [notification object];
    NSNumber * userId = [SystemConfig getUserId];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    NSInteger count = 0;
    if(tmpNumber && [tmpNumber isKindOfClass:[NSNumber class]]) {
        count = tmpNumber.integerValue;
        if(count == 0) {
            count = [[NotificationDbHelper getInstance] queryAllNotificationUnReadBy:userId project:projectId];
        }
        NSString * badgeStr = nil;
        if(count > 0) {
            if(count < 100) {
                badgeStr = [[NSString alloc] initWithFormat:@"%ld", count];
            } else {
                badgeStr = @"99+";
            }
        }
        [BaseViewController updateAppBageIcon:count];
        [self updateBadge:0 desc:badgeStr];
    } else {
    }
}

//当项目切换时更新需要更新的数据
- (void) updateWhenProjectChanged {
    [self requestUserInfo]; //用户信息可能会变
    [self requestFunctionPermission];   //模块权限也可能会变
}

#pragma mark - 网络请求
//请求模块权限
- (void) requestFunctionPermission {
    [self resetFunction];
    [_powerBusiness requestPermissionListSuccess:^(NSInteger key, id object) {
        NSLog(@"权限请求成功");
        NSMutableArray * array = object;
        [_powerManager initPermissionWithFunctionKeyArray:array];
        [self notifyFunctionPermissionRequestSuccess];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"权限请求失败");
    }];
}

// 获取当前用户信息
- (void) requestUserInfo {
    [[UserBusiness getInstance] getCurrentUserInfoSuccess:^(NSInteger key, id object) {
        if(object) {
            UserInfo *user = object;
            [self saveUserInfo:user];
        }
    } fail:^(NSInteger key, NSError *error) {
        
    }];
}

/**
 获取离线基础数据更新
 */
- (void) requestBaseDataUpdateInfo {
    NSNumber *preRequestDate = [SystemConfig getPreRequestDate];
    [[CommonBusiness getInstance] getBaseDataUpdateRecordByTime:preRequestDate success:^(NSInteger key, id object) {
        _record = object;
        if([_record isNewData]) {
            [self tryToUpdateBaseData];
        }
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"数据获取失败");
    }];
}


- (void) saveUserInfo:(UserInfo*) newInfo {
    NSString* loginName = [SystemConfig getLoginName];
    newInfo.loginName = loginName;
    if(newInfo) {
        [[BaseDataDbHelper getInstance] saveUserInfo:newInfo];
    }
}

#pragma mark - 更新离线数据
- (void) tryToUpdateBaseData {
    DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"common_base_data_notice_need_update" inTable:nil] leftButtonTitle:nil rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] viewController:self];
    alertView.rightBlock = ^(){
        NSLog(@"现在更新");
        [self requestAllBaseInfo];
    };
    [alertView show];
}

- (void) requestAllBaseInfo {
    if(![[BaseDataDownloader getInstance] isDownloading]) {
        if(_record && ![_record isNewData]) { //如果数据都为最新的数据了就更新获取数据的时间
            DownloadRecord * downloadRecord = [[DownloadRecord alloc] initWithDataType:BASE_DATA_TYPE_ALL andPreRequestDate:_record.newestDate];
            BaseDataDbHelper *dbHelper = [BaseDataDbHelper getInstance];
            if([dbHelper isDownloadRecordExist:BASE_DATA_TYPE_ALL]) {
                [dbHelper updateDownloadRecordByType:BASE_DATA_TYPE_ALL downloadRecord:downloadRecord];
            } else {
                [dbHelper addDownloadRecord:downloadRecord projectId:[SystemConfig getCurrentProjectId]];
            }
            
        } else {
            [_downloader setTargetRecord:_record.newestDate];
            //下载工单相关基础数据
            [self showLoadingDialogwith:[[BaseBundle getInstance] getStringByKey:@"" inTable:nil]];
            [self requestBaseInfo];
        }
    }
    
}

- (void) requestBaseInfo {
    if([SystemConfig needShowOrder]) {
        if(!_record || _record.departmentNew) {
            [_downloader downloadOrgInfo];
        }
        if(!_record || _record.serviceTypeNew) {
            [_downloader downloadServiceTypeInfo];
        }
        if(!_record || _record.locationNew) {
            [_downloader downloadLocationInfo];
        }
        if(!_record || _record.priorityTypeNew) {
            [_downloader downloadPriorityInfo];
        }
        if(!_record || _record.workFlowNew) {
            [_downloader downloadFlowInfo];
        }
        if(!_record || _record.failureReasonNew) {
            [_downloader downloadFailureReasonInfo];
        }
    }
    //下载需求相关基础数据
    if([SystemConfig needShowRequirement]) {
        if(!_record || _record.requirementTypeNew) {
            [_downloader downloadRequirementTypeInfo];
        }
    }
    //下载资产相关基础数据
    if([SystemConfig needShowAsset]) {
        if(!_record || _record.deviceNew) {
            [_downloader downloadDeviceInfo];
        }
        if(!_record || _record.deviceTypeNew) {
            [_downloader downloadDeviceTypeInfo];
        }
    }
}



#pragma --- tabbar
- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    NSInteger curIndex = self.selectedIndex;
//    [self requestFunctionPermission];   //页面切换的时候去刷新模块权限设置
    
}

#pragma mark - login
- (void) onLoginSuccess:(Token *) token {
    NSLog(@"onSuccess --- %@", NSStringFromClass([self class]));
}

- (void) onLoginError:(NSError *)error {
    NSLog(@"error");
}

- (void) onLoginCancel {
    
}

#pragma mark - 对话框
//显示加载对话框
- (void) showLoadingDialog {
    if(!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = [[BaseBundle getInstance] getStringByKey:@"loading" inTable:nil];
    }
    [self.view addSubview:_hud];
    [_hud show:YES];
}

//显示加载对话框
- (void) showLoadingDialogwith:(NSString *) msg {
    if(!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.labelText = msg;
    }
    [self.view addSubview:_hud];
    [_hud show:YES];
}

//隐藏加载对话框
- (void) hideLoadingDialog {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - 提示权限更新
- (void) notifyFunctionPermissionRequestSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FunctionPermissionUpdate" object:nil];
}

@end
