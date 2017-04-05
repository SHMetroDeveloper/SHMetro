//
//  SubModuleViewController.m
//  client_ios_fm_a
//
//  Created by Ausen Inesanet on 21/3/2017.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import "SubModuleViewController.h"
#import "PatrolTaskUnFinishedViewController.h"
#import "PullTableView.h"
#import "FunctionItemView.h"
#import "ProjectItem.h"
#import "UndoWorkOrderViewController.h"
#import "QrCodeViewController.h"
#import "FMImage.h"
#import "FMTheme.h"
#import "ApprovalOrderViewController.h"
#import "MaintenanceDetailViewController.h"
#import "PlannedMaintenanceViewController.h"
#import "BaseGroupView.h"
#import "DispachOrderViewController.h"
#import "PatrolNetRequest.h"
#import "PatrolTaskEntity.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "UIButton+BootStrap.h"
#import "FMSize.h"
#import "FMFont.h"
#import "GCD.h"
#import "EnergyTaskListViewController.h"


#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "UserViewController.h"
#import "PatrolDBHelper.h"
#import "PatrolSpotViewController.h"
#import "FunctionEntryItem.h"
#import "FunctionItemGridView.h"
#import "SeperatorView.h"
#import "MSGridView.h"
#import "ImageScrollView.h"

#import "PieChartViewController.h"
#import "ReportChartViewController.h"

#import "InventoryDockViewController.h"
#import "PowerManager.h"
#import "WorkOrderFunctionPermission.h"
#import "PatrolFunctionPermission.h"
#import "OrderUnValidatedViewController.h"
#import "OrderUnClosedViewController.h"

#import "FMChartView.h"

#import "AssetManageViewController.h"

#import "RequirementDockViewController.h"
#import "RequirementFunctionPermission.h"
#import "WorkOrderDockViewController.h"
#import "InventoryFunctionPermission.h"
#import "EnergyTaskListViewController.h"
#import "CommonBusiness.h"
#import "SDCycleScrollView.h"

#import "AttendanceViewController.h"

#import "DrawMarqueeView.h"
#import "PatrolDockViewController.h"
#import "PlannedMaintenanceFunctionPermission.h"
#import "AssetFunctionPermission.h"
#import "EnergyFunctionPermission.h"
#import "InventoryFunctionPermission.h"
#import "AttendanceFunctionPermission.h"
#import "BulletinFunctionPermission.h"
#import "ImageItemView.h"

#import "BaseBundle.h"
#import "AttachmentViewController.h"

#import "ContractDockViewController.h"
#import "ContractFunctionPermission.h"

#import "BulletinViewController.h"


#import "InfiniteLoopViewBuilder.h"
#import "LoopViewCell.h"
#import "InfiniteLoopModel.h"
#import "NodeStateView.h"
#import "BulletinBusiness.h"

#import "BulletinDetailViewController.h"

#import "QuickReportFunctionPermission.h"

#import "ScannerFunctionPermission.h"
#import "ScannerBusiness.h"
#import "AttendanceQrCode.h"
#import "UserEntity.h"
#import "BaseDataDbHelper.h"
#import "AttendanceEntity.h"
#import "PatrolSpotListViewController.h"
#import "EquipmentDetailViewController.h"
#import "PatrolSpotQrcode.h"
#import "EquipmentQrcode.h"

@interface SubModuleViewController () <MSGridViewDelegate, MSGridViewDataSource, SDCycleScrollViewDelegate,InfiniteLoopViewBuilderEventDelegate,DrawMarqueeViewDelegate,OnQrCodeScanFinishedListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;        //主容器
@property (readwrite, nonatomic, strong) UIScrollView * mainContentView;        //
@property (readwrite, nonatomic, strong) FMChartView * chartView;

