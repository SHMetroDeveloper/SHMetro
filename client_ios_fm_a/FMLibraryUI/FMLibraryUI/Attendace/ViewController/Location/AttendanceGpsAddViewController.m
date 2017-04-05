//
//  AttendanceGpsAddViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "AttendanceGpsAddViewController.h"
#import "LocationAddTableHelper.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "POIAnnotation.h"
#import "AttendanceSettingEntity.h"
#import "AttendanceSettingOperateEntity.h"
#import "AttendanceBusiness.h"
#import "AttendanceDbHelper.h"
#import "FMUtilsPackages.h"
#import "GpsAddTableView.h"
#import "GpsSearchTableView.h"
#import "FMSearchController.h"
#import "SearchResultDisplayViewController.h"
#import "BaseBundle.h"

@interface AttendanceGpsAddViewController () <OnMessageHandleListener, AMapLocationManagerDelegate, AMapSearchDelegate,MAMapViewDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UIView *mainContainerView;
@property (nonatomic, strong) GpsAddTableView *tableView;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, assign) CGFloat mapHeight;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (nonatomic, strong) UIImageView *centerAnnotationView;

@property (nonatomic, strong) AttendanceBusiness * business;
@property (nonatomic, strong) AttendanceDbHelper * dbHelper;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) __block CLLocation *currentLocation;  //当前位置

@property (nonatomic, strong) AMapSearchAPI * search;
@property (nonatomic, assign) NSInteger searchPage;               //搜索结果分页

@property (nonatomic, strong) FMSearchController *searchController;  //
@property (nonatomic, strong) SearchResultDisplayViewController *searchResultsController;  //搜索展示页面
@property (nonatomic, strong) NSString *cityName;  //当前所在位置的城市名字
@property (nonatomic, assign) __block BOOL isSearching;   //是否正在搜索

@property (nonatomic, strong) __block NSMutableArray *locationArray;
@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation AttendanceGpsAddViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_add" inTable:nil]];
    NSArray * menus = [[NSArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self saveSelectedLocation];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    //初始化定位
    [self setting];
    //开始定位
    [self startSerialLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_searchController.active) {
        _searchController.active = NO;
        [_searchController.searchBar removeFromSuperview];
    }
    
    [self stopSerialLocation];
    _locationManager = nil;
    _search = nil;
    _mapView = nil;
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        CGFloat realWidth = CGRectGetWidth(frame);
        CGFloat realHeight = CGRectGetHeight(frame);
        CGFloat originY = 44;
        _mapHeight = 240;
        
        
        _dbHelper = [AttendanceDbHelper getInstance];
        _business = [AttendanceBusiness getInstance];
        
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, originY, realWidth, _mapHeight)];
        _mapView.delegate = self;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //仅在地图上显示，不跟随用户位置
        //高德隐藏接口，可以显示国外街道地址信息。
        [_mapView performSelector:@selector(setShowsWorldMap:) withObject:@(YES)];
        originY += _mapHeight;
        
        
        _centerAnnotationView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"icon_location_square"]];
        _centerAnnotationView.frame = CGRectMake((realWidth-30)/2, _mapHeight/2-30, 30, 30);
        _centerAnnotationView.hidden = YES;
        [_mapView addSubview:_centerAnnotationView];
        
        
        __weak typeof(self) weakSelf = self;
        _tableView = [[GpsAddTableView alloc] initWithFrame:CGRectMake(0, originY, realWidth, realHeight-originY)];
        _tableView.loadMoreBlock = ^(){
            [weakSelf loadMoreData];
        };
        
        [_mainContainerView addSubview:self.searchController.searchBar];
        [_mainContainerView addSubview:_mapView];
        [_mainContainerView addSubview:_tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}



#pragma mark - 懒加载
- (SearchResultDisplayViewController *)searchResultsController {
    if (!_searchResultsController) {
        _searchResultsController = [[SearchResultDisplayViewController alloc] init];
        [_searchResultsController setOnMessageHandleListener:self];
    }
    return _searchResultsController;
}


- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[FMSearchController alloc] initWithSearchResultsController:self.searchResultsController];
        _searchController.searchBar.frame = CGRectMake(0, 0, _searchController.searchBar.frame.size.width, _searchController.searchBar.frame.size.height);
        _searchController.searchBar.placeholder = [[BaseBundle getInstance] getStringByKey:@"attendance_location_search_placeholder" inTable:nil];
        __weak typeof(self) weakSelf = self;
        _searchController.actionBlock = ^(SearchActionType actionType) {
            switch (actionType) {
                case FUZZY_SEARCH_ACTION_TYPE_DONE:
//                    NSLog(@"点击了键盘 确认搜索");
//                    weakSelf.isSearching = YES;
                    break;
                    
                case FUZZY_SEARCH_ACTION_TYPE_CANCEL:
//                    NSLog(@"点击了取消按钮 取消搜索");
//                    weakSelf.isSearching = NO;
                    break;
            }
        };
        
        _searchController.textChangeBlock = ^(NSString *text) {
            if (![FMUtils isStringEmpty:text]) {
//                weakSelf.isSearching = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.searchResultsController setCityName:weakSelf.cityName];
                    [weakSelf.searchResultsController setSearchKeyWord:text];
                });
            } else {
//                weakSelf.isSearching = NO;
            }
        };
    }
    return _searchController;
}

- (void) setting {
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [_locationManager setPausesLocationUpdatesAutomatically:YES];
    [_locationManager setAllowsBackgroundLocationUpdates:NO];
    [_locationManager setLocationTimeout:15];
    [_locationManager setReGeocodeTimeout:15];
    
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    _searchPage = 1;   //搜索结果分页默认为第一页
}

- (void) updateList {
    if (_tableView.mj_footer.isRefreshing) {
        [_tableView.mj_footer endRefreshing];
    }
    
    [_tableView reloadData];
}

- (void) loadMoreData {
    _searchPage += 1;
    [self requestSearch];
}

//搜索附近位置
- (void) requestSearch {    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.page = _searchPage;
    request.radius = 3000;
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
//    request.keywords = @"公司企业";
    request.keywords = @"";
    /* 按照距离排序. */
    request.sortrule = 0;
    request.requireExtension = YES;
    
    
    [_search AMapPOIAroundSearch:request];
}

//查询当前位置的描述信息
- (void) requestDescriptionOfCurrentLocation {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    regeo.requireExtension = YES;
    [_search AMapReGoecodeSearch:regeo];
}

- (void)startSerialLocation {
    //开始单次定位请求
    __weak typeof(self) weakSelf = self;
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            //如果定位失败，则弹出提示信息，并且直接return。
            if (error.code == AMapLocationErrorLocateFailed) {
                [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_location_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
                return;
            }
        }
        
        if (regeocode) {
            _cityName = regeocode.city;
        }
        
        if (location && !weakSelf.currentLocation) {
            //获取到定位信息，更新annotation
            if (!_pointAnnotaiton) {
                _pointAnnotaiton = [[MAPointAnnotation alloc] init];
                [_pointAnnotaiton setCoordinate:location.coordinate];
                
                [_mapView addAnnotation:_pointAnnotaiton];
            }

            weakSelf.currentLocation = location;
            [weakSelf requestSearch];
        }
    }];
}

//停止地理位置扫描
- (void)stopSerialLocation {
    [_locationManager stopUpdatingLocation];
}

//更新地图位置
- (void) updateMapViewCenterLocation:(AttendanceLocation *) location {
    _isSearching = YES;
    CLLocationCoordinate2D centerLocation = CLLocationCoordinate2DMake(location.lat.doubleValue, location.lon.doubleValue);
    [_mapView setCenterCoordinate:centerLocation animated:YES];
}

