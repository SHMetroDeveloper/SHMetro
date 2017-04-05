//
//  FunctionsGridViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/9.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "FunctionsGridViewController.h"
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

@interface FunctionsGridViewController () <MSGridViewDelegate, MSGridViewDataSource, SDCycleScrollViewDelegate,InfiniteLoopViewBuilderEventDelegate,DrawMarqueeViewDelegate,OnQrCodeScanFinishedListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;        //主容器
@property (readwrite, nonatomic, strong) UIScrollView * mainContentView;        //
@property (readwrite, nonatomic, strong) FMChartView * chartView;
//@property (readwrite, nonatomic, strong) SDCycleScrollView *imgScrollView; //图片滚动播放器
//@property (readwrite, nonatomic, strong) UIImageView * topImgView;  //顶部展示图片
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


@implementation FunctionsGridViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
     NSLog(@"viewDidLoad");
    _business = [CommonBusiness getInstance];
    _bulletinBusiness = [BulletinBusiness getInstance];
    _isBackFromQrCode = NO;
    [self initFunctions];
    [self initUI];
    [self updateList];
    [self initFunctionPermissionUpdateHandler];
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestUndoNumber];
    [self requestBulletin];
    [self showTabBar];
    [self forbiddenSwipeBack];
    
    //二维码扫描结束
    if (_isBackFromQrCode) {
        
        _isBackFromQrCode = NO;
        [self handleQrCodeScanFinished];
    }
}

- (void) forbiddenSwipeBack {
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [[self view] addGestureRecognizer:leftRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft ) {
        NSLog(@"Left");
    }
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight ) {
        NSLog(@"Right");
    }
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

- (void) updateBulletin {
    if (_bulletinHistory.count > 0) {
        //轮播图的图片
        NSMutableArray *models = [NSMutableArray new];
        for (NSInteger i = 0; i < _bulletinHistory.count; i ++) {
            BulletinHistory *bulletinHistory = _bulletinHistory[i];
            InfiniteLoopModel *model = [[InfiniteLoopModel alloc] init];
            if (![FMUtils isNumberNullOrZero:bulletinHistory.imageId]) {
                model.imageUrl = [FMUtils getUrlOfImageById:bulletinHistory.imageId].absoluteString;
            }
            model.infiniteLoopCellClass = [LoopViewCell class];
            model.infiniteLoopCellReuseIdentifier = [NSString stringWithFormat:@"LoopTypeTwoCell_%ld", i];
            [models addObject:model];
        }
        self.loopView.models = (NSArray <InfiniteLoopViewProtocol, InfiniteLoopCellClassProtocol> *)models;
        [self.loopView startLoopAnimated:YES];
        
        //置顶公告的标题
        BulletinHistory *bulletinHistory = _bulletinHistory[0];
        _bulletinHistoryTitle = bulletinHistory.title;
        [_marqueeView addContentView:[self getMarqueeDisplayLabelBy:_bulletinHistoryTitle]];
        if (!_hasAnimated) {
            _hasAnimated = YES;
            [_marqueeView startAnimation];
        } else {
            [_marqueeView stopAnimation];
        }
    } else {
        NSMutableArray *models = [NSMutableArray array];
        InfiniteLoopModel *model = [[InfiniteLoopModel alloc] init];
        model.infiniteLoopCellClass = [LoopViewCell class];
        model.infiniteLoopCellReuseIdentifier = [NSString stringWithFormat:@"LoopTypeTwoCell_%d", 0];
        [models addObject:model];
        self.loopView.models = (NSArray <InfiniteLoopViewProtocol, InfiniteLoopCellClassProtocol> *)models;
        [self.loopView startLoopAnimated:YES];
    }
}

#pragma mark - InfiniteLoopViewBuilderEventDelegate
- (void)infiniteLoopViewBuilder:(InfiniteLoopViewBuilder *)infiniteLoopViewBuilder
                           data:(id <InfiniteLoopViewProtocol>)data
                  selectedIndex:(NSInteger)index
                           cell:(CustomInfiniteLoopCell *)cell {
    if (_bulletinHistory && _bulletinHistory.count > 0) {
        BulletinHistory *bulletinHistory = _bulletinHistory[index];
        BulletinDetailViewController *bulletinDetailVC = [[BulletinDetailViewController alloc] init];
        bulletinDetailVC.bulletinId = bulletinHistory.bulletinId;
        [self gotoViewController:bulletinDetailVC];
    }
}

