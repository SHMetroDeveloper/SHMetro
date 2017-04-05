//
//  WriteOrderLaborerSetTimeViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WriteOrderLaborerSetTimeViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "BaseTextField.h"
#import "UIButton+Bootstrap.h"
#import "CustomAlertView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "OnClickListener.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderBusiness.h"

@interface WriteOrderLaborerSetTimeViewController () <OnItemClickListener, OnClickListener>
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) UILabel * arriveLbl;      //实际到场时间
@property (readwrite, nonatomic, strong) UIButton * arriveTimeBtn;

@property (readwrite, nonatomic, strong) UILabel * finishLbl;      //实际完成时间
@property (readwrite, nonatomic, strong) UIButton * finishTimeBtn;

@property (readwrite, nonatomic, strong) NSNumber * arriveTime;
@property (readwrite, nonatomic, strong) NSNumber * finishTime;
@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;  //工单业务处理

@property (readwrite, nonatomic, strong) NSString * laborerName;
@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NSNumber * laborerId;

@property (readwrite, nonatomic, strong) id<OnMessageHandleListener> resultHandler;

@end


@implementation WriteOrderLaborerSetTimeViewController

- (instancetype) initWithLaborerName:(NSString *) name {
    self = [super  init];
    if(self) {
        _laborerName = name;
    }
    return self;
}


- (void) initNavigation {
    [self setTitleWith:[NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"order_time_setting" inTable:nil],_laborerName]];
    [self setBackAble:YES];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_menu_save" inTable:nil], nil];
    [self setMenuWithArray:menus];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initAlertView];
}

- (void)initLayout {
    if(!_mainContainerView) {
        
        _business = [WorkOrderBusiness getInstance];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        CGFloat headerHeight = [FMSize getInstance].listHeaderHeight;
        CGFloat padding = [FMSize getInstance].padding50;
        CGFloat itemHeight = [FMSize getSizeByPixel:144];
        CGFloat labelWidth = 120;
        CGFloat labelHeight = 31;
        CGFloat originX = 0;
        CGFloat originY = 0;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
        
        _datePicker = [[BaseTimePicker alloc] init];
        [_datePicker setOnItemClickListener:self];
        
        _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_datePicker setPickerType:BASE_TIME_PICKER_MINUTE];
        
        //实际到场lbl
        originX = padding;
        originY = [FMSize getSizeByPixel:54];
        labelHeight = headerHeight-[FMSize getSizeByPixel:54]-[FMSize getSizeByPixel:34];
        _arriveLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        _arriveLbl.textAlignment = NSTextAlignmentLeft;
        _arriveLbl.font = [FMFont getInstance].font44;
        _arriveLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _arriveLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_time_arrive_reality" inTable:nil];
        
        //实际到场时间选择Btn
        originX = 0;
        originY = headerHeight;
        _arriveTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, itemHeight)];
        [_arriveTimeBtn defaultStyle];
        [_arriveTimeBtn addTarget:self action:@selector(onArriveTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _arriveTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _arriveTimeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,padding, 0, 0);
        _arriveTimeBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_arriveTimeBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_time_picker" inTable:nil] forState:UIControlStateNormal];
        [_arriveTimeBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] forState:UIControlStateNormal];
        _arriveTimeBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
        _arriveTimeBtn.titleLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        UIImageView * nextIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_realWidth-[FMSize getInstance].padding50-15, (itemHeight - 22)/2, 22, 22)];
        [nextIcon setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        [_arriveTimeBtn addSubview:nextIcon];
        
        //实际完成时间lbl
        originX = padding;
        originY = headerHeight + itemHeight + [FMSize getSizeByPixel:54];
        _finishLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        _finishLbl.textAlignment = NSTextAlignmentLeft;
        _finishLbl.font = [FMFont getInstance].font44;
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _finishLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_time_finish_reality" inTable:nil];
        
        
        //实际完成时间Btn
        originX = 0;
        originY = headerHeight*2+itemHeight;
        _finishTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, _realWidth, itemHeight)];
        [_finishTimeBtn defaultStyle];
        [_finishTimeBtn addTarget:self action:@selector(onFinishTimeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _finishTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _finishTimeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,padding, 0, 0);
        _finishTimeBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_finishTimeBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_time_picker" inTable:nil] forState:UIControlStateNormal];
        [_finishTimeBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3] forState:UIControlStateNormal];
        _finishTimeBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
        _finishTimeBtn.titleLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        UIImageView * nextIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(_realWidth-[FMSize getInstance].padding50-15, (itemHeight - 22)/2, 22, 22)];
        [nextIcon2 setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        [_finishTimeBtn addSubview:nextIcon2];
        
        [_mainContainerView addSubview:_arriveLbl];
        [_mainContainerView addSubview:_arriveTimeBtn];
        [_mainContainerView addSubview:_finishLbl];
        [_mainContainerView addSubview:_finishTimeBtn];
        
        [self.view addSubview:_mainContainerView];
        
        [self updateTimeStr];
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

- (void) setWorkOrderId:(NSNumber *)woId andLaborerId:(NSNumber *)laborerId{
    _woId = [woId copy];
    _laborerId = [laborerId copy];
}

- (void) setArriveTime:(NSNumber *)arriveTime andFinishTime:(NSNumber *) finishTime {
    _arriveTime = [arriveTime copy];
    _finishTime = [finishTime copy];
}

- (void) updateTimeStr {
    
    if (_arriveTime) {
        NSString * strArriveTime = [[NSString alloc] initWithFormat:@"%@",  [FMUtils timeLongToDateString:_arriveTime]];
        [_arriveTimeBtn setTitle:strArriveTime forState:UIControlStateNormal];
    }
    if (_finishTime) {
        NSString * strFinishTime = [[NSString alloc] initWithFormat:@"%@",  [FMUtils timeLongToDateString:_finishTime]];
        [_finishTimeBtn setTitle:strFinishTime forState:UIControlStateNormal];
    }
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        
//        [self handleResult];
        [self gotoUploadLaborerInfo];
        
    }
}

