//
//  MyRequirementViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/24.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "MyRequirementViewController.h"
#import "PullTableView.h"
#import "RequirementEntity.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "RequirementItemView.h"
#import "ServiceCenterServerConfig.h"
#import "ServiceCenterNetRequest.h"
#import "SystemConfig.h"
#import "SeperatorView.h"
#import "RequirementDetailViewController.h"
#import "BaseBundle.h"

@interface MyRequirementViewController () <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (readwrite, nonatomic, strong) PullTableView * pullTableView;
@property (readwrite, nonatomic, strong) NSMutableArray * requirementArray;

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;       //提示标签
@property (readwrite, nonatomic, assign) CGFloat noticeWidth;       //提示标签宽度
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;

@property (readwrite, nonatomic, assign) CGFloat padding;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, assign) NSInteger pageSize;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;


@end

@implementation MyRequirementViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _mPage = [[NetPage alloc] init];
        _padding = [FMSize getInstance].defaultPadding;
        _noticeHeight = [FMSize getInstance].defaultNoticeHeight;
        _itemHeight = 150;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        
        _pullTableView.dataSource = self;
        _pullTableView.pullDelegate = self;
        _pullTableView.delegate = self;
        
        _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _pullTableView.pullBackgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _pullTableView.pullArrowImage = [[FMTheme getInstance] getImageByName:@"grayArrow"];
        _pullTableView.pullTextColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        _noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"requirement_my_no_data" inTable:nil];
        [_noticeLbl setHidden:YES];
        
        [_mainContainerView addSubview:_pullTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_my_requirement" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
    [self work];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) work {
    [self requestData];
}

#pragma mark 数据请求
- (void) requestData {
    /**
     *  此处填写网络请求
     */
    [self showLoadingDialog];
    RequirementRequestParam * param = [[RequirementRequestParam alloc] initWithPage:_mPage andQueryType:REQUIREMENT_TYPE_MINE andCondition:nil];
    ServiceCenterNetRequest * netRequest = [ServiceCenterNetRequest getInstance];
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSNumber * projectId = [SystemConfig getCurrentProjectId];

    
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
    return _itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    RequirementItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat itemHeight = _itemHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
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
        [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
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
    [self gotoViewController:detailVC];
}



@end
