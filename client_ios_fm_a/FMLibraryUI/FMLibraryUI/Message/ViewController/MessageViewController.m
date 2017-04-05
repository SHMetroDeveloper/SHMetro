//
//  MessageViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MessageViewController.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "NotificationItemView.h"
#import "SeperatorView.h"
#import "TaskAlertView.h"
#import "FastEntryAlertContentView.h"
#import "QrCodeViewController.h"
#import "PatrolSpotViewController.h"
#import "PulsingHaloLayer.h"
#import "ProjectsViewController.h"
#import "NotificationDbHelper.h"
#import "WorkOrderDetailViewController.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "MaintenanceDetailViewController.h"
#import "ProjectExchangeView.h"
#import "ImageItemView.h"
#import "NewRequirementViewController.h"
#import "EquipmentDetailViewController.h"
#import "BulletinDetailViewController.h"
#import "ReservationDetailViewController.h"
#import "InventoryMaterialDetailViewController.h"

//#import "SWTableViewCell.h"
#import "FMMessageTableViewCell.h"

#import "TaskAlertView.h"
#import "MenuAlertContentView.h"

#import "NewReportViewController.h"
#import "NotificationBusiness.h"
#import "NotificationServerConfig.h"
#import "MessageListViewController.h"
#import "PowerManager.h"
#import "ReportFunctionPermission.h"
#import "ContractDetailViewController.h"

#import "MessageTableView.h"

typedef void (^ActionHandler) (UIAlertAction * action);

@interface MessageViewController ()<OnClickListener,OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) MessageTableView *tableView;

@property (readwrite, nonatomic, strong) ProjectExchangeView * exchangeView;  //项目切换

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度
@property (readwrite, nonatomic, assign) CGFloat noticeImgHeight;   //提示图标高度

@property (readwrite, nonatomic, strong) TaskAlertView * infoView;
@property (readwrite, nonatomic, assign) CGFloat infoViewHeight;

@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;   //事件处理

@property (readwrite, nonatomic, assign) BOOL isWorking;    //是否正在处理任务

@property (readwrite, nonatomic, strong) NSMutableArray * orderMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * patrolMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * maintenanceMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * assetMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * inventoryMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * contractMsgArray;
@property (readwrite, nonatomic, strong) NSMutableArray * bulletinMsgArray;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat msgItemHeight;

@property (readwrite, nonatomic, strong) NSString * projectName;
@property (readwrite, nonatomic, assign) NSInteger lastTabIndex;    //上次的 tabIndex
@property (readwrite, nonatomic, assign) NSInteger curUnReadMsgIndex;
@property (readwrite, nonatomic, strong) NotificationBusiness * business;

@property (readwrite, nonatomic, strong) PowerManager * manager;
//消息处理
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation MessageViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
//    NSMutableArray * menus = [[NSMutableArray alloc] init];
    if([self canReport]) {
//        UIImage * imageReport = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
//        [menus addObject:imageReport];
//        [self setMenuWithArray:menus];
    } else {
        [self setMenuWithArray:nil];
    }
    
    [self initBackView];
    _projectName = [SystemConfig getCurrentProjectName];
    CGFloat backWidth = [ProjectExchangeView calculateWidthBy:_projectName];
    [_exchangeView setInfoWithName:_projectName];
    [self setBackBarWithView:_exchangeView andbackWidth:backWidth];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFunctionPermissionUpdateHandler];
    [self initProjectExchangeHandler];
    [self initBusiness];
    [self initLayout];
    [self notifyNotificationNeedUpdate];
    [self initAlertView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
//    [self requestMessageData];
    [self notifyNotificationNeedUpdate];
}

- (void) initBackView {
    if(!_exchangeView) {
        _exchangeView = [[ProjectExchangeView alloc] init];
    }
}

- (void) initBusiness {
    _manager = [PowerManager getInstance];
    _business = [NotificationBusiness getInstance];
}

- (void) initProjectExchangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CurrentProjectChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateCurrentProject:)
                                                 name: @"CurrentProjectChanged"
                                               object: nil];
}

- (void) initFunctionPermissionUpdateHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FunctionPermissionUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateFunctionPermission)
                                                 name: @"FunctionPermissionUpdate"
                                               object: nil];
}

- (void) dealloc {
    NSLog(@"dealloc --- %@", NSStringFromClass([self class]));
}

