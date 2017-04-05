//
//  WriteOrderEquipmentComponentReplaceViewController.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "WriteOrderEquipmentComponentReplaceViewController.h"
#import "BaseTextField.h"
#import "FMSize.h"
#import "FMColor.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "WorkOrderDetailEntity.h"
#import "UIButton+Bootstrap.h"
#import "CaptionTextField.h"
#import "WorkOrderBusiness.h"
#import "InfoSelectViewController.h"
#import "IQKeyboardManager.h"
#import "AssetManagementConfig.h"
#import "WorkOrderServerConfig.h"
#import "TaskAlertView.h"
#import "BaseTimePicker.h"
#import "WorkOrderSaveEntity.h"

typedef NS_ENUM(NSInteger, OrderEquipmentComponentDatePickerType) {
    ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_UNKNOW,
    ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_INSTALL,//安装日期
    ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_EXPIRE,//质保到期
};

@interface WriteOrderEquipmentComponentReplaceViewController () <OnItemClickListener, OnClickListener>
@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;

@property (readwrite, nonatomic, strong) CaptionTextField * nameTF;   //名称
@property (readwrite, nonatomic, strong) CaptionTextField * codeTF;//编码
@property (readwrite, nonatomic, strong) CaptionTextField * brandTF;   //品牌
@property (readwrite, nonatomic, strong) CaptionTextField * modelTF;//型号
@property (readwrite, nonatomic, strong) CaptionTextField * periodTF;//质保期
@property (readwrite, nonatomic, strong) CaptionTextField * installDateTF;//安装日期
@property (readwrite, nonatomic, strong) CaptionTextField * expiredDateTF;//质保到期

@property (nonatomic, strong) TaskAlertView * alertView;
@property (nonatomic, strong) BaseTimePicker * datePicker;

@property (nonatomic, strong) WorkOrderEquipmentOperationRecord * component;

@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) NSNumber * installDate;
@property (nonatomic, strong) NSNumber * expiredDate;

