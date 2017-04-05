//
//  PatrolDockViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolDockViewController.h"
#import "HeaderCollectionReusableView.h"
#import "FMUtilsPackages.h"
#import "FunctionItemGridView.h"
#import "FunctionEntryItem.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

#import "PowerManager.h"
#import "PatrolFunctionPermission.h"
#import "CommonBusiness.h"
#import "FMTheme.h"
#import "ScanHeaderCollectionReusableView.h"
#import "QrCodeViewController.h"
#import "PatrolSpotViewController.h"
#import "PatrolSpotListViewController.h"
#import "PatrolBusiness.h"
#import "BaseDataDownloader.h"
#import "FunctionGridCollectionViewCell.h"
#import "PatrolSpotQrcode.h"

@interface PatrolDockViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, OnQrCodeScanFinishedListener>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) ScanHeaderCollectionReusableView * headerView;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat seperatorheight;
@property (nonatomic, assign) NSInteger colCount;   //列数

@property (readwrite, nonatomic, strong) NSMutableArray * functionArray;    //功能列表
@property (readwrite, nonatomic, strong) UndoTaskEntity * undoTask;
@property (readwrite, nonatomic, strong) PatrolSpotQrcode * spotQrcode;

@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法
@property (nonatomic, strong) CommonBusiness * business;

@property (readwrite, nonatomic, strong) PatrolBusiness * patrolbusiness;
@property (readwrite, nonatomic, strong) PatrolDBHelper * dbHelper;
@property (readwrite, nonatomic, strong) NetPage * mPage;
@property (readwrite, nonatomic, strong) NSMutableArray * taskIdArray;
@property (readwrite, nonatomic, strong) LocalTaskManager * manager;

@end

@implementation PatrolDockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mPage = [[NetPage alloc] init];
    _business = [CommonBusiness getInstance];
    _patrolbusiness = [PatrolBusiness getInstance];
    _dbHelper = [PatrolDBHelper getInstance];
    [self initFunctions];
    
    dispatch_queue_t patrolQueue = dispatch_queue_create("patrol.task", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(patrolQueue, ^{
        [self requestPatrolTask];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_backFromQrcode) {
        _backFromQrcode = NO;
        [self handleQrcodeResult];
    }
    [self requestUndoNumber];
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_patrol" inTable:nil]];
    [self setBackAble:YES];
    [self setNavigationColor:[UIColor colorWithRed:163/255.0 green:190/255.0 blue:101/255.0 alpha:1]];
}

- (void)initLayout {
    CGRect frame = self.view.frame;
    _realHeight = frame.size.height;
    _realWidth = frame.size.width;
    
    _headerHeight = self.view.frame.size.height * 0.308 + 20;
    _seperatorheight = [FMSize getInstance].seperatorHeight;
    _colCount = 3;
    
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight) collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delaysContentTouches = NO;
    _collectionView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[FunctionGridCollectionViewCell class] forCellWithReuseIdentifier:@"cellIndentifier"];
    [_collectionView registerClass:[ScanHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
}

- (void) initEntry {
    PowerManager * manager = [PowerManager getInstance];
    FunctionPermission *permission = [manager getFunctionPermissionByKey:PATROL_FUNCTION];
    NSArray *functions = [permission getAllFunctions];
    for(FunctionItem * item in functions) {
        if(item.permissionType != FUNCTION_ACCESS_PERMISSION_NONE && item.isFormal) {
            FunctionEntryItem *entry = [[FunctionEntryItem alloc] init];
            entry.projectName = item.name;
            entry.projectLogo = [[FMTheme getInstance] getImageByName:item.iconName];
            entry.entryClass = item.entryClass;
            [_functionArray addObject:entry];
        }
    }
}

- (void) initFunctions {
    if (!_functionArray) {
        _functionArray = [NSMutableArray new];
    } else {
        [_functionArray removeAllObjects];
    }
    
    [self initEntry];
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


- (void) updateTaskNumber {
    for(FunctionEntryItem * func in _functionArray) {
        NSString * name = func.projectName;
        if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_patrol_task" inTable:nil]]) {
            func.projectState = _undoTask.patrolTaskNumber;
        }
    }
    [_collectionView reloadData];
}

//请求巡检任务数据
- (void) requestPatrolTask {
    [_patrolbusiness requestPatrolTaskByPage:_mPage success:^(NSInteger key, id object) {
        PatrolTaskResponseData * data = object;
        [_mPage setPage:data.page];
        NSMutableArray * array = data.contents;
        if(!_taskIdArray) {
            _taskIdArray = [[NSMutableArray alloc] init];
        }
        if ([_mPage isFirstPage]) {
            if(_taskIdArray) {
                [_taskIdArray removeAllObjects];
            }
        }
        for(PatrolTask * task in array) {
            [_taskIdArray addObject:task.patrolTaskId];
        }
        LocalTaskManager * manager = [[LocalTaskManager alloc] init];;
        [manager addPatrolTask:array];
        
        if([_mPage haveMorePage]) {
            [_mPage nextPage];
            [self requestPatrolTask];
        }
        if(_mPage && _mPage.totalCount > 0 && ![_mPage haveMorePage]) {    //如果获取到所有任务的 ID 则删除多余任务
            [manager clearPatrolTaskNotIn:_taskIdArray];
        }
    } fail:^(NSInteger key, NSError *error) {
        _taskIdArray = nil;
    }];
}

#pragma mark - 计算 gridcell 所需宽度和高度
- (CGFloat) getItemWidth:(NSInteger) position {
    CGFloat res = (NSInteger) (_realWidth/_colCount);
    CGFloat tmp = _realWidth - res * _colCount;
    if(position < tmp) {
        res += 1;
    }
    return res;
}

- (CGFloat) getItemHeight {
    CGFloat res = (NSInteger) (_realWidth/_colCount);
    CGFloat tmp = _realWidth - res * _colCount;
    if(tmp > 0) {
        res += 1;
    }
    return res;
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [_functionArray count];
    if(_colCount <= 0) {
        _colCount = 3;
    }
    NSInteger row = (count + _colCount - 1)/_colCount;
    return _colCount * row;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIndentifier";
    FunctionGridCollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.functionView setShowBottomLine:YES];
    cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    FunctionGridCollectionViewCell * functionCell = (FunctionGridCollectionViewCell *) cell;
    if(functionCell.functionView && position < [_functionArray count]) {
        FunctionEntryItem * project = _functionArray[position];
        UIImage *logo = project.projectLogo;
        [functionCell.functionView setInfoWithLogo:logo
                                              name:project.projectName
                                           message:project.projectMessage
                                              time:project.projectMessageTime
                                             state:project.projectState];
    } else {
        [functionCell.functionView setInfoWithLogo:nil name:nil message:nil time:nil state:0];
    }
    if(position % _colCount == _colCount - 1) {
        [functionCell.functionView setShowRightLine:NO];
    } else {
        [functionCell.functionView setShowRightLine:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    CGFloat itemWidth = [self getItemWidth:position];
    CGFloat itemHeight = [self getItemHeight];
    
    return CGSizeMake(itemWidth, itemHeight);
}

//header方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"headerView";
    _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    _headerView.backgroundColor = [UIColor colorWithRed:163/255.0 green:190/255.0 blue:101/255.0 alpha:1];
    __weak typeof(self) weakSelf = self;
    _headerView.actionBlock = ^(){
        [weakSelf gotoScanQrcode];
    };
    //    [_headerView setHeaderImage:[[FMTheme getInstance] getImageByName:@"inventory_banner"]];
    return _headerView;
}

//header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(_realWidth, _headerHeight);
}

