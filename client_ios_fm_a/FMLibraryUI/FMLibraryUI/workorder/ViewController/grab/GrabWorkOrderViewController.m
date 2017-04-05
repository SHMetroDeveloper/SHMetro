//
//  GrabWorkOrderViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/3.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "GrabWorkOrderViewController.h"
#import "PullTableView.h"
#import "NetPage.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "TaskAlertView.h"
#import "WorkOrderGrabEntity.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderGrabItemView.h"
#import "SeperatorView.h"
#import "OnItemClickListener.h"
#import "WorkOrderServerConfig.h"
#import "WorkOrderDetailViewController.h"
#import "GrabOrderContentItemView.h"
#import "CustomAlertView.h"
#import "GrabWorkOrderParam.h"
#import "ImageItemView.h"

@interface GrabWorkOrderViewController () <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, OnItemClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * orderTableView;

@property (readwrite, nonatomic, strong) NSMutableArray * orderArray;
@property (readwrite, nonatomic, strong) NetPage * mPage;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) TaskAlertView * infoView;
@property (readwrite, nonatomic, assign) CGFloat infoViewHeight;
@property (readwrite, nonatomic, assign) BOOL isWorking;
@property (readwrite, nonatomic, weak) id curTask;

@property (readwrite, nonatomic, strong) GrabOrderContentItemView * grabContentView;
@property (readwrite, nonatomic, strong) UIDatePicker * datePicker;

@property (readwrite, nonatomic, strong) NSNumber* estimateArriveTime;


@end

@implementation GrabWorkOrderViewController

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _defaultItemHeight = 140;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _orderTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _orderTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _orderTableView.pullDelegate = self;
        

        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_grab_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        [_noticeLbl setHidden:YES];
        
        _infoView = [[TaskAlertView alloc] init];
        _infoView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        _infoView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        [_infoView setFrame:CGRectMake(0, _realHeight, _realWidth, _infoViewHeight)];
        [_infoView setHidden:YES];
        
        _grabContentView = [[GrabOrderContentItemView alloc] init];
        [_grabContentView setOnItemClickListener:self];
        
        [_infoView setContentView:_grabContentView withKey:@"grab"];
        
        [_mainContainerView addSubview:_orderTableView];
        [_mainContainerView addSubview:_noticeLbl];
        [_mainContainerView addSubview:_infoView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initData {
    _mPage = [[NetPage alloc] init];
    _orderArray = [[NSMutableArray alloc] init];
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_grab" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLayout];
    [self initDatePicker];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initDatePicker {
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = [FMSize getInstance].datePickerHeight;
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    [_datePicker setFrame:CGRectMake(0, 0, _realWidth-padding*2, itemHeight)];
}


- (void) updateList {
    if(_orderArray && [_orderArray count] > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
    [_orderTableView reloadData];
}

- (void) stopRefresh {
    [self refreshTable];
    [self loadMoreDataToTable];
}

- (void) showTimeSelectDialog {
    
    CustomAlertView *alertView = [[CustomAlertView alloc] init];
    [alertView setContainerView:_datePicker];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil], nil]];
    [alertView setOnButtonTouchUpInside:^(CustomAlertView *alertView, int buttonIndex) {
        if(buttonIndex == 0) {
            NSDate * date = _datePicker.date;
            _estimateArriveTime = [FMUtils dateToTimeLong:date];
            [_grabContentView setInfoWith:_estimateArriveTime];
        }
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    
    [alertView show];
}

#pragma mark - Refresh and load more methods
- (void) refreshTable {
    _orderTableView.pullLastRefreshDate = [NSDate date];
    _orderTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    _orderTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(_isWorking) {
        if(_curTask) {
            count = 1;
        }
    } else {
        count = [_orderArray count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    WorkOrderGrab * order;
    if(_isWorking) {
        order = (WorkOrderGrab *) _curTask;
    } else {
        order = _orderArray[position];
    }
    CGFloat itemHeight = [WorkOrderGrabItemView calculateHeightByDesc:order.woDescription location:order.location andWidth:_realWidth];
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    WorkOrderGrabItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat itemHeight = _defaultItemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat width = _realWidth;
    
    WorkOrderGrab* job;
    if(_isWorking) {
        job = (WorkOrderGrab *)_curTask;
    } else {
        job = _orderArray[position];
    }
    itemHeight = [WorkOrderGrabItemView calculateHeightByDesc:job.woDescription location:job.location andWidth:_realWidth];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[WorkOrderGrabItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = view;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
    }
    if(cell && !itemView) {
        itemView = [[WorkOrderGrabItemView alloc] init];
        [itemView setOnItemClickListener:self];
        [cell addSubview:itemView];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        
        [itemView setInfoWithOrder:job];
        if(_isWorking) {
            [itemView setShowGrabButton:NO];
        }
        itemView.tag = position;
    }
    
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(!_isWorking) {
        [_mPage reset];
        [self requestData];
    } else {
        [self stopRefresh];
    }
    
}


- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if(!_isWorking) {
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self requestData];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.0f];
        }
    } else {
        [self stopRefresh];
    }
    
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    if(!_isWorking) {
        [self goToWorkOrderDetail:position];
    } else {
        [self resetWorking];
    }
}


- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[WorkOrderGrabItemView class]]) {
        NSInteger position = view.tag;
        if(subView && subView.tag == WORK_ORDER_ITEM_OPERATE_TYPE_GRAB) {
            NSLog(@"开始抢单。");
            
            [self showOrderGrab:position];
            [self updateList];
        } else if( _isWorking) {
            [self resetWorking];
        } else {
            [self goToWorkOrderDetail:position];
        }
    } else if([view isKindOfClass:[GrabOrderContentItemView class]]) {
        NSInteger type = subView.tag;
        switch (type) {
            case GRAB_ORDER_CONTENT_ITEM_OPERATE_SELECT_TIME:
                [self showTimeSelectDialog];
                break;
            case GRAB_ORDER_CONTENT_ITEM_OPERATE_OK:
                [self grabWorkOrder];
                break;
            case GRAB_ORDER_CONTENT_ITEM_OPERATE_CANCEL:
                [self resetWorking];
                break;
                
            default:
                break;
        }
    }
}

//弹出框
//派工
- (void) resetWorking {
    _isWorking = NO;
    _curTask = nil;
    _estimateArriveTime = nil;
    [self updateList];
    [self setShowInfoView:NO];
}

- (void)setShowInfoView:(BOOL)show{
    
    [_infoView setHidden:NO];
    
    if(show)
    {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration
                              delay:0.0
                            options:0
                         animations:^{
                             [_orderTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight-_infoViewHeight)];
                             [_infoView setFrame:CGRectMake(0, _realHeight-_infoViewHeight, _realWidth, _infoViewHeight)];
                         }
                         completion:^(BOOL finished) {
                         }];
    } else  {
        [UIView animateWithDuration:[FMSize getInstance].defaultAnimationDuration
                              delay:0.0
                            options:0
                         animations:^{
                             [_orderTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
                             [_infoView setFrame:CGRectMake(0, _realHeight, _realWidth, _infoViewHeight)];
                         }
                         completion:^(BOOL finished) {
                             [_infoView setHidden:YES];
                         }];
        
    }
    
}



- (void) showOrderGrab:(NSInteger) position {
    if(_isWorking) {        //取消当前的弹出框
        [self resetWorking];
        
    } else {
        _isWorking = YES;
        _curTask = _orderArray[position];  //点击了待抢单工单
        _estimateArriveTime = nil;
        WorkOrderGrab * order = (WorkOrderGrab *) _curTask;
        CGFloat itemHeight = [WorkOrderGrabItemView calculateHeightByDesc:order.woDescription location:order.location andWidth:_realWidth];
        _infoViewHeight = _realHeight - itemHeight;
        [_grabContentView setInfoWith:_estimateArriveTime];
        [self updateList];
        [_infoView showType:@"grab"];
        [self setShowInfoView:YES];
    }
}



#pragma --- 请求网络数据

