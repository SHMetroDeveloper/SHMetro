//
//  InventoryDockViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/12/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDockViewController.h"
#import "HeaderCollectionReusableView.h"
#import "RequirementHistoryViewController.h"
#import "EvaluateRequirementViewController.h"
#import "UndoRequirementViewController.h"
#import "ApprovalRequirementViewController.h"
#import "VideoTakeViewController.h"
#import "FMUtilsPackages.h"
#import "FunctionItemGridView.h"
#import "FunctionEntryItem.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

#import "FMTheme.h"
#import "PowerManager.h"
#import "InventoryFunctionPermission.h"
#import "ScanHeaderCollectionReusableView.h"
#import "InventoryMaterialDetailViewController.h"
#import "QrCodeViewController.h"
#import "InventoryMaterialQrcode.h"
#import "FunctionGridCollectionViewCell.h"


typedef void(^TestBlock)();

@interface InventoryDockViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,OnQrCodeScanFinishedListener>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ScanHeaderCollectionReusableView *headerView;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat seperatorheight;
@property (nonatomic, assign) NSInteger colCount;   //列数

@property (readwrite, nonatomic, strong) NSMutableArray * functionArray;    //功能列表

@property (readwrite, nonatomic, strong) InventoryMaterialQrcode * materialQrcode;


@property (readwrite, nonatomic, assign) BOOL needUpdate;
@property (readwrite, nonatomic, assign) BOOL backFromQrcode;   //二维码扫描
@property (readwrite, nonatomic, assign) BOOL isValidQrcode;   //二维码合法
@end

@implementation InventoryDockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFunctions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_backFromQrcode) {
        _backFromQrcode = NO;
        if (_isValidQrcode) {
            _isValidQrcode = NO;
            NSString *inventoryCode = [_materialQrcode getMaterialCode];
            NSString *warehouseId = [_materialQrcode getWarehouseId];
            
            [self gotoInventoryDetailByCode:inventoryCode warehouse:[FMUtils stringToNumber:warehouseId]];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_code_error" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateList];
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
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_inventory" inTable:nil]];
    [self setNavigationColor:[UIColor clearColor]];
    [self setBackAble:YES];
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
    FunctionPermission *inventoryPermission = [manager getFunctionPermissionByKey:INVENTORY_FUNCTION];
    NSArray *functions = [inventoryPermission getAllFunctions];
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

- (void) updateList {
    [_collectionView reloadData];
}

- (CGFloat) getItemWidth:(NSInteger) position {
    position = position % _colCount;
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
    _headerView.backgroundColor = [UIColor colorWithRed:0xa0/255.0 green:0x89/255.0 blue:0xda/255.0 alpha:1];
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
    NSInteger position = indexPath.row;
    if(position >=0 && position < [_functionArray count]) {
        FunctionEntryItem * item = _functionArray[position];
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

- (void)gotoInventoryDetailByCode:(NSString *)inventoryCode warehouse:(NSNumber *) warehouseId {
    InventoryMaterialDetailViewController *VC = [[InventoryMaterialDetailViewController alloc] init];
    VC.isEditAble = YES;
    VC.inventoryCode = inventoryCode;
    VC.warehouseId = warehouseId;
    VC.fromQrcode = YES;
    [self gotoViewController:VC];
}

#pragma mark - 二维码扫描结束
- (void) onQrCodeScanFinished:(NSString *)result {
    _backFromQrcode = YES;
    _materialQrcode = [[InventoryMaterialQrcode alloc] initWithString:result];
    _isValidQrcode = [_materialQrcode isValidQrcode];
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