- (void) updateCurrentProject:(NSNotification *) notification {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        CGRect frame = [self getContentFrame];
        CGFloat tabHeight = [FMSize getInstance].tabbarHeight;
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame) - tabHeight;
        _infoViewHeight = CGRectGetHeight(self.view.frame);
        _msgItemHeight = [FMSize getInstance].msgItemHeight;
        _projectName = [SystemConfig getCurrentProjectName];
        _noticeHeight = [FMSize getInstance].msgNoticeHeight;
        _noticeImgHeight = [FMSize getInstance].msgNoticeLogoHeight;
        _lastTabIndex = -1;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2 , _realWidth, _noticeHeight)];
        [_noticeLbl setLogoWidth:_noticeImgHeight];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"message_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"notice_no_msg"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"notice_no_msg"]];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:_noticeLbl];
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initAlertView {
    _infoView = [[TaskAlertView alloc] init];
    [_infoView setFrame:CGRectMake(0, 0, _realWidth, _infoViewHeight)];
    [_infoView setHidden:YES];
    [_infoView setOnClickListener:self];
    [self.view addSubview:_infoView];
    
    CGFloat contentHeight = 300;
    
    _menuContentView = [[MenuAlertContentView alloc] init];
    [_menuContentView setOnMessageHandleListener:self];
    
    [_infoView setContentView:_menuContentView withKey:@"menu" andHeight:(contentHeight + 40)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (MessageTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.delaysContentTouches = YES;
        [_tableView setEditable:NO];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        __weak typeof(self) weakSelf = self;
        __weak typeof(_tableView) weakTableView = _tableView;
        _tableView.actionBlock = ^(NotificationEntity *notificationEntity, NotificationItemType notificationType){
            //跳转
            switch(notificationType) {
                case NOTIFICATION_ITEM_TYPE_ORDER:
                    [weakSelf gotoHandleOrderMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_PATROL:
                    [weakSelf gotoHandlePatrolMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_ASSET:
                    [weakSelf gotoHandleAssetMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
                    [weakSelf gotoHandlePlannedMaintenanceMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_REQUIREMENT:
                    [weakSelf gotoHandleRequirementMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_INVENTORY:
                    [weakSelf gotoHandleInventoryMsg:notificationEntity];
                    break;
                case NOTIFICATION_ITEM_TYPE_CONTRACT:
                    [weakSelf gotoHandleContractMsg:notificationEntity];
                    break;
                
                case NOTIFICATION_ITEM_TYPE_BULLETION:
                    [weakSelf gotoHandleBulletin:notificationEntity];
                    break;
                    
                default:
                    break;
            }
        };
        
        _tableView.editBlock = ^(NotificationEditType editType, NSIndexPath *indexPath, NotificationEntity *msg){
            switch (editType) {
                case NOTIFICATION_EDIT_TYPE_READ:
                    [weakSelf markMsgRead:msg];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NOTIFICATION_EDIT_TYPE_DELETE:
                    [weakSelf deleteMsgBy:indexPath type:msg.type];
                    break;
                case NOTIFICATION_EDIT_TYPE_MORE:
                    [weakSelf showMoreMenu];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
            }
        };
        
        _tableView.moreBlock = ^(NotificationItemType type) {
            [weakSelf gotoShowMoreMsg:type];
        };
    }
    return _tableView;
}

- (void) onBackButtonPressed {
    [self onProjectExchangeBtnClicked];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self gotoReport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 判断是否有报障模块权限
- (BOOL) canReport {
    BOOL res = YES;
//    FunctionPermission * permission = [_manager getFunctionPermissionByKey:REPORT_FUNCTION];
//    FunctionAccessPermissionType type = [permission getPermissionType];
//    if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
//        res = YES;
//    }
    return res;
}

- (void) initMsg {
    if (!_orderMsgArray) {
        _orderMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_orderMsgArray removeAllObjects];
    }
    if (!_patrolMsgArray) {
        _patrolMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_patrolMsgArray removeAllObjects];
    }
    if (!_maintenanceMsgArray) {
        _maintenanceMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_maintenanceMsgArray removeAllObjects];
    }
    if (!_assetMsgArray) {
        _assetMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_assetMsgArray removeAllObjects];
    }
    if (!_requirementMsgArray) {
        _requirementMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_requirementMsgArray removeAllObjects];
    }
    if (!_inventoryMsgArray) {
        _inventoryMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_inventoryMsgArray removeAllObjects];
    }
    if (!_contractMsgArray) {
        _contractMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_contractMsgArray removeAllObjects];
    }
    if (!_bulletinMsgArray) {
        _bulletinMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_bulletinMsgArray removeAllObjects];
    }
    [self updateList];
}


- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

//模块权限更新
- (void) updateFunctionPermission {
    [self updateTitle];
}

