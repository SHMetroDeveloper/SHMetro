//
//  ReservationDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationDetailViewController.h"
#import "InventoryBusiness.h"
#import "BaseBundle.h"
#import "ReservationDetailEntity.h"
#import "ReservationDetailTableHelper.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "TaskAlertView.h"
#import "MenuAlertContentView.h"
#import "OperateReservationEntity.h"
#import "InventoryDeliveryContentView.h"
#import "WorkOrderDetailViewController.h"
#import "InventoryDeliveryMaterialDetailViewController.h"
#import "InventoryDeliveryEntity.h"
#import "CommonAlertContentView.h"
#import "IQKeyboardManager.h"
#import "InfoSelectViewController.h"
#import "UserBusiness.h"
#import "SystemConfig.h"
#import "WorkOrderBusiness.h"
#import "WorkTeamSupervisorEntity.h"

typedef NS_ENUM(NSInteger, InventoryReservationSelectType) {
    INVENTORY_RESERVATION_SELECT_TYPE_UNKNOW,
    INVENTORY_RESERVATION_SELECT_TYPE_RESERVE_PERSON,
    INVENTORY_RESERVATION_SELECT_TYPE_ADMINISTRATOR,
    INVENTORY_RESERVATION_SELECT_TYPE_SUPERVISOR,
    INVENTORY_RESERVATION_SELECT_TYPE_RECEIVING_PERSON
};

@interface ReservationDetailViewController () <OnMessageHandleListener, OnClickListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) TaskAlertView *alertView; //弹出框
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度

@property (readwrite, nonatomic, strong) CommonAlertContentView *approvalContentView;  //审批
@property (readwrite, nonatomic, strong) CommonAlertContentView *cancelDeliveryView;   //取消出库
@property (readwrite, nonatomic, strong) CommonAlertContentView *cancelReservationView;   //取消预订
@property (readwrite, nonatomic, strong) InventoryDeliveryContentView * deliveryContentView;

@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;   //事件处理

@property (readwrite, nonatomic, assign) BOOL readonly;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSNumber * reservationId;

@property (readwrite, nonatomic, strong) __block ReservationDetailEntity * entity;
@property (readwrite, nonatomic, assign) NSInteger curIndex;

@property (readwrite, nonatomic, strong) NSMutableDictionary *batchCostDict;
@property (readwrite, nonatomic, strong) NSMutableDictionary *batchAmountDict;

@property (readwrite, nonatomic, strong) NSMutableArray * batchArray;
@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, assign) InventoryReservationSelectType selectType;

@property (readwrite, nonatomic, strong) InventoryBusiness * business;
@property (readwrite, nonatomic, strong) UserBusiness * userBusiness;

//预订人
@property (readwrite, nonatomic, strong) __block NSMutableArray *personArray;
@property (readwrite, nonatomic, assign) __block NSInteger currentPerson;

//管理员
@property (readwrite, nonatomic, strong) __block NSMutableArray *warehouseArray;
@property (readwrite, nonatomic, strong) __block NSMutableArray *administratorArray;
@property (readwrite, nonatomic, assign) __block NSInteger currentAdministrator;

//主管
@property (readwrite, nonatomic, strong) __block NSMutableArray *supervisorArray;
@property (readwrite, nonatomic, assign) __block NSInteger  currentSupervisor;

//领用人
@property (readwrite, nonatomic, strong) __block NSMutableArray *receivingPersonArray;
@property (readwrite, nonatomic, assign) __block NSInteger currentReceivingPerson;

@property (readwrite, nonatomic, strong) ReservationDetailTableHelper * helper;

@property (readwrite, nonatomic, strong) __block NetPage * warehousePage;

@property (readwrite, nonatomic, assign) __block BOOL canCancel;        //允许取消预定
@property (readwrite, nonatomic, assign) __block BOOL canEditOperator;   //允许编辑操作人

@property (readwrite, nonatomic, assign) __block BOOL requestingDetail; //是否在请求预定详情
@property (readwrite, nonatomic, assign) __block BOOL requestingAdministrator; //是否在请求管理员
@property (readwrite, nonatomic, assign) __block BOOL requestingPersonReserving; //是否在请求预定人
@property (readwrite, nonatomic, assign) __block BOOL requestingSupervisor; //是否在请求主管

@end

