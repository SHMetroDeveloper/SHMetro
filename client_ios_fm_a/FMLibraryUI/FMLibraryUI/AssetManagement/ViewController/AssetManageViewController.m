//
//  AssetManageViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManageViewController.h"
//工具类
#import "AssetManageTableHelper.h"
#import "AssetManagementBusiness.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "FMFont.h"
#import "FMSize.h"
#import "QrCodeViewController.h"//二维码扫描
//controller类
#import "EquipmentDetailViewController.h"
#import "EquipmentListViewController.h"
#import "REFrostedViewController.h"
#import "EquipmentListFilterViewController.h"
//view类
#import "AssetStatusBarChartView.h"
#import "SystemConfig.h"
#import "EquipmentQueryViewController.h"
#import "BaseBundle.h"
#import "EquipmentQrcode.h"
#import "UserEntity.h"
#import "BaseDataDbHelper.h"


@interface AssetManageViewController () <OnMessageHandleListener,OnQrCodeScanFinishedListener>

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) AssetStatusBarChartView * barChartView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) AssetManageTableHelper * tableViewHelper;
@property (nonatomic, strong) AssetManagementBusiness * business;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) BOOL isBackFromQrCode;
@property (nonatomic, strong) EquipmentQrcode * equipQrcode;
@property (nonatomic, strong) AssetBaseInfoEntity * baseInfo;
@property (nonatomic, strong) BaseDataDbHelper *dbHelper;

@end

@implementation AssetManageViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_asset" inTable:nil]];
//    [self setNavigationColor:[UIColor colorWithRed:130/255.0 green:101/255.0 blue:203/255.0 alpha:255/255.0]];
    [self setNavigationColor:[UIColor clearColor]];
    [self setBackAble:YES];
    
    UIImage * imageQrCode = [[FMTheme getInstance]  getImageByName:@"icon_home_patrol"];
    NSArray * imageArray = @[imageQrCode];
    [self setMenuWithArray:imageArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self requestBaseInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"警告 警告，内存过高");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isBackFromQrCode) {
        _isBackFromQrCode = NO;
        [self handleQrcodeResult];
    }
}

- (void)initLayout {
    CGFloat height = self.view.frame.size.height;
    _headerHeight = height * 0.448f;
    
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    _business = [AssetManagementBusiness getInstance];
    _dbHelper = [BaseDataDbHelper getInstance];
    
    _tableViewHelper = [[AssetManageTableHelper alloc] initWithContext:self];
    [_tableViewHelper setOnMessageHandleListener:self];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    _headerView.backgroundColor = [UIColor colorWithRed:130/255.0 green:101/255.0 blue:203/255.0 alpha:255/255.0];
    
    //64为导航栏的高度
    _barChartView = [[AssetStatusBarChartView alloc] initWithFrame:CGRectMake(0, 64, _realWidth, _headerHeight - 64)];
    [_headerView addSubview:_barChartView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    [header addSubview:_headerView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, height)];
    _tableView.delegate = _tableViewHelper;
    _tableView.dataSource = _tableViewHelper;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = header;
    _tableView.backgroundColor = [FMColor getInstance].mainBackground;
    
    [self.view addSubview:_tableView];
}

- (void) updateLayoutOffsetY:(CGFloat) offsetY {
        CGRect headerViewRect = _headerView.frame;
        headerViewRect.origin.y = offsetY;
        headerViewRect.size.height = _headerHeight - offsetY;
        _headerView.frame = headerViewRect;
        
        CGRect barChartViewRect = _barChartView.frame;
        barChartViewRect.origin.y = 64 - offsetY;
        _barChartView.frame = barChartViewRect;
}

- (void) updateAssetInfo {
    
    [_tableView reloadData];
}

- (void) requestData {
    [self showLoadingDialog];
    AssetManagementEquipmentsRequestParam * param = [self getRequestParams];
    [_business getEquipmentsListDataByParam:param Success:^(NSInteger key, id object) {
        AssetManagementEquipmentsResponseData * response = object;
        [_tableViewHelper addEquipmentWithArray:response.contents];
        [self hideLoadingDialog];
        [self updateAssetInfo];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"%@",error);
        [self hideLoadingDialog];
    }];
}