- (void)infiniteLoopViewBuilder:(InfiniteLoopViewBuilder *)infiniteLoopViewBuilder
           didScrollCurrentPage:(NSInteger)index {
    if (_bulletinHistory && _bulletinHistory.count > 0) {
        BulletinHistory *bulletinHistory = _bulletinHistory[index];
        _bulletinHistoryTitle = bulletinHistory.title;
        [_marqueeView stopAnimation];
    }
}

- (void)drawMarqueeView:(DrawMarqueeView *)drawMarqueeView animationDidStopFinished:(BOOL)finished {
    [drawMarqueeView stopAnimation];
    dispatch_async(dispatch_get_main_queue(), ^{
        [drawMarqueeView addContentView:[self getMarqueeDisplayLabelBy:_bulletinHistoryTitle]];
        [drawMarqueeView startAnimation];
    });
}

- (UILabel *) getMarqueeDisplayLabelBy:(NSString *) title {
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, _realWidth-20, 20)];
    titleLbl.numberOfLines = 1;
    titleLbl.font = [FMFont setFontByPX:56];  //高度大约是19
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    titleLbl.text = title;
    [titleLbl sizeToFit];
    return titleLbl;
}


//初始化程序入口设置
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
    

    
    //附件
//    FunctionEntryItem * attachmentFunction = [[FunctionEntryItem alloc] init];
//    attachmentFunction.projectName = @"attachment";
//    attachmentFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"btn_more_highlight"];
//    [_functionArray addObject:attachmentFunction];
    

    //蓝牙工具
//    FunctionEntryItem * bluetoothToolsFunction = [[FunctionEntryItem alloc] init];
//    bluetoothToolsFunction.projectName = @"Bluetooth";
//    bluetoothToolsFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"audio_icon_sep"];
//    [_functionArray addObject:bluetoothToolsFunction];
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

- (void) updateFunctionPermission {
    NSLog(@"updateFunctionPermission");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initFunctions];
        [self updateList];
    });
}

- (void) initFunctionPermissionUpdateHandler {
    NSLog(@"initFunctionPermissionUpdateHandler");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FunctionPermissionUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateFunctionPermission)
                                                 name: @"FunctionPermissionUpdate"
                                               object: nil];
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

//更新表单
- (void) updateCharts {
    NSMutableArray* dateArray = [[NSMutableArray alloc] init];
    NSMutableArray * valueArray1 = [[NSMutableArray alloc] init];
    NSMutableArray * valueArray2 = [[NSMutableArray alloc] init];
    NSInteger count = 7;
    NSInteger index;
    if(_chartData) {
        count = [_chartData.workOrderCurrently count];
        for(index=0;index<count;index++) {
            WorkOrderCurrentlyEntity * item = _chartData.workOrderCurrently[count-1-index];
            //            NSDate * date = [FMUtils timeLongToDate:item.date];
            [dateArray addObject:[FMUtils getDateTimeDescriptionBy:item.date format:@"MM/dd"]];
            [valueArray1 addObject:[NSNumber numberWithInteger:item.finishedAmount]];
            [valueArray2 addObject:[NSNumber numberWithInteger:item.newAmount]];
        }
    } else {
        count = 7;
        NSNumber * today = [FMUtils getTimeLongNow];
        NSInteger secondsOfOneDay = 60 * 60 * 24 * 1000;
        for(index = 0; index < count;index++) {
            NSNumber * tmp = [NSNumber numberWithLongLong:(today.longLongValue - (count - 1 - index) * secondsOfOneDay)];
            NSDate * date = [FMUtils timeLongToDate:tmp];
//            NSString *strDate = [FMUtils getDayStr:date];
            NSString * strDate = [FMUtils getDateStrMMDD:date];
            [dateArray addObject:strDate];
            [valueArray1 addObject:[NSNumber numberWithInteger:0]];
            [valueArray2 addObject:[NSNumber numberWithInteger:0]];
        }
    }
    
    [_chartView clear];
    [_chartView setInfoWithDateKeys:dateArray];//日期
    [_chartView setFinishedInfoWithArray:valueArray1]; //已完成工单量
    [_chartView setTotalInfoWithArray:valueArray2];    //所有工单量
}

