//
//  InventoryHistoryTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/5.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "WarehouseQueryTableView.h"
#import "FMUtilsPackages.h"
#import "InventoryWarehouseQueryTableViewCell.h"

@interface WarehouseQueryTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation WarehouseQueryTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
        
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshData)];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray<InventoryWarehouseDetail *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    _dataArray = dataArray;
    [self reloadData];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _dataArray.count;
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    height = [InventoryWarehouseQueryTableViewCell getItemHeight];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];;
    if (!cell) {
        InventoryWarehouseQueryTableViewCell *custCell = [[InventoryWarehouseQueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = custCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[InventoryWarehouseQueryTableViewCell class]]) {
        InventoryWarehouseDetail *warehouseDetail = _dataArray[position];
        InventoryWarehouseQueryTableViewCell *custCell = (InventoryWarehouseQueryTableViewCell *)cell;
        if (position == _dataArray.count - 1) {
            [custCell setSeperatorGapped:NO];
        } else {
            [custCell setSeperatorGapped:YES];
        }
        
        [custCell setInfoWithName:warehouseDetail.warehouseName
                          contact:warehouseDetail.contact
                         location:warehouseDetail.location
                             type:warehouseDetail.materialTypeCount
                           amount:warehouseDetail.materialCount];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    InventoryWarehouseDetail *warehouseDetail = _dataArray[position];
    _actionBlock(warehouseDetail.warehouseId, warehouseDetail.warehouseName);
}

- (void)RefreshData {
    _refreshBlock(WAREHOUSE_REFRESH_TYPE_REFRESH);
}

- (void)LoadMoreToTableView {
    _refreshBlock(WAREHOUSE_REFRESH_TYPE_LOADMORE);
}

@end
