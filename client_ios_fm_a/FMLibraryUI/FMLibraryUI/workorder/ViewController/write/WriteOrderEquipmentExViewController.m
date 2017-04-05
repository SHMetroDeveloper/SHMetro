//
//  WriteOrderEquipmentExViewController.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/3.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "WriteOrderEquipmentExViewController.h"
#import "BaseTextField.h"
#import "FMSize.h"
#import "FMColor.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "WorkOrderDetailEntity.h"
#import "UIButton+Bootstrap.h"
#import "CaptionTextField.h"
#import "CaptionTextView.h"
#import "WorkOrderBusiness.h"
#import "InfoSelectViewController.h"
#import "IQKeyboardManager.h"
#import "AssetManagementConfig.h"
#import "WorkOrderServerConfig.h"
#import "CaptionTextTableViewCell.h"
#import "OrderEquipmentEditTableHelper.h"
#import "TaskAlertView.h"
#import "BasePicker.h"
#import "BaseBundle.h"
#import "AssetManagementBusiness.h"
#import "EquipmentCoreComponentDetailViewController.h"
#import "WriteOrderEquipmentComponentReplaceViewController.h"
#import "AssetManagementBusiness.h"

@interface WriteOrderEquipmentExViewController () <OnClickListener, OnViewResizeListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) BasePicker * pickerView;
@property (nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, strong) NSString * failure;
@property (readwrite, nonatomic, strong) NSString * repair;
@property (nonatomic, assign) EquipmentStatus status;
@property (nonatomic, assign) OrderEquipmentRepairType repairType;
@property (readwrite, nonatomic, strong) NSNumber * equipmentId;
@property (readwrite, nonatomic, strong) NSNumber * woId;

@property (readwrite, nonatomic, strong) Device * equip;

@property (readwrite, nonatomic, strong) NSMutableArray * equipIds;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (nonatomic, strong) OrderEquipmentEditTableHelper * helper;
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) CGFloat defaultTextViewHeight;

@property (nonatomic, strong) NSString *titleName;

@property (readwrite, nonatomic, assign) WriteOrderEquipmentOperateType operateType;

@property (nonatomic, strong) NSMutableArray * componentArray;//核心组件数组
@property (nonatomic, strong) NSMutableDictionary * records;//本次更换记录
@property (nonatomic, assign) NSInteger curIndex;//当前修改的核心组件

@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * strStatusArray;
@property (nonatomic, strong) NSMutableArray * repairTypeArray;
@property (nonatomic, strong) NSMutableArray * strRepairTypeArray;


@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WriteOrderEquipmentExViewController

- (instancetype) initWithType:(WriteOrderEquipmentOperateType) type andTitleName:(NSString *) name {
    self = [super init];
    if(self) {
        _titleName = name;
        _operateType = type;
        
    }
    return self;
}

