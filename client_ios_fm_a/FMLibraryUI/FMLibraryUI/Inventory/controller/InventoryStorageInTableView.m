//
//  InventoryStorageInTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/23.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageInTableView.h"
#import "FMUtilsPackages.h"
#import "CaptionTextField.h"
#import "InventoryMaterialDetailEntity.h"

#import "BaseBundle.h"

static NSString *cellIdentifier = @"Cell";
static NSString *headerViewIdentifer = @"headerView";

@interface InventoryStorageInTableView ()<UITableViewDelegate,UITableViewDataSource,OnClickListener>
@property (nonatomic, strong) CaptionTextField *warehouseView;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation InventoryStorageInTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        CGFloat defaultItemHeight = 92;
        _warehouseView = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, 0, _realWidth, defaultItemHeight)];
        [_warehouseView setEditable:NO];
        [_warehouseView setShowMark:YES];
        [_warehouseView setOnClickListener:self];
        _warehouseView.tag = 100;
        [_warehouseView setTitle:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name" inTable:nil]];
        [_warehouseView setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
        [_warehouseView setDesc: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_amount" inTable:nil]];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.tableHeaderView = _warehouseView;
        
        [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerViewIdentifer];
        [self registerClass:[InventoryStorageInTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        CGFloat defaultItemHeight = 92;
        _warehouseView = [[CaptionTextField alloc] initWithFrame:CGRectMake(0, 0, _realWidth, defaultItemHeight)];
        [_warehouseView setEditable:NO];
        [_warehouseView setShowMark:YES];
        [_warehouseView setOnClickListener:self];
        [_warehouseView setShowOneLine:YES];
        _warehouseView.tag = 100;
        [_warehouseView setTitle:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name" inTable:nil]];
        [_warehouseView setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
        [_warehouseView setDesc: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_amount" inTable:nil]];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.tableHeaderView = _warehouseView;
        
        [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerViewIdentifer];
        [self registerClass:[InventoryStorageInTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

#pragma mark - Setter
- (void)setDataArray:(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    
    _dataArray = [dataArray copy];
    [self reloadData];
}

- (void)setWareHouseName:(NSString *) name {
    if (![FMUtils isStringEmpty:name]) {
        [_warehouseView setText:name];
    } else {
        [_warehouseView setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
    }
}


- (void) setAmount:(NSNumber *)amount forMaterial:(NSNumber *)inventoryId {
    NSInteger index = 0;
    NSInteger count = [_dataArray count];
    for(index = 0; index < count; index++) {
        InventoryMaterialDetail * material = _dataArray[index];
        if([material.inventoryId isEqualToNumber:inventoryId]) {
            material.reservedNumber = amount;
            break;
        }
    }
    [self reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger count = 0;
    if (_dataArray.count > 0) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = _dataArray.count;
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [InventoryStorageInTableViewCell getItemHeight];
    
    return height;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InventoryStorageInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(InventoryStorageInTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    InventoryMaterialDetail *materialDetail = _dataArray[position];
    cell.tableViewType = _tableViewType;
    [cell setInfoWithCode:materialDetail.code
                     name:materialDetail.name
                    brand:materialDetail.brand
                    model:materialDetail.model
               realNumber:materialDetail.totalNumber
                   number:materialDetail.reservedNumber];
    
    if (position == _dataArray.count - 1) {
        [cell setSeperatorGapped:NO];
    } else {
        [cell setSeperatorGapped:YES];
    }
}

//headerView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 44;
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifer];
    headerView.contentView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    UILabel *titleLbl = nil;
    if (headerView) {
        NSArray *subViews = [headerView subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[UILabel class]]) {
                titleLbl = (UILabel *)view;
                break;
            }
        }
    }
    if (headerView && !titleLbl) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(17, 7, tableView.frame.size.width-34, 37)];
        titleLbl.font = [FMFont fontWithSize:15];
        titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        titleLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_material" inTable:nil];;
        [headerView addSubview:titleLbl];
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

#pragma mark - TableView EditConfiguration
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    BOOL editable = NO;
    if (section == 0) {
        editable = YES;
    }
    return editable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    
    //删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _deleteBlock([NSNumber numberWithInteger:position]);
    }];
    deleteAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
    
    return @[deleteAction];
}

#pragma mark - ClickEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    InventoryMaterialDetail *materialDetail = _dataArray[position];
    _editBlock(materialDetail.inventoryId);
}

- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[CaptionTextField class]] && view.tag == 100) {
        _actionBlock();
    }
}

@end