//更新数字统计提示
- (void) updateTaskNumber {
    for(FunctionEntryItem * func in _functionArray) {
        PowerManager * manager = [PowerManager getInstance];
        NSString * name = func.projectName;
        if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_order" inTable:nil]]) {
            func.projectState = 0;
            FunctionPermission * workOrderPermission = [manager getFunctionPermissionByKey:WORK_ORDER_FUNCTION];
            //待处理
            FunctionAccessPermissionType type = [workOrderPermission getPermisstionTypeOfSubFunctionByKey:WORK_ORDER_SUB_FUNCTION_UNDO];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.undoOrderNumber;
            }
            
            //待派工
            type = [workOrderPermission getPermisstionTypeOfSubFunctionByKey:WORK_ORDER_SUB_FUNCTION_DISPACH];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unArrangeOrderNumber;
            }
            
            //待审批
            type = [workOrderPermission getPermisstionTypeOfSubFunctionByKey:WORK_ORDER_SUB_FUNCTION_APPROVAL];//
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unApprovalOrderNumber;
            }
            
            //待存档
            type = [workOrderPermission getPermisstionTypeOfSubFunctionByKey:WORK_ORDER_SUB_FUNCTION_CLOSE];//
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unArchivedOrderNumber;
            }
            
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil]]) {
            FunctionPermission * patrolPermission = [manager getFunctionPermissionByKey:PATROL_FUNCTION];
            func.projectState = 0;
            
            //巡检任务
            FunctionAccessPermissionType type = [patrolPermission getPermisstionTypeOfSubFunctionByKey:PATROL_SUB_FUNCTION_TASK];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.patrolTaskNumber;
            }
            
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil]]) {
            FunctionPermission * requirementPermission = [manager getFunctionPermissionByKey:REQUIREMENT_FUNCTION];
            func.projectState = 0;
            
            //待处理
            FunctionAccessPermissionType type = [requirementPermission getPermisstionTypeOfSubFunctionByKey:REQUIREMENT_SUB_FUNCTION_UNDO];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.undoRequirementNumber;
            }
            
            //待审批
            type = [requirementPermission getPermisstionTypeOfSubFunctionByKey:REQUIREMENT_SUB_FUNCTION_APPROVAL];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unApprovalRequirementNumber;
            }
            
            //待评价
            type = [requirementPermission getPermisstionTypeOfSubFunctionByKey:REQUIREMENT_SUB_FUNCTION_EVALUATE];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unEvaluateRequirementNumber;
            }
            
        } else if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil]]) {
            FunctionPermission * requirementPermission = [manager getFunctionPermissionByKey:BULLETIN_FUNCTION];
            func.projectState = 0;
            
            //公告
            FunctionAccessPermissionType type = [requirementPermission getPermissionType];
            if(type != FUNCTION_ACCESS_PERMISSION_NONE) {
                func.projectState += _undoTask.unReadBulletinNumber;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateList];
    });
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

