//
//  WorkOrderDetailDispachViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailDispachViewController.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "InsetsLabel.h"
#import "BaseItemView.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "LaborerItemView.h"
#import "DispachLaborerViewController.h"
#import "WorkOrderServerConfig.h"
#import "SeperatorView.h"
#import "CustomAlertView.h"
#import "DispachWorkOrderEntity.h"
#import "WorkOrderBusiness.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "BaseTextField.h"
#import "DXAlertView.h"


//时间类型
typedef NS_ENUM(NSInteger, TimeType) {
    TIME_TYPE_UNKNOW,
    TIME_TYPE_START,    //开始时间
    TIME_TYPE_FINISH    //完成时间
};

@interface WorkOrderDetailDispachViewController () <OnMessageHandleListener, OnItemClickListener, OnClickListener>

@property (readwrite, nonatomic, strong) UIScrollView * mainContainerView;
@property (readwrite, nonatomic, strong) InsetsLabel * estimateTimeLbl;
@property (readwrite, nonatomic, strong) BaseItemView * startTimeView;
@property (readwrite, nonatomic, strong) BaseItemView * endTimeView;
@property (readwrite, nonatomic, strong) BaseTextField * timeUsedView;

@property (readwrite, nonatomic, strong) InsetsLabel * laborerLbl;
@property (readwrite, nonatomic, strong) NSMutableArray * laborerViewArray;
@property (readwrite, nonatomic, strong) NSMutableArray * seperatorViewArray;

@property (readwrite, nonatomic, strong) UIView * addContainerView;
@property (readwrite, nonatomic, strong) UIButton * addBtn;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;  //工单业务处理

@property (readwrite, nonatomic, strong) NSNumber * timeStart;  //派工预估开始时间
@property (readwrite, nonatomic, strong) NSNumber * timeFinish; //派工预估完成时间
@property (readwrite, nonatomic, strong) NSNumber * timeUsed; //预估耗时


@property (readwrite, nonatomic, strong) NSMutableArray * laborerArray;

@property (readwrite, nonatomic, assign) NSInteger chargeIndex; //负责人的序号


@property (readwrite, nonatomic, strong) NSString * code;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat itemAddHeight;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) CGFloat padding;

@property (readwrite, nonatomic, strong) NSNumber * orderId;

@end

@implementation WorkOrderDetailDispachViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    if(!_mainContainerView) {
        
        _laborerViewArray = [[NSMutableArray alloc] init];
        _laborerArray = [[NSMutableArray alloc] init];
        _seperatorViewArray = [[NSMutableArray alloc] init];
        _chargeIndex = -1;
        
        _headerHeight = 45;
        _itemHeight = 50;
        _itemAddHeight = 80;
        _padding = 17;
        _imgWidth = 40;
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _mainContainerView.delaysContentTouches = NO;
        
        CGFloat originY = 0;
        CGFloat itemHeight;
        UIColor * textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        
        itemHeight = _headerHeight;
        _estimateTimeLbl = [[InsetsLabel alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        [_estimateTimeLbl setText:[[BaseBundle getInstance] getStringByKey:@"order_laborer_estimate" inTable:nil]];
        originY += itemHeight;
        
        itemHeight = _itemHeight;
        _startTimeView = [[BaseItemView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        _startTimeView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_startTimeView setNameColor:textColor];
        [_startTimeView setPaddingLeft:_padding andPaddingRight:_padding];
        [_startTimeView addTarget:self action:@selector(onStartClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        SeperatorView * timeStartSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(_padding, itemHeight-seperatorHeight, _realWidth-_padding*2, seperatorHeight)];
        [_startTimeView addSubview:timeStartSeperator];
        
        [_startTimeView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_laborer_estimate_time_start" inTable:nil]];
        [_startTimeView setShowMore:YES];
        originY += itemHeight;
        
        
        
        itemHeight = _itemHeight;
        _endTimeView = [[BaseItemView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        _endTimeView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_endTimeView setNameColor:textColor];
        [_endTimeView setPaddingLeft:_padding andPaddingRight:_padding];
        [_endTimeView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_laborer_estimate_time_end" inTable:nil]];
        [_endTimeView setShowMore:YES];
        [_endTimeView addTarget:self action:@selector(onEndClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SeperatorView * timeEndSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(_padding, itemHeight-seperatorHeight, _realWidth-_padding*2, seperatorHeight)];
        [_endTimeView addSubview:timeEndSeperator];
        
        originY += itemHeight;
        
        itemHeight = _itemHeight;
        _timeUsedView = [[BaseTextField alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        _timeUsedView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_timeUsedView setLabelWithText:[[BaseBundle getInstance] getStringByKey:@"order_filter_time_used" inTable:nil]];
        [_timeUsedView setLabelFont:[FMFont fontWithSize:16]];
        _timeUsedView.layer.borderWidth = 0;
        [_timeUsedView setBorderStyle:UITextBorderStyleNone];
        _timeUsedView.delegate = self;
        _timeUsedView.textAlignment = NSTextAlignmentRight;
//        _timeUsedView.keyboardType = UIKeyboardTypeNumberPad;
        [_timeUsedView setLabelColor:textColor];
        CGRect frame = [_timeUsedView frame];
        frame.size.width = _padding;
        UIView * rightView = [[UIView alloc] initWithFrame:frame];
        _timeUsedView.rightViewMode = UITextFieldViewModeAlways;
        _timeUsedView.rightView = rightView;
        [_timeUsedView setPaddingLeft:_padding right:_padding andLabelWidth:0];
        
        SeperatorView * timeUsedSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
        [_timeUsedView addSubview:timeUsedSeperator];
        
        originY += itemHeight;
        
        
        itemHeight = _headerHeight;
        _laborerLbl = [[InsetsLabel alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        NSString * strDesc = [[NSString alloc] initWithFormat:@"%@(%@)", [[BaseBundle getInstance] getStringByKey:@"order_laborer" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_laborer_responsible_desc" inTable:nil]];
        [_laborerLbl setText:strDesc];
        originY += itemHeight;
        
        itemHeight = _itemAddHeight;
        
        _addContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, itemHeight)];
        _addContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-_imgWidth-_padding, (itemHeight -_imgWidth)/2, _imgWidth, _imgWidth)];
        
        
        [_addBtn setImage:[[FMTheme getInstance] getImageByName:@"add_blue"] forState:UIControlStateNormal];
        [_addBtn setImage:[[FMTheme getInstance] getImageByName:@"addmore"] forState:UIControlStateHighlighted];
        [_addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SeperatorView * bottomSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
        originY += itemHeight;
        
        
        
//        [_addContainerView addSubview:_addImgView];
        [_addContainerView addSubview:_addBtn];
        [_addContainerView addSubview:bottomSeperator];
        
        [_mainContainerView addSubview:_estimateTimeLbl];
        [_mainContainerView addSubview:_startTimeView];
        [_mainContainerView addSubview:_endTimeView];
        [_mainContainerView addSubview:_timeUsedView];
        
        [_mainContainerView addSubview:_laborerLbl];
        [_mainContainerView addSubview:_addContainerView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initNavigation {
    if(![FMUtils isStringEmpty:_code]) {
        [self setTitleWith:_code];
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_operation_dispach" inTable:nil]];
    }
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_dispach" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
    [self initBusiness];
    [self updateTime];
}

- (void) initAlertView {
    
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    
    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_MINUTE];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


- (void) updateLayout {
    NSInteger index = 0;
    NSInteger count = [_laborerArray count];
    
    CGFloat originY = _headerHeight * 2 + _itemHeight * 3;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    for(index=0; index<count; index++) {
        WorkOrderLaborerDispach * laborer = _laborerArray[index];
        LaborerItemView * laborerView;
        if(index < [_laborerViewArray count]) {
            laborerView = _laborerViewArray[index];
            [laborerView setHidden:NO];
        }
        if(!laborerView) {
            laborerView = [[LaborerItemView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _itemHeight)];
            laborerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
            
            SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(_padding, _itemHeight-seperatorHeight, _realWidth-_padding * 2, seperatorHeight)];
            [laborerView addSubview:seperator];
            
            [laborerView setOnItemClickListener:self];
            
            [_laborerViewArray addObject:laborerView];
            [_mainContainerView addSubview:laborerView];
        }
        if(laborerView) {
            [laborerView setFrame:CGRectMake(0, originY, _realWidth, _itemHeight)];
            [laborerView setInfoWithName:laborer.name];
            laborerView.tag = index;
            if(_chargeIndex == index) {
                [laborerView setSelected:YES];
            } else {
                [laborerView setSelected:NO];
            }
        }
        originY += _itemHeight;
    }
    
    for(NSInteger lindex = index;lindex < [_laborerViewArray count];lindex++) {
        LaborerItemView * laborerView = _laborerViewArray[lindex];
        [laborerView setHidden:YES];
    }
    
    
    [_addContainerView setFrame:CGRectMake(0, originY, _realWidth, _itemAddHeight)];
    originY += _itemAddHeight;
    
    

    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
}

- (void) updateTime {
    NSString * strTime;
    if(_timeStart) {
        strTime = [FMUtils timeLongToDateString:_timeStart];
        [_startTimeView updateDesc:strTime];
    } else {
        [_startTimeView updateDesc:@""];
    }
    if(_timeFinish) {
        strTime = [FMUtils timeLongToDateString:_timeFinish];
        [_endTimeView updateDesc:strTime];
    } else {
        [_endTimeView updateDesc:@""];
    }
    if(_timeUsed) {
        strTime = [[NSString alloc] initWithFormat:@"%.1f h", _timeUsed.floatValue];
        [_timeUsedView setText:strTime];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) initBusiness {
    _business = [WorkOrderBusiness getInstance];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self requestDispach];
}

- (void) setInfoWithOrderId:(NSNumber *) orderId code:(NSString *) code{
    _orderId = [orderId copy];
    _code = [code copy];
}

//设置预估开始时间和预估完成时间
- (void) setEstimateTimeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd {
    _timeStart = [timeStart copy];
    _timeFinish = [timeEnd copy];
    
    if(_timeStart && _timeFinish) {
        _timeUsed = [NSNumber numberWithFloat:(CGFloat)(_timeFinish.longLongValue - _timeStart.longLongValue)/(CGFloat)(1000 * 60 * 60)];
    }
}

#pragma mark - 添加执行人
- (void) onAddBtnClicked:(UITapGestureRecognizer *) gesture {
    [self gotoDispachLaborerSelect];
}

#pragma mark - 选择负责人， 设置时间
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[LaborerItemView class]]) {
        NSInteger index = view.tag;
        if(subView) {
            LaborerItemActionType type = subView.tag;
            if(type == LABORER_ACTION_DELETE) {
                DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_notice_delete_worker" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
                
                alertView.leftBlock = ^(){
                    if(index < [_laborerArray count]) {
                        [_laborerArray removeObjectAtIndex:index];
                        if(_chargeIndex > index) {
                            _chargeIndex--;
                        } else if(_chargeIndex == index) {
                            _chargeIndex = -1;
                        }
                        [self updateLayout];
                    }
                };
                alertView.rightBlock = ^(){
                };
                alertView.dismissBlock = ^(){};
                [alertView show];
                
            }
        } else {
            if(_chargeIndex != index) {
                _chargeIndex = index;
                [self updateLayout];
            }
        }
    } if(view == _datePicker) {
        NSInteger tag = _datePicker.tag;
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    if(tag == TIME_TYPE_START) {
                        _timeStart = time;
                        NSString * strTime = [FMUtils timeLongToDateString:_timeStart];
                        [_startTimeView updateDesc:strTime];
                    } else if(tag == TIME_TYPE_FINISH) {
                        _timeFinish = time;
                        NSString * strTime = [FMUtils timeLongToDateString:_timeFinish];
                        [_endTimeView updateDesc:strTime];
                    }
                    break;
                default:
                    break;
            }
            if(_timeStart && _timeFinish) {
                _timeUsed = [NSNumber numberWithFloat:(CGFloat)(_timeFinish.longLongValue - _timeStart.longLongValue)/(CGFloat)(1000 * 60 * 60)];
                NSString * strTime = [[NSString alloc] initWithFormat:@"%.1f h", _timeUsed.floatValue];
                [_timeUsedView setText:strTime];
            }
            [self checkTimeAndShowNotice];
        }
        [_alertView close];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

#pragma mark - 时间选择
- (void) onStartClicked:(id) sender {
    [self showTimeSelectDialog:TIME_TYPE_START];
}

- (void) onEndClicked:(id) sender {
    [self showTimeSelectDialog:TIME_TYPE_FINISH];
}


- (void) showTimeSelectDialog:(TimeType) type {
    NSDate * curDate = nil;
    if(type == TIME_TYPE_START) {
        if(_timeStart && ![_timeStart isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            curDate = [FMUtils timeLongToDate:_timeStart];
        } else {
            curDate = [NSDate date];
        }
        
    } else if(type == TIME_TYPE_FINISH){
        if(_timeFinish && ![_timeFinish isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            curDate = [FMUtils timeLongToDate:_timeFinish];
            
        } else {
            curDate = [NSDate date];
        }
    }
    NSNumber * time = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:time];
    _datePicker.tag = type;
    
    [_alertView showType:@"time"];
    [_alertView show];
}

//检查预估开始时间和预估完成时间，如果完成时间早于开始时间则给出提示
- (BOOL) checkTimeAndShowNotice {
    if(_timeStart && _timeFinish && [_timeStart longLongValue] > [_timeFinish longLongValue]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_time_start_behind_end" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - 页面跳转
//选择执行人
- (void) gotoDispachLaborerSelect {
    DispachLaborerViewController * laborerSelectVC = [[DispachLaborerViewController alloc] init];
    [laborerSelectVC setWorkOrderWithId:_orderId];
    [laborerSelectVC setOnMessageHandleListener:self];
    [laborerSelectVC setSelectedLaborers:_laborerArray];
    [self gotoViewController:laborerSelectVC];
}

#pragma mark - handle message
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:@"DispachLaborerViewController"]) {
            NSMutableArray * res = [msg valueForKeyPath:@"result"];
            _laborerArray = res;
            if (_laborerArray.count > 0) {
                _chargeIndex = 0;  //默认选第一个人为负责人
            }
            [self updateLayout];
        }
    }
}

#pragma mark - 派工执行人管理
- (BOOL) isLaborerExist:(NSNumber *) laborerId {
    BOOL res = NO;
    if(_laborerArray) {
        for(WorkOrderLaborerDispach * laborer in _laborerArray) {
            if([laborer.emId isEqualToNumber:laborerId]) {
                res = YES;
                break;
            }
        }
    }
    return res;
}
- (void) removeLaborer:(NSNumber *) laborerId {
    NSInteger index = 0;
    NSInteger count = [_laborerArray count];
    if(laborerId) {
        for(index = 0; index < count;index++) {
            WorkOrderLaborerDispach * laborer = _laborerArray[index];
            if(laborer && laborer.emId && [laborer.emId isEqualToNumber:laborerId]) {
                [_laborerArray removeObjectAtIndex:index];
                break;
            }
        }
    }
}


#pragma mark - 请求派工
- (void) requestDispach {
    DispachWorkOrderRequestParam * param = [[DispachWorkOrderRequestParam alloc] init];
    param.woId = [_orderId copy];
    
    if ([_laborerArray count] == 0 || !_laborerArray) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_laborer_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    if(_chargeIndex < 0 || _chargeIndex >= [_laborerArray count]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_designate_principal" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    NSInteger index = 0;
    for(WorkOrderLaborerDispach * dlaborer in _laborerArray) {
        DispachWorkOrderLaborer * laborer = [[DispachWorkOrderLaborer alloc] init];
        laborer.laborerId = dlaborer.emId;
        if(index == _chargeIndex) {
            laborer.responsible = YES;
        } else {
            laborer.responsible = NO;
        }
        [param.laborers addObject:laborer];
        index++;
    }
    if(_timeStart && _timeFinish && [_timeStart longLongValue] > [_timeFinish longLongValue]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_time_start_behind_end" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    param.estimatedArrivalDate = [_timeStart copy];
    param.estimatedCompletionDate = [_timeFinish copy];
    param.estimatedWorkingTime = [NSNumber numberWithLongLong:(_timeUsed.doubleValue * 60)];
    if(_business) {
        [self showLoadingDialog];
        [_business dispachOrder:param success:^(NSInteger key, id object) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_dispach_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self hideLoadingDialog];
            [self notifyOrderStatusChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //回退两级
                [self backToParentWithLevel:2];
            });
        } fail:^(NSInteger key, NSError *error) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_dispach_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self hideLoadingDialog];
        }];
    }
}

#pragma mark - 通知工单列表刷新
- (void) notifyOrderStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMOrderStatusUpdate" object:nil];
}

@end
