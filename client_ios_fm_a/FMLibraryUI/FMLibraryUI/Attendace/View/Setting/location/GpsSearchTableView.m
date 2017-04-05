//
//  GpsSearchTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "GpsSearchTableView.h"
#import "FMUtilsPackages.h"
#import "LocationAddTableViewCell.h"


@interface GpsSearchTableView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat itemHeight;
@end

@implementation GpsSearchTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 70;
        
        self.dataSource = self;
        self.delegate = self;
        self.delaysContentTouches = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
        
    }
    return self;
}

- (void) setDataArray:(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    } else {
        [_dataArray removeAllObjects];
    }
    
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
}

- (void) addDataArray:(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    [_dataArray addObjectsFromArray:dataArray];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    LocationAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LocationAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[LocationAddTableViewCell class]]) {
        AttendanceLocation *location = _dataArray[position];
        LocationAddTableViewCell *locationCell = (LocationAddTableViewCell *)cell;
        if(position == _dataArray.count - 1) {
            [locationCell setIsLast:YES];
        } else {
            [locationCell setIsLast:NO];
        }
        [locationCell setNeedChecked:NO];
        [locationCell setChecked:NO];
        [locationCell setName:location.name];
        [locationCell setDesc:location.desc];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AttendanceLocation *location = _dataArray[indexPath.row];
    _locationSelectBlock(location);
}

#pragma mark - ActionBlock
- (void) LoadMoreToTableView {
    _loadMoreBlock();
}

@end