- (void) onArriveTimeButtonClicked {
    NSLog(@"设置时间到达时间");
    [self showTimeSelectDialogWithTag:0];
}


- (void) onFinishTimeButtonClicked {
    NSLog(@"设置时间完成时间");
    [self showTimeSelectDialogWithTag:1];
}

- (void) showTimeSelectDialogWithTag:(NSInteger) tag {
    
    NSDate * curDate = nil;
    if(tag == 0) {
        if(_arriveTime && ![_arriveTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            curDate = [FMUtils timeLongToDate:_arriveTime];
        } else
        {
            curDate = [NSDate date];
        }
        
    } else if(tag == 1){
        if(_finishTime && ![_finishTime isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
            curDate = [FMUtils timeLongToDate:_finishTime];
            
        } else {
            curDate = [NSDate date];
        }
    }
    NSNumber *tmp = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:tmp];
    _datePicker.tag = tag;

    [_alertView showType:@"time"];
    [_alertView show];

}

- (void) timeChanged {
    NSLog(@"时间发生了变化");
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _resultHandler = handler;
}

- (void) handleResult {
    if(_resultHandler) {
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:_arriveTime forKeyPath:@"arriveTime"];
        [data setValue:_finishTime forKeyPath:@"finishTime"];
        [result setValue:@"WriteOrderLaborerSetTimeViewController" forKeyPath:@"msgOrigin"];
        [result setValue:@"WriteOrderLaborerSetTimeViewController" forKeyPath:@"resultType"];
        [result setValue:data forKeyPath:@"result"];
        [_resultHandler handleMessage:result];
    }
}

- (BOOL) checkTimeArrive:(NSNumber *) arrive finish:(NSNumber *) finish {
    BOOL res = YES;
    if(arrive && finish && arrive.longLongValue > finish.longLongValue) {
        res = NO;
    }
    return res;
}

#pragma mark - 时间选择
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        NSInteger tag = _datePicker.tag;
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    if(tag == 0) {
                        if([self checkTimeArrive:time finish:_finishTime]) {
                            _arriveTime = time;
                            [self updateTimeStr];
                        } else {
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_time_start_behind_end" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        }
                    } else if(tag == 1) {
                        if([self checkTimeArrive:_arriveTime finish:time]) {
                            _finishTime = time;
                            [self updateTimeStr];
                        } else {
                            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_time_start_behind_end" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                        }
                    }
                    break;
                default:
                    break;
            }
        }
        [_alertView close];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}


#pragma mark - 网络上传
- (void) gotoUploadLaborerInfo{
    WorkOrderLaborerTimeSaveRequestParam * param  = [self getLaborerInfoParam];
    if (!param.actualFinishDate) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_select_actualarrival_time" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        });
        return;
    }
    [self showLoadingDialog];
    [_business saveLaborerTimeInfo:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_setted_ok" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self handleResult];
            [self finish];
        });
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_setted_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (WorkOrderLaborerTimeSaveRequestParam *) getLaborerInfoParam{
    WorkOrderLaborerTimeSaveRequestParam * param = [[WorkOrderLaborerTimeSaveRequestParam alloc] init];
    param.woId = _woId;
    param.laborerId = _laborerId;
    param.actualArrivalDate = _arriveTime;
    param.actualFinishDate = _finishTime;
    return param;
}


@end



