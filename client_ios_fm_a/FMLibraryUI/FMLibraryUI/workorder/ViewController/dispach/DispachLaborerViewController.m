//
//  DispachLaborerViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "DispachLaborerViewController.h"
#import "LaborerSelectItemView.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMFont.h"
#import "SystemConfig.h"
#import "LaborerSelectItemView.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "SeperatorView.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderServerConfig.h"
#import "ImageItemView.h"
#import "FMSearchController.h"

@interface DispachLaborerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (readwrite, nonatomic, strong) UIView *mainContainerView;
@property (readwrite, nonatomic, strong) FMSearchController *searchController;
@property (readwrite, nonatomic, strong) UITableView *laborerTableView;

@property (readwrite, nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSMutableArray *laborerArray;
@property (readwrite, nonatomic, strong) NSMutableArray *selectedArray;
@property (readwrite, nonatomic, strong) NSMutableArray *searchResultArray;
@property (readwrite, nonatomic, strong) NSMutableArray *searchStoreArray;
@property (readwrite, nonatomic, strong) NSNumber *woId;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) BOOL isSearching;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation DispachLaborerViewController

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_info_select_laborer" inTable:nil]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestLaborers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_searchController.active) {
        _searchController.active = NO;
        [_searchController.searchBar removeFromSuperview];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self handleResult];
        [self finish];
    }
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    _noticeHeight = [FMSize getInstance].noticeHeight;
    _itemHeight = 50;
    
    if (!_laborerArray) {
        _laborerArray = [NSMutableArray new];
    }
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    if (!_searchResultArray) {
        _searchResultArray = [NSMutableArray new];
    }
    if (!_searchStoreArray) {
        _searchStoreArray = [NSMutableArray new];
    }
    
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    _laborerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    CGRect bounds = [_laborerTableView bounds];
    bounds.origin.y += self.searchController.searchBar.bounds.size.height;
    [_laborerTableView setBounds:bounds];  //为了隐藏SearchBar到导航栏底部去
    _laborerTableView.dataSource = self;
    _laborerTableView.delegate = self;
    _laborerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _laborerTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _laborerTableView.tableHeaderView = self.searchController.searchBar;
    
    
    _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (height-_noticeHeight)/2, width, _noticeHeight)];
    [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"select_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
    [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
    [_noticeLbl setHidden:YES];
    

    [_mainContainerView addSubview:_laborerTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
}

- (FMSearchController *)searchController {
    if (!_searchController) {
        __weak typeof(self) weakSelf = self;
        __weak typeof(_laborerTableView) weakTableView = _laborerTableView;
        _searchController = [[FMSearchController alloc] initWithSearchResultsController:nil];
        
        _searchController.actionBlock = ^(SearchActionType actionType) {
            switch (actionType) {
                case FUZZY_SEARCH_ACTION_TYPE_DONE:
                    NSLog(@"确认搜索");
                    break;
                    
                case FUZZY_SEARCH_ACTION_TYPE_CANCEL:
                    NSLog(@"取消搜索");
                    weakSelf.isSearching = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakTableView reloadData];
                    });
                    break;
            }
        };
        
        _searchController.textChangeBlock = ^(NSString *text) {
            if (![FMUtils isStringEmpty:text]) {
                weakSelf.isSearching = YES;
                [weakSelf startSearch:text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakTableView reloadData];
                });
            } else {
                weakSelf.isSearching = NO;
            }
        };
    }
    return _searchController;
}