- (void) initNavigation {
    if (![FMUtils isStringEmpty:_titleName]) {
        [self setTitleWith:_titleName];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_equipment_add" inTable:nil]];
    }
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_tableView) {
        
        _defaultTextViewHeight = 174;
        
        _business = [[WorkOrderBusiness alloc] init];
        _helper = [[OrderEquipmentEditTableHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        if(_operateType == ORDER_EQUIPMENT_OPERATE_TYPE_EDIT) {
            [_helper setNeedShowNameAndCode:NO];
        } else {
            [_helper setNeedShowNameAndCode:YES];
        }
        
        
        CGRect frame = [self getContentFrame];
        
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.dataSource = _helper;
        _tableView.delegate = _helper;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delaysContentTouches = NO;
        
        [self.view addSubview:_tableView];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
    [self initAlertView];
    [self requestCoreComponents];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_needUpdate) {
        _needUpdate = NO;
        [self updateLayout];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self requestSaveInfo];
}

- (void) initAlertView {
    _pickerView = [[BasePicker alloc] init];
    [_pickerView setOnItemClickListener:self];
    _pickerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    CGFloat realWidth = CGRectGetWidth(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_pickerView withKey:@"picker" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}

- (void) updateLayout {
    if(_operateType == ORDER_EQUIPMENT_OPERATE_TYPE_ADD) {
        [_helper setNeedShowNameAndCode:YES];
    } else {
        [_helper setNeedShowNameAndCode:NO];
    }
    [self updateInfo];
}


- (void) updateInfo {
    if(_equip) {
        [_helper setInfoWithCode:_equip.code];
        [_helper setInfoWithName:_equip.name];
    }
    [_helper setInfoWithStatus:_status];
    [_helper setInfoWithRepairType:_repairType];
    [_helper setInfoWithFailureDesc:_failure];
    [_helper setInfoWithRepairDesc:_repair];
    
    [_tableView reloadData];
}

- (WorkOrderEquipment *) getInfoInput {
    WorkOrderEquipment * param = [[WorkOrderEquipment alloc] init];
    if(_operateType == ORDER_EQUIPMENT_OPERATE_TYPE_ADD) {
        param.woId = [_woId copy];
        param.equipmentId = [_equip.eqId copy];
        param.equipmentName = _equip.name;
        param.equipmentCode = _equip.code;
        param.failureDesc = [_helper getFailureDesc];
        param.repairDesc = [_helper getRepairDesc];
        param.equipmentStatus = _status;
        param.repairType = _repairType;
        return param;
    } else {
        param.woId = [_woId copy];
        param.equipmentId = [_equipmentId copy];
        param.failureDesc = [_helper getFailureDesc];
        param.repairDesc = [_helper getRepairDesc];
        param.equipmentStatus = _status;
        param.repairType = _repairType;
        return param;
    }
}

- (void) setInfoWith:(WorkOrderEquipment *) equip{
    _equipmentId = equip.equipmentId;
    _failure = equip.failureDesc;
    _repair = equip.repairDesc;
    
    _status = equip.equipmentStatus;
    _repairType = equip.repairType;
}

- (void) setWorkOrderId:(NSNumber *) woId {
    _woId = [woId copy];
}

- (void) setEquipmentArrayWithIds:(NSMutableArray *) ids {
    _equipIds = ids;
}

- (void) handleResult {
    if(_handler) {
        WorkOrderEquipment * item = [self getInfoInput];
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:item forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
    [self finish];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

#pragma mark --- 输入框 大小发生变化
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if([view isKindOfClass:[CaptionTextView class]]) {
        CGRect frame = view.frame;
        if(frame.size.width != newSize.width || frame.size.height != newSize.height) {
            frame.size = newSize;
            view.frame = frame;
            [self updateLayout];
        }
    }
}

#pragma marl - 网络上传
- (void) requestSaveInfo {
    WorkOrderEquipmentEditRequestParam * param = [self getEquipmentInfoParam];
    if(param.equipmentId) {
        if(_operateType == ORDER_EQUIPMENT_OPERATE_TYPE_ADD) {
            param.operateType = WORK_ORDER_EQUIPMENT_TYPE_ADD;
        } else {
            param.operateType = WORK_ORDER_EQUIPMENT_TYPE_MODIFY;
        }
        [self showLoadingDialog];
        [_business saveOrderEquipment:param success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_edit_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self handleResult];
            });
            
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_edit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_notice_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    
}
//获取核心组件操作记录
- (NSMutableArray *) getComponentsOperationRecords {
    NSMutableArray * res = [[NSMutableArray alloc] init];
    for (NSString * key in _records.allKeys) {
        id value = [_records valueForKeyPath:key];
        [res addObject:value];
    }
    return res;
}

- (WorkOrderEquipmentEditRequestParam *) getEquipmentInfoParam {
    WorkOrderEquipmentEditRequestParam * param = [[WorkOrderEquipmentEditRequestParam alloc] init];
    param.woId = _woId;
    if(_operateType == ORDER_EQUIPMENT_OPERATE_TYPE_ADD) {
        param.equipmentId = _equip.eqId;
    } else {
        param.equipmentId = _equipmentId;
    }
    param.equipmentStatus = _status;
    param.repairType = _repairType;
    
    param.failureDesc = [_helper getFailureDesc];
    param.repairDesc = [_helper getRepairDesc];
    
    //整改或更换保存核心组件
    if(_repairType == ORDER_EQUIPMENT_REPAIR_TYPE_RECTIFY || _repairType == ORDER_EQUIPMENT_REPAIR_TYPE_REPLACE) {
        param.operation = [self getComponentsOperationRecords];
    }
    
    return param;
}

//根据设备 ID 检查设备是否存在
- (BOOL) checkEquipmentExist:(NSNumber *) equipId {
    BOOL res = NO;
    for(NSNumber * obj in _equipIds) {
        if([obj isEqualToNumber:equipId]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (void) noticeEquipExist {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"report_equipment_exist" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    });
}

- (void) requestCoreComponents {
    AssetCoreComponentListParam *param = [[AssetCoreComponentListParam alloc] init];
    param.eqId = _equipmentId;
    if(param.eqId) {
        [[AssetManagementBusiness getInstance] getCoreComponentListByParam:param Success:^(NSInteger key, id object) {
            if(!_componentArray) {
                _componentArray = [[NSMutableArray alloc] init];
                _records = [[NSMutableDictionary alloc] init];
            } else {
                [_componentArray removeAllObjects];
                [_records removeAllObjects];
            }
            _componentArray = object;
            [_helper setInfoWithComponents:_componentArray];
            [_tableView reloadData];
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"请求失败");
            [_helper setInfoWithComponents:nil];
            [_tableView reloadData];
        }];
    }
}

#pragma mark - 点击事件处理
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[_pickerView class]]) {
        BasePickerActionType actionType = subView.tag;
        BOOL needUpdate = NO;
        if(actionType == BASE_PICKER_ACTION_OK) {
            
            OrderEquipmentEditEventType type = view.tag;
            NSInteger position;
            NSNumber * tmpNumber;
            switch(type) {
                case WO_EQUIPMENT_EDIT_EVENT_SELECT_STATUS:
                    position = [_pickerView getSelectedIndex];
                    tmpNumber = _statusArray[position];
                    _status = tmpNumber.integerValue;
                    [_helper setInfoWithStatus:_status];
                    needUpdate = YES;
                    break;
                case WO_EQUIPMENT_EDIT_EVENT_SELECT_REPAIR_TYPE:
                    position = [_pickerView getSelectedIndex];
                    tmpNumber = _repairTypeArray[position];
                    _repairType = tmpNumber.integerValue;
                    [_helper setInfoWithRepairType:_repairType];
                    needUpdate = YES;
                    break;
            }
            
        }
        [_alertView close];
        if(needUpdate) {
            [_tableView reloadData];
        }
    }
}