@property (readwrite, nonatomic, strong) __block InfiniteLoopViewBuilder *loopView;  //循环滚动播放器
@property (readwrite, nonatomic, strong) __block NSMutableArray *bulletinHistory;  //置顶公告记录
@property (readwrite, nonatomic, assign) __block BOOL bulletinUpdated;   //公告记录是否刷新
@property (readwrite, nonatomic, strong) __block NSString *bulletinHistoryTitle;

@property (readwrite, nonatomic, strong) DrawMarqueeView *marqueeView;  //滚动显示label
@property (readwrite, nonatomic, assign) BOOL hasAnimated;

@property (readwrite, nonatomic, strong) MSGridView * functionsView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度
@property (readwrite, nonatomic, assign) CGFloat noticeImgHeight;   //提示图标高度

@property (readwrite, nonatomic, strong) NSString* qrcodeResult;
@property (readwrite, nonatomic, assign) BOOL isBackFromQrCode;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat seperatorSize;

@property (readwrite, nonatomic, assign) CGFloat imgPageHeight;
@property (readwrite, nonatomic, assign) CGFloat functionColumn;
@property (readwrite, nonatomic, strong) NSMutableArray * functionArray;    //功能列表
@property (readwrite, nonatomic, strong) UndoTaskEntity * undoTask;
@property (readwrite, nonatomic, strong) PowerManager * functionManager;;

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, assign) BOOL hasShowed;
@property (readwrite, nonatomic, assign) BOOL isWideScreen;

@property (readwrite, nonatomic, strong) HomeChartEntity * chartData;

@property (readwrite, nonatomic, strong) CommonBusiness * business;
@property (readwrite, nonatomic, strong) BulletinBusiness *bulletinBusiness;

@end

@implementation SubModuleViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _business = [CommonBusiness getInstance];
//    _bulletinBusiness = [BulletinBusiness getInstance];
    _isBackFromQrCode = NO;
    //[self initFunctions];
    [self initUI];
    [self updateList];
//    [self initFunctionPermissionUpdateHandler];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) initFunctions {
    NSLog(@"initFunctions");
    if(!_functionArray) {
        _functionArray = [[NSMutableArray alloc] init];
    } else {
        [_functionArray removeAllObjects];
    }
    
    [self initMainEntry];
}