#pragma mark - 获取公告置顶数据 
- (void) requestBulletin {
    BulletinHistoryRequestParam *param = [[BulletinHistoryRequestParam alloc] init];
    param.type = 0;
    param.page = [[NetPageParam alloc] init];
    
    if (!_bulletinHistory) {
        _bulletinHistory = [NSMutableArray new];
    } else {
        [_bulletinHistory removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    [_bulletinBusiness getBulletinHistoryByParam:param Success:^(NSInteger key, id object) {
        BulletinHistoryResponseData *response = object;
        weakSelf.bulletinHistory = [NSMutableArray arrayWithArray:[response contents]];
        [weakSelf updateBulletin];
    } Fail:^(NSInteger key, NSError *error) {
        [weakSelf updateBulletin];
    }];
}


#pragma - 获取待处理任务数量
- (void) requestUndoNumber {
    BaseDataGetUndoTaskCountParam * requestParam = [[BaseDataGetUndoTaskCountParam alloc] init];
    [_business getTaskCountUndo:requestParam success:^(NSInteger key, id object) {
        _undoTask = object;
        [self updateTaskNumber];
    } fail:^(NSInteger key, NSError *error) {
        NSLog(@"------- fail to request task count ---------");
    }];
}


#pragma --- collection view
-(MSGridViewCell *)cellForIndexPath:(NSIndexPath*)indexPath inGridWithIndexPath:(NSIndexPath *)gridIndexPath {
    static NSString *reuseIdentifier = @"cell";
    MSGridViewCell *cell = [MSGridView dequeueReusableCellWithIdentifier:reuseIdentifier];
    FunctionItemGridView * functionItemView;
    NSInteger rowIndex = [indexPath indexAtPosition:0];
    NSInteger colIndex = [indexPath indexAtPosition:1];
    
    NSInteger position = rowIndex * _functionColumn + colIndex;
    CGFloat itemWidth = [self getFunctionItemWidth];
    CGFloat itemHeight = [self getFunctionItemHeight];
    CGFloat seperatorSize = 0;
    if (_isWideScreen) {
        seperatorSize = [FMSize getInstance].seperatorHeight + 0.1 + 0.1; //因视觉错觉问题 这里选择将其加粗0.1
    } else {
        seperatorSize = [FMSize getInstance].seperatorHeight + 0.1;
    }
    NSInteger tagBottom = 100;
    NSInteger tagRight = 200;
    SeperatorView * rightSeperator;
    SeperatorView * bottomSeperator;
    
    if(!cell) {
        cell = [[MSGridViewCell alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight) reuseIdentifier:reuseIdentifier];
        
    } else {
        NSArray * subViews = cell.contentView.subviews;
        for(UIView* view in subViews) {
            if([view isKindOfClass:[FunctionItemGridView class]]) {
                functionItemView = (FunctionItemGridView *)view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                if(view.tag == tagBottom) {
                    bottomSeperator = (SeperatorView *)view;
                } else if(view.tag == tagRight) {
                    rightSeperator = (SeperatorView *)view;
                }
            }
        }
    }
    
    if(cell && !rightSeperator) {
        rightSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(itemWidth-seperatorSize, 0, seperatorSize, itemHeight)];
        rightSeperator.tag = tagRight;
        [rightSeperator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
        [cell addSubview:rightSeperator];
    }
    
    if(cell && !bottomSeperator) {
        seperatorSize += 0.2;
        bottomSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorSize, itemWidth, seperatorSize)];
        bottomSeperator.tag = tagBottom;
        [bottomSeperator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
        [cell addSubview:bottomSeperator];
    }
    
    if(rightSeperator) {
        if(colIndex < _functionColumn-1) {//除了最后一列外，都加右分割线
            [rightSeperator setHidden:NO];
            
        } else {
            [rightSeperator setHidden:YES];
        }
    }
    
    if(cell && !functionItemView) {
        if(position < [_functionArray count]) { //工程Cell
            functionItemView = [[FunctionItemGridView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
            [cell addSubview:functionItemView];
        }
    }
    
    if(functionItemView && position < [_functionArray count]) {
        FunctionEntryItem * project = _functionArray[position];
        UIImage * logo = project.projectLogo;
        [functionItemView setInfoWithLogo:logo name:project.projectName message:project.projectMessage time:project.projectMessageTime state:project.projectState];
        [cell setClickAble:YES];
    } else {
        [cell setClickAble:NO];
    }
    cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    functionItemView.tag = position;
    return cell;
}

// Returns the number of supergrid rows
-(NSUInteger)numberOfGridRows {
    return 1;
}

// Returns the number of supergrid rows
-(NSUInteger)numberOfGridColumns {
    return 1;
}


-(NSUInteger)numberOfColumnsForGridAtIndexPath:(NSIndexPath*)indexPath {
    return _functionColumn;
}

-(NSUInteger)numberOfRowsForGridAtIndexPath:(NSIndexPath*)indexPath {
    NSUInteger count = 0;
    count = ([_functionArray count] + _functionColumn - 1) / _functionColumn;
    return count;
}

/*
 * If you want to specify a height
 *
 */

-(float)heightForCellRowAtIndex:(NSUInteger)row forGridAtIndexPath:(NSIndexPath *)gridIndexPath {
    CGFloat height = [self getFunctionItemHeight];
    return height;
}

-(void)didSelectCellWithIndexPath:(NSIndexPath*) indexPath {
    int position = [indexPath indexAtPosition:2]*_functionColumn+[indexPath indexAtPosition:3];
    if(position >= 0 && position < [_functionArray count]) {
        FunctionEntryItem * item = _functionArray[position];
        NSString * name = item.projectName;
        
        if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_order" inTable:nil]]) {
            [self gotoWorkOrder];
        } else if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_chart" inTable:nil]]) {
            [self gotoChart];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_maintenance" inTable:nil]]) {
            [self goToPreventiveMaintenance];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_asset" inTable:nil]]) {
            [self goToAssetManagement];
        }else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil]]) {
            [self gotoPatrol];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil]]) {
            [self gotoServiceCenter];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_inventory" inTable:nil]]) {
            [self gotoInventory];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_energy" inTable:nil]]) {
            [self gotoEnergy];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_attendance" inTable:nil]]) {
            [self gotoAttendance];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_contract" inTable:nil]]) {
            [self gotoContract];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil]]) {
            [self gotoNoticeCenter];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_quick_report" inTable:nil]]) {
            [self gotoQuickReport];
        } else if ([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_scanner" inTable:nil]]) {
            [self gotoScanner];
        }
//        else if ([name isEqualToString:@"Bluetooth"]) {
//            [self gotoBluetoothTools];
//        }
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark - 跳转


/**
 扫一扫
 */
- (void)gotoScanner {
    
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}


/**
 工单
 */
- (void) gotoWorkOrder {
    WorkOrderDockViewController * orderVC = [[WorkOrderDockViewController alloc] init];
    [self gotoViewController:orderVC];
}


/**
 巡检
 */
- (void) gotoPatrol {
    PatrolDockViewController * patrolVC = [[PatrolDockViewController alloc] init];
    [self gotoViewController:patrolVC];
}


/**
 服务台
 */
- (void) gotoServiceCenter {
    RequirementDockViewController * serviceCenterVC = [[RequirementDockViewController alloc] init];
    [self gotoViewController:serviceCenterVC];
}


/**
 计划性维护
 */
- (void)goToPreventiveMaintenance{
    PlannedMaintenanceViewController * testVC = [[PlannedMaintenanceViewController alloc] init];
    [self gotoViewController:testVC];
}


/**
 资产管理
 */
- (void) goToAssetManagement {
    AssetManageViewController * viewController = [[AssetManageViewController alloc] init];
    [self gotoViewController:viewController];
}


/**
 库存
 */
- (void) gotoInventory {
    InventoryDockViewController * inventoryVC = [[InventoryDockViewController alloc] init];
    [self gotoViewController:inventoryVC];
}


/**
 报表
 */
- (void) gotoChart {
//    PieChartViewController* chartVC = [[PieChartViewController alloc] init];
//    [self gotoViewController:chartVC];
    ReportChartViewController * chartVC = [[ReportChartViewController alloc] init];
    [self gotoViewController:chartVC];
}


/**
 签到打卡
 */
- (void) gotoAttendance {
    AttendanceViewController *attendanceVC = [[AttendanceViewController  alloc] init];
    [self gotoViewController:attendanceVC];
}

//- (void) gotoAttachment {
//    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] init];
//    [self gotoViewController:attachmentVC];
//}


/**
 公告中心
 */
- (void) gotoNoticeCenter {
    BulletinViewController *bulletinVC = [[BulletinViewController alloc] init];
    [self gotoViewController:bulletinVC];
}


/**
 快速报障
 */
- (void) gotoQuickReport {
    QuickReportViewController *vc = [[QuickReportViewController alloc] init];
    [self gotoViewController:vc];
}


/**
 知识库
 */
- (void) gotoLibrary {
    NSLog(@"跳转知识库。");
}


/**
 能源管理
 */
- (void) gotoEnergy {
    EnergyTaskListViewController * energyVC = [[EnergyTaskListViewController alloc] init];
    [self gotoViewController:energyVC];
}


/**
 合同
 */
- (void) gotoContract {
    ContractDockViewController * contractVC = [[ContractDockViewController alloc] init];
    [self gotoViewController:contractVC];
}


#pragma mark - 二维码扫描结束

/**
 监听二维码扫描结束

 @param result 扫描结果
 */
- (void)onQrCodeScanFinished:(NSString *)result {
    
    DLog(@"扫描结果：%@", result);
    
    _isBackFromQrCode = YES;
    _qrcodeResult = result;
}


/**
 二维码扫描结束后的处理
 */
- (void)handleQrCodeScanFinished {
    
    BOOL valid = NO;
    FMQrcode * qrcode = [[FMQrcode alloc] initWithString:_qrcodeResult];
    NSString *functionName = [qrcode getFunction];
    
    /* 巡检 */
    if([functionName isEqualToString:FM_QRCODE_FUNCTION_PATROL]) {
        
        PatrolSpotQrcode *patrolSpotQrcode = [[PatrolSpotQrcode alloc] initWithQrcode:qrcode];
        if([patrolSpotQrcode isValidQrcode]) {
            
            valid = YES;
            NSNumber *spotId = [patrolSpotQrcode getSpotId];
            NSString *spotName = [patrolSpotQrcode getSpotName];
            NSNumber *buildingId = [patrolSpotQrcode getBuildingId];
            NSString *buildingName = [patrolSpotQrcode getBuildingName];
            if (spotId) {
                
                [self gotoSpotsViewControllerBySpotId:spotId spotName:spotName];
            }
            else if (buildingId) {
                
                [self gotoSpotsViewControllerByBuildingId:buildingId buildingName:buildingName];
            }
        }
    }
    /* 设备 */
    else if([functionName isEqualToString:FM_QRCODE_FUNCTION_ASSET]) {
        
        EquipmentQrcode *equipmentQrcode = [[EquipmentQrcode alloc] initWithQrcode:qrcode];
        if([equipmentQrcode isValidQrcode]) {
            
            valid = YES;
            [self gotoAssetDetail:[[equipmentQrcode getEquipmentId] stringValue]];
        }
    }
    /* 委外人员 */
    else if([functionName isEqualToString:FM_QRCODE_FUNCTION_COMMON]) {
        
        AttendanceQrCode *employQrcode = [[AttendanceQrCode alloc] initWithQrcode:qrcode];
        if ([employQrcode isValidQrcode]) {
            
            valid = YES;
            if ([employQrcode.emType isEqualToNumber:@(USER_TYPE_OUTSOURCE)]) {
                
                [self requestAttendance:employQrcode.emId];
            }
            else {
                
                [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_not_outsource" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            }
        }
    }
    
    /* 二维码有误 */
    if(!valid) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_qrcode_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}


/**
 跳转到巡点位检任务详情

 @param spotId 点位ID
 @param spotName 点位名称
 */
- (void)gotoSpotsViewControllerBySpotId:(NSNumber *)spotId spotName:(NSString *)spotName {
    
    PatrolSpotListViewController * spotsVC = [[PatrolSpotListViewController alloc] init];
    [spotsVC setInfoWithSpotId:spotId spotName:spotName];
    [self gotoViewController:spotsVC];
}


/**
 跳转到巡检点位任务详情
 
 @param buildingId 站点ID
 @param buildingName 站点名称
 */
- (void)gotoSpotsViewControllerByBuildingId:(NSNumber *)buildingId buildingName:(NSString *)buildingName {
    
    PatrolSpotListViewController * spotsVC = [[PatrolSpotListViewController alloc] init];
    [spotsVC setInfoWithBuildingId:buildingId buildingName:buildingName];
    [self gotoViewController:spotsVC];
}


/**
 跳转到设备详情

 @param uuid 设备UUID
 */
- (void)gotoAssetDetail:(NSString *)uuid {
    
    EquipmentDetailViewController * viewController = [[EquipmentDetailViewController alloc] init];
    [viewController setUuid:uuid];
    [self gotoViewController:viewController];
}


/**
 请求签到

 @param personId 被签的委外人员ID
 */
- (void)requestAttendance:(NSNumber *)personId {
    
    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
    if (user && [user.type isEqualToNumber:@(USER_TYPE_STATION)]) {
        
        __weak typeof(self) weakSelf = self;
        
        //请求签到
        [weakSelf showLoadingDialog];
        [[ScannerBusiness getInstance] attendanceByPersonId:personId contactId:user.emId contactName:user.name location:user.location createTime:[FMUtils dateToTimeLong:[NSDate date]] Success:^(NSInteger key, id object) {
            
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            
        } fail:^(NSInteger key, NSError *error) {
            
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_faile" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            
            DLog(@"错误信息：%@", error);
        }];
    }
    else {
        
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_not_station" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}

@end
