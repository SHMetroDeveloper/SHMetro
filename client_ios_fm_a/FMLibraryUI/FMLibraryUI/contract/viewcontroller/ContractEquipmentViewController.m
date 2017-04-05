//
//  ContractEquipmentViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractEquipmentViewController.h"
#import "EquipmentDetailViewController.h"
#import "FMUtilsPackages.h"
#import "ContractEquipmentTableViewCell.h"
#import "ContractBusiness.h"
#import "FMLoadMoreFooterView.h"


static NSString *cellIdentifier = @"cellIdentifier";

@interface ContractEquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ContractBusiness *business;
@property (nonatomic, strong) __block NetPage *netPage;
@property (nonatomic, strong) __block NSMutableArray *equipmentArray;
@property (nonatomic, strong) NSNumber *contractId;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;
@end

@implementation ContractEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_equipment_detail_title" inTable:nil]];
    [self setBackAble:YES];
}

- (void)initLayout {
    CGRect mFrame = [self getContentFrame];
    _realWidth = CGRectGetWidth(mFrame);
    _realHeight = CGRectGetHeight(mFrame);
    
    if (!_business) {
        _business = [ContractBusiness getInstance];
    }
    if (!_netPage) {
        _netPage = [[NetPage alloc] init];
    }
    if (!_equipmentArray) {
        _equipmentArray = [NSMutableArray new];
    }
    
    _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
    
    [_mainContainerView addSubview:self.tableView];
    
    [self.view addSubview:_mainContainerView];
    
    if (_equipmentArray.count > 0) {
        [self updateList];
    }
}

#pragma mark - Lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_tableView registerClass:[ContractEquipmentTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        
        _tableView.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreEquipment)];
    }
    return _tableView;
}

#pragma mark - Private Method
- (void)setContractId:(NSNumber *)contractId equipmentDataArray:(NSMutableArray *)dataArray andNetPage:(NetPage *)netPage {
    if (!_equipmentArray) {
        _equipmentArray = [NSMutableArray new];
    }
    if (!_netPage) {
        _netPage = [[NetPage alloc] init];
    }
    
    _contractId = contractId;
    _equipmentArray = [NSMutableArray arrayWithArray:dataArray];
    [_netPage setPage:netPage];
}

- (void)updateList {
    if (_tableView.mj_footer.isRefreshing && ![_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else if (_tableView.mj_footer.isRefreshing && [_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)loadMoreEquipment {
    if ([_netPage haveMorePage]) {
        [_netPage nextPage];
        [self requestEquipmentData];
    } else {
        [self updateList];
    }
}

#pragma mark - NetWorking
- (void)requestEquipmentData {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getEquipmentListOfContract:_contractId andPage:_netPage success:^(NSInteger key, id object) {
        ContractEquipmentResponseData *data = (ContractEquipmentResponseData *)object;
        weakSelf.netPage = data.page;
        if ([weakSelf.netPage isFirstPage]) {
            weakSelf.equipmentArray = [NSMutableArray arrayWithArray:data.contents];
        } else {
            [weakSelf.equipmentArray addObjectsFromArray:data.contents];
        }
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

- (void)gotoEquipmentDetailByID:(NSNumber *)equipmentId {
    EquipmentDetailViewController *equipmentDetailVC = [[EquipmentDetailViewController alloc] initWithEquipmentID:equipmentId];
    [self gotoViewController:equipmentDetailVC];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _equipmentArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    height = [ContractEquipmentTableViewCell getItemHeight];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ContractEquipmentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    ContractEquipment *equipment = _equipmentArray[position];
    if (position == _equipmentArray.count-1) {
        [cell setSeperatorGapped:NO];
    } else {
        [cell setSeperatorGapped:YES];
    }
    [cell setEquipmentCode:equipment.code];
    [cell setEquipmentName:equipment.name];
    [cell setEquipmentLocation:equipment.location];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    ContractEquipment *equipment = _equipmentArray[position];
    [self gotoEquipmentDetailByID:equipment.equipmentId];
}

@end