- (void) requestData {
    [self showLoadingDialog];
    GrabWorkOrderRequestParam * param = [[GrabWorkOrderRequestParam alloc] initWithPage:_mPage];
    WorkOrderNetRequest * netRequest = [WorkOrderNetRequest getInstance];
    [netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"可抢单信息获取成功。");
        NSDictionary* data = [responseObject valueForKeyPath:@"data"];
        
        NSDictionary * page = [data valueForKeyPath:@"page"];
        if(![page isKindOfClass:[NSNull class]]) {
            [_mPage setPageWithDictionary:page];
        }
        NSMutableArray * orders = [data valueForKeyPath:@"contents"];
        if([orders isKindOfClass:[NSNull class]]) {
            orders = nil;
        }
        if(!_orderArray) {
            _orderArray = [[NSMutableArray alloc] init];
        } else if([_mPage isFirstPage]){
            [_orderArray removeAllObjects];
        }
        NSNumber * tmpNumber;
        for(NSDictionary * order in orders) {
            WorkOrderGrab * job  = [[WorkOrderGrab alloc] init];
            job.woId = [order valueForKeyPath:@"woId"];
            if([job.woId isKindOfClass:[NSNull class]]) {
                job.woId = nil;
            }
            job.woCode = [order valueForKeyPath:@"code"];
            if([job.woCode isKindOfClass:[NSNull class]]) {
                job.woCode = nil;
            }
            tmpNumber = [order valueForKeyPath:@"priorityId"];
            if([tmpNumber isKindOfClass:[NSNull class]]) {
                tmpNumber = nil;
            }
            job.priority = [tmpNumber integerValue];
            
            job.woDescription = [order valueForKeyPath:@"woDescription"];
            if([job.woDescription isKindOfClass:[NSNull class]]) {
                job.woDescription = nil;
            }
            job.createDateTime = [order valueForKeyPath:@"createDateTime"];
            if([job.createDateTime isKindOfClass:[NSNull class]]) {
                job.createDateTime = nil;
            }
            job.location = [order valueForKeyPath:@"location"];
            if([job.location isKindOfClass:[NSNull class]]) {
                job.location = nil;
            }
            
            tmpNumber = [order valueForKeyPath:@"status"];
            if([tmpNumber isKindOfClass:[NSNull class]]) {
                tmpNumber = nil;
            }
            job.status = [tmpNumber integerValue];
            job.status = ORDER_STATUS_CREATE;   //TODO: 抢单测试代码
            
            tmpNumber = [order valueForKeyPath:@"currentLaborerStatus"];
            if([tmpNumber isKindOfClass:[NSNull class]]) {
                tmpNumber = nil;
            }
            if(tmpNumber) {
                job.laborerStatus = [tmpNumber integerValue];
            }
            
            tmpNumber = [order valueForKeyPath:@"grabType"];
            if([tmpNumber isKindOfClass:[NSNull class]]) {
                tmpNumber = nil;
            }
            job.grabType = [tmpNumber integerValue];
            job.grabType = WORK_ORDER_GRAB_TYPE_GRAB;   //TODO:抢单测试代码
            
            tmpNumber = [order valueForKeyPath:@"grabStatus"];
            if([tmpNumber isKindOfClass:[NSNull class]]) {
                tmpNumber = nil;
            }
            job.grabStatus = [tmpNumber integerValue];
            job.grabStatus = WORK_ORDER_GRAB_LABORER_STATUS_UNTOOK;   //TODO:抢单测试代码
            
            [_orderArray addObject:job];
        }
        
        [self performSelectorOnMainThread:@selector(updateList) withObject:nil waitUntilDone:NO];
        [self hideLoadingDialog];
        [self stopRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"可抢单信息获取失败。");
        [self stopRefresh];
        [self hideLoadingDialog];
        [self updateList];
    }];
}


#pragma --- 抢单
- (void) grabWorkOrder {
    NSLog(@"抢单中...");
    if(_estimateArriveTime) {
        WorkOrderGrab * order = (WorkOrderGrab *) _curTask;
        GrabWorkOrderParam * param = [[GrabWorkOrderParam alloc] init];
        param.userId = [SystemConfig getUserId];
        param.woId = [order.woId copy];
        param.arrivalDateTime = [_estimateArriveTime copy];
        
        WorkOrderNetRequest * netRequest = [WorkOrderNetRequest getInstance];
        [netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_grab_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self requestData];
            [self resetWorking];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_grab_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_designate_arrive_time" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
    _estimateArriveTime = nil;  //不管有没抢成功，数据清空
}




#pragma --- 跳转
- (void) goToWorkOrderDetail:(NSInteger) position {
    WorkOrderGrab * workJob = _orderArray[position];
    WorkOrderDetailViewController * taskDetailVC = [[WorkOrderDetailViewController alloc] init];
    [taskDetailVC setWorkOrderWithId:workJob.woId];
//    [taskDetailVC setLaborerStatus:workJob.laborerStatus];
    if([workJob isGrabAble]) {
//        [taskDetailVC setGrabAble:YES];
    }
    [self gotoViewController:taskDetailVC];
}


@end
