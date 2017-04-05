//
//  ReservationViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/19.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ReservationViewController.h"
#import "PullTableView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "NetPage.h"
#import "ReserveBaseInfoView.h"
#import "WorkOrderWriteWarehouseNameView.h"
#import "WorkOrderDetailMaterialItemView.h"
#import "InfoSelectViewController.h"
#import "BaseDataEntity.h"
#import "ReservationMaterialViewController.h"
#import "DXAlertView.h"
#import "UIButton+Bootstrap.h"
#import "OnClickListener.h"
#import "SystemConfig.h"
#import "OnItemClickListener.h"
#import "CustomAlertView.h"
#import "OnMessageHandleListener.h"
#import "ReserveInventoryEntity.h"
#import "InventoryNetRequest.h"
#import "UserEntity.h"
#import "BaseDataDbHelper.h"
#import "InventoryBusiness.h"
#import "CaptionTextField.h"
#import "CaptionTextView.h"
#import "BaseLabelView.h"
#import "ReservationMaterialItemView.h"
#import "ReservationTableHelper.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "WarehouseEntity.h"
#import "UIButton+Bootstrap.h"
#import "WorkOrderBusiness.h"
#import "WorkTeamSupervisorEntity.h"

//数据选择类型
typedef NS_ENUM(NSInteger, ReservationInfoSelectType) {
    RESERVATION_INFO_SELECT_TYPE_UNKNOW,
    RESERVATION_INFO_SELECT_TYPE_ADMINISTRATOR, //选择仓库管理员
    RESERVATION_INFO_SELECT_TYPE_SUPERVISOR,    //选择主管
};

@interface ReservationViewController () <OnViewResizeListener, OnClickListener, OnItemClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) UIView * controlView;//
@property (readwrite, nonatomic, strong) UIButton * okBtn;//预定按钮

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;


@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat controlHeight; //
@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, strong) NSNumber * warehouseId; //仓库ID
@property (readwrite, nonatomic, strong) NSMutableArray * materials;
@property (readwrite, nonatomic, strong) WarehouseEntity * warehouse;
@property (readwrite, nonatomic, assign) NSInteger curAdministrator;


@property (readwrite, nonatomic, strong) NSString * userName;
@property (readwrite, nonatomic, strong) NSNumber * reserveTime;

@property (readwrite, nonatomic, strong) NSMutableArray * supervisorArray;
@property (readwrite, nonatomic, assign) NSInteger curSupervisor;

@property (readwrite, nonatomic, strong) NSMutableArray * infoArray;
@property (readwrite, nonatomic, strong) NetPage * mPage;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSString * woCode;

@property (readwrite, nonatomic, strong) InventoryBusiness * business;

@property (readwrite, nonatomic, strong) ReservationTableHelper * helper;

@property (readwrite, nonatomic, assign) ReservationInfoSelectType selectType; //选择类型
@property (readwrite, nonatomic, assign) ReservationMaterialOperateType operateType;
@property (readwrite, nonatomic, assign) NSInteger currentIndex;

@end

@implementation ReservationViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory_reserve" inTable:nil]];
    [self setBackAble:YES];
    
    UIImage *addImage = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
    [self setMenuWithArray:@[addImage]];
}


- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [InventoryBusiness getInstance];
        _helper = [[ReservationTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _controlHeight = [FMSize getInstance].btnBottomControlHeight + [FMSize getInstance].padding20;  //
        _btnHeight = [FMSize getInstance].btnBottomControlHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight-_controlHeight)];
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = _helper;
        _tableView.dataSource = _helper;
        
        CGFloat padding = [FMSize getInstance].padding20;
        
    
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, _realHeight-_controlHeight, _realWidth, _controlHeight)];
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(padding, 0, _realWidth-padding * 2, _btnHeight)];
        [_okBtn addTarget:self action:@selector(onOKButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_btn_reserve" inTable:nil] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [FMFont getInstance].font44;
        [_okBtn successStyle];
        
        _datePicker = [[BaseTimePicker alloc] init];
        [_datePicker setOnItemClickListener:self];
        
        _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_datePicker setPickerType:BASE_TIME_PICKER_DAY];

        [_controlView addSubview:_okBtn];
        
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_controlView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initAlertView {
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


- (void) initData {
    _mPage = [[NetPage alloc] init];
    _userName = [SystemConfig getLoginName];
    _reserveTime = [FMUtils getTimeLongNow];
    _curAdministrator = 0;  //默认显示第一个
    _curSupervisor = 0;
    
    NSInteger userId = [[SystemConfig getOauthFM] getUserInfo].userId;
    NSString * userName;
    UserInfo * user = [[BaseDataDbHelper getInstance] queryUserById:[NSNumber numberWithInteger:userId]];
    if(user) {
        userName = user.name;
        if([FMUtils isStringEmpty:userName]) {
            userName = user.loginName;
        }
        if(!userName) {
            userName = @"";
        }
        _userName = userName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
    [self initAlertView];
    [self updateInfo];
    [self requestSupervisors];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self tryToAddMaterial];
    }
}

- (NSString *) getReserveTimeDesc {
    NSDate * date = [FMUtils timeLongToDate:_reserveTime];
    NSString * res = [FMUtils getDayStr:date];
    return res;
}

- (void) updateInfo {
    [_helper setApplicant:_userName];
    [_helper setDate:[self getReserveTimeDesc]];
    
    if(_warehouse) {
        [_helper setWarehouseName:_warehouse.name];
        if(_curAdministrator >= 0 && _curAdministrator < [_warehouse.administrator count]) {
            WarehouseAdministrator * admin = _warehouse.administrator[_curAdministrator];
            [_helper setAdministrator:admin.name];
        }
    }
    if(_supervisorArray) {
        if(_curSupervisor >= 0 && _curSupervisor < [_supervisorArray count]) {
            WorkTeamSupervisorEntity * supervisor = _supervisorArray[_curSupervisor];
            [_helper setSupervisor:supervisor.name];
        }
    }
    [_tableView reloadData];
}



- (void) showTimeSelectDialog{
    
    NSDate * curDate = nil;
        if(![FMUtils isNumberNullOrZero:_reserveTime]) {
            curDate = [FMUtils timeLongToDate:_reserveTime];
        } else
        {
            curDate = [NSDate date];
        }

    NSNumber *tmp = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:tmp];
    
    [_alertView showType:@"time"];
    [_alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updateList {
    [_tableView reloadData];
}

- (void) setInfoWithWorkOrderId:(NSNumber *) woId code:(NSString *) woCode {
    _woId = [woId copy];
    _woCode = [woCode copy];
}

- (void) tryToAddMaterial {
    if(_warehouseId) {
        [self gotoAddMaterial];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}
- (void) tryToDeleteMaterial:(NSInteger) position {
    if(position >= 0 && position < [_materials count]) {
        DXAlertView* alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        alert.leftBlock = ^() {
            [self deleteMaterial:position];
        };
        alert.rightBlock = ^() {
            
        };
        alert.dismissBlock = ^() {
        };
        [alert show];
    }
}

- (void) deleteMaterial:(NSInteger) position {
    if(position >= 0 && position < [_materials count]) {
        [_materials removeObjectAtIndex:position];
        [_helper setDataWithArray:_materials];
        [self updateList];
    }
}

- (void) tryToReserveMaterials {
    if(_materials && [_materials count] > 0) {
        [self requestReserveMaterial];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (ReserveInventoryRequestParam *) getReservationParam {
    ReserveInventoryRequestParam * param = [[ReserveInventoryRequestParam alloc] init];
    param.userId = [SystemConfig getEmployeeId];
//    param.date = _reserveTime;
//    param.desc = [_helper getDesc];
    param.date = [FMUtils getTimeLongNow];
    param.desc = nil;
    param.warehouseId = _warehouseId;
    param.woId = _woId;
    param.woCode = _woCode;
    
    WarehouseAdministrator * admin = _warehouse.administrator[_curAdministrator];
    param.administrator = admin.administratorId;
    
    WorkTeamSupervisorEntity * supervisor = _supervisorArray[_curSupervisor];
    param.supervisor = supervisor.supervisorId;
    
    for(NSDictionary * dic in _materials) {
        InventoryReserveEntity * material = [[InventoryReserveEntity alloc] init];
        material.inventoryId = [dic valueForKeyPath:@"inventoryId"];
        NSNumber * bookAmount = [dic valueForKeyPath:@"reserveAmount"];
        material.amount = [[NSString alloc] initWithFormat:@"%.2f", bookAmount.doubleValue];
        [param.materials addObject:material];
    }
    return param;
}

#pragma mark - 网络请求

//请求主管信息列表
- (void) requestSupervisors {
    WorkOrderBusiness * business = [WorkOrderBusiness getInstance];
    NSNumber * emId = [SystemConfig getEmployeeId];
    [business getWorkGroupSupervisors:emId success:^(NSInteger key, id object) {
        _supervisorArray = object;
        [self updateInfo];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"获取主管信息失败");
    }];
}

- (void) requestReserveMaterial {
    [self showLoadingDialog];
    ReserveInventoryRequestParam * param = [self getReservationParam];
    
    [_business requestReserve:param success:^(NSInteger key, id object) {
        NSLog(@"库存预约成功");
        [self notifyReservationUpdate];
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"库存预约失败");
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (void) notifyReservationUpdate {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMReservationStatusUpdate" object:nil];
}

#pragma --- 点击
- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onOKButtonClicked {
    [self tryToReserveMaterials];
}

#pragma --- 备注高度改变
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
//    if(view == _baseInfoView) {
//        CGRect frame = _baseInfoView.frame;
//        frame.size = newSize;
//        _baseInfoView.frame = frame;
//        [self updateLayout];
//    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    _reserveTime = time;
                    [self updateInfo];
                    
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}

#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"InfoSelectViewController"]) {
            NSNumber * tmpNumber;
            NSInteger requestType;
            tmpNumber = [msg valueForKeyPath:@"requestType"];
            requestType = [tmpNumber integerValue];
            switch(requestType) {
                case REQUEST_TYPE_WAREHOUSE_INFO_SELECT:
                    _warehouse = [msg valueForKeyPath:@"result"];
                    _warehouseId = _warehouse.warehouseId;
                    _curAdministrator = 0;
                    [self updateInfo];
                    break;
                case REQUEST_TYPE_COMMON_INFO_SELECT:
                    if(_selectType == RESERVATION_INFO_SELECT_TYPE_ADMINISTRATOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _curAdministrator = tmpNumber.integerValue;
                            [self updateInfo];
                        }
                    } else if(_selectType == RESERVATION_INFO_SELECT_TYPE_SUPERVISOR) {
                        NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
                        if(result) {
                            tmpNumber = [result valueForKeyPath:@"position"];
                            _curSupervisor = tmpNumber.integerValue;
                            [self updateInfo];
                        }
                    }
                    break;
            }
        } else if([msgOrigin isEqualToString:@"WriteOrderAddMaterialViewController"]) {
//            [_materialPage reset];
//            [self requestMaterials];
        } else if([msgOrigin isEqualToString:@"ReservationMaterialViewController"]) {
            NSMutableDictionary * material = [msg valueForKeyPath:@"result"];
            if(!_materials) {
                _materials = [[NSMutableArray alloc] init];
            }
            if(_operateType == RESERVATION_MATERIAL_OPERATE_TYPE_ADD) {
                [_materials addObject:material];
            } else if(_operateType == RESERVATION_MATERIAL_OPERATE_TYPE_EDIT) {
                _materials[_currentIndex] = material;
            }
            [_helper setDataWithArray:_materials];
            [self updateInfo];
        } else if([msgOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            InventoryReservationEventType eventType = tmpNumber.integerValue;
            switch(eventType) {
                case INVENTORY_RESERVATION_EVENT_SELECT_WAREHOUSE:
                    if(_warehouse && _materials && [_materials count] > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        });
                    } else {
                        [self gotoSelectWarehouse];
                    }
                    break;
                case INVENTORY_RESERVATION_EVENT_SELECT_ADMINISTRATOR:
                    [self gotoSelectAdministrator];
                    break;
                case INVENTORY_RESERVATION_EVENT_SELECT_SUPERVISOR:
                    [self gotoSelectSupervisor];
                    break;
//                case INVENTORY_RESERVATION_EVENT_SELECT_DATE:
//                    [self showTimeSelectDialog];
//                    break;
                case INVENTORY_RESERVATION_EVENT_EDIT_MATERIAL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoEditMaterial:tmpNumber.integerValue];
                    break;
                case INVENTORY_RESERVATION_EVENT_DELETE_MATERIAL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self tryToDeleteMaterial:tmpNumber.integerValue];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - 界面跳转
//选择仓库
- (void) gotoSelectWarehouse {
    NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"selectAll", nil];
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//添加物料
- (void) gotoAddMaterial {
    _operateType = RESERVATION_MATERIAL_OPERATE_TYPE_ADD;
    ReservationMaterialViewController * addVC = [[ReservationMaterialViewController alloc] initWithRequestType:RESERVATION_MATERIAL_OPERATE_TYPE_ADD];
    
    [addVC setInfoWithWorkOrderId:nil];
    [addVC setInfoWithWarehouse:_warehouseId];
    [addVC setInfoWithMaterials:_materials];
    [addVC setOnMessageHandleListener:self];
    [self gotoViewController:addVC];
}

//编辑物料
- (void) gotoEditMaterial:(NSInteger) position {
    _operateType = RESERVATION_MATERIAL_OPERATE_TYPE_EDIT;
    _currentIndex = position;
    ReservationMaterialViewController * editVC = [[ReservationMaterialViewController alloc] initWithRequestType:RESERVATION_MATERIAL_OPERATE_TYPE_EDIT];
    NSMutableDictionary * material = _materials[position];
    [editVC setInfoWithWorkOrderId:nil];
    [editVC setInfoWithWarehouse:_warehouseId];
    [editVC setInfoWithMaterials:_materials];
    [editVC setMaterial:material];
    [editVC setOnMessageHandleListener:self];
    [self gotoViewController:editVC];
}

//选择仓库管理员
- (void) gotoSelectAdministrator {
    if(_warehouse) {
        if([_warehouse.administrator count] > 1) {  //只有超过一个的时候允许选择
            _selectType = RESERVATION_INFO_SELECT_TYPE_ADMINISTRATOR;
            NSMutableArray * data = [[NSMutableArray alloc] init];
            NSString * desc =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil];;
            for(WarehouseAdministrator * admin in _warehouse.administrator) {
                [data addObject:admin.name];
            }
            NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, @"data", desc, @"desc", nil];
            InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_COMMON_INFO_SELECT andParam:param];
            [vc setOnMessageHandleListener:self];
            [self gotoViewController:vc];
        }
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    NSLog(@"选择仓库管理员");
}

//选择审批主管
- (void) gotoSelectSupervisor {
    NSLog(@"选择审批主管");
    if([_supervisorArray count] > 1) {  //只有超过一个的时候允许选择
        _selectType = RESERVATION_INFO_SELECT_TYPE_SUPERVISOR;
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
    
}

@end