- (void) updateList {
    [self updateNotice];
    [self notifyUpdateTabBadge];
    
    [_tableView setOrderMsgArray:_orderMsgArray];
    [_tableView setPatrolMsgArray:_patrolMsgArray];
    [_tableView setMaintenanceMsgArray:_maintenanceMsgArray];
    [_tableView setAssetMsgArray:_assetMsgArray];
    [_tableView setRequirementMsgArray:_requirementMsgArray];
    [_tableView setInventoryMsgArray:_inventoryMsgArray];
    [_tableView setContractMsgArray:_contractMsgArray];
    [_tableView setBulletinMsgArray:_bulletinMsgArray];
    
    [_tableView reloadData];
}

- (void) updateNotice {
    if([_orderMsgArray count] == 0 && [_patrolMsgArray count] == 0 && [_maintenanceMsgArray count] == 0 && [_assetMsgArray count] == 0 && [_requirementMsgArray count] == 0 && [_inventoryMsgArray count] == 0 && [_contractMsgArray count] == 0 && [_bulletinMsgArray count] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

//请求消息记录
- (void) requestMessageData {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    
    if (!_orderMsgArray) {
        _orderMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_orderMsgArray removeAllObjects];
    }
    if (!_patrolMsgArray) {
        _patrolMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_patrolMsgArray removeAllObjects];
    }
    if (!_maintenanceMsgArray) {
        _maintenanceMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_maintenanceMsgArray removeAllObjects];
    }
    if (!_assetMsgArray) {
        _assetMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_assetMsgArray removeAllObjects];
    }
    if (!_requirementMsgArray) {
        _requirementMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_requirementMsgArray removeAllObjects];
    }
    if (!_inventoryMsgArray) {
        _inventoryMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_inventoryMsgArray removeAllObjects];
    }
    if (!_contractMsgArray) {
        _contractMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_contractMsgArray removeAllObjects];
    }
    if (!_bulletinMsgArray) {
        _bulletinMsgArray = [[NSMutableArray alloc] init];
    } else {
        [_bulletinMsgArray removeAllObjects];
    }
    
    
    NSMutableArray *dataArray = [dbHelper queryAllNotificationBy:userId];   //所有项目消息
    for (NotificationEntity *entity in dataArray) {
        if (!entity.deleted) {
            entity.itemHeight = [FMMessageTableViewCell calculateHeightByContent:entity.content andWidth:_realWidth paddingLeft:[FMSize getInstance].listHeaderHeight];
            switch(entity.type) {
                case NOTIFICATION_ITEM_TYPE_ORDER:
                    [_orderMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_PATROL:
                    [_patrolMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_ASSET:
                    [_assetMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
                    [_maintenanceMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_REQUIREMENT:
                    [_requirementMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_INVENTORY:
                    [_inventoryMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_CONTRACT:
                    [_contractMsgArray addObject:entity];
                    break;
                case NOTIFICATION_ITEM_TYPE_BULLETION:
                    [_bulletinMsgArray addObject:entity];
                    break;
            }
        }
    }
    [self updateList];
}


- (void) deleteMsgBy:(NSIndexPath *) index type:(NotificationItemType) type{
    NotificationEntity *msg;
    NSInteger position = index.row;
    
    switch (type) {
        case NOTIFICATION_ITEM_TYPE_ORDER:
            msg = _orderMsgArray[position];
            [_orderMsgArray removeObjectAtIndex:position];
            [_tableView setOrderMsgArray:_orderMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_PATROL:
            msg = _patrolMsgArray[position];
            [_patrolMsgArray removeObjectAtIndex:position];
            [_tableView setPatrolMsgArray:_patrolMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_ASSET:
            msg = _assetMsgArray[position];
            [_assetMsgArray removeObjectAtIndex:position];
            [_tableView setAssetMsgArray:_assetMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
            msg = _maintenanceMsgArray[position];
            [_maintenanceMsgArray removeObjectAtIndex:position];
            [_tableView setMaintenanceMsgArray:_maintenanceMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_REQUIREMENT:
            msg = _requirementMsgArray[position];
            [_requirementMsgArray removeObjectAtIndex:position];
            [_tableView setRequirementMsgArray:_requirementMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_INVENTORY:
            msg = _inventoryMsgArray[position];
            [_inventoryMsgArray removeObjectAtIndex:position];
            [_tableView setInventoryMsgArray:_inventoryMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_CONTRACT:
            msg = _contractMsgArray[position];
            [_contractMsgArray removeObjectAtIndex:position];
            [_tableView setMaintenanceMsgArray:_contractMsgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_BULLETION:
            msg = _bulletinMsgArray[position];
            [_bulletinMsgArray removeObjectAtIndex:position];
            [_tableView setBulletinMsgArray:_bulletinMsgArray];
            break;
        default:
            break;
    }
    if(msg) {
//        [self markMsgReadRemote:msg.msgId]; //向服务器发已读确认
        NSNumber *userId = [SystemConfig getUserId];
        [[NotificationDbHelper getInstance] deleteNotificationById:msg.msgId andUserId:userId];
        
        //异步操作，向服务器发送请求，删除该条消息
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MessageOperationDeleteRrequestParam *param = [[MessageOperationDeleteRrequestParam alloc] init];
            param.type = type;
            [param.messages addObject:msg.msgId];
            [_business markMessageDelete:param success:^(NSInteger key, id object) {
                NSLog(@"消息删除成功");
            } fail:^(NSInteger key, NSError *error) {
                NSLog(@"消息删除失败");
            }];
        });
        
        [self updateList];
    }
}


//把消息标记为已读
- (void) markMsgRead:(nullable NotificationEntity *) msg {
    if(msg && !msg.read) {
        msg.read = YES;
        NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
        NSNumber * userId = [SystemConfig getUserId];
        [dbHelper updateNotificationById:msg.msgId userId:userId notification:msg];
        [self notifyUpdateTabBadge];
        NSNumber * msgId = msg.msgId;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_business markMessageRead:msgId success:^(NSInteger key, id object) {
                [self notifyNotificationNeedUpdate];
                NSLog(@"消息确认成功");
            } fail:^(NSInteger key, NSError *error) {
                NSLog(@"消息确认失败");
            }];
        });
    }
    [self markMsgReadLocal:msg.msgId];
    [self markMsgReadRemote:msg.msgId];
    [self updateList];
}

- (void) allMessageReaded {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    [dbHelper markAllNotificationReadByUser:userId];
    [self requestMessageData];
    [self notifyUpdateTabBadge];
//    [BaseViewController updateAppBageIcon];
}

- (void) allMessageDelete {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    [dbHelper deleteAllNotificationByUser:userId];
    [self requestMessageData];
    [self notifyUpdateTabBadge];
//    [BaseViewController updateAppBageIcon];
}


- (void) showMoreMenu {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"message_controller_menu_allread" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"message_controller_menu_alldelete" inTable:nil], nil];
    __weak id weakSelf = self;
    ActionHandler allReadHandler = ^(UIAlertAction * action) {
        [weakSelf allMessageReaded];
    };
    ActionHandler allDeleteHandler = ^(UIAlertAction * action) {
        [weakSelf allMessageDelete];
    };
    
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:allReadHandler, allDeleteHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}


- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers{
    _isWorking = YES;
    [self hideTabBar];
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_infoView setContentHeight:height withKey:@"menu"];
    [_infoView showType:@"menu"];
    [_infoView show];
}

//更新本地数据库数据
- (void) markMsgReadLocal:(NSNumber *) msgId {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    [dbHelper markNotificationRead:msgId userId:userId];
}

//向服务器发请求
- (void) markMsgReadRemote:(NSNumber *) msgId {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_business markMessageRead:msgId success:^(NSInteger key, id object) {
            NSLog(@"消息确认成功");
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"消息确认失败");
        }];
    });
}

