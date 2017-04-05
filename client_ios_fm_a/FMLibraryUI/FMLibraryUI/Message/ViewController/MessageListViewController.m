//
//  MessageListViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/31/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageTableView.h"
#import "ImageItemView.h"
#import "TaskAlertView.h"
#import "MenuAlertContentView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "SystemConfig.h"
#import "NotificationDbHelper.h"
#import "WorkOrderDetailViewController.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "MaintenanceDetailViewController.h"
#import "EquipmentDetailViewController.h"
#import "ContractDetailViewController.h"
#import "NotificationBusiness.h"
#import "BulletinDetailViewController.h"
#import "ReservationDetailViewController.h"
#import "InventoryMaterialDetailViewController.h"
#import "BaseBundle.h"


@interface MessageListViewController () <OnClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) MessageTableView *tableView;


@property (readwrite, nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度
@property (readwrite, nonatomic, assign) CGFloat noticeImgHeight;   //提示图标高度

@property (readwrite, nonatomic, strong) TaskAlertView *infoView;
@property (readwrite, nonatomic, assign) CGFloat infoViewHeight;


@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;   //事件处理

@property (readwrite, nonatomic, strong) NSMutableArray * msgArray;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat msgItemHeight;

@property (readwrite, nonatomic, assign) BOOL isWorking;
@property (readwrite, nonatomic, strong) NotificationBusiness * business;

@property (readwrite, nonatomic, assign) NotificationItemType type;

@end

@implementation MessageListViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setMsgType:(NotificationItemType) type {
    _type = type;
}

- (void) initNavigation {
    NSString * title = @"";
    switch(_type) {
        case NOTIFICATION_ITEM_TYPE_ORDER:
            title = [[BaseBundle getInstance] getStringByKey:@"function_order" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_PATROL:
            title = [[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
            title = [[BaseBundle getInstance] getStringByKey:@"function_maintenance" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_ASSET:
            title = [[BaseBundle getInstance] getStringByKey:@"function_asset" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_REQUIREMENT:
            title = [[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_INVENTORY:
            title = [[BaseBundle getInstance] getStringByKey:@"function_inventory" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_CONTRACT:
            title = [[BaseBundle getInstance] getStringByKey:@"function_contract" inTable:nil];
            break;
        case NOTIFICATION_ITEM_TYPE_BULLETION:
            title = [[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil];
            break;
        default:
            break;
    }
    [self setTitleWith:title];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    [self requestMessageData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _infoViewHeight = CGRectGetHeight(self.view.frame);
        _msgItemHeight = [FMSize getInstance].msgItemHeight;
        _noticeHeight = [FMSize getInstance].msgNoticeHeight;
        _noticeImgHeight = [FMSize getInstance].msgNoticeLogoHeight;
        
        _business = [NotificationBusiness getInstance];
        
        _msgArray = [[NSMutableArray alloc] init];

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

#pragma mark - LazyLoad
- (MessageTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        [_tableView setShowHeader:NO];
        __weak typeof(self) weakSelf = self;
        __weak typeof(_tableView) weakTableView = _tableView;
        _tableView.actionBlock = ^(NotificationEntity *notificationEntity, NotificationItemType notificationType){
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
                    [weakSelf gotoHandleBulletinMsg:notificationEntity];
                    break;
                default:
                    break;
            }
        };
        
        _tableView.editBlock = ^(NotificationEditType editType, NSIndexPath *indexPath, NotificationEntity *msg){
            NSInteger position = indexPath.row;
            switch (editType) {
                case NOTIFICATION_EDIT_TYPE_READ:
                    [weakSelf markMsgRead:msg];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                case NOTIFICATION_EDIT_TYPE_DELETE:
                    [weakSelf deleteMsgBy:position];
                    break;
                case NOTIFICATION_EDIT_TYPE_MORE:
                    [weakSelf showMoreMenu];
                    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
            }
        };
        
    }
    return _tableView;
}

- (void) updateList {
    switch (_type) {
        case NOTIFICATION_ITEM_TYPE_ORDER:
            [_tableView setOrderMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_PATROL:
            [_tableView setPatrolMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:
            [_tableView setMaintenanceMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_ASSET:
            [_tableView setAssetMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_REQUIREMENT:
            [_tableView setRequirementMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_INVENTORY:
            [_tableView setInventoryMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_CONTRACT:
            [_tableView setContractMsgArray:_msgArray];
            break;
        case NOTIFICATION_ITEM_TYPE_BULLETION:
            [_tableView setBulletinMsgArray:_msgArray];
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
    
    [self updateNotice];
    [self notifyUpdateTabBadge];
}

- (void) updateNotice {
    if([_msgArray count] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (void) deleteMsgBy:(NSInteger) position {
    NotificationEntity * msg;

    msg = _msgArray[position];
    [_msgArray removeObjectAtIndex:position];
    
    if(msg) {
//        [self markMsgReadRemote:msg.msgId]; //向服务器发已读确认
        NSNumber *userId = [SystemConfig getUserId];
        [[NotificationDbHelper getInstance] deleteNotificationById:msg.msgId andUserId:userId];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MessageOperationDeleteRrequestParam *param = [[MessageOperationDeleteRrequestParam alloc] init];
            param.type = _type;
            [param.messages addObject:msg.msgId];
            [_business markMessageDelete:param success:^(NSInteger key, id object) {
                NSLog(@"%ld全部删除成功",_type);
                [self notifyNotificationNeedUpdate];
            } fail:^(NSInteger key, NSError *error) {
                NSLog(@"%ld全部删除失败",_type);
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
                NSLog(@"消息确认成功");
                [self notifyNotificationNeedUpdate];
            } fail:^(NSInteger key, NSError *error) {
                NSLog(@"消息确认失败");
            }];
        });
        for(NotificationEntity * tmsg in _msgArray) {
            if([tmsg.msgId isEqualToNumber:msgId]) {
                tmsg.read = YES;
                break;
            }
        }
        
    }
    [self markMsgReadLocal:msg.msgId];
    [self markMsgReadRemote:msg.msgId];
    [self updateList];
}

- (void) allMessageReaded {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    [dbHelper markAllNotificationReadByUser:userId andType:_type];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MessageOperationReadAllRrequestParam *param = [[MessageOperationReadAllRrequestParam alloc] init];
        param.type = _type;
        [_business markMessageReadAll:param success:^(NSInteger key, id object) {
            NSLog(@"%ld全部标记为已读成功",_type);
            [self notifyNotificationNeedUpdate];
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"%ld全部标记为已读失败",_type);
        }];
    });
//    [self requestMessageData];
//    [self notifyUpdateTabBadge];
//    [BaseViewController updateAppBageIcon];
}

- (void) allMessageDelete {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    [_msgArray removeAllObjects];
    [dbHelper deleteAllNotificationByUser:userId andType:_type];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MessageOperationDeleteRrequestParam *param = [[MessageOperationDeleteRrequestParam alloc] init];
        param.type = _type;
        param.messages = nil;
        [_business markMessageDelete:param success:^(NSInteger key, id object) {
            NSLog(@"%ld全部删除成功",_type);
            [self notifyNotificationNeedUpdate];
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"%ld全部删除失败",_type);
        }];
    });
//    [self requestMessageData];
//    [self notifyUpdateTabBadge];
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

- (void) notifyUpdateTabBadge {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationBadgeUpdate" object:self];
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
    NSNumber * orderId;
    WorkOrderStatus orderStatus;
    orderId = msg.woId;
    orderStatus = msg.woStatus;
    switch(orderStatus) {
        case ORDER_STATUS_TERMINATE:
        case ORDER_STATUS_FINISH:
        case ORDER_STATUS_CLOSE:
        case ORDER_STATUS_VALIDATATION:
            orderVC = [[WorkOrderDetailViewController alloc] init];
            [orderVC setWorkOrderWithId:orderId];
            [orderVC setReadOnly:YES];
            [self gotoViewController:orderVC];
            break;
            
        default:
            orderVC = [[WorkOrderDetailViewController alloc] init];
            [orderVC setWorkOrderWithId:orderId];
            [self gotoViewController:orderVC];
            break;
    }
}


#pragma mark - PushEvent

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

//查看公告消息
- (void) gotoHandleBulletinMsg:(NotificationEntity *) msg {
    [self markMsgRead:msg];
    BulletinDetailViewController *bulletinVC = [[BulletinDetailViewController alloc] init];
    bulletinVC.bulletinId = msg.bulletinId;
    [self gotoViewController:bulletinVC];
}

- (void) onClick:(UIView *)view {
    if(_isWorking) {
        _isWorking = NO;
        [_infoView close];
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
        }
    }
}

#pragma - mark 收到新的通知
- (void) didNotificationUpdated {
    [super didNotificationUpdated];
    [self requestMessageData];
}

- (void) requestMessageData {
    NotificationDbHelper * dbHelper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    NSMutableArray * array;
    _msgArray = [[NSMutableArray alloc] init];
//    if (NOTIFICATION_ITEM_TYPE_BULLETION == _type) { //如果是公告，就先去获取公司级公告
//        array = [dbHelper queryAllNotificationOfCompanyBy:userId];
//        [_msgArray addObjectsFromArray:array];
//    }
    array = [dbHelper queryAllNotificationByType:_type ofUser:userId];
    [_msgArray addObjectsFromArray:array];
    for(NotificationEntity * entity in _msgArray) {
        entity.itemHeight = [FMMessageTableViewCell calculateHeightByContent:entity.content andWidth:_realWidth paddingLeft:[FMSize getInstance].defaultPadding];
    }
    [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO];
}

@end