- (void) requestBaseInfo {
    RequestAssetBaseInfoParam * param = [[RequestAssetBaseInfoParam alloc] init];
    param.postId = [SystemConfig getUserId];
    [_business getBaseInfoOfAsset:param success:^(NSInteger key, id object) {
        _baseInfo = object;
        NSLog(@"获取资产概况成功");
        [self updateBaseInfo];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"获取资产概况失败");
    }];
}

- (void) updateBaseInfo {
    [_tableViewHelper setInfoWithAmount:_baseInfo.totalCount system:_baseInfo.systemCount maintain:_baseInfo.maintainCount];
    [_tableView reloadData];
    [self updateChartData];
}

- (void) updateChartData {
    if(_baseInfo && _baseInfo.equipment) {
        NSMutableArray * data = [[NSMutableArray alloc] init];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.idle]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.stop]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.working]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.repairing]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.scraping]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.scraped]];
        [data addObject:[NSNumber numberWithInteger:_baseInfo.equipment.locked]];
        
        [_barChartView setEquipment:data];
    }
}


- (AssetManagementEquipmentsRequestParam *) getRequestParams {
    NetPage * page = [[NetPage alloc] init];
    SearchCondition *condition = [[SearchCondition alloc] init];
//    NSNumber *userId = [SystemConfig getUserId];
//    UserInfo *user = [_dbHelper queryUserById:userId];
//    condition.location = user.location;
    AssetManagementEquipmentsRequestParam * params = [[AssetManagementEquipmentsRequestParam alloc] initWithCondition:condition andPage:page];
    
    return params;
}

#pragma mark - 处理事件
- (void) handleMessage:(id) msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([_tableViewHelper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            AssetManageEventType type = [[result valueForKeyPath:@"eventType"] integerValue];
            switch (type) {
                case ASSET_MANAGE_SHOW_DETAIL: {
                    AssetManagementEquipmentsEntity * data = [result valueForKeyPath:@"eventData"];
                    [self gotoShowEquipmentDetailByEqid:data.eqId];
                }
                    break;
                    
                case ASSET_MANAGE_SHOW_MORE:
                    [self gotoShowMoreEquipments];
                    break;
                    
                case ASSET_MANAGE_DID_SCROLL: {
                    NSNumber * offsetY = [result valueForKeyPath:@"eventData"];
                    [self updateLayoutOffsetY:offsetY.floatValue];
                }
                    break;
            }
        }
    }
}

#pragma mark = 二维码扫描处理事件
- (void)onQrCodeScanFinished:(NSString *)result {
    _isBackFromQrCode = YES;
    _equipQrcode = [[EquipmentQrcode alloc] initWithString:result];
}

- (void) handleQrcodeResult {
    if(_equipQrcode && [_equipQrcode isValidQrcode]) {
        NSNumber * eqId = [_equipQrcode getEquipmentId];
        if(![FMUtils isNumberNullOrZero:eqId]) {
            [self gotoShowEquipmentDetailByEqid:eqId];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
        
    } else {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"asset_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

- (void) onMenuItemClicked: (NSInteger) position {
    if (position == 0) {
        [self goToQrCode];
    }
}

- (void) goToQrCode {
    QrCodeViewController * qrcodeVC = [[QrCodeViewController alloc] init];
    [qrcodeVC setBackAble:YES];
    [qrcodeVC setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:qrcodeVC];
}

- (void) gotoAssetDetail:(NSString *) uuid {
    EquipmentDetailViewController * viewController = [[EquipmentDetailViewController alloc] init];
    [viewController setUuid:uuid];
    [self gotoViewController:viewController];
}

- (void) gotoShowMoreEquipments {
    //筛选
    EquipmentQueryViewController * vc = [[EquipmentQueryViewController alloc] init];
    
    [self gotoViewController:vc];
}


- (void) gotoShowEquipmentDetailByEqid:(NSNumber *) equipmentId {
    EquipmentDetailViewController * viewController = [[EquipmentDetailViewController alloc] initWithEquipmentID:equipmentId];
    [viewController setEditable:YES];
    [self gotoViewController:viewController];
}

@end