//每个section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    //    return [FMSize getInstance].seperatorHeight;
    return 0;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    //    return [FMSize getInstance].seperatorHeight;
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row;
    if(index >=0 && index < [_functionArray count]) {
        FunctionEntryItem * item = _functionArray[index];
        [self gotoFunction:item];
    }
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger position = indexPath.row;
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    if(position < [_functionArray count]) {
        //设置(Highlight)高亮下的颜色
        [cell setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L8]];
    } else {
        [cell setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
    }
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:[UIColor whiteColor]];
}

//进入子功能界面
- (void) gotoFunction:(FunctionEntryItem *) entry {
    if(entry) {
        if(entry.entryClass){
            Class c = entry.entryClass;
            BaseViewController * vc = [[c alloc] init];
            [self gotoViewController:vc];
        }
    }
}

//扫描二维码
- (void) gotoScanQrcode {
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

- (void) handleQrcodeResult {
    
    if(_spotQrcode && [_spotQrcode isValidQrcode]) {
        
        NSNumber *spotId = [_spotQrcode getSpotId];
        NSString *spotName = [_spotQrcode getSpotName];
        NSNumber *buildingId = [_spotQrcode getBuildingId];
        NSString *buildingName = [_spotQrcode getBuildingName];
        if (spotId) {
            
            [self gotoSpotsViewControllerBySpotId:spotId spotName:spotName];
        }
        else if (buildingId) {
            
            [self gotoSpotsViewControllerByBuildingId:buildingId buildingName:buildingName];
        }
    }
    else {
        
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_spot_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }
}


//跳转到点位详情
- (void) gotoSpotViewController:(DBPatrolSpot *) spot {
    PatrolSpotViewController *spotVC = [[PatrolSpotViewController alloc] init];
    [spotVC setPatrolSpot:spot];
    [self gotoViewController:spotVC];
}

- (void) gotoSpotsViewController:(NSString *) spotCode {
    PatrolSpotListViewController * spotsVC = [[PatrolSpotListViewController alloc] init];
    [spotsVC setInfoWithCode:spotCode];
    [self gotoViewController:spotsVC];
}


/**
 跳转到巡检点位任务详情
 
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


#pragma mark - 二维码扫描结束
- (void) onQrCodeScanFinished:(NSString *)result {
    _backFromQrcode = YES;
    _spotQrcode = [[PatrolSpotQrcode alloc] initWithString:result];
}

#pragma mark - 监听滑动响应
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        CGRect rect = _headerView.frame;
        rect.origin.y = offsetY;
        rect.size.height = _headerHeight - offsetY;
        _headerView.frame = rect;
    }
}

@end

