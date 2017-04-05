//
//  GpsAddTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/20.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "GpsAddTableView.h"
#import "FMUtilsPackages.h"
#import "LocationAddTableViewCell.h"
#import "AttendanceSettingEntity.h"

@interface GpsAddTableView ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, assign) CGFloat itemHeight;
@end

@implementation GpsAddTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemHeight = 70;
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        self.delegate = self;
        self.dataSource = self;
        
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
    }
    return self;
}


#pragma mark - API Method
- (void) setDataArray:(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    } else {
        [_dataArray removeAllObjects];
    }
    if (_selectedArray) {
        [_selectedArray removeAllObjects];
    }
    
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
}

- (void) addDataArray:(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    
    [_dataArray addObjectsFromArray:dataArray];
}

- (NSMutableArray *) getSelectedLocation {
    NSMutableArray *result = [NSMutableArray new];
    
    if (_dataArray.count > 0 && _selectedArray.count > 0) {
        NSIndexPath *index = _selectedArray[0];
        result = [NSMutableArray arrayWithObject:_dataArray[index.row]];
    }
    return result;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LocationAddTableViewCell calculateHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    LocationAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[LocationAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    BOOL isChecked = NO;
    if (_selectedArray.count > 0) {
        NSIndexPath *selectedIndex = _selectedArray[0];
        if (indexPath.row == selectedIndex.row) {
            isChecked = YES;
        }
    }
    if (cell && [cell isKindOfClass:[LocationAddTableViewCell class]]) {
        AttendanceLocation *location = _dataArray[position];
        LocationAddTableViewCell *locationCell = (LocationAddTableViewCell *)cell;
        if(position == _dataArray.count - 1) {
            [locationCell setIsLast:YES];
        } else {
            [locationCell setIsLast:NO];
        }
        [locationCell setNeedChecked:YES];
        [locationCell setChecked:isChecked];
        [locationCell setName:location.name];
        [locationCell setDesc:location.desc];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    } else {
        [_selectedArray removeAllObjects];
    }
    
    [_selectedArray addObject:indexPath];
    [tableView reloadData];
}


#pragma mark - ActionBlock
- (void) LoadMoreToTableView {
    _loadMoreBlock();
}

@end