- (void) startSearch:(NSString *) string {
    if (_searchResultArray) {
        [_searchResultArray removeAllObjects];
    }
    
    NSString *key = string.lowercaseString;
    NSMutableArray *tempArr = [NSMutableArray new];
    
    [_searchStoreArray enumerateObjectsUsingBlock:^(SearchStoreEntity *searchEnity, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = searchEnity.name.lowercaseString;
        NSString *namePinyin = searchEnity.namePinyin.lowercaseString;
        NSString *nameAcronyms = searchEnity.nameAcronyms.lowercaseString;
        
        NSRange rang1 = [name rangeOfString:key];
        if (rang1.length>0) {
            [tempArr addObject:searchEnity];
        } else {
            if ([nameAcronyms containsString:key]) {
                [tempArr addObject:searchEnity];
            } else {
                if ([nameAcronyms containsString:[key substringToIndex:1]]) {
                    if ([namePinyin containsString:key] ) {
                        [tempArr addObject:searchEnity];
                    }
                }
            }
        }
    }];
    
    //首先把已选的人添加进去
    [_selectedArray enumerateObjectsUsingBlock:^(WorkOrderLaborerDispach *laborer, NSUInteger idx, BOOL * _Nonnull stop) {
        [_searchResultArray addObject:laborer];
    }];
    
    //再把搜索到的结果中还没有添加的 加入数组
    [tempArr enumerateObjectsUsingBlock:^(SearchStoreEntity *searchEnity, NSUInteger idx, BOOL * _Nonnull stop) {
        for (WorkOrderLaborerDispach *laborer in _laborerArray) {
            if (![_searchResultArray containsObject:laborer] && laborer.emId == searchEnity.identification) {
                [_searchResultArray addObject:laborer];
            }
        }
    }];
}

- (void) setWorkOrderWithId:(NSNumber *) woId {
    _woId = [woId copy];
}

- (void) setSelectedLaborers:(NSMutableArray *) laborers {
    _selectedArray = laborers;
}

- (BOOL) isLaborerChecked:(NSNumber *) laborerId {
    BOOL res = NO;
    for(WorkOrderLaborerDispach * laborer in _selectedArray) {
        if([laborer.emId isEqualToNumber:laborerId]) {
            res = YES;
            break;
        }
    }
    return res;
}

- (void) updateLaborerCheckedStatus:(WorkOrderLaborerDispach *) laborer {
    BOOL isExist = NO;
    NSInteger index = 0;
    NSInteger count = [_selectedArray count];
    for(index=0;index<count;index++) {
        WorkOrderLaborerDispach * obj = _selectedArray[index];
        if([obj.emId isEqualToNumber:laborer.emId]) {
            isExist = YES;
            [_selectedArray removeObjectAtIndex:index];
            break;
        }
    }
    if(!isExist) {
        [_selectedArray addObject:laborer];
    }
}

- (NSMutableArray *) getSelectedLaborers {
    NSMutableArray * res = _selectedArray;
    return res;
}

- (void) updateList {
    [self updateNotice];
    [_laborerTableView reloadData];
}