- (void) onClick:(UIView *)view  {
    if(view == _alertView) {
        [_alertView close];
    }
}

#pragma mark - 事件处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            InfoSelectRequestType requestType = [[msg valueForKeyPath:@"requestType"] integerValue];
            id result;
            switch (requestType) {
                case REQUEST_TYPE_DEVICE_INFO_SELECT:
                    result = [msg valueForKeyPath:@"result"];
                    if(result) {
                        _equip = result;
                        if([self checkEquipmentExist:_equip.eqId]) {
                            _equip = nil;
                            [self noticeEquipExist];
                        } else {
                            _needUpdate = YES;
                        }
                    }
                    break;
                default:
                    break;
            }
        } else if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            OrderEquipmentEditEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            NSNumber * tmpNumber;
            switch (eventType) {
                case WO_EQUIPMENT_EDIT_EVENT_SELECT_EQUIPMENT:
                    [self gotoSelectEquipment];
                    break;
                case WO_EQUIPMENT_EDIT_EVENT_SELECT_STATUS:
                    NSLog(@"选择状态");
                    [self gotoSelectStatus];
                    break;
                case WO_EQUIPMENT_EDIT_EVENT_SELECT_REPAIR_TYPE:
                    [self gotoSelectRepairType];
                    break;
                case WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_DETAIL:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoComponentDetail:tmpNumber.integerValue];
                    break;
                case WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_REPAIR:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [_tableView reloadData];
                    [self gotoReplaceComponent:tmpNumber.integerValue];
                    break;
                default:
                    break;
            }
        } else if ([strOrigin isEqualToString:NSStringFromClass([WriteOrderEquipmentComponentReplaceViewController class])]) {
            id result = [msg valueForKeyPath:@"result"];
            if(result) {
                WorkOrderEquipmentOperationRecord * record = result;
                AssetCoreComponentListEntity * component = _componentArray[_curIndex];
                component.code = record.code;
                component.name = record.name;
                record.fromEqCoreId = component.eqCoreId;
                NSString * key = [[NSString alloc] initWithFormat:@"%lld", component.eqCoreId.longLongValue];
                [_records setValue:record forKeyPath:key];
                
                _componentArray[_curIndex] = component;
                [_helper setInfoWithComponents:_componentArray];
                [_tableView reloadData];
            }
        }
    }
}