- (void) initMainEntry {
    NSLog(@"initMainEntry");
    PowerManager * manager = [PowerManager getInstance];
    FunctionAccessPermissionType type = FUNCTION_ACCESS_PERMISSION_NONE;
    FunctionPermission *permission;
    
    //扫一扫
    permission = [manager getFunctionPermissionByKey:SCANNER_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        
        FunctionEntryItem *scannerFunction = [[FunctionEntryItem alloc] init];
        scannerFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_scanner" inTable:nil];
        scannerFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_scanner"];
        [_functionArray addObject:scannerFunction];
    }
    
    
    //公告
    permission = [manager getFunctionPermissionByKey:BULLETIN_FUNCTION];
    type = [permission getPermissionType];
    if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * noticeFunction = [[FunctionEntryItem alloc] init];
        noticeFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil];
        noticeFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_bulletin"];
        [_functionArray addObject:noticeFunction];
    }
    
    //快速报障
    permission = [manager getFunctionPermissionByKey:REQUIREMENT_FUNCTION];
    type = [permission getPermisstionTypeOfSubFunctionByKey:REQUIREMENT_SUB_FUNCTION_CREATE];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * quickReportFunction = [[FunctionEntryItem alloc] init];
        quickReportFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_quick_report" inTable:nil];
        quickReportFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_quick_report"];
        [_functionArray addObject:quickReportFunction];
    }
    
    
    //服务台
    permission = [manager getFunctionPermissionByKey:REQUIREMENT_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * serviceCenterFunction = [[FunctionEntryItem alloc] init];
        serviceCenterFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil];
        serviceCenterFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_requirement"];
        [_functionArray addObject:serviceCenterFunction];
    }
    
    
    //工单
    permission = [manager getFunctionPermissionByKey:WORK_ORDER_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * orderFunction = [[FunctionEntryItem alloc] init];
        orderFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_order" inTable:nil];
        orderFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_order"];
        [_functionArray addObject:orderFunction];
    }
    
    //巡检
    permission = [manager getFunctionPermissionByKey:PATROL_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * patrolFunction = [[FunctionEntryItem alloc] init];
        patrolFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil];
        patrolFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_patrol"];
        [_functionArray addObject:patrolFunction];
    }
    
    
    //计划性维护
    permission = [manager getFunctionPermissionByKey:PPM_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * ppmFunction = [[FunctionEntryItem alloc] init];
        ppmFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_maintenance" inTable:nil];
        ppmFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_ppm"];
        [_functionArray addObject:ppmFunction];
    }
    
    
    //资产
    permission = [manager getFunctionPermissionByKey:ASSET_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * assetFunction = [[FunctionEntryItem alloc] init];
        assetFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_asset" inTable:nil];
        assetFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_asset_managemanet"];
        [_functionArray addObject:assetFunction];
    }
    
    
    //能源管理
    permission = [manager getFunctionPermissionByKey:ENERGY_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * EnergyStarFunction = [[FunctionEntryItem alloc] init];
        EnergyStarFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_energy" inTable:nil];
        EnergyStarFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_energy"];
        [_functionArray addObject:EnergyStarFunction];
    }
    
    
    //库存
    permission = [manager getFunctionPermissionByKey:INVENTORY_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * inventoryFunction = [[FunctionEntryItem alloc] init];
        inventoryFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_inventory" inTable:nil];
        inventoryFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_inventory_manage"];
        [_functionArray addObject:inventoryFunction];
    }
    
    //在岗管理
    permission = [manager getFunctionPermissionByKey:ATTENDANCE_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * attendanceFunction = [[FunctionEntryItem alloc] init];
        attendanceFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_attendance" inTable:nil];
        attendanceFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_attendance"];
        [_functionArray addObject:attendanceFunction];
    }
    
    //合同
    permission = [manager getFunctionPermissionByKey:CONTRACT_FUNCTION];
    type = [permission getPermissionType];
    if (type != FUNCTION_ACCESS_PERMISSION_NONE) {
        FunctionEntryItem * contractFunction = [[FunctionEntryItem alloc] init];
        contractFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_contract" inTable:nil];
        contractFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_contract"];
        [_functionArray addObject:contractFunction];
    }

}

- (void) updateList {
    if(_mainContainerView && _functionArray) {
        NSInteger rowCount = ([_functionArray count] + (_functionColumn - 1))/_functionColumn;
        CGFloat itemHeight = [self getFunctionItemHeight];
        CGFloat minHeight = rowCount * itemHeight;
        _mainContentView.contentSize = CGSizeMake(_realWidth, minHeight);
        
        if(minHeight > 0) {//gridview 高度不能为 0，否则应用崩溃
            [_functionsView setHidden:NO];
            [_noticeLbl setHidden:YES];
            [_functionsView setFrame:CGRectMake(0, 0, _realWidth, minHeight)];
            [_functionsView reloadData];
        } else {
            [_functionsView setHidden:YES];
            [_noticeLbl setHidden:NO];
        }
    }
}

//获取宽度
- (CGFloat) getFunctionItemWidth {
    CGFloat itemWidth = _realWidth / _functionColumn * 1.0;
    return itemWidth;
}

//获取高度
- (CGFloat) getFunctionItemHeight {
    CGFloat itemWidth = [self getFunctionItemWidth];
    CGFloat itemHeight = (NSInteger)itemWidth ;
    return itemHeight;
}

