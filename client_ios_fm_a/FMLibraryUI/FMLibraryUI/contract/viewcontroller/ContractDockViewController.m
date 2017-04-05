//
//  ContractDockViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractDockViewController.h"
#import "HeaderCollectionReusableView.h"
#import "FMUtilsPackages.h"
#import "FunctionItemGridView.h"
#import "FunctionEntryItem.h"
#import "SeperatorView.h"
#import "PowerManager.h"
#import "ContractFunctionPermission.h"
#import "ContractProfileCollectionViewCell.h"
#import "FunctionGridCollectionViewCell.h"
#import "ControctProfileBarChartView.h"
#import "CommonBusiness.h"
#import "FMTheme.h"
#import "ContractBusiness.h"

static NSString *cellItemIdentifier = @"cellItemIdentifier";
static NSString *cellProfileIdentifier = @"cellProfileIdentifier";
static NSString *headerIdentifier = @"headerIdentifier";
static NSString *footerIdentifier = @"footerIdentifier";

@interface ContractDockViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) UICollectionReusableView *headerView;
@property (nonatomic, strong) ControctProfileBarChartView *barChartView;

@property (nonatomic, strong) ContractBusiness *contractBusiness;
@property (nonatomic, strong) __block ContractStatisticsEntity *contractStatistics;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat seperatorheight;
@property (nonatomic, assign) NSInteger colCount;   //列数

@property (readwrite, nonatomic, strong) NSMutableArray * functionArray;    //功能列表
@property (nonatomic, strong) CommonBusiness * business;
@end

@implementation ContractDockViewController
- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_contract" inTable:nil]];
    [self setNavigationColor:[UIColor clearColor]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _business = [CommonBusiness getInstance];
    _contractBusiness = [ContractBusiness getInstance];
    [self initFunctions];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initLayout {
    CGRect frame = self.view.frame;
    _realHeight = frame.size.height;
    _realWidth = frame.size.width;
    CGFloat height = frame.size.height;
    _headerHeight = height * 0.448f;
    
    _seperatorheight = [FMSize getInstance].seperatorHeight;
    _colCount = 3;
    
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight) collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delaysContentTouches = NO;
    _collectionView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    [_collectionView registerClass:[ContractProfileCollectionViewCell class] forCellWithReuseIdentifier:cellProfileIdentifier];
    [_collectionView registerClass:[FunctionGridCollectionViewCell class] forCellWithReuseIdentifier:cellItemIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:footerIdentifier];
    
    self.view.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    [self.view addSubview:_collectionView];
}

- (void) initEntry {
    PowerManager * manager = [PowerManager getInstance];
    FunctionPermission * permission = [manager getFunctionPermissionByKey:CONTRACT_FUNCTION];
    NSArray * functions = [permission getAllFunctions];
    for(FunctionItem * item in functions) {
        if(item.permissionType != FUNCTION_ACCESS_PERMISSION_NONE && item.isFormal) {
            FunctionEntryItem *entry = [[FunctionEntryItem alloc] init];
            entry.projectName = item.name;
            entry.projectLogo = [[FMTheme getInstance] getImageByName:item.iconName];
            entry.entryClass = item.entryClass;
            [_functionArray addObject:entry];
        }
    }
    if (_functionArray.count > 0) {
        [self requestContractStatistics];
    }
}

#pragma mark - PrivateMethod
- (void)updateCharView {
    if (_contractStatistics) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSInteger undo = 0;
        NSInteger expired = 0;
        NSInteger process = 0;
        NSInteger terminated = 0;
        NSInteger unPassed = 0;
        NSInteger passed = 0;
        NSInteger closed = 0;
        for (ContractTypeAmount *typeAmount in _contractStatistics.amount) {
            undo += typeAmount.undo;
            expired += typeAmount.expired;
            process += typeAmount.process;
            terminated += typeAmount.terminated;
            unPassed += typeAmount.unPassed;
            passed += typeAmount.passed;
            closed += typeAmount.closed;
        }
        [data addObject:[NSNumber numberWithInteger:undo]];
        [data addObject:[NSNumber numberWithInteger:expired]];
        [data addObject:[NSNumber numberWithInteger:process]];
        [data addObject:[NSNumber numberWithInteger:terminated]];
        [data addObject:[NSNumber numberWithInteger:unPassed]];
        [data addObject:[NSNumber numberWithInteger:passed]];
        [data addObject:[NSNumber numberWithInteger:closed]];
        [_barChartView setContractStatistics:data];
        [_collectionView reloadData];
    } else {
        [_barChartView setContractStatistics:nil];
        [_collectionView reloadData];
    }
}