- (void) gotoSelectEquipment {
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_DEVICE_INFO_SELECT];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
}

//选择状态
- (void) gotoSelectStatus {
    if(!_statusArray) {
        
        _statusArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:EQUIP_STATUS_IDLE], [NSNumber numberWithInteger:EQUIP_STATUS_USING], [NSNumber numberWithInteger:EQUIP_STATUS_STOP], [NSNumber numberWithInteger:EQUIP_STATUS_REPAIRING], [NSNumber numberWithInteger:EQUIP_STATUS_SCRAPING], [NSNumber numberWithInteger:EQUIP_STATUS_SCRAP], [NSNumber numberWithInteger:EQUIP_STATUS_LOCKED], nil];
        
        _strStatusArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_idle" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_using" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_stop" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_repairing" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_scraping" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_scrap" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_equipment_status_lock" inTable:nil], nil];
    }
    
    [_pickerView setDataByArray:_strStatusArray];
    [_pickerView setCenterIndex:0];
    _pickerView.tag = WO_EQUIPMENT_EDIT_EVENT_SELECT_STATUS;
    [_alertView showType:@"picker"];
    [_alertView show];
}

//选择维修类型
- (void) gotoSelectRepairType {
    if(!_repairTypeArray) {
        _repairTypeArray = [[NSMutableArray alloc] initWithObjects:
                            [NSNumber numberWithInteger:ORDER_EQUIPMENT_REPAIR_TYPE_NONE],
                            [NSNumber numberWithInteger:ORDER_EQUIPMENT_REPAIR_TYPE_REPAIR],
                            [NSNumber numberWithInteger:ORDER_EQUIPMENT_REPAIR_TYPE_RECTIFY],
                            [NSNumber numberWithInteger:ORDER_EQUIPMENT_REPAIR_TYPE_REPLACE],nil];
        
        _strRepairTypeArray = [[NSMutableArray alloc] initWithObjects:
//                               [[BaseBundle getInstance] getStringByKey:@"order_equipment_repairtype_none" inTable:nil],
                               @"",
                               [[BaseBundle getInstance] getStringByKey:@"order_equipment_repairtype_repair" inTable:nil],
                               [[BaseBundle getInstance] getStringByKey:@"order_equipment_repairtype_rectify" inTable:nil],
                               [[BaseBundle getInstance] getStringByKey:@"order_equipment_repairtype_exchange" inTable:nil],nil];
    }
    [_pickerView setDataByArray:_strRepairTypeArray];
    [_pickerView setCenterIndex:0];
    _pickerView.tag = WO_EQUIPMENT_EDIT_EVENT_SELECT_REPAIR_TYPE;
    [_alertView showType:@"picker"];
    [_alertView show];
}

//核心组件详情
- (void) gotoComponentDetail:(NSInteger) position {
    AssetCoreComponentListEntity *component = _componentArray[position];
    EquipmentCoreComponentDetailViewController *vc = [[EquipmentCoreComponentDetailViewController alloc] init];
    [vc setEqCoreId:component.eqCoreId];
    [self gotoViewController:vc];
}

//组件替换
- (void) gotoReplaceComponent:(NSInteger) position {
    _curIndex = position;
    WriteOrderEquipmentComponentReplaceViewController * vc = [[WriteOrderEquipmentComponentReplaceViewController alloc] init];
    [vc setOnMessageHandleListener:self];
    AssetCoreComponentListEntity * component = _componentArray[_curIndex];
    NSString * key = [[NSString alloc] initWithFormat:@"%lld", component.eqCoreId.longLongValue];
    WorkOrderEquipmentOperationRecord * record = [_records valueForKeyPath:key];
    [vc setInfoWith:record];
    [self gotoViewController:vc];
}

#pragma mark - 键盘展示
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
            CGRect frame = [self getContentFrame];
            frame.size.height -= keyboardSize.height;
//            [_mainContainerView setFrame:frame];
        }];
    }
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
//        [_mainContainerView setFrame:frame];
    }];
}

@end