@property (nonatomic, assign) OrderEquipmentComponentDatePickerType pickerType;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WriteOrderEquipmentComponentReplaceViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_equipment_component_replace" inTable:nil]];
    [self setBackAble:YES];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLayout];
    [self initAlertView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _itemHeight = 92;
        
        CGRect frame = [self getContentFrame];
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        
        _nameTF = [[CaptionTextField alloc] init];
        [_nameTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_name" inTable:nil]];
        [_nameTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_name_placeholder" inTable:nil]];
        [_nameTF setShowMark:YES];
        [_nameTF setEditable:YES];
        
        _codeTF = [[CaptionTextField alloc] init];
        [_codeTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_code" inTable:nil]];
        [_codeTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_code_placeholder" inTable:nil]];
        [_codeTF setShowMark:YES];
        [_codeTF setEditable:YES];
        
        _brandTF = [[CaptionTextField alloc] init];
        [_brandTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_brand" inTable:nil]];
        [_brandTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_brand_placeholder" inTable:nil]];
        [_brandTF setEditable:YES];
        
        _modelTF = [[CaptionTextField alloc] init];
        [_modelTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_model" inTable:nil]];
        [_modelTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_model_placeholder" inTable:nil]];
        [_modelTF setEditable:YES];
        
        _periodTF = [[CaptionTextField alloc] init];
        [_periodTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_period" inTable:nil]];
        [_periodTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_period_placeholder" inTable:nil]];
        [_periodTF setEditable:YES];
        
        _installDateTF = [[CaptionTextField alloc] init];
        [_installDateTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_install_date" inTable:nil]];
        [_installDateTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_install_date_placeholder" inTable:nil]];
        [_installDateTF setEditable:NO];
        [_installDateTF setOnClickListener:self];
        
        _expiredDateTF = [[CaptionTextField alloc] init];
        [_expiredDateTF setTitle:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_expired_date" inTable:nil]];
        [_expiredDateTF setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_expired_date_placeholder" inTable:nil]];
        [_expiredDateTF setEditable:NO];
        [_expiredDateTF setOnClickListener:self];
        
        
        [_mainContainerView addSubview:_nameTF];
        [_mainContainerView addSubview:_codeTF];
        [_mainContainerView addSubview:_brandTF];
        [_mainContainerView addSubview:_modelTF];
        [_mainContainerView addSubview:_periodTF];
        [_mainContainerView addSubview:_installDateTF];
        [_mainContainerView addSubview:_expiredDateTF];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void) initAlertView {
    
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    
    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_DAY];
    
    CGFloat realWidth = CGRectGetWidth(self.view.frame);
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self handleResult];
}

- (void) updateLayout {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    
    CGFloat originY = 0;
    CGFloat itemWidth = width ;
    CGFloat sepHeight = 0;
    
    [_codeTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_nameTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_brandTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_modelTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_periodTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_installDateTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    [_expiredDateTF setFrame:CGRectMake(0, originY, itemWidth, _itemHeight)];
    originY += _itemHeight + sepHeight;
    
    _mainContainerView.contentSize = CGSizeMake(width, originY);
    [self updateInfo];
}

- (void) updateInfo {
    if(_component) {
        [_codeTF setText:_component.code];
        [_nameTF setText:_component.name];
        [_brandTF setText:_component.brand];
        [_modelTF setText:_component.model];
        [_periodTF setText:[[NSString alloc] initWithFormat:@"%ld", _component.period]];
        [_installDateTF setText:@""];
        if (![FMUtils isNumberNullOrZero:_component.installDate]) {
            [_installDateTF setText:[FMUtils getDayStr:[FMUtils timeLongToDate:_component.installDate]]];
        }
        [_expiredDateTF setText:@""];
        if (![FMUtils isNumberNullOrZero:_component.expireDate]) {
            [_expiredDateTF setText:[FMUtils getDayStr:[FMUtils timeLongToDate:_component.expireDate]]];
        }
    }
}

- (void) updateDate {
    NSInteger period = _periodTF.text.integerValue;
    if(_installDate) {
        [_installDateTF setText:[FMUtils getDayStr:[FMUtils timeLongToDate:_installDate]]];
    }
    if(_expiredDate) {
        [_expiredDateTF setText:[FMUtils getDayStr:[FMUtils timeLongToDate:_expiredDate]]];
    } else if (_installDate && period > 0) {
        _expiredDate = [FMUtils getTimeOfSomeMonths:period fromDate:_installDate];
        [_expiredDateTF setText:[FMUtils getDayStr:[FMUtils timeLongToDate:_expiredDate]]];
    }
}


- (void) setInfoWith:(WorkOrderEquipmentOperationRecord *) component{
    _component = component;
    [self updateInfo];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

- (void) handleResult {
    if(_handler) {
        WorkOrderEquipmentOperationRecord * item = [self getInfoInput];
        if([FMUtils isStringEmpty:item.code]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_component_notice_code_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else if ([FMUtils isStringEmpty:item.name]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_component_notice_name_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
            [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
            [msg setValue:item forKeyPath:@"result"];
            [_handler handleMessage:msg];
            [self finish];
        }
    }
}



#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    if(view == _installDateTF) {
        [self selectDateByType:ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_INSTALL];
    } else if(view == _expiredDateTF) {
        [self selectDateByType:ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_EXPIRE];
    } else if(view == _alertView) {
        [_alertView close];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            NSDictionary * dic;
            BOOL needUpdate = NO;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    dic = [FMUtils timeLongToDictionary:time];
                    if(_pickerType == ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_INSTALL) {
                        _installDate = [time copy];
                        needUpdate = YES;
                        
                    } else if(_pickerType == ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_EXPIRE) {
                        _expiredDate = [time copy];
                        needUpdate = YES;
                    }
                    break;
                default:
                    break;
            }
            if(needUpdate) {
                [self updateDate];
            }
        }
        [_alertView close];
        
    }
}

- (void) selectDateByType:(OrderEquipmentComponentDatePickerType) pickerType {
    _pickerType = pickerType;
    NSNumber * time;
    switch(pickerType) {
        case ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_INSTALL:
            time = _installDate;
            break;
        case ORDER_EQUIPMENT_COMPONENT_DATE_PICKER_TYPE_EXPIRE:
            time = _expiredDate;
            break;
    }
    if(!time) {
        time = [FMUtils getTimeLongNow];
    }
    [_datePicker setCenterDate:time];
    [_alertView showType:@"time"];
    [_alertView show];
}

//获取输入信息
- (WorkOrderEquipmentOperationRecord *) getInfoInput {
    WorkOrderEquipmentOperationRecord * res = [[WorkOrderEquipmentOperationRecord alloc] init];
    //    res.fromEqCoreId = [_woId copy];
    res.code = _codeTF.text;
    res.name = _nameTF.text;
    res.brand = _brandTF.text;
    res.model = _modelTF.text;
    res.period = _periodTF.text.integerValue;
    
    res.installDate = nil;
    if (![FMUtils isNumberNullOrZero:_installDate]) {
        res.installDate = _installDate;
    } else if (![FMUtils isNumberNullOrZero:_component.installDate]) {
        res.installDate = _component.installDate;
    }
    
    res.expireDate = nil;
    if (![FMUtils isNumberNullOrZero:_expiredDate]) {
        res.expireDate = _expiredDate;
    } else if (![FMUtils isNumberNullOrZero:_component.expireDate]) {
        res.expireDate = _component.expireDate;
    }
    
    return res;
}

@end
