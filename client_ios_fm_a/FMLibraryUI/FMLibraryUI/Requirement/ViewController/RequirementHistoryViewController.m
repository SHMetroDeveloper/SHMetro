//
//  DemandQueryListControllerViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/12/22.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "RequirementHistoryViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "CustomAlertView.h"
#import "RequirementDetailViewController.h"
#import "RequirementEntity.h"
#import "ServiceCenterServerConfig.h"
#import "ServiceCenterNetRequest.h"
#import "RequirementItemView.h"
#import "RequirementManagerBusiness.h"
#import "ImageItemView.h"
#import "BaseTimePicker.h"
#import "TaskAlertView.h"
#import "MonthFilterTimeView.h"

@interface RequirementHistoryViewController ()<OnItemClickListener, OnClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) PullTableView * pullTableView;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementArray;

//@property (readwrite, nonatomic, strong) UIButton * preMonthBtn;
//@property (readwrite, nonatomic, strong) UIButton * nextMonthBtn;
//@property (readwrite, nonatomic, strong) UIButton * curMonthBtn;
@property (readwrite, nonatomic, strong) MonthFilterTimeView * timeFilterView;
@property (readwrite, nonatomic, assign) CGFloat timeControlHeight;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;

@property (readwrite, nonatomic, assign) NSInteger year;
@property (readwrite, nonatomic, assign) NSInteger month;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (readwrite, nonatomic, assign) CGFloat realWidth;   //
@property (readwrite, nonatomic, assign) CGFloat realHeight;   //

@property (readwrite, nonatomic, assign) BOOL isFirst;

@property (readwrite, nonatomic, strong) RequirementRequestCondition * condition;//查询条件
@property (readwrite, nonatomic, strong) RequirementManagerBusiness * business;

@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, assign) NSInteger pageSize;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;



@end

@implementation RequirementHistoryViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement_query" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initParameters];
    [self initAlertView];
    [self work];
}


- (void) initParameters {
    
    _itemHeight = 150;
    
    if (!_business) {
        _business = [RequirementManagerBusiness getInstance];
    }
    
    _requirementArray = [[NSMutableArray alloc] init];
    _mPage = [[NetPage alloc] init];

}

- (void) initLayout {
    if (!_mainContainerView) {
        _isFirst = YES;
        
        CGFloat originY = 0;
        CGRect mframe = [self getContentFrame];
        _realWidth = CGRectGetWidth(mframe);
        _realHeight = CGRectGetHeight(mframe);
        
        _timeControlHeight = [FMSize getInstance].topControlHeight;
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:mframe];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        UIView *controllView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _timeControlHeight)];
        [controllView setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND]];
        
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, originY + _timeControlHeight, _realWidth, _realHeight-_timeControlHeight)];
        _pullTableView.dataSource = self;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = self;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
        _timeFilterView = [[MonthFilterTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeControlHeight)];
        [_timeFilterView setCurrentTime:[FMUtils getTimeLongNow]];
        [_timeFilterView setOnMessageHandleListener:self];
        
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"requirement_my_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
        
        [_mainContainerView addSubview:_timeFilterView];
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}


- (void) initAlertView {
    _datePicker = [[BaseTimePicker alloc] init];
    [_datePicker setOnItemClickListener:self];
    
    _datePicker.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_datePicker setPickerType:BASE_TIME_PICKER_MONTH];
    
    CGFloat alertViewHeight = CGRectGetHeight(self.view.frame);
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_datePicker withKey:@"time" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
}


//更新提示
- (void) updateNotice:(NSString *) notice display:(BOOL) show {
    _noticeLbl.text = notice;
    if (show) {
        [_noticeLbl setHidden:NO];
    }else{
        [_noticeLbl setHidden:YES];
    }
}

- (void) showTimeSelectDialog {
    NSDate * curDate = nil;
    NSNumber * time = [_timeFilterView getCurrentTime];
    if(![FMUtils isNumberNullOrZero:time]) {
        curDate = [FMUtils timeLongToDate:time];
    } else
    {
        curDate = [NSDate date];
    }
    
    NSNumber *tmp = [FMUtils dateToTimeLong:curDate];
    [_datePicker setCenterDate:tmp];
    
    [_alertView showType:@"time"];
    [_alertView show];
}

