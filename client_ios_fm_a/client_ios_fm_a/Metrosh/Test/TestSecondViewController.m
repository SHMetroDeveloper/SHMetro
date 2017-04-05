//
//  TestSecondViewController.m
//  client_ios_fm_a
//
//  Created by flynn.yang on 2017/2/22.
//  Copyright © 2017年 facilityone. All rights reserved.
//

#import "TestSecondViewController.h"


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

#import "LoginViewController.h"
#import "BussinessUserInfo.h"

@interface TestSecondViewController () <MSGridViewDelegate, MSGridViewDataSource , SDCycleScrollViewDelegate,InfiniteLoopViewBuilderEventDelegate>


@property (readwrite, nonatomic, strong) UIView * mainContainerView;        //主容器
@property (readwrite, nonatomic, strong) UIScrollView * mainContentView;        //

@property (readwrite, nonatomic, strong) MSGridView * functionsView;

@property (readwrite, nonatomic, strong) NSMutableArray * functionArray;    //功能列表
@property (readwrite, nonatomic, strong) __block InfiniteLoopViewBuilder *loopView;  //循环滚动播放器

@property (readwrite, nonatomic, assign) BOOL hasAnimated;


@property (readwrite, nonatomic, strong) HomeChartEntity * chartData;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat seperatorSize;

@property (readwrite, nonatomic, assign) CGFloat imgPageHeight;
@property (readwrite, nonatomic, assign) CGFloat functionColumn;

//@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度
@property (readwrite, nonatomic, assign) CGFloat noticeImgHeight;   //提示图标高度
@property (readwrite, nonatomic, assign) BOOL isWideScreen;

@property (readwrite, nonatomic, assign) __block BOOL bulletinUpdated;   //公告记录是否刷新
@property (readwrite, nonatomic, strong) __block NSString *bulletinHistoryTitle;

@property (readwrite, nonatomic, strong) __block NSMutableArray *bulletinHistory;  //置顶公告记录

@end

@implementation TestSecondViewController

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
    // Do any additional setup after loading the view.
    [self cleanFunctions];
    [self initFunctions];
    [self initUI];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
 }


- (void) initNavigation {
    [self setTitleWith:@"FM-ONE"];
}

- (void) cleanFunctions {
    
    if(!_functionArray) {
        _functionArray = [[NSMutableArray alloc] init];
    } else {
        [_functionArray removeAllObjects];
    }
}

- (void) initFunctions {

    FunctionEntryItem * noticeFunction = [[FunctionEntryItem alloc] init];
    noticeFunction.projectName = [[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil];
    noticeFunction.projectLogo = [[FMTheme getInstance] getImageByName:@"home_function_bulletin"];
    [_functionArray addObject:noticeFunction];
    
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
        
        [_mainContentView addSubview:_functionsView];
        [_mainContainerView addSubview:_mainContentView];
        [_mainContainerView addSubview:_loopView];

        
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
       // [_marqueeView stopAnimation];
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


- (void) updateFunctionPermission {
//    NSLog(@"updateFunctionPermission");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self initFunctions];
//        [self updateList];
//    });
}

- (void) initFunctionPermissionUpdateHandler {
//    NSLog(@"initFunctionPermissionUpdateHandler");
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FunctionPermissionUpdate" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(updateFunctionPermission)
//                                                 name: @"FunctionPermissionUpdate"
//                                               object: nil];
}

- (void) updateList {
    if(_mainContainerView && _functionArray) {
        NSInteger rowCount = ([_functionArray count] + (_functionColumn - 1))/_functionColumn;
        CGFloat itemHeight = [self getFunctionItemHeight];
        CGFloat minHeight = rowCount * itemHeight;
        _mainContentView.contentSize = CGSizeMake(_realWidth, minHeight);
        
        if(minHeight > 0) {//gridview 高度不能为 0，否则应用崩溃
            [_functionsView setHidden:NO];
           // [_noticeLbl setHidden:YES];
            [_functionsView setFrame:CGRectMake(0, 0, _realWidth, minHeight)];
            [_functionsView reloadData];
        } else {
            [_functionsView setHidden:YES];
           // [_noticeLbl setHidden:NO];
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
        
        LoginViewController  * login =   [[LoginViewController alloc] init];
        BussinessUserInfo * userInfo = [BussinessUserInfo getSingleton];
        
        
        [login setPrimaryToken : [userInfo getToken]];
        [self gotoViewController : login];
        
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
 
 */

/**
 二维码扫描结束后的处理
 */
/**
 跳转到巡检任务详情
 
 @param spotCode 点位ID
 */
- (void)gotoSpotsViewController:(NSString *)spotCode {
    
    PatrolSpotListViewController * spotsVC = [[PatrolSpotListViewController alloc] init];
    [spotsVC setInfoWithCode:spotCode];
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
