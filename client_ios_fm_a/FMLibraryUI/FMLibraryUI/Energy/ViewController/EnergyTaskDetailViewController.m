//
//  MissionListViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyTaskDetailViewController.h"
#import "SystemConfig.h"
#import "PullTableView.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "SeperatorView.h"
#import "NetPage.h"
#import "BaseBundle.h"

#import "ImageItemView.h"
#import "MissionCheckView.h"
#import "EnergyTaskContentViewController.h"
#import "EnergyTaskListEntity.h"
#import "EnergyTaskSubmitEntity.h"
#import "EnergyServerConfig.h"
#import "EnergyBusiness.h"

@interface EnergyTaskDetailViewController ()<UITableViewDataSource, UITableViewDelegate,OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * pullTableView;
//@property (readwrite, nonatomic, strong) UILabel * noticeLbl;       //提示标签

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度


//@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
//@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * contentArray;  //存放任务实体的数组
@property (readwrite, nonatomic, strong) NSMutableArray * resultArray;//存放上传数据的数组

@property (readwrite, nonatomic, assign) NSInteger currentIndex;
@property (readwrite, nonatomic, strong) NSString * nowTime;
@property (readwrite, nonatomic, strong) NSString * titleDetail;
@property (readwrite, nonatomic, strong) NSNumber * meterReadingId;

@property (readwrite, nonatomic, strong) EnergyBusiness * business;

@end

@implementation EnergyTaskDetailViewController

- (instancetype)init {
   self = [super init];
    return self;
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _business = [EnergyBusiness getInstance];
        
        _noticeHeight = [FMSize getInstance].noticeHeight;

        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _pullTableView.dataSource = self;
        _pullTableView.delegate = self;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"energy_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        

        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
      
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
        
        [self updateList];
    }
}

- (void)initNavigation {
    [self setTitleWith:_titleDetail];
    NSArray *menuArray = @[[[BaseBundle getInstance] getStringByKey:@"btn_title_upload" inTable:nil]];
    [self setMenuWithArray:menuArray];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 数据来源
- (void) setInfoWithTitle:(NSString *) title {
    _titleDetail = title;
    [self initNavigation];
}

- (void) setInfoWithArray:(NSArray *) meters andMeterReadingId:(NSNumber *) meterReadingId {
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    if (!_resultArray) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    for(EnergyTaskDetailEntity * content in meters) {
        if(content.deleted) {
            continue;
        }
        [_contentArray addObject:content];
        
        EnergyTaskResultItem * res = [[EnergyTaskResultItem alloc] init];
        res.meterId = content.meterId;
        [_resultArray addObject:res];
    }
    _meterReadingId = meterReadingId;
}

//是否需要上传
- (BOOL) needToSubmit {
    BOOL res = NO;
    for(EnergyTaskResultItem *item in _resultArray) {
        if(item.result) {
            res = YES;
            break;
        }
    }
    
    if (!_resultArray || _resultArray.count == 0) {
        res = NO;
    }
    
    return res;
}

- (void) uploadRightNow {
    if (![self needToSubmit]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"energy_notice_no_need_submit" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    
    [self showLoadingDialog];
    NSNumber * time = [FMUtils getTimeLongNow];
    EnergyTaskSubmitParam * param = [[EnergyTaskSubmitParam alloc] initWithMeterReadingId:_meterReadingId startDateTime:time endDateTime:time results:_resultArray];
    [_business requestSubmitEnergyTask:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"data_submit_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"data_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];

        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"data_submit_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//更新列表
- (void) updateList {
    if(!_contentArray || [_contentArray count] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
    [_pullTableView reloadData];
}

- (BOOL) taskIsChecked:(NSInteger) position {
    BOOL checked = NO;
    EnergyTaskResultItem * parameterEntity = _resultArray[position];
    if (![FMUtils isStringEmpty:parameterEntity.result]) {
        checked = YES;
    }
    
    return checked;
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (position == 0) {
        [self uploadRightNow];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChecked = [self taskIsChecked:indexPath.row];
    return [MissionCheckView calculateHeightByFinished:isChecked];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    
    MissionCheckView * itemView = nil;
    SeperatorView * seperator = nil;
    
    BOOL isChecked = [self taskIsChecked:indexPath.row];
    CGFloat itemHeight = [MissionCheckView calculateHeightByFinished:isChecked];
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        NSArray * subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[MissionCheckView class]]) {
                itemView = (MissionCheckView *)view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *)view;
            }
        }
    }
    if (cell && !itemView) {
        itemView = [[MissionCheckView alloc] init];
        [cell addSubview:itemView];
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if(seperator) {
        if (position == _contentArray.count -1) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        } else {
            [seperator setDotted:YES];
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
        }
    }
    if (itemView) {
        EnergyTaskDetailEntity * entity = _contentArray[position];
        EnergyTaskResultItem * item = _resultArray[position];
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        [itemView setInfoWithMeterName:entity.meterName location:entity.location andFinsihTime:_nowTime];
        if (![FMUtils isStringEmpty:item.result]) {
            [itemView setFinished:YES];
            [itemView setEndTime:_nowTime];
        }
    }
    return cell;
}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:@"MissionDetailViewController"]) {
            NSString * content = [msg valueForKeyPath:@"result"];
            NSNumber * meterId = [msg valueForKeyPath:@"meterId"];
            EnergyTaskResultItem * item = [[EnergyTaskResultItem alloc] init];
            item.meterId = meterId;
            item.result = content;
            
            _resultArray[_currentIndex] = item;
            _nowTime = [FMUtils getMinuteStr:[FMUtils timeLongToDate:[FMUtils getTimeLongNow]]];
            NSIndexPath * tempIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
            [_pullTableView reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark 点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self goToCopyMeters:position];
}

- (void) goToCopyMeters:(NSInteger) position {
    //记录点击的是哪个细分任务，在handlemessage的时候有用
    _currentIndex = position;
    EnergyTaskDetailEntity * entity = _contentArray[_currentIndex];
    EnergyTaskResultItem * result = _resultArray[_currentIndex];
    
    EnergyTaskContentViewController * contentVC = [[EnergyTaskContentViewController alloc] init];
    [contentVC setInfoWithTitile:entity.meterName andUnit:entity.unit andResult:result.result andMeterId:entity.meterId];
    [contentVC setOnMessageHandleListener:self];
    
    [self gotoViewController:contentVC];
}

@end