- (void) updateNotice {
    if (_laborerArray.count > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

#pragma - mark UITableViewDataSource & UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (_isSearching) {
        count = _searchResultArray.count;
    } else {
        count = _laborerArray.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = _itemHeight;
    return height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    LaborerSelectItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = _itemHeight;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    WorkOrderLaborerDispach * laborer = [[WorkOrderLaborerDispach alloc] init];
    
    if (_isSearching) {
        laborer = _searchResultArray[position];
    } else {
        laborer = _laborerArray[position];
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subviews = [cell subviews];
        for(id view in subviews) {
            if([view isKindOfClass:[LaborerSelectItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = view;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(seperator) {
        if(position == _laborerArray.count - 1) {
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }else {
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        }
    }
    if(cell && !itemView) {
        itemView = [[LaborerSelectItemView alloc] init];
        [cell addSubview:itemView];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        BOOL checked = [self isLaborerChecked:laborer.emId];
        [itemView setInfoWith:laborer.name score:laborer.score grabStatus:laborer.grabStatus estimateArriveTime:laborer.estimateArriveTime status:laborer.status];
        [itemView setChecked:checked];
        [itemView setShowGrab:NO];   //2.0阶段取消了抢单这个功能，默认不显示抢单
        itemView.tag = position;
    }
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    WorkOrderLaborerDispach *laborer = [[WorkOrderLaborerDispach alloc] init];
    if (_isSearching) {
        laborer = _searchResultArray[indexPath.row];
    } else {
        laborer = _laborerArray[indexPath.row];
    }
    
    [self updateLaborerCheckedStatus:laborer];
    [_laborerTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void) requestLaborers {
    [self showLoadingDialog];
    NSNumber * userId = [SystemConfig getEmployeeId];
    WorkOrderLaborerDispachRequestParam * param = [[WorkOrderLaborerDispachRequestParam alloc] initWithUserId:userId andOrderId:_woId];
    WorkOrderNetRequest * netRequest = [WorkOrderNetRequest getInstance];
    [netRequest request:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray* data = [responseObject valueForKeyPath:@"data"];
        if(![data isKindOfClass:[NSNull class]]) {
            for(NSDictionary * dgroup in data) {
                WorkOrderLaborerGroupDispach * group = [[WorkOrderLaborerGroupDispach alloc] init];
                group.wtId = [dgroup valueForKeyPath:@"wtId"];
                if([group.wtId isKindOfClass:[NSNull class]]) {
                    group.wtId = nil;
                }
                group.name = [dgroup valueForKeyPath:@"name"];
                if([group.name isKindOfClass:[NSNull class]]) {
                    group.name = nil;
                }
                NSMutableArray * dmembers = [dgroup valueForKeyPath:@"members"];
                if(![dmembers isKindOfClass:[NSNull class]]) {
                    for(NSDictionary * dmember in dmembers) {
                        WorkOrderLaborerDispach * laborer = [[WorkOrderLaborerDispach alloc] init];
                        laborer.emId = [dmember valueForKeyPath:@"emId"];
                        if([laborer.emId isKindOfClass:[NSNull class]]) {
                            laborer.emId = nil;
                        }
                        
                        laborer.name = [dmember valueForKeyPath:@"name"];
                        if([laborer.name isKindOfClass:[NSNull class]]) {
                            laborer.name = nil;
                        }
                        
                        laborer.phone = [dmember valueForKeyPath:@"phone"];
                        if([laborer.phone isKindOfClass:[NSNull class]]) {
                            laborer.phone = nil;
                        }
                        NSNumber * number = [dmember valueForKeyPath:@"woNumber"];
                        if([number isKindOfClass:[NSNull class]]) {
                            number = nil;
                        }
                        laborer.woNumber = [number integerValue];
                        
                        number = [dmember valueForKeyPath:@"grabStatus"];
                        if([number isKindOfClass:[NSNull class]]) {
                            number = nil;
                        }
                        laborer.grabStatus = [number integerValue];
                        
                        number = [dmember valueForKeyPath:@"score"];
                        if([number isKindOfClass:[NSNull class]]) {
                            number = nil;
                        }
                        laborer.score = [number integerValue];
                        
                        laborer.estimateArriveTime = [dmember valueForKeyPath:@"estimateArriveTime"];
                        if([laborer.estimateArriveTime isKindOfClass:[NSNull class]]) {
                            laborer.estimateArriveTime = nil;
                        }
                        
                        laborer.status = [dmember valueForKeyPath:@"status"];//到岗状态
                        if([laborer.status isKindOfClass:[NSNull class]]) {
                            laborer.status = nil;
                        }
                        
                        [group.members addObject:laborer];
                        
                        //为tableview获取数据源
                        [_laborerArray addObject:laborer];
                        
                        //为模糊搜索做模型转换
                        SearchStoreEntity *searchEntity = [[SearchStoreEntity alloc] init];
                        searchEntity.name = laborer.name;
                        searchEntity.namePinyin = [laborer.name transformToPinyin];
                        searchEntity.nameAcronyms = [laborer.name transformToPinyinFirstLetter];
                        searchEntity.identification = laborer.emId;
                        [_searchStoreArray addObject:searchEntity];
                    }
                }
            }
        }
        
        [self hideLoadingDialog];
        [self updateList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideLoadingDialog];
    }];
}


#pragma mark - MessageHandleDelegate
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult {
    if(_handler) {
        NSMutableArray * laborers = [self getSelectedLaborers];
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:@"DispachLaborerViewController" forKeyPath:@"msgOrigin"];
        [msg setValue:laborers forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

@end