@implementation ReservationDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_reserve_detail" inTable:nil]];
    [self setBackAble:YES];
    
    NSMutableArray * menus = [[NSMutableArray alloc] init];
    NSNumber * emId = [SystemConfig getEmployeeId];
    if(!_readonly) {
        if(_entity) {
            switch(_entity.status) {
                case RESERVATION_STATUS_TYPE_UNCHECK:
                    if(_entity.supervisor && [_entity.supervisor isEqualToNumber:emId]) {   //主管可以审批待审批预定单
                        menus = [[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_detail_operation_approval" inTable:nil], nil];
                    }
                    break;
                case RESERVATION_STATUS_TYPE_ACCEPTED:
                    if(_entity.administrator && [_entity.administrator isEqualToNumber:emId]) {   //只有选择的仓库管理员才能进行出库等操作
                        menus = [[NSMutableArray alloc] initWithObjects:[[FMTheme getInstance] getImageByName:@"menu_more"], nil];
                    }
                    break;
                case RESERVATION_STATUS_TYPE_REFUSE:
                    break;
            }
        }
    } else {
        if (_canCancel) {
            if(_entity.status == RESERVATION_STATUS_TYPE_UNCHECK) {
                [menus addObject: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_cancel_reservation" inTable:nil]];
            }
        }
        if (_canEditOperator) {
            if(_entity.status == RESERVATION_STATUS_TYPE_UNCHECK) {
                [menus addObject:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil]];
            }
        }
    }
    [self setMenuWithArray:menus];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
            [manager.disabledDistanceHandlingClasses addObject:[self class]];
        }
        
        _business = [InventoryBusiness getInstance];
        _userBusiness = [UserBusiness getInstance];
        _warehousePage = [[NetPage alloc] init];
        
        _personArray = [NSMutableArray new];
        _administratorArray = [NSMutableArray new];
        _warehouseArray = [NSMutableArray new];
        _supervisorArray = [NSMutableArray new];
        
        _currentSupervisor = -1;
        
        _helper = [[ReservationDetailTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        if (!_batchCostDict) {
            _batchCostDict = [NSMutableDictionary new];
        }
        
        if (!_batchAmountDict) {
            _batchAmountDict = [NSMutableDictionary new];
        }
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.delaysContentTouches = NO;
        
        _tableView.delegate = _helper;
        _tableView.dataSource = _helper;
        
        _approvalContentView = [[CommonAlertContentView alloc] init];
        [_approvalContentView setTitleWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_approval_title" inTable:nil]];
        [_approvalContentView setOperationButtonTextArray:[NSMutableArray arrayWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_detail_operation_approval_cancel" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_detail_operation_approval_ok" inTable:nil], nil]];
        [_approvalContentView setEditLabelWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_approval_desc_placeholder" inTable:nil]];
        [_approvalContentView setOnItemClickListener:self];
        
        _cancelDeliveryView = [[CommonAlertContentView alloc] init];
        [_cancelDeliveryView setTitleWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_cancel_title" inTable:nil]];
        [_cancelDeliveryView setOperationButtonTextArray:[NSMutableArray arrayWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil]];
        [_cancelDeliveryView setEditLabelWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_approval_desc_placeholder" inTable:nil]];
        [_cancelDeliveryView setOnItemClickListener:self];
        
        _cancelReservationView = [[CommonAlertContentView alloc] init];
        [_cancelReservationView setTitleWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_cancel_reservation" inTable:nil]];
        [_cancelReservationView setOperationButtonTextArray:[NSMutableArray arrayWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil]];
        [_cancelReservationView setEditLabelWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_approval_desc_placeholder" inTable:nil]];
        [_cancelReservationView setOnItemClickListener:self];
        
        _deliveryContentView = [[InventoryDeliveryContentView alloc] init];
        [_deliveryContentView setTitleWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_delivery_title" inTable:nil]];
        [_deliveryContentView setOnItemClickListener:self];
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        
        [_mainContainerView addSubview:_tableView];
        
        [self.view addSubview:_mainContainerView];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    [self requestData];
    if(_canEditOperator) {
        [self requestPersonList];
        [self requestWarehouseList];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateHandlerInfo];
    }
}

- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void) initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat contentHeight = 300;
    CGFloat commontHeight = 250;
    
    [_alertView setContentView:_approvalContentView withKey:@"approval" andHeight:(commontHeight)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    [_alertView setContentView:_cancelDeliveryView withKey:@"cancelDelivery" andHeight:(commontHeight)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    [_alertView setContentView:_cancelReservationView withKey:@"cancellations" andHeight:(commontHeight)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    [_alertView setContentView:_deliveryContentView withKey:@"delivery" andHeight:(contentHeight)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:(contentHeight + 40)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


- (void) onMenuItemClicked:(NSInteger)position {
    if(!_readonly) {
        switch (_entity.status) {
            case RESERVATION_STATUS_TYPE_UNCHECK:
                [self showApprovalControl];
                break;
            case RESERVATION_STATUS_TYPE_ACCEPTED:
                [self showDeliveryControl];
                break;
            default:
                break;
        }
    } else {
        if(position == 0 && [self canCancel]) { //如果是取消预定
            NSNumber * emId = [SystemConfig getEmployeeId];
            if(([emId isEqualToNumber:_entity.reservationPersonId])) {
                [self showCancellations];
            }
        } else {    //否则就是 编辑操作人
            [self requestEditHandler];
        }
    }
}

- (void) onMenuDeliverClicked {
    [_alertView close];
    [self requestDelivery];
//    [self showDeliveryControl];
}

- (void) onMenuCancelDeliverClicked {
    [self showCancelDeliveryControl];
}

//判断是否允许编辑
- (BOOL) canEditHandler {
    BOOL res = NO;
    if (_canEditOperator && _entity.status == RESERVATION_STATUS_TYPE_UNCHECK) {
        res = YES;
    }
    return res;
}

#pragma mark - 显示菜单
- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers{
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_alertView setContentHeight:height withKey:@"menu"];
    [_alertView showType:@"menu"];
    [_alertView show];
}

//展示审批操作界面
- (void) showApprovalControl {
    [_alertView showType:@"approval"];
    [_alertView show];
}

//展示取消预订操作界面
- (void) showCancellations {
    [_alertView showType:@"cancellations"];
    [_alertView show];
}

//展示出库操作界面
- (void) showDeliveryControl {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_stock_out" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"inventory_btn_cancel" inTable:nil], nil];
    __weak id weakSelf = self;
    ActionHandler deliveryHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuDeliverClicked];
    };
    ActionHandler cancelDeliveryHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuCancelDeliverClicked];
    };
    [self showControlWithMenuTexts:menus handlers:[[NSMutableArray alloc] initWithObjects:deliveryHandler, cancelDeliveryHandler, nil]];
}

//展示取消出库操作界面
- (void) showCancelDeliveryControl {
    [_alertView showType:@"cancelDelivery"];
    [_alertView show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) setInfoWithReservationId:(NSNumber *) reservationId {
    _reservationId = reservationId;
}

- (void) setReadonly:(BOOL) readonly {
    _readonly = readonly;
}

- (void) setCanEditHandler:(BOOL) can {
    _canEditOperator = can;
}

- (void) setCanCancelReservation:(BOOL) can {
    _canCancel = can;
}



//可以出库
- (BOOL) canDeliveried {
    BOOL res = !_readonly && _entity && _entity.status == RESERVATION_STATUS_TYPE_ACCEPTED;
    return res;
}

- (void) updateList {
    if([self canDeliveried]) {   //待出库
        [_helper setReservationType:INVENTORY_RESERVATION_DETAIL_TYPE_DELIVERY];
    } else {
        [_helper setReservationType:INVENTORY_RESERVATION_DETAIL_TYPE_RESERVE];
    }
    [_tableView reloadData];
}

- (void) updateHandlerInfo {
    if (_canEditOperator && _personArray && _currentPerson >= 0 && _currentPerson < _personArray.count) {
        SimpleUserEntity *user = _personArray[_currentPerson];
        [_helper setInfoWithReservePerson:user.name];
    } else if(_entity.reservationPersonId) {
        [_helper setInfoWithReservePerson:_entity.reservationPersonName];
    } else {
        [_helper setInfoWithReservePerson:nil];
    }
    
    if(_entity.administrator) {
        [_helper setInfoWithAdministrator:_entity.administratorName];
    } else if (_canEditOperator && _administratorArray && _currentAdministrator >= 0 && _currentAdministrator < _administratorArray.count) {
        WarehouseAdministrator *admin = _administratorArray[_currentAdministrator];
        [_helper setInfoWithAdministrator:admin.name];
    } else {
        [_helper setInfoWithAdministrator:nil];
    }
    
    if (_canEditOperator && _supervisorArray && _currentSupervisor >= 0 && _currentSupervisor < _supervisorArray.count) {
        WorkTeamSupervisorEntity * supervisor = _supervisorArray[_currentSupervisor];
        [_helper setInfoWithSupervisor:supervisor.name];
    } else if(_entity.supervisor) {
        [_helper setInfoWithSupervisor:_entity.supervisorName];
    }else {
        [_helper setInfoWithSupervisor:nil];
    }
    
    if (_receivingPersonArray && _currentReceivingPerson >= 0 && _currentReceivingPerson < _receivingPersonArray.count) {
        SimpleUserEntity * user = _receivingPersonArray[_currentReceivingPerson];
        [_helper setInfoWithReceivingPerson:user.name];
    } else {
        [_helper setInfoWithReceivingPerson:nil];
    }
    [self updateList];
}

- (void) initBatchArray {
    if(_entity && [_entity.materials count] > 0) {
        if(!_batchArray) {
            _batchArray = [[NSMutableArray alloc] init];
        } else {
            [_batchArray removeAllObjects];
        }
        for(NSInteger index = 0; index < [_entity.materials count];index++) {
            [_batchArray addObject:[[NSMutableArray alloc] init]];
        }
    }
}

#pragma mark - 处理推送过来的数据
- (void) handleNotification {
    if(self.baseVcParam) {
        _reservationId = [self.baseVcParam valueForKeyPath:@"reservationId"];
        [self requestData];
    }
}

- (NSNumber *) getAmountOfBatch:(NSMutableArray *) batchs {
    NSNumber * count = 0;
    double sum = 0;
    for(InventoryDeliveryMaterialBatchEntity * batch in batchs) {
        sum += batch.amount.doubleValue;
    }
    count = [NSNumber numberWithDouble:sum];
    return count;
}

#pragma mark - 网络请求
- (void) tryToShowDialog {
    if(!_requestingDetail && !_requestingAdministrator && !_requestingPersonReserving && !_requestingSupervisor) {
        [self showLoadingDialog];
    }
}

//试着关闭加载框
- (void) tryToCloseDialog {
    if(!_requestingDetail && !_requestingAdministrator && !_requestingPersonReserving && !_requestingSupervisor) {
        [self hideLoadingDialog];
    }
}
//请求预定详情
- (void) requestData {
//    [self showLoadingDialog];
    if(_business) {
        [self tryToShowDialog];
        _requestingDetail = YES;
        GetReservationDetailRequestParam * param = [[GetReservationDetailRequestParam alloc] initWith:_reservationId];
        __weak typeof(self) weakSelf = self;
        [_business getReservationDetail:param success:^(NSInteger key, id object) {
            weakSelf.entity = object;
            [weakSelf initBatchArray];
            [weakSelf.helper setInfoWith:weakSelf.entity];
            [weakSelf updateTitle];
            [weakSelf updateHandlerInfo];
            weakSelf.requestingDetail = NO;
            [weakSelf tryToCloseDialog];
            if(_canEditOperator) {
                [weakSelf requestSupervisors];
            }
        } fail:^(NSInteger key, NSError *error) {
            weakSelf.entity = nil;
            [weakSelf updateList];
            weakSelf.requestingDetail = NO;
            [weakSelf tryToCloseDialog];
        }];
    }
}

//审核通过
- (void) requestApprovalOK {
    if(_business) {
        [self showLoadingDialog];
        ReservationApprovalRequestParam * param = [self getReservationParam];
        param.type = RESERVATION_OPERATION_TYPE_PASS;
        [_business requestApprovalRerservation:param success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_approval_pass_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self notifyReservationNeedUpdate];
            [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_approval_pass_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
}

//驳回
- (void) requestApprovalCancel {
    if ([FMUtils isStringEmpty:[_approvalContentView getDesc]]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_approval_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        if(_business) {
            [self showLoadingDialog];
            ReservationApprovalRequestParam * param = [self getReservationParam];
            param.type = RESERVATION_OPERATION_TYPE_REFUSE;
            [_business requestApprovalRerservation:param success:^(NSInteger key, id object) {
                [self hideLoadingDialog];
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_approval_refuse_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                [self notifyReservationNeedUpdate];
                [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            } fail:^(NSInteger key, NSError *error) {
                [self hideLoadingDialog];
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_approval_refuse_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }];
        }
    }
}

//预定出库
- (void) requestDelivery {
    if(_business) {
        __weak typeof(self) weakSelf = self;
        InventoryDeliveryParam *param = [self getDeliveryParam];
        if([param.inventory count] > 0) {
            if(param.administrator) {
                if(param.receivingPersonId) {
                    [weakSelf showLoadingDialog];
                    [_business requestDelivery:param success:^(NSInteger key, id object) {
                        [weakSelf notifyReservationNeedUpdate];
                        [weakSelf hideLoadingDialog];
                        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
                    } fail:^(NSInteger key, NSError *error) {
                        [weakSelf hideLoadingDialog];
                        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_delivery_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    }];
                } else {
                    [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_receiving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                }
            } else {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_delivery_receive_amount" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

//请求取消出库
- (void) requestCancelDelivery {
    if(_business) {
        ReservationApprovalRequestParam * param = [self getCancelDeliveryParam];
        if(![FMUtils isStringEmpty:param.desc]) {
            [self showLoadingDialog];
            [_business requestApprovalRerservation:param success:^(NSInteger key, id object) {
                [self notifyReservationNeedUpdate];
                [self hideLoadingDialog];
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_cancel_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
            } fail:^(NSInteger key, NSError *error) {
                [self hideLoadingDialog];
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_cancel_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_cancel_delivery_reason" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

//取消预订
- (void)requestCancelReservation {
    ReservationApprovalRequestParam *param = [self getCancelReservationParam];
    if(![FMUtils isStringEmpty:param.desc]) {
        __weak typeof(self) weakSelf = self;
        [weakSelf showLoadingDialog];
        [_business requestApprovalRerservation:param success:^(NSInteger key, id object) {
            [weakSelf notifyReservationNeedUpdate];
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_cancel_reservation_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_cancel_reservation_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_cancel_reservation_reason" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

//请求员工信息列表
- (void) requestPersonList {
    __weak typeof(self) weakSelf = self;
    [self tryToShowDialog];
    _requestingPersonReserving = YES;
    [_userBusiness getUsersOfCurrentProjectSuccess:^(NSInteger key, id object) {
        weakSelf.personArray = [object copy];
        weakSelf.receivingPersonArray = [object copy];
        weakSelf.currentPerson = -1;
        weakSelf.currentReceivingPerson = -1;
        weakSelf.requestingPersonReserving = NO;
        [weakSelf tryToCloseDialog];
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.personArray = nil;
        weakSelf.receivingPersonArray = nil;
        weakSelf.currentPerson = -1;
        weakSelf.currentReceivingPerson = -1;
        weakSelf.requestingPersonReserving = NO;
        [weakSelf tryToCloseDialog];
    }];
}

//请求主管信息列表
- (void) requestSupervisors {
    NSNumber * emId = nil;
    
    _supervisorArray = nil;
    _currentSupervisor = -1;
    WorkOrderBusiness * business = [WorkOrderBusiness getInstance];
    if(_personArray && _currentPerson >= 0 && _currentPerson < [_personArray count]) {   //如果选择了预定人
        SimpleUserEntity * user = _personArray[_currentPerson];
        emId = user.emId;
    } else if(_entity && _entity.reservationPersonId) {    //如果已经有预定人
        emId = _entity.reservationPersonId;
    }
    if(emId) {
        __weak typeof(self) weakSelf = self;
        [self tryToShowDialog];
        _requestingSupervisor = YES;
        [business getWorkGroupSupervisors:emId success:^(NSInteger key, id object) {
            weakSelf.supervisorArray = object;
            [weakSelf updateHandlerInfo];
            weakSelf.requestingSupervisor = NO;
            [weakSelf tryToCloseDialog];
        } fail:^(NSInteger key, NSError *error) {
            weakSelf.supervisorArray = nil;
            [weakSelf updateHandlerInfo];
            weakSelf.requestingSupervisor = NO;
            [weakSelf tryToCloseDialog];
        }];
    }
}

- (void) updateAdministratorInfo  {
    _administratorArray = nil;
    for (WarehouseEntity *wareHouse in _warehouseArray) {
        if ([wareHouse.warehouseId isEqualToNumber:_entity.warehouseId]) {
            _administratorArray = wareHouse.administrator;
            break;
        }
    }
}

//获取仓库列表信息，以便于获得每个仓库的管理员
- (void) requestWarehouseList {
    [self tryToShowDialog];
    _requestingAdministrator = YES;
    NSNumber *emId = nil;   //选择所有仓库
//    __block NetPage *mPage = [[NetPage alloc] init];
    InventoryGetWarehouseParam *param = [[InventoryGetWarehouseParam alloc] initWith:_warehousePage employeeId:emId];
    __weak typeof(self) weakSelf = self;
    [_business getWarehouseList:param success:^(NSInteger key, id object) {
        InventoryGetWarehouseResponseData *data = object;
//        [mPage setPage:data.page];
        [weakSelf.warehousePage setPage:data.page];
        if ([weakSelf.warehousePage isFirstPage]) {
            weakSelf.warehouseArray = data.contents;
        } else {
            [weakSelf.warehouseArray addObjectsFromArray:data.contents];
        }
        if ([weakSelf.warehousePage haveMorePage]) {
            [weakSelf.warehousePage nextPage];
            [weakSelf requestWarehouseList];
        } else {
            [weakSelf updateAdministratorInfo];
            [weakSelf updateHandlerInfo];
            weakSelf.requestingAdministrator = NO;
            [weakSelf tryToCloseDialog];
        }
        
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.requestingAdministrator = NO;
        [weakSelf tryToCloseDialog];
    }];
}

//请求编辑操作人
- (void) requestEditHandler {
    EditReservationHandlerParam * param = [self getReservationHandlerEditParam];
    if(param.activityId) {
        if(param.administrator) {
            if(param.reservePerson) {
                if(param.supervisor) {
                    [self showLoadingDialog];
                    __weak typeof(self) weakSelf = self;
                    [_business requestEditReservationHandler:param success:^(NSInteger key, id object) {
                        [weakSelf hideLoadingDialog];
                        [weakSelf notifyReservationNeedUpdate];
                        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_edit_handler_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    } fail:^(NSInteger key, NSError *error) {
                        [weakSelf hideLoadingDialog];
                        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_edit_handler_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                    }];
                } else {
                    [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_supervisor" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                }
            } else {
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_reserving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_administrator" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (EditReservationHandlerParam *) getReservationHandlerEditParam {
    EditReservationHandlerParam * param = [[EditReservationHandlerParam alloc] init];
    param.activityId = _entity.activityId;
    param.administrator = [self getAdministratorId];
    param.supervisor = [self getSupervisorId];
    param.reservePerson = [self getReservePersonId];
    return param;
}

- (ReservationApprovalRequestParam *) getReservationParam {
    ReservationApprovalRequestParam * param = [[ReservationApprovalRequestParam alloc] init];
    param.activityId = _entity.activityId;
    param.desc = [_approvalContentView getDesc];
    return param;
}

//获取所选仓库管理员ID
- (NSNumber *) getAdministratorId {
    NSNumber * res = nil;
    if(_administratorArray && _currentAdministrator >= 0 && _currentAdministrator < [_administratorArray count]) {
        WarehouseAdministrator * admin = _administratorArray[_currentAdministrator];
        res = [admin.administratorId copy];
    } else if(_entity.administrator) {
        res = [_entity.administrator copy];
    }
    return res;
}

//获取所选主管ID
- (NSNumber *) getSupervisorId {
    NSNumber * res = nil;
    if(_supervisorArray && _currentSupervisor >= 0 && _currentSupervisor < [_supervisorArray count]) {
        WorkTeamSupervisorEntity * supervisor = _supervisorArray[_currentSupervisor];
        res = supervisor.supervisorId;
    } else if(_entity.supervisor) {
        res = _entity.supervisor;
    }
    return res;
}

//获取所选预定人ID
- (NSNumber *) getReservePersonId {
    NSNumber * res = nil;
    if(_personArray && _currentPerson >= 0 && _currentPerson < [_personArray count]) {
        SimpleUserEntity * user = _personArray[_currentPerson];
        res = user.emId;
    } else if(_entity.reservationPersonId) {
        res = _entity.reservationPersonId;
    }
    return res;
}

//获取所选领用人ID
- (NSNumber *) getReceivingPersonId {
    NSNumber * res = nil;
    if(_receivingPersonArray && _currentReceivingPerson >= 0 && _currentReceivingPerson < [_receivingPersonArray count]) {
        SimpleUserEntity * user = _receivingPersonArray[_currentReceivingPerson];
        res = user.emId;
    }
    return res;
}

//出库参数
- (InventoryDeliveryParam *) getDeliveryParam {
    InventoryDeliveryParam * param = [[InventoryDeliveryParam alloc] init];
    param.type = INVENTORY_DELIVERY_TYPE_RESERVED;
    
    param.activityId = _entity.activityId;
    param.warehouseId = _entity.warehouseId;
    param.targetWarehouseId = nil;
    param.administrator = [self getAdministratorId];
    param.supervisor = [self getSupervisorId];
    param.receivingPersonId = [self getReceivingPersonId];
    
    NSInteger index = 0;
    for(MaterialEntity * obj in _entity.materials) {
        InventoryDeliveryMaterialEntity * material = [[InventoryDeliveryMaterialEntity alloc] init];
        material.inventoryId = [obj.inventoryId copy];
        if(index >= 0 && index < [_batchArray count]) {
            NSMutableArray * batchArray = _batchArray[index];
            material.batch = batchArray;
            if([batchArray count] > 0) {    //如果预定的有批次
                [param.inventory addObject:material];
            }
            index ++;
        }
    }
    return param;
}

//取消出库参数
- (ReservationApprovalRequestParam *) getCancelDeliveryParam {
    ReservationApprovalRequestParam * param = [[ReservationApprovalRequestParam alloc] init];
    param.type = RESERVATION_OPERATION_TYPE_CANCEL;
    param.activityId = _entity.activityId;
    param.desc = [_cancelDeliveryView getDesc];
    return param;
}

//取消预订参数
- (ReservationApprovalRequestParam *) getCancelReservationParam {
    ReservationApprovalRequestParam *param = [[ReservationApprovalRequestParam alloc] init];
    param.type = RESERVATION_OPERATION_TYPE_CANCELLATION;  //取消预订
    param.activityId = _entity.activityId;
    param.desc = [_cancelReservationView getDesc];
    return param;
}

#pragma mark --- 点击事件
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _approvalContentView) {
        [self retractKeyboard];
        [_alertView close];
        if(subView) {
            CommonAlertContentOperateType type = subView.tag;
            switch(type) {
                case COMMON_ALERT_OPERATE_TYPE_LEFT:
                    [self requestApprovalCancel];
                    break;
                case COMMON_ALERT_OPERATE_TYPE_RIGHT:
                    [self requestApprovalOK];
                    break;
                default:
                    break;
            }
        }
    } else if(view == _cancelDeliveryView) {
        [self requestCancelDelivery];
    } else if(view == _cancelReservationView) {
        [self requestCancelReservation];
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
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
                    [_alertView close];
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSMutableDictionary * data = [result valueForKeyPath:@"eventData"];
            InventoryReservationDetailEventType type = tmpNumber.integerValue;
            NSInteger position;
            switch (type) {
                case INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ORDER:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    position = tmpNumber.integerValue;
                    [self gotoOrderDetail:position];
                    break;
                case INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_RESERVEPERSON:
                    if([self canEditHandler] && _personArray && [_personArray count] > 1) {
                        [self gotoSelectReservePerson];
                    }
                    break;
                
                case INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ADMINISTRATOR:
                    if([self canEditHandler]) {
                        [self gotoSelectAdministrator];
                    }
                    break;
                
                case INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_SUPERVISOR:
                    if([self canEditHandler]) {
                        NSNumber * emId = [self getReservePersonId];
                        if(emId) {
                            if(_supervisorArray && [_supervisorArray count] > 0) {
                                if([_supervisorArray count] > 1) {
                                    [self gotoSelectSupervisor];
                                }
                            } else {
                                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_no_supervisor" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                            }
                        } else {
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_reserving_person" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        }
                    }
                    break;
                case INVENTORY_RESERVATION_DETAIL_EVENT_SELECT_RECEIVING_PERSON:
                    if(!_readonly && _receivingPersonArray && [_receivingPersonArray count] > 0) {
                        [self gotoSelectReceivingPerson];
                    }
                    break;
                    
                case INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_MATERIAL:
                    [self gotoMaterialDetail:data];
                    break;
                default:
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([InventoryDeliveryMaterialDetailViewController class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            _batchCostDict = [result valueForKeyPath:@"cost"];  // batchID : "batchPrice"

            NSMutableDictionary *amountDic = [result valueForKeyPath:@"amount"]; // batchID : "batchNumber"
            for (NSString *key in amountDic) {
                NSNumber *amount = [amountDic valueForKeyPath:key];
                [_batchAmountDict setValue:amount forKeyPath:key];
            }
            
            InventoryDeliveryMaterialDetailEventType eventType = [tmpNumber integerValue];
            NSMutableArray * batchs;
            MaterialEntity * material;
            switch (eventType) {
                case INVENTORY_DELIVERY_MATERIAL_DETAIL_EVENT_OK:
                    batchs = [result valueForKeyPath:@"eventData"];
                    material = _entity.materials[_curIndex];
                    if(!_batchArray) {
                        _batchArray = [[NSMutableArray alloc] init];
                    }
                    _batchArray[_curIndex] = [batchs copy];
                    [_helper setAmount:[self getAmountOfBatch:batchs] forMaterialAtPosition:_curIndex];
                    [_helper setRealCost:[self getSelectBatchCostBy:_batchCostDict andAmount:_batchAmountDict]];
                    _needUpdate = YES;
                    break;
                    
                default:
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            NSNumber *tmpNumber;
            switch (requestType) {
                    case REQUEST_TYPE_COMMON_INFO_SELECT:
                    if (_selectType == INVENTORY_RESERVATION_SELECT_TYPE_RESERVE_PERSON) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentPerson = tmpNumber.integerValue;
                            _needUpdate = YES;
                            
                            [self requestSupervisors];
                        }
                    } else if (_selectType == INVENTORY_RESERVATION_SELECT_TYPE_ADMINISTRATOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentAdministrator = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if (_selectType == INVENTORY_RESERVATION_SELECT_TYPE_SUPERVISOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentSupervisor = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    } else if (_selectType == INVENTORY_RESERVATION_SELECT_TYPE_RECEIVING_PERSON) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _currentReceivingPerson = tmpNumber.integerValue;
                            _needUpdate = YES;
                        }
                    }
                    break;
            }
        }
    }
}


- (NSString *)getSelectBatchCostBy:(NSDictionary *)costDict andAmount:(NSDictionary *)amount {
    double cost = 0;
    for(NSString *key in amount) {
        NSNumber *tmpNumber = [amount valueForKeyPath:key];
        NSString *pirce = [costDict valueForKeyPath:key];
        
        cost += tmpNumber.doubleValue * pirce.doubleValue;
    }
    NSString *costStr = [NSString stringWithFormat:@"%0.2f",cost];
    return costStr;
}

//通知更新预定列表
- (void) notifyReservationNeedUpdate {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMReservationStatusUpdate" object:nil];
}

#pragma mark - 键盘的显示与隐藏
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        CGFloat statusBarHeight = 20;
        [_alertView moveToTopWithHeight:keyboardSize.height andPadding:statusBarHeight];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if(![_alertView isHidden]) {
        [_alertView reset];
    }
}



#pragma mark --- 工单详情
- (void) gotoOrderDetail:(NSInteger) position {
    NSNumber * woId = [_helper getOrderIdByPosition:position];
    if(woId) {
        
        NSLog(@"The VS are like %@",self.navigationController.viewControllers);
        UIViewController *targetVC = nil;
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[WorkOrderDetailViewController class]]) {
                targetVC = viewController;
                break;
            }
        }
        if (!targetVC) {
            WorkOrderDetailViewController * vc = [[WorkOrderDetailViewController alloc] init];
            [vc setWorkOrderWithId:woId];
            [vc setReadOnly:YES];
            [self gotoViewController:vc];
        } else {
            [self.navigationController popToViewController:targetVC animated:YES];
        }
        
//        NSLog(@"The VC are like %@",self.navigationController.viewControllers);
        
//        WorkOrderDetailViewController * vc = [[WorkOrderDetailViewController alloc] init];
//        [vc setWorkOrderWithId:woId];
//        [vc setReadOnly:YES];
//        [self gotoViewController:vc];
    }
}

- (void) gotoMaterialDetail:(NSMutableDictionary *) data {
    if([self canDeliveried]) {
        InventoryDeliveryMaterialDetailViewController * vc = [[InventoryDeliveryMaterialDetailViewController alloc] init];
        ReservationMaterial * material = [data valueForKeyPath:@"material"];
        NSNumber * tmpNumber = [data valueForKeyPath:@"position"];
        _curIndex = tmpNumber.integerValue;
        NSMutableArray * batchs = _batchArray[_curIndex];
        if([self canDeliveried]) {   //只有待出库的预订单才允许编辑出库数量
            [vc setReadOnly:NO];
        } else {
            [vc setReadOnly:YES];
        }
        [vc setInfoWithReservationMaterial:material batch:batchs];
        [vc setInfoWithRealCost:_batchCostDict];
//        [vc setInfoWithBatchNumber:_batchAmountDict];
        [vc setOnMessageHandleListener:self];
        [vc setOperationType:INVENTORY_DELIVERY_MATERIAL_TYPE_RESERVATION];
        [self gotoViewController:vc];
    }
}

- (void) gotoSelectReservePerson {
    _selectType = INVENTORY_RESERVATION_SELECT_TYPE_RESERVE_PERSON;
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *desc = [[BaseBundle getInstance] getStringByKey:@"inventory_reservation_person" inTable:nil];
    for(SimpleUserEntity *user in _personArray) {
        [data addObject:user.name];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController *vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
    
}



- (void) gotoSelectAdministrator {
    _selectType = INVENTORY_RESERVATION_SELECT_TYPE_ADMINISTRATOR;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
    
    for(WarehouseAdministrator * admin in _administratorArray) {
        [data addObject:admin.name];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

- (void) gotoSelectSupervisor {
    _selectType = INVENTORY_RESERVATION_SELECT_TYPE_SUPERVISOR;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_supervisor" inTable:nil];;
    for(WorkTeamSupervisorEntity * supervisor in _supervisorArray) {
        [data addObject:supervisor.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
    
}

- (void) gotoSelectReceivingPerson {

    _selectType = INVENTORY_RESERVATION_SELECT_TYPE_RECEIVING_PERSON;
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_receive_person" inTable:nil];;
    for(SimpleUserEntity * user in _receivingPersonArray) {
        [data addObject:user.name];
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
    
}

@end