- (void) initUI{
    NSLog(@"initUI");
    if(!_mainContainerView) {
        
        CGRect frame = [self getContentFrame];
        CGFloat tabBarHeight = [FMSize getInstance].tabbarHeight;
        CGFloat originY = 0;
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame) - tabBarHeight;
        frame.size.height = _realHeight;
        
        _seperatorSize = [FMSize getInstance].seperatorHeight;
        _functionColumn = 3;
        _noticeHeight = [FMSize getInstance].msgNoticeHeight;
        
        _imgPageHeight = _realHeight/3;
        _mainContainerView = [[UIScrollView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _chartView = [[FMChartView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _imgPageHeight)];
        
        //        NSMutableArray * imageNames = [[NSMutableArray alloc] initWithObjects:@"ad03", @"ad03", nil];
        //        _imgScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, originY, _realWidth, _imgPageHeight) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
        //        _imgScrollView.delegate = self;
        //        _imgScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        //        _imgScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        [_imgScrollView setCurrentPageDotColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME]];
        //        [_imgScrollView setPageDotColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f]];
        
        //        _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _imgPageHeight)];
        //        [_topImgView setImage:[[FMTheme getInstance] getImageByName:@"ad03"]];
        //        _topImgView.layer.masksToBounds = YES;
        
        
        //轮播图
        NSMutableArray *models = [NSMutableArray array];
        InfiniteLoopModel *model = [[InfiniteLoopModel alloc] init];
        model.infiniteLoopCellClass = [LoopViewCell class];
        model.infiniteLoopCellReuseIdentifier = [NSString stringWithFormat:@"LoopTypeTwoCell_%d", 0];
        [models addObject:model];
        
        _loopView = [[InfiniteLoopViewBuilder alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _imgPageHeight)];
        _loopView.nodeViewTemplate   = [NodeStateView new];
        _loopView.delegate           = self;
        _loopView.scrollTimeInterval = 5.f;
        _loopView.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
        _loopView.sampleNodeViewSize = CGSizeMake(20, 8);
        _loopView.position           = kNodeViewBottom;
        _loopView.scrollTimeInterval = 20000000000000000.0f;  //阻止滚动器自己滚动
        _loopView.edgeInsets         = UIEdgeInsetsMake(0, 0, 2, 2);
        _loopView.models             = (NSArray <InfiniteLoopViewProtocol, InfiniteLoopCellClassProtocol> *)models;
        [_loopView startLoopAnimated:YES];
        
        //题目走马灯
        _marqueeView = [[DrawMarqueeView alloc] initWithFrame:CGRectMake(16, originY + _imgPageHeight - 25 - 20, _realWidth-32, 25)];
        _marqueeView.speed             = 4.f;
        _marqueeView.delegate          = self;
        _marqueeView.marqueeDirection  = kDrawMarqueeLeft;
        
        
        
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        flowLayout.minimumLineSpacing = 0;//行间距(最小值)
        flowLayout.minimumInteritemSpacing = 0;//item间距(最小值)
        
        originY += _imgPageHeight - [FMSize getInstance].defaultBorderWidth;
        
        _mainContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _realHeight-originY)];
        _mainContentView.showsVerticalScrollIndicator = NO;
        _mainContentView.delaysContentTouches = NO;
        _mainContentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        _functionsView = [[MSGridView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight-originY)];
        _functionsView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _functionsView.gridViewDelegate = self;
        _functionsView.gridViewDataSource = self;
        _functionsView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _functionsView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        _functionsView.delaysContentTouches = NO;
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight - originY -_noticeHeight)/2 , _realWidth, _noticeHeight)];
        [_noticeLbl setLogoWidth:_noticeImgHeight];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"main_notice_no_function" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"notice_no_msg"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"notice_no_msg"]];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_DEFAULT_LABEL]];
        
        
        [_mainContentView addSubview:_functionsView];
        [_mainContainerView addSubview:_mainContentView];
        //        [_mainContainerView addSubview:_chartView];
        //        [_mainContainerView addSubview:_imgScrollView];
        
        //        [_mainContainerView addSubview:_topImgView];
        [_mainContainerView addSubview:_loopView];
        [_mainContainerView addSubview:_marqueeView];
        
        [_mainContentView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
