//
//  AssetCoreComponentViewController.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "EquipmentCoreComponentDetailViewController.h"
#import "EquipmentCoreComponentDetailTableView.h"
#import "FMUtilsPackages.h"
#import "AssetManagementBusiness.h"

@interface EquipmentCoreComponentDetailViewController ()
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) EquipmentCoreComponentDetailTableView *tableView;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, strong) NSNumber *eqCoreId;
@property (nonatomic, strong) AssetCoreComponentDetailEntity *coreComponentDetail;
@property (nonatomic, strong) AssetManagementBusiness *business;
@end

@implementation EquipmentCoreComponentDetailViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"core_component_navi_title" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realHeight = CGRectGetHeight(mFrame);
        _realWidth = CGRectGetWidth(mFrame);
        
        _business = [AssetManagementBusiness getInstance];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

#pragma mark - Lazy load
- (EquipmentCoreComponentDetailTableView *)tableView {
    if (!_tableView) {
        _tableView = [[EquipmentCoreComponentDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
    }
    return _tableView;
}

#pragma mark - Private Methods
- (void)setEqCoreId:(NSNumber *)eqCoreId {
    _eqCoreId = eqCoreId;
}

- (void)updateList {
    [_tableView setCoreComponentDetail:_coreComponentDetail];
}

#pragma mark - NetWorking
- (void)requestData {
    [self showLoadingDialog];
    AssetCoreComponentDetailRequestParam *param = [[AssetCoreComponentDetailRequestParam alloc] init];
    param.eqCoreId = _eqCoreId;
    __weak typeof(self) weakSelf = self;
    [_business getCoreComponentDetailByParam:param Success:^(NSInteger key, id object) {
        weakSelf.coreComponentDetail = (AssetCoreComponentDetailEntity *)object;
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.coreComponentDetail = nil;
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}


@end
