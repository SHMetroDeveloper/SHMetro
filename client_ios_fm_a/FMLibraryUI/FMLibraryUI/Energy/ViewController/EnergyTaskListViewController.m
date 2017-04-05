//
//  MeterMainListViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/1/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EnergyTaskListViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "PullTableView.h"
#import "SystemConfig.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "NetPage.h"

#import "BaseBundle.h"
#import "ImageItemView.h"
#import "EnergyTaskListEntity.h"
#import "EnergyTaskSubmitEntity.h"
#import "BaseItemView.h"
#import "EnergyBusiness.h"
#import "EnergyServerConfig.h"
#import "EnergyTaskDetailViewController.h"
#import "EnergyMissionListView.h"
#import "ImageItemView.h"


@interface EnergyTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) PullTableView * pullTableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, assign) NSInteger pageSize;

@property (readwrite, nonatomic, strong) NSMutableArray * taskArray;  //任务条数

@property (readwrite, nonatomic, strong) EnergyBusiness * business;
@end

@implementation EnergyTaskListViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)initLayout {
    if (!_mainContainerView) {
        
        _business = [EnergyBusiness getInstance];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mPage = [[NetPage alloc] init];
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _itemHeight = 60;
        
        //包含视图
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        //下拉更新tableview
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _pullTableView.dataSource = self;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = self;
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _pullTableView.delaysContentTouches = NO;
        
        //提醒视图
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"energy_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
        
        _taskArray = [[NSMutableArray alloc] init];
    }
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_energy_second_title" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self work];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//更新提示
- (void) updateNotice:(NSString *) notice display:(BOOL) show {
//    _noticeLbl.text = notice;
    if (show) {
        [_noticeLbl setHidden:NO];
    }else{
        [_noticeLbl setHidden:YES];
    }
}

- (void) work {
    [self requestData];
}

- (void) requestData {
    [self showLoadingDialog];
    EnergyTaskListRequestParam * param = [[EnergyTaskListRequestParam alloc] initWithpreRequestDate:[NSNumber numberWithLong:0] page:_mPage];

    [_business getEnergyTaskListByParam:param success:^(NSInteger key, id object) {
        EnergyTaskListResponseData * data = object;
        [_mPage setPage:data.page];
        NSArray * array = data.contents;
        if(!_taskArray) {
            _taskArray = [[NSMutableArray alloc] init];
        } else if ([_mPage isFirstPage]){
            [_taskArray removeAllObjects];
        }
        for(EnergyTaskEntity * entity in array) {
            if(entity.deleted) {
                continue;
            }
            [_taskArray addObject:entity];
        }
        [self hideLoadingDialog];
        [self updateList];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
    }];
}

- (void) stopRefresh {
    [self refreshTable];
    [self loadMoreDataToTable];
}

//更新列表
- (void) updateList {
    [self stopRefresh];
    
    if(!_taskArray|| [_taskArray count] == 0) {
        [self updateNotice:[[BaseBundle getInstance] getStringByKey:@"energy_no_data" inTable:nil] display:YES];
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
    return [_taskArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    EnergyTaskEntity * entity = _taskArray[position];
    CGFloat height = [EnergyMissionListView calculateheightByLastTime:entity.lastSubmitTime];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    SeperatorView * seperator = nil;
    EnergyMissionListView * itemView = nil;
    
    EnergyTaskEntity * entity = _taskArray[position];
    
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = [EnergyMissionListView calculateheightByLastTime:entity.lastSubmitTime];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if ([view isKindOfClass:[EnergyMissionListView class]]) {
                itemView = (EnergyMissionListView *)view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *)view;
            }
        }
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if (seperator) {
        if (position == _taskArray.count-1) {
            seperator.hidden = YES;
        } else {
            seperator.hidden = NO;
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
        }
    }
    if(cell && !itemView) {
        itemView = [[EnergyMissionListView alloc] init];
        [cell addSubview:itemView];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];

        [itemView setInfoWithTitle:entity.meterReadingName description:[EnergyServerConfig getEnergyCycleDescription:entity.readingCycle.integerValue] lastSubmitTime:entity.lastSubmitTime];
        itemView.tag = position;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self goToSecondList:position];
}


- (void) goToSecondList:(NSInteger) position {
    EnergyTaskDetailViewController * VC = [[EnergyTaskDetailViewController alloc] init];
    EnergyTaskEntity * entity = _taskArray[position];
    NSMutableArray * contents = entity.meters;
    [VC setInfoWithTitle:entity.meterReadingName];
    [VC setInfoWithArray:contents andMeterReadingId:entity.meterReadingId];
    [self gotoViewController:VC];
}

@end
