//
//  RequirementViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/22.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "RequirementDockViewController.h"
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
#import "BaseDataEntity.h"
#import "CommonBusiness.h"
#import "FMTheme.h"
#import "BaseBundle.h"

#import "PowerManager.h"
#import "RequirementFunctionPermission.h"
#import "FunctionGridCollectionViewCell.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RequirementDockViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) HeaderCollectionReusableView * headerView;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat seperatorheight;
@property (nonatomic, assign) NSInteger colCount;

@property (nonatomic, strong) UndoTaskEntity *undoTask;
@property (nonatomic, strong) CommonBusiness *business;

@property (nonatomic, strong) NSMutableArray * functionArray;    //功能列表

@end

@implementation RequirementDockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _business = [CommonBusiness getInstance];
    [self initFunctions];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestUndoNumber];
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_requirement" inTable:nil]];
    [self setNavigationColor:[UIColor clearColor]];
    [self setBackAble:YES];
}

- (void)initLayout {

    CGRect frame = self.view.frame;
    _realHeight = frame.size.height;
    _realWidth = frame.size.width;
    
    _headerHeight = _realHeight * 0.308 + 20;
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
    [_collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
}

- (void) initEntry {
    PowerManager * manager = [PowerManager getInstance];
    FunctionPermission * requirementPermission = [manager getFunctionPermissionByKey:REQUIREMENT_FUNCTION];
    NSArray * functions = [requirementPermission getAllFunctions];
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

#pragma mark - 更新角标
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
        if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_requirement_approval" inTable:nil]]) {
            func.projectState = _undoTask.unApprovalRequirementNumber;
        } else if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_requirement_undo" inTable:nil]]) {
            func.projectState = _undoTask.undoRequirementNumber;
        } else if([name isEqualToString:[[BaseBundle getInstance] getStringByKey:@"function_requirement_evaluate" inTable:nil]]) {
            func.projectState = _undoTask.unEvaluateRequirementNumber;
        }
    }
    [_collectionView reloadData];
}

#pragma mark - 计算 gridcell 所需宽度和高度
- (CGFloat) getItemWidth:(NSInteger) position {
    CGFloat res = (NSInteger) (_realWidth/_colCount);
    CGFloat tmp = _realWidth - res * _colCount;
    if(position%_colCount < tmp) {
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
    return row * _colCount;
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
    UIImage *bannerImg = nil;
    bannerImg = [[FMTheme getInstance] getImageByName:@"service_center_banner"];
    [_headerView setHeaderImage:bannerImg];
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

//进入子功能界面
- (void) gotoFunction:(FunctionEntryItem *) entry {
    if(entry) {
        Class c = entry.entryClass;
        BaseViewController * vc = [[c alloc] init];
        [self gotoViewController:vc];
    }
}
@end