//处理工单消息
- (void) gotoHandleOrderMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    WorkOrderDetailViewController * orderVC;        //工单
    WorkOrderDetailViewController * orderHistoryVC;  //历史工单详情
    NSNumber * orderId;
    WorkOrderStatus orderStatus;
    orderId = msg.woId;
    orderStatus = msg.woStatus;
    switch(orderStatus) {
        case ORDER_STATUS_TERMINATE:
        case ORDER_STATUS_FINISH:
        case ORDER_STATUS_CLOSE:
        case ORDER_STATUS_VALIDATATION:
            orderHistoryVC = [[WorkOrderDetailViewController alloc] init];
            [orderHistoryVC setWorkOrderWithId:orderId];
            [orderHistoryVC setReadOnly:YES];
            [self gotoViewController:orderHistoryVC];
            break;
            
        default:
            orderVC = [[WorkOrderDetailViewController alloc] init];
            [orderVC setWorkOrderWithId:orderId];
            [self gotoViewController:orderVC];
            break;
    }
}


#pragma mark - 跳转（在用）
//报障
- (void) gotoReport {
    NewReportViewController *reportVC = [[NewReportViewController alloc] init];
//    NewReportViewController * reportVC = [[NewReportViewController alloc] init];
    [self gotoViewController:reportVC];
    
}

