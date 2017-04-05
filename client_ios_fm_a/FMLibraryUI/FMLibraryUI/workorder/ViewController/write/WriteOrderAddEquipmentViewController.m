//
//  WriteOrderAddEquipmentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  填写工单 --- 编辑设备

#import "WriteOrderAddEquipmentViewController.h"
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

@interface WriteOrderAddEquipmentViewController () <OnClickListener, OnViewResizeListener>

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;

@property (readwrite, nonatomic, strong) CaptionTextField * nameTF;   //名称
@property (readwrite, nonatomic, strong) CaptionTextField * codeTF;//编码
@property (readwrite, nonatomic, strong) CaptionTextField * statusTF;   //状态
@property (readwrite, nonatomic, strong) CaptionTextField * repairTypeTF;//维修类型
@property (readwrite, nonatomic, strong) CaptionTextView * failureTF;
@property (readwrite, nonatomic, strong) CaptionTextView * repairTF;

@property (readwrite, nonatomic, strong) NSString * failure;
@property (readwrite, nonatomic, strong) NSString * repair;
@property (nonatomic, assign) EquipmentStatus status;
@property (nonatomic, assign) OrderEquipmentRepairType repairType;
@property (readwrite, nonatomic, strong) NSNumber * equipmentId;
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) Device * equip;

@property (readwrite, nonatomic, strong) NSMutableArray * equipIds;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) CGFloat defaultTextViewHeight;

@property (nonatomic, strong) NSString *titleName;

@property (readwrite, nonatomic, assign) WriteOrderAddEquipmentOperateType operateType;


@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WriteOrderAddEquipmentViewController

- (instancetype) initWithType:(WriteOrderAddEquipmentOperateType) type andTitleName:(NSString *) name {
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
    if(!_mainContainerView) {
        
        _defaultTextViewHeight = 174;
        
        _business = [[WorkOrderBusiness alloc] init];
        
        CGRect frame = [self getContentFrame];
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        
        _nameTF = [[CaptionTextField alloc] init];
        [_nameTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil]];
        [_nameTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name_placeholder" inTable:nil]];
        [_nameTF setEditable:NO];
        [_nameTF setOnClickListener:self];
        
        _codeTF = [[CaptionTextField alloc] init];
        [_codeTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil]];
        [_codeTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code_placeholder" inTable:nil]];
        [_codeTF setEditable:NO];
        [_codeTF setOnClickListener:self];

        
        _statusTF = [[CaptionTextField alloc] init];
        [_statusTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_status" inTable:nil]];
        [_statusTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_status_placeholder" inTable:nil]];
        [_statusTF setEditable:NO];
        [_statusTF setOnClickListener:self];
        
        _repairTypeTF = [[CaptionTextField alloc] init];
        [_repairTypeTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_type" inTable:nil]];
        [_repairTypeTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_type_placeholder" inTable:nil]];
        [_repairTypeTF setEditable:NO];
        [_repairTypeTF setOnClickListener:self];
        
        
        _failureTF = [[CaptionTextView alloc] init];
        [_failureTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil]];
        [_failureTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc_placeholder" inTable:nil]];
        [_failureTF setOnViewResizeListener:self];
        
        _repairTF = [[CaptionTextView alloc] init];
        [_repairTF setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil]];
        [_repairTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_placeholder" inTable:nil]];
        [_repairTF setOnViewResizeListener:self];
        
        [_mainContainerView addSubview:_nameTF];
        [_mainContainerView addSubview:_codeTF];
        [_mainContainerView addSubview:_statusTF];
        [_mainContainerView addSubview:_repairTypeTF];
        [_mainContainerView addSubview:_failureTF];
        [_mainContainerView addSubview:_repairTF];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
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

- (void) updateLayout {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat originY = 0;
    CGFloat itemHeight = 92;
    CGFloat itemWidth = width ;
    CGFloat sepHeight = 0;
    
    if(_operateType == ORDER_EQUIPMENT_TYPE_ADD) {
        [_nameTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
        [_nameTF setHidden:NO];
        originY += itemHeight + sepHeight;
        
        [_codeTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
        [_codeTF setHidden:NO];
        originY += itemHeight + sepHeight;
        
    } else {
        [_nameTF setHidden:YES];
        [_codeTF setHidden:YES];
    }
    
    [_statusTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_repairTypeTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = CGRectGetHeight(_failureTF.frame);
    if(itemHeight == 0) {
        itemHeight = _defaultTextViewHeight;
    }
    [_failureTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    itemHeight = CGRectGetHeight(_repairTF.frame);
    if(itemHeight == 0) {
        itemHeight = _defaultTextViewHeight;
    }
    [_repairTF setFrame:CGRectMake(0, originY, itemWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
    [self updateInfo];
}


- (void) updateInfo {
    if(_equip) {
        [_nameTF setText:_equip.name];
        [_codeTF setText:_equip.code];
    }
//    [_statusTF setText:<#(NSString *)#>]
    [_repairTypeTF setText:[WorkOrderServerConfig getOrderEquipmentRepairTypeDesc:_repairType]];
    [_failureTF setText:_failure];
    [_repairTF setText:_repair];
}

- (WorkOrderEquipment *) getInfoInput {
    WorkOrderEquipment * param = [[WorkOrderEquipment alloc] init];
    if(_operateType == ORDER_EQUIPMENT_TYPE_ADD) {
        param.woId = [_woId copy];
        param.equipmentId = [_equip.eqId copy];
        param.equipmentName = _equip.name;
        param.equipmentCode = _equip.code;
        param.failureDesc = _failureTF.text;
        param.repairDesc = _repairTF.text;
        param.equipmentStatus = _status;
        param.repairType = _repairType;
        return param;
    } else {
        param.woId = [_woId copy];
        param.equipmentId = [_equipmentId copy];
        param.failureDesc = _failureTF.text;
        param.repairDesc = _repairTF.text;
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
        if(_operateType == ORDER_EQUIPMENT_TYPE_ADD) {
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

- (WorkOrderEquipmentEditRequestParam *) getEquipmentInfoParam {
    WorkOrderEquipmentEditRequestParam * param = [[WorkOrderEquipmentEditRequestParam alloc] init];
    param.woId = _woId;
    if(_operateType == ORDER_EQUIPMENT_TYPE_ADD) {
        param.equipmentId = _equip.eqId;
    } else {
        param.equipmentId = _equipmentId;
    }
    param.failureDesc = _failureTF.text;
    param.repairDesc = _repairTF.text;
    
    return param;
}


- (void) onClick:(UIView *)view {
    if(view == _nameTF || view == _codeTF) {
        [self gotoSelectEquipment];
    }
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
        }
    }
}

- (void) gotoSelectEquipment {
    InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_DEVICE_INFO_SELECT];
    [vc setOnMessageHandleListener:self];
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
            [_mainContainerView setFrame:frame];
        }];
    }
}



- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration animations:^{
        CGRect frame = [self getContentFrame];
        [_mainContainerView setFrame:frame];
    }];
}

@end