- (void) work {
    [self requestData];
}

#pragma mark 数据请求
- (void) requestData {
    [self showLoadingDialog];
    RequirementRequestCondition * condition = [[RequirementRequestCondition alloc] init];
    condition.timeStart = [_timeFilterView getCurrentTimeBegin];
    condition.timeEnd = [_timeFilterView getCurrentTimeEnd];
    RequirementRequestParam * param = [[RequirementRequestParam alloc] initWithPage:_mPage andQueryType:REQUIREMENT_TYPE_HISTORY andCondition:condition];
    [_business getHistoryRequirementListDataByParam:param Success:^(NSInteger key, id object) {
        RequirementEntityResponseData * responseData = object;
        if (!responseData.page) {
            _mPage = nil;
        } else {
            _mPage = responseData.page;
        }
        
        if (!_requirementArray) {
            _requirementArray = [NSMutableArray new];
        } else if([_mPage isFirstPage]) {
            [_requirementArray removeAllObjects];
        }
        
        if (responseData.contents) {
            [_requirementArray addObjectsFromArray:responseData.contents];
        }
        
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [self updateList];
        [self hideLoadingDialog];
    }];
}



//更新列表
- (void) updateList {
    if([_mPage isFirstPage]) {
        [self refreshTable];
    } else {
        [self loadMoreDataToTable];
    }
    if(!_requirementArray || [_requirementArray count] == 0) {
        [self updateNotice:[[BaseBundle getInstance] getStringByKey:@"requirement_my_no_data" inTable:nil] display:YES];
    } else {
        [self updateNotice:@"" display:NO];
    }
    
    [_pullTableView reloadData];
    
}

#pragma mark - Refresh and load more methods
- (void) refreshTable {
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable {
    self.pullTableView.pullTableIsLoadingMore = NO;
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_requirementArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = [RequirementItemView getItemHeight];
    return itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    RequirementItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat itemHeight = [RequirementItemView getItemHeight];
//    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat padding = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    RequirementEntity* requirement = _requirementArray[position];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[RequirementItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[RequirementItemView alloc] initWithFrame:CGRectMake(padding, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if(seperator) {
        if(position < [_requirementArray count] - 1) {
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
        } else {
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }
        
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        
        [itemView setInfoWith:requirement];
        itemView.tag = position;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - PullTableViewDelegate
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    if(!_mPage) {
        _mPage = [[NetPage alloc] init];
    }
    [_mPage reset];
    [self work];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    if([_mPage haveMorePage]) {
        [_mPage nextPage];
        [self work];
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"no_more_data" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
    }
}

#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    [self goToDemandDetail:position];
}

- (void) goToDemandDetail:(NSInteger) position {
    RequirementDetailViewController * detailVC = [[RequirementDetailViewController alloc] init];
    RequirementEntity * requirement = _requirementArray[position];
    [detailVC setInforWith:requirement.reqId];
    [detailVC setEditable:NO];
    [self gotoViewController:detailVC];
}


#pragma mark - 时间选择
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _datePicker) {
        if(subView) {
            BaseTimePickerActionType type = subView.tag;
            NSNumber * time;
            switch(type) {
                case BASE_TIME_PICKER_ACTION_OK:
                    time = [_datePicker getSelectTime];
                    [_timeFilterView setCurrentTime:time];
                    [self work];
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

#pragma mark --- 消息处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_timeFilterView class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * tmpNumber = [result valueForKeyPath:@"eventType"];
            NSInteger type = tmpNumber.integerValue;
            switch (type) {
                case MONTH_FILTER_TYPE_SELECT_TIME:
                    [self performSelectorOnMainThread:@selector(showTimeSelectDialog) withObject:nil waitUntilDone:NO];
                    break;
                case MONTH_FILTER_TYPE_UPDATE:
                    [self initParameters];
                    [self updateList];
                    [self work];
                    break;
                default:
                    break;
            }
        }
    }
}

@end