//处理巡检消息
- (void) gotoHandlePatrolMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    PatrolTaskUnFinishedViewController *patrolVC = [[PatrolTaskUnFinishedViewController alloc] init];
    [self gotoViewController:patrolVC];
}

//处理资产消息
- (void) gotoHandleAssetMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    NSNumber *assetId = msg.assetId;
    EquipmentDetailViewController *assetVC = [[EquipmentDetailViewController alloc] initWithEquipmentID:assetId];
    [self gotoViewController:assetVC];
}

//处理计划性维护消息
- (void) gotoHandlePlannedMaintenanceMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    NSNumber *maintenanceId = msg.pmId;
    NSNumber *todoId = msg.todoId;
    MaintenanceDetailViewController *maintenanceVC = [[MaintenanceDetailViewController alloc] init];
    [maintenanceVC setInfoWithPmId:maintenanceId todoId:todoId];
    [self gotoViewController:maintenanceVC];
}

//处理需求消息
- (void) gotoHandleRequirementMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    [self updateList];
}

//处理库存消息
- (void) gotoHandleInventoryMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    [self updateList];
    if(![FMUtils isNumberNullOrZero:msg.reservationId]) {   //预订单信息则进入预定详情
        ReservationDetailViewController * reservationVC = [[ReservationDetailViewController alloc] init];
        [reservationVC setInfoWithReservationId:msg.reservationId];
        [reservationVC setReadonly:NO];
        [reservationVC setCanEditHandler:YES];
        [self gotoViewController:reservationVC];
    } else if(![FMUtils isNumberNullOrZero:msg.inventoryId]) {  //物资信息，则进入物资详情
        InventoryMaterialDetailViewController * inventoryVC = [[InventoryMaterialDetailViewController alloc] init];
        [inventoryVC setInventoryId:msg.inventoryId];
        [self gotoViewController:inventoryVC];
    }
}
    
//处理合同消息
- (void) gotoHandleContractMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    NSNumber *contractId = msg.contractId;
    ContractDetailViewController *maintenanceVC = [[ContractDetailViewController alloc] init];
    [maintenanceVC setContractWithId:contractId];
    [self gotoViewController:maintenanceVC];
}

//阅读未读公告
- (void)gotoHandleBulletin:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    BulletinDetailViewController *bulletinVC = [[BulletinDetailViewController alloc] init];
    //此处有待完善，NotificationEntity模块需要加字段
    [bulletinVC setDataType:BULLETIN_DATA_TYPE_UNREAD];
    bulletinVC.bulletinId = msg.bulletinId;
    [self gotoViewController:bulletinVC];
}

- (void) resetWorking {
    if(_isWorking) {
        _isWorking = NO;
        [_infoView close];
        [self showTabBar];
    }
}


#pragma - mark 点击事件
- (void) onProjectExchangeBtnClicked{
    ProjectsViewController * projectsVC = [[ProjectsViewController alloc] initWithType:PROJECT_BACK_TYPE_BACK];
    [self gotoViewController:projectsVC];
}

#pragma mark - 点击代理
- (void) onClick:(UIView *)view {
    if(view == _infoView) {
        [self resetWorking];
    }
}


- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if(msgOrigin && [msgOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"menuType"];
            MenuAlertViewType type = [tmpNumber integerValue];
            NSInteger position;
            switch(type) {
                case MENU_ALERT_TYPE_NORMAL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    position = tmpNumber.integerValue;
                    if(position < [_actionHandlerArray count]) {
                        ActionHandler handler = _actionHandlerArray[position];
                        handler(nil);
                    }
                    break;
                case MENU_ALERT_TYPE_CANCEL:
                    break;
            }
            [_infoView close];
            [self showTabBar];
        }
    }
}


#pragma - mark 消息处理
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) listener {
    _handler = listener;
}

- (void) notifyUpdateTabBadge {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationBadgeUpdate" object:self];
//    [BaseViewController updateAppBageIcon];
}

#pragma - mark 跳转（废弃）
- (void) gotoAssetDetail:(NSString *) uuid {
    EquipmentDetailViewController *detailVC = [[EquipmentDetailViewController alloc] init];
    [detailVC setUuid:uuid];
    [self gotoViewController:detailVC];
}

- (void) gotoShowMoreMsg:(NotificationItemType) type {
    MessageListViewController * msgVC = [[MessageListViewController alloc] init];
    [msgVC setMsgType:type];
    [self gotoViewController:msgVC];
}

#pragma - mark 收到新的通知
- (void) didNotificationUpdated {
    [super didNotificationUpdated];
    [self requestMessageData];
}

@end
