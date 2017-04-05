//
//  MaterialQueryTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/6.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "MaterialQueryTableView.h"
#import "FMUtilsPackages.h"
#import "InventoryMaterialQueryTableViewCell.h"


@interface MaterialQueryTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation MaterialQueryTableView
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

- (void)setDataArray:(NSMutableArray<InventoryMaterialQueryDetail *> *)dataArray {
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
    height = [InventoryMaterialQueryTableViewCell getItemHeight];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        InventoryMaterialQueryTableViewCell *custCell = [[InventoryMaterialQueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = custCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[InventoryMaterialQueryTableViewCell class]]) {
        InventoryMaterialQueryTableViewCell *custCell = (InventoryMaterialQueryTableViewCell *)cell;
        if (position == _dataArray.count - 1) {
            custCell.seperatorGapped = NO;
        } else {
            custCell.seperatorGapped = YES;
        }
        InventoryMaterialQueryDetail *materialDetail = _dataArray[position];
        NSNumber *imageId = nil;
        if (materialDetail.pictures.count > 0) {
            imageId = materialDetail.pictures[0];
        }
        [custCell setInfoWithName:materialDetail.materialName
                             code:materialDetail.materialCode
                    warehouseName:_warehouseName
                            brand:materialDetail.materialBrand
                            model:materialDetail.materialModel
                   previewImageId:imageId
                       totalNumber:materialDetail.totalNumber
                        minNumber:materialDetail.minNumber];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    InventoryMaterialQueryDetail *materialDetail = _dataArray[position];
    _actionBlock(materialDetail.inventoryId);
}

- (void)RefreshData {
    _refreshBlock(MATERIAL_REFRESH_TYPE_REFRESH);
}

- (void)LoadMoreToTableView {
    _refreshBlock(MATERIAL_REFRESH_TYPE_LOADMORE);
}

@end


