//
//  MaterialQueryViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "MaterialQueryViewController.h"
#import "FMUtilsPackages.h"
#import "InventoryBusiness.h"
#import "ImageItemView.h"
#import "MaterialQueryTableView.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "MaterialQueryFilterViewController.h"
#import "InventoryMaterialDetailViewController.h"

#import "BaseBundle.h"

@interface MaterialQueryViewController ()
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) MaterialQueryTableView *tableView;

@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, assign) CGFloat filterWidth;
@property (nonatomic, assign) CGFloat filterHeight;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;      //提示标签高度

@property (nonatomic, strong) InventoryBusiness *business;
@property (nonatomic, strong) __block NetPage *netPage;
@property (nonatomic, assign) NSInteger conditionType;   //搜索type
@property (nonatomic, strong) NSString *conditionParam;   //模糊查询关键字
@property (nonatomic, strong) NSString *conditionName;   //物资名字

@property (nonatomic, strong) __block NSMutableArray *materialArray;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation MaterialQueryViewController

- (void)initNavigation {
    [self setTitleWith:_warehouseName];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestMaterialData];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        _filterWidth = [FMSize getInstance].filterWidth;
        _filterHeight = [FMSize getInstance].filterHeight;
        
        _business = [InventoryBusiness getInstance];
        _netPage = [[NetPage alloc] init];
        _conditionType = 0;
        _conditionParam = nil;
        _conditionName = nil;
        _materialArray = [NSMutableArray new];
        
        _filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-_filterWidth-[FMSize getInstance].defaultPadding, _realHeight-_filterHeight-[FMSize getInstance].defaultPadding, _filterWidth, _filterHeight)];
        [_filterBtn addTarget:self action:@selector(moveLeft) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_normal"] forState:UIControlStateNormal];
        [_filterBtn setImage:[[FMTheme getInstance] getImageByName:@"filter_btn_highlight"] forState:UIControlStateHighlighted];
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        [_mainContainerView addSubview:self.noticeLbl];
        [_mainContainerView addSubview:_filterBtn];
        
        [self.view addSubview:_mainContainerView];
        
        [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    }
}

//- (void)filterMaterial {
//    NSMutableArray *tempArray = [NSMutableArray new];
//    for (InventoryMaterialQueryDetail *materialDetail in _materialArray) {
//        if (_conditionType == 0) {
//            [tempArray addObject:materialDetail];
//        } else if (_conditionType == 1) {  //状态为充足的物料
//            if (materialDetail.amount > materialDetail.minNumber) {
//                [tempArray addObject:materialDetail];
//            }
//        } else if (_conditionType == 2) {  //状态为紧缺的物料
//            if (materialDetail.amount <= materialDetail.minNumber) {
//                [tempArray addObject:materialDetail];
//            }
//        }
//    }
//    _materialArray = tempArray;
//}

- (void)updateList {
    //本地过滤
//    [self filterMaterial];
    
    if (_materialArray.count > 0) {
        [self.noticeLbl setHidden:YES];
    } else {
        [self.noticeLbl setHidden:NO];
    }
    
    if (_tableView.mj_footer.isRefreshing && ![_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    } else if (_tableView.mj_footer.isRefreshing && [_netPage haveMorePage]) {
        [_tableView.mj_footer endRefreshing];
    }
    
    if (_tableView.mj_header.isRefreshing) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
    
    _tableView.warehouseName = _warehouseName;
    _tableView.dataArray = _materialArray;
}

#pragma mark - Lazyload
- (MaterialQueryTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MaterialQueryTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.refreshBlock = ^(MaterialRefreshType type){
            if (type == MATERIAL_REFRESH_TYPE_REFRESH) {
                [weakSelf.netPage reset];
                [weakSelf.materialArray removeAllObjects];
                [weakSelf requestMaterialData];
            } else if (type == MATERIAL_REFRESH_TYPE_LOADMORE) {
                if ([weakSelf.netPage haveMorePage]) {
                    [weakSelf.netPage nextPage];
                    [weakSelf requestMaterialData];
                } else {
                    [weakSelf updateList];
                }
            }
        };
        
        _tableView.actionBlock = ^(NSNumber *inventoryId){
            [weakSelf gotoMaterialDetail:inventoryId];
        };
    }
    return _tableView;
}

- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_material_empty" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_noticeLbl setHidden:YES];
    }
    return _noticeLbl;
}


#pragma mark - NetWorking
- (void)requestMaterialData {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    
    InventoryMaterialQueryRequestParam *param = [self getQueryRequestParam];
    [_business requestMaterialListBy:param success:^(NSInteger key, id object) {
        InventoryMaterialQueryResponseData *responseData = object;
        weakSelf.netPage = responseData.page;
        if ([weakSelf.netPage isFirstPage]) {
            weakSelf.materialArray = responseData.contents;
        } else {
            [weakSelf.materialArray addObjectsFromArray:responseData.contents];
        }
 
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    }];
}

- (InventoryMaterialQueryRequestParam *)getQueryRequestParam {
    InventoryMaterialQueryCondition *condition = [[InventoryMaterialQueryCondition alloc] init];
    condition.type = _conditionType;
    condition.name = _conditionName;
    condition.param = _conditionParam;
    
    InventoryMaterialQueryRequestParam *param = [[InventoryMaterialQueryRequestParam alloc] init];
    param.warehouseId = _warehouseId;
    param.condition = condition;
    param.page.pageSize = _netPage.pageSize;
    param.page.pageNumber = _netPage.pageNumber;
    
    return param;
}

- (void) moveLeft {
    [self.frostedViewController presentMenuViewController];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([MaterialQueryFilterViewController class])]) {
            NSDictionary *result = [msg valueForKeyPath:@"result"];
            _conditionType = [[result valueForKeyPath:@"type"] integerValue];
            _conditionName = [result valueForKeyPath:@"name"];
            [_netPage reset];
            
            [self requestMaterialData];
        }
    }
}

#pragma mark - PushEvent 
- (void)gotoMaterialDetail:(NSNumber *)inventoryId {
    InventoryMaterialDetailViewController *materialDetailVC = [[InventoryMaterialDetailViewController alloc] init];
    materialDetailVC.inventoryId = inventoryId;
    materialDetailVC.isEditAble = NO;
    
    [self gotoViewController:materialDetailVC];
}

@end