//获取地理位置细节信息
- (void) requestDetailLocation:(AttendanceLocation *) location {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.page = _searchPage;
    request.city = _cityName;
    request.keywords = [NSString stringWithFormat:@"%@",location.name];
    request.sortrule = 0;
    request.requireExtension = YES;
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:location.lat.doubleValue longitude:location.lon.doubleValue];
    
    [_search AMapPOIKeywordsSearch:request];
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
}


#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    if (_isSearching) {
        [_mapView removeAnnotation:_pointAnnotaiton];
        _centerAnnotationView.hidden = NO;
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (_isSearching) {
        _isSearching = NO;
        
        if (_currentLocation) {
            _centerAnnotationView.hidden = YES;
            [_pointAnnotaiton setCoordinate:_currentLocation.coordinate];
            [_mapView addAnnotation:_pointAnnotaiton];
        }
    }
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [_mapView removeAnnotation:_pointAnnotaiton];
        _centerAnnotationView.hidden = NO;
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        if (_currentLocation) {
            _currentLocation = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
            
            _searchPage = 1;  //当拖动地图的时候 搜索半径回到默认的3000
            [self requestSearch];
            
            _centerAnnotationView.hidden = YES;
            [_pointAnnotaiton setCoordinate:_currentLocation.coordinate];
            [_mapView addAnnotation:_pointAnnotaiton];
        }
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;
        annotationView.image = [[FMTheme getInstance]  getImageByName:@"icon_location_square"];

        return annotationView;
    }
    
    return nil;
}

#pragma mark - NetWorking
//获取可用（没有被添加到服务器的）位置信息
- (NSMutableArray *) getAddableLocations {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(AttendanceLocation *location in _locationArray) {
        if(![_dbHelper isSignLocationExistByLat:location.lat lon:location.lon andLocationName:location.name]) {
            [array addObject:location];
        }
    }
    return array;
}

- (void) saveSelectedLocation {
    _locationArray = [_tableView getSelectedLocation];
    if([_locationArray count] == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_location_add_empty" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        NSMutableArray *array = [self getAddableLocations];
        if([array count] > 0) {
            [self requestAddSelectedLocation:array];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_notice_location_add_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
        
    }
}

- (void) requestAddSelectedLocation:(NSMutableArray *) array {
    NSMutableArray * locationArray = [[NSMutableArray alloc] init];
    for(AttendanceLocation * obj in array) {
        AttendanceOperateLocation * location = [[AttendanceOperateLocation alloc] init];
        location.locationId = [obj.locationId copy];
        location.name = [obj.name copy];
        location.desc = [obj.desc copy];
        location.lat = [obj.lat copy];
        location.lon = [obj.lon copy];
        location.enable = obj.enable;
        [locationArray addObject:location];
    }
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business setRuleOfLocation:locationArray sType:ATTENDANCE_OPERATE_LOCATION_TYPE_ADD accuracy:100 success:^(NSInteger key, id object) {
        NSArray * idArray = object;
        NSInteger index = 0;
        NSInteger count = [weakSelf.locationArray count];
        for(NSNumber * locationId in idArray) {
            if(index < count) {
                AttendanceLocation *location = weakSelf.locationArray[index];
                location.locationId = [locationId copy];
                weakSelf.locationArray[index] = location;
            } else {
                break;
            }
        }
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_add_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        
        [weakSelf saveResult];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_add_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
    
}

#pragma mark - OnMessageHandleListener
- (void) saveResult {
    [self handleResult:_locationArray];
    [self finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
}

- (void) handleResult:(NSMutableArray *) array {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        [msg setValue:array forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([SearchResultDisplayViewController class])]) {
            NSMutableArray *array = [msg valueForKeyPath:@"result"];
            AttendanceLocation *location = array[0];
            [self updateMapViewCenterLocation:location];
            _searchPage = 1;
            [self requestDetailLocation:location];
        }
    }
}

@end

