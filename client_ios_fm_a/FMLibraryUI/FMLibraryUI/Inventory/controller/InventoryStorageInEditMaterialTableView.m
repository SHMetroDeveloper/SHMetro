//
//  InventoryStorageInEditMaterialTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/28.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryStorageInEditMaterialTableView.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import "MarkedListHeaderView.h"
#import "InventoryMaterialBaseInfoTableViewCell.h"
#import "InventoryMaterialBatchTableViewCell.h"
#import "InventoryMaterialStorageInEntity.h"
#import "InventoryMaterialProviderEntity.h"


typedef NS_ENUM(NSInteger, MaterialEditSectionType) {
    MATERIAL_EDIT_SECTION_TYPE_PROFILE,
    MATERIAL_EDIT_SECTION_TYPE_BATCH
};

@interface InventoryStorageInEditMaterialTableView ()<UITableViewDelegate,UITableViewDataSource,OnClickListener>

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation InventoryStorageInEditMaterialTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = [FMSize getInstance].listFooterHeight;
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    }
    return self;
}

#pragma mark - Setter & Getter
- (void)setMaterialDetail:(InventoryMaterialDetail *)materialDetail {
    _materialDetail = materialDetail;
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setBatchArray:(NSMutableArray<InventoryMaterialBatchViewModel *> *)batchArray{
    if (!_batchArray) {
        _batchArray = [NSMutableArray new];
    }
    _batchArray = batchArray;
    [self reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (MaterialEditSectionType)getSectionTypeBySection:(NSInteger)section {
    MaterialEditSectionType sectionType = MATERIAL_EDIT_SECTION_TYPE_PROFILE;
    switch (section) {
        case 0:
            sectionType = MATERIAL_EDIT_SECTION_TYPE_PROFILE;
            break;
        case 1:
            sectionType = MATERIAL_EDIT_SECTION_TYPE_BATCH;
            break;
    }
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    MaterialEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_EDIT_SECTION_TYPE_PROFILE:
            count = 1 + 1; //footerCell
            break;
            
        case MATERIAL_EDIT_SECTION_TYPE_BATCH:
            count = _batchArray.count;
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    MaterialEditSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch (sectionType) {
        case MATERIAL_EDIT_SECTION_TYPE_PROFILE:
            if (indexPath.row == 1) {
                height = _footerHeight;
            } else {
//                height = [InventoryMaterialBaseInfoTableViewCell getItemHeightByExpand:_isExpand
//                                                                           description:_materialDetail.desc
//                                                                            photoCount:_materialDetail.pictures.count
//                                                                       attachmentCount:_materialDetail.attachment.count];
                height = [InventoryMaterialBaseInfoTableViewCell getItemHeightByExpand:_isExpand
                                                                           description:_materialDetail.desc
                                                                            photoCount:0
                                                                       attachmentCount:0];
            }
            break;
            
        case MATERIAL_EDIT_SECTION_TYPE_BATCH:
            height = [InventoryMaterialBatchTableViewCell getItemHeight];
            break;
    }
    
    return height;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"cell";
    MaterialEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_EDIT_SECTION_TYPE_PROFILE:{
            if (position == 1) {
                cellIdentifier = @"cellFooter";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
                }
            } else {
                cellIdentifier = @"cellProfile";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    InventoryMaterialBaseInfoTableViewCell *custCell = [[InventoryMaterialBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    custCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    custCell.attachmentBlock = ^(InventoryMaterialDetailAttachment *attachment){
                        _itemClickBlock(MATERIAL_TYPE_CLICK_ATTACHMENT,attachment);
                    };
                    custCell.photoBlock = ^(NSNumber *photoPosition){
                        _itemClickBlock(MATERIAL_TYPE_CLICK_PHOTO,photoPosition);
                    };
                    
                    cell = custCell;
                }
            }
        }
            break;
            
        case MATERIAL_EDIT_SECTION_TYPE_BATCH:{
            cellIdentifier = @"cellBatch";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                InventoryMaterialBatchTableViewCell *custCell = [[InventoryMaterialBatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                custCell.selectionStyle = UITableViewCellSelectionStyleBlue;
                
                cell = custCell;
            }
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    MaterialEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_EDIT_SECTION_TYPE_PROFILE:{
            if (cell && [cell isKindOfClass:[InventoryMaterialBaseInfoTableViewCell class]]) {
                InventoryMaterialBaseInfoTableViewCell *custCell = (InventoryMaterialBaseInfoTableViewCell *)cell;
//                if (_materialDetail.pictures.count > 0) {
//                    custCell.showPhotos = YES;
//                }
//                if (_materialDetail.attachment.count > 0) {
//                    custCell.showAttachments = YES;
//                }
                custCell.showPhotos = NO;
                custCell.showAttachments = NO;
                custCell.isExpand = _isExpand;
                custCell.materialDetail = _materialDetail;
            }
        }
            break;
            
        case MATERIAL_EDIT_SECTION_TYPE_BATCH:{
            if (cell && [cell isKindOfClass:[InventoryMaterialBatchTableViewCell class]]) {
                InventoryMaterialBatchTableViewCell *custCell = (InventoryMaterialBatchTableViewCell *)cell;
                InventoryMaterialBatchViewModel *batchModel = _batchArray[position];
                if (position == _batchArray.count - 1) {
                    custCell.seperatorGapped = NO;
                } else {
                    custCell.seperatorGapped = YES;
                }
                custCell.provider = batchModel.name;
                custCell.dueTime = batchModel.dueDate;
                custCell.price = batchModel.price;
                custCell.amount = batchModel.number;
            }
        }
            break;
    }
}

//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"headerIdentifier";
    UITableViewHeaderFooterView *headerView = nil;
    
    MaterialEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_EDIT_SECTION_TYPE_PROFILE:{
            headerIdentifier = @"profileIdentifier";
            headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
            MarkedListHeaderView *profileHeaderView = nil;
            if (!headerView) {
                headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
            } else {
                NSArray *subViews = headerView.contentView.subviews;
                for (id view in subViews) {
                    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
                        profileHeaderView = (MarkedListHeaderView *)view;
                    }
                }
            }
            if (headerView && !profileHeaderView) {
                profileHeaderView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
                profileHeaderView.tag = MATERIAL_EDIT_SECTION_TYPE_PROFILE;
                [headerView addSubview:profileHeaderView];
            }
            if (profileHeaderView) {
                [profileHeaderView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_material_section_title_detail" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
                if (_isExpand) {
                    [profileHeaderView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
                } else {
                    [profileHeaderView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
                }
                [profileHeaderView setOnClickListener:self];
                [profileHeaderView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
                [profileHeaderView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
                [profileHeaderView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            }
        }
            break;
            
        case MATERIAL_EDIT_SECTION_TYPE_BATCH:{
            headerIdentifier = @"batchIdentifier";
            headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
            MarkedListHeaderView *batchHeaderView = nil;
            if (!headerView) {
                headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
            } else {
                NSArray *subViews = headerView.contentView.subviews;
                for (id view in subViews) {
                    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
                        batchHeaderView = (MarkedListHeaderView *)view;
                    }
                }
            }
            if (headerView && !batchHeaderView) {
                batchHeaderView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
                batchHeaderView.tag = MATERIAL_EDIT_SECTION_TYPE_BATCH;
                [headerView addSubview:batchHeaderView];
            }
            if (batchHeaderView) {
                [batchHeaderView setDescColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                [batchHeaderView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_material_section_title_batch" inTable:nil] desc:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil] andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
                [batchHeaderView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
                [batchHeaderView setShowEdit:NO];
                [batchHeaderView setOnClickListener:self];
            }
        }
            break;
    }
    return headerView;
}

#pragma mark - TableView EditConfiguration
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    BOOL editable = NO;
    if (section == 1) {
        editable = YES;
    }
    return editable;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //删除操作
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        _actionBlock(MATERIAL_EDIT_TYPE_BATCH_DELETE ,[NSNumber numberWithInteger:indexPath.row]);
    }];
    deleteAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
    
    return @[deleteAction];
}


#pragma mark - ClickEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        _actionBlock(MATERIAL_EDIT_TYPE_BATCH_EDIT ,[NSNumber numberWithInteger:indexPath.row]);
    }
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
        if (view.tag == MATERIAL_EDIT_SECTION_TYPE_PROFILE) {
            _isExpand = !_isExpand;
            [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (view.tag == MATERIAL_EDIT_SECTION_TYPE_BATCH) {
            _actionBlock(MATERIAL_EDIT_TYPE_BATCH_ADD ,nil);
        }
    }
}

@end