#pragma mark - NetWorking
- (void)requestContractStatistics {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_contractBusiness getContractStatisticsSuccess:^(NSInteger key, id object) {
        weakSelf.contractStatistics = object;
        [weakSelf updateCharView];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        weakSelf.contractStatistics = nil;
        [weakSelf updateCharView];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) initFunctions {
    if (!_functionArray) {
        _functionArray = [NSMutableArray new];
    } else {
        [_functionArray removeAllObjects];
    }
    [self initEntry];
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemCount = 0;
    if (section == 0) {
        itemCount = 3;
        
    } else if (section == 1) {
        NSInteger count = [_functionArray count];
        if(_colCount <= 0) {
            _colCount = 3;
        }
        NSInteger row = (count + _colCount - 1)/_colCount;
        itemCount = _colCount * row;
    }
    
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    UICollectionViewCell * cell = nil;

    
    if (section == 0) {
        ContractProfileCollectionViewCell *custCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellProfileIdentifier forIndexPath:indexPath];
        custCell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        if (position == 0) {
            [custCell setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_amount_total" inTable:nil]];
            [custCell setContentWith:[NSString stringWithFormat:@"%ld",_contractStatistics.total]];
        } else if (position == 1) {
            [custCell setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_amount_receivable" inTable:nil]];
            [custCell setContentWith:[NSString stringWithFormat:@"%ld",_contractStatistics.receipt]];
        } else if (position == 2) {
            [custCell setTitleWith:[[BaseBundle getInstance] getStringByKey:@"contract_amount_payment" inTable:nil]];
            [custCell setContentWith:[NSString stringWithFormat:@"%ld",_contractStatistics.payment]];
        }
        cell = custCell;
    } else if (section == 1) {
        FunctionGridCollectionViewCell * functionCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellItemIdentifier forIndexPath:indexPath];
        [functionCell.functionView setShowBottomLine:YES];
        functionCell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        cell = functionCell;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == 1) {
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
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    CGFloat itemWidth = [self getItemWidth:position];
    CGFloat itemHeight = 0;
    if (indexPath.section == 0) {
        itemHeight = [ContractProfileCollectionViewCell getItemHeight];
    } else if (indexPath.section == 1) {
        itemHeight = [self getItemHeight];
    }
    
    return CGSizeMake(itemWidth, itemHeight);
}

//header方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    UICollectionReusableView *reusableView = nil;
    
    if (section == 0) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        _headerView.backgroundColor = [UIColor colorWithRed:0x5f/255.0 green:0x65/255.0 blue:0xd8/255.0 alpha:255/255.0];
        if (_headerView) {
            NSArray *subViews = [_headerView subviews];
            for (id view in subViews) {
                if ([view isKindOfClass:[ControctProfileBarChartView class]]) {
                    _barChartView = (ControctProfileBarChartView *)view;
                }
            }
        }
        if (_headerView && !_barChartView) {
            //64为导航栏的高度
//            _barChartView = [[ControctProfileBarChartView alloc] initWithFrame:CGRectMake(0, 64, _realWidth, _headerHeight - 64)];
            _barChartView = [[ControctProfileBarChartView alloc] init];
            [_headerView addSubview:_barChartView];
        }
        if (_barChartView) {
            [_barChartView setFrame:CGRectMake(0, 64, _realWidth, _headerHeight - 64)];
        }
        reusableView = _headerView;
    } else if (section == 1) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        reusableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    }
    
    return reusableView;
}

//header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeZero;
    if (section == 0) {
        headerSize = CGSizeMake(_realWidth, _headerHeight);
    } else if (section == 1) {
        headerSize = CGSizeMake(_realWidth, 10);  //10为section与section之间的分割高度
    }
    return headerSize;
}

//每个section的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

//列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isHighLight = NO;
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        isHighLight = NO;
    } else if (section == 1) {
        isHighLight = YES;
    }
    return isHighLight;
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
        
        CGRect barChartViewRect = _barChartView.frame;
        barChartViewRect.origin.y = 64 - offsetY;
        _barChartView.frame = barChartViewRect;
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
