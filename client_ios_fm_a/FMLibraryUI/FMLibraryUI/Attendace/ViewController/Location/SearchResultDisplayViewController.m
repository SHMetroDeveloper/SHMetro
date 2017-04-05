//
//  SearchResultDisplayViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "SearchResultDisplayViewController.h"
#import "GpsSearchTableView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "AttendanceSettingEntity.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"


@interface SearchResultDisplayViewController () <AMapSearchDelegate>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) GpsSearchTableView *tableView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, assign) NSInteger searchPage;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation SearchResultDisplayViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_add" inTable:nil]];
    [self setBackAble:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        _searchPage = 1;
        
        _mainContainerView = [[UIView alloc] initWithFrame:mFrame];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateList {
    if (_tableView.mj_footer.isRefreshing) {
        [_tableView.mj_footer endRefreshing];
    }
    
    [_tableView reloadData];
}

#pragma mark - Lazyload
- (GpsSearchTableView *)tableView {
    if (!_tableView) {
        CGRect mFrame = [self getContentFrame];
        CGFloat height = CGRectGetHeight(mFrame);
        CGFloat width = CGRectGetWidth(mFrame);
        CGFloat originY = 44;  //44为searchBar的默认高度
        _tableView = [[GpsSearchTableView alloc] initWithFrame:CGRectMake(0, originY, width, height-originY)];
        __weak typeof(self) weakSelf = self;
        _tableView.loadMoreBlock = ^(){
            [weakSelf loadMoreData];
        };
        _tableView.locationSelectBlock = ^(AttendanceLocation *location){
            if (location) {
                NSMutableArray *array = [NSMutableArray arrayWithObject:location];
                [weakSelf handleResult:array];
            }
        };
    }
    return _tableView;
}

#pragma mark - Setter
- (void)setCityName:(NSString *)cityName {
    _cityName = [cityName copy];
}

- (void)setSearchKeyWord:(NSString *)searchKeyWord {
    if (![FMUtils isStingEqualIgnoreCaseString1:searchKeyWord String2:_searchKeyWord]) {
        _searchKeyWord = [searchKeyWord copy];
        _searchPage = 1;
        [self searchLocationByKeyWord:_searchKeyWord];
    }
}

- (void) searchLocationByKeyWord:(NSString *) keyword {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.page = _searchPage;
    request.city = _cityName;
//    request.keywords = [NSString stringWithFormat:@"公司企业|%@",keyword];
    request.keywords = [NSString stringWithFormat:@"%@",keyword];
    request.sortrule = 0;
    request.requireExtension = YES;
    
    [self showLoadingDialog];
    [_search AMapPOIKeywordsSearch:request];
}

- (void) loadMoreData {
    _searchPage += 1;
    [self searchLocationByKeyWord:_searchKeyWord];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    /* POI 搜索回调. */
    if (response.pois.count == 0) {
        return;
    }
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        AttendanceLocation * location = [[AttendanceLocation alloc] init];
        location.name = obj.name;
        location.desc = obj.address;
        location.lat = [[NSString alloc] initWithFormat:@"%f", obj.location.latitude];
        location.lon = [[NSString alloc] initWithFormat:@"%f", obj.location.longitude];
        location.enable = YES;
        [array addObject:location];
    }];
    
    if (_searchPage == 1) {
        [_tableView setDataArray:array];
    } else {
        [_tableView addDataArray:array];
    }
    [self updateList];
    [self hideLoadingDialog];
}

#pragma mark - OnMessageHandleListener
- (void) handleResult:(NSMutableArray *) array {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        [msg setValue:array forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

@end
