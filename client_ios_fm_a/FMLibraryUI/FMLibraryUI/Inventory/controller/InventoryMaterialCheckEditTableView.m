//
//  InventoryMaterialCountEditTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/1.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialCheckEditTableView.h"
#import "FMUtilsPackages.h"
#import "MarkedListHeaderView.h"
#import "InventoryMaterialBaseInfoTableViewCell.h"
#import "InventoryMaterialBatchTableViewCell.h"
#import "InventoryMaterialCheckEntity.h"
#import "InventoryMaterialProviderEntity.h"
#import "InventoryMaterialCheckBatchTableViewCell.h"
#import "InventoryMaterialDetailBatchEntity.h"
#import "BaseBundle.h"

typedef NS_ENUM(NSInteger, MaterialCountEditSectionType) {
    MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE,
    MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH
};

@interface InventoryMaterialCheckEditTableView()<UITableViewDelegate,UITableViewDataSource,OnClickListener>

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;
@end

@implementation InventoryMaterialCheckEditTableView
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
        
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
    }
    return self;
}

#pragma mark - Setter & Getter
- (void)setMaterialDetail:(InventoryMaterialDetail *)materialDetail {
    _materialDetail = materialDetail;
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setBatchArray:(NSMutableArray<InventoryBatchCheckViewModel *> *)batchArray {
    if (!_batchArray) {
        _batchArray = [NSMutableArray new];
    }
    _batchArray = batchArray;
    [self reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (MaterialCountEditSectionType)getSectionTypeBySection:(NSInteger)section {
    MaterialCountEditSectionType sectionType = MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE;
    switch (section) {
        case 0:
            sectionType = MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE;
            break;
            
        case 1:
            sectionType = MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH;
            break;
    }
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    MaterialCountEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE:
            count = 1+1;  //+1 footerViewer
            break;
            
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH:
            count = _batchArray.count;
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    MaterialCountEditSectionType sectionType = [self getSectionTypeBySection:indexPath.section];
    switch (sectionType) {
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE:
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
            
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH:
            height = [InventoryMaterialCheckBatchTableViewCell getItemHeight];
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
    MaterialCountEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE:{
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
            
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH:{
            cellIdentifier = @"cellBatch";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                InventoryMaterialCheckBatchTableViewCell *custCell = [[InventoryMaterialCheckBatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                custCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                
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
    MaterialCountEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE:{
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
            
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH:{
            if (cell && [cell isKindOfClass:[InventoryMaterialCheckBatchTableViewCell class]]) {
                InventoryBatchCheckViewModel *batchModel = _batchArray[position];
                InventoryMaterialCheckBatchTableViewCell *custCell = (InventoryMaterialCheckBatchTableViewCell *)cell;
                if (position == _batchArray.count - 1) {
                    custCell.seperatorGapped = NO;
                } else {
                    custCell.seperatorGapped = YES;
                }
                custCell.isChecked = batchModel.isChecked;
                [custCell setInfoWithProvider:batchModel.providerName
                                        price:batchModel.price
                              inventoryNumber:batchModel.inventoryNumber
                                  checkNumber:batchModel.checkNumber
                                storageInTime:batchModel.storageDate
                                      dueTime:batchModel.dueDate];
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
    
    MaterialCountEditSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE:{
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
                profileHeaderView.tag = MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE;
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
            
        case MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH:{
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
                batchHeaderView.tag = MATERIAL_COUNT_EDIT_SECTION_TYPE_BATCH;
                [headerView addSubview:batchHeaderView];
            }

            if (batchHeaderView) {
                [batchHeaderView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_material_section_title_batch_count" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
                [batchHeaderView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
                [batchHeaderView setShowEdit:NO];
                [batchHeaderView setOnClickListener:self];
            }
        }
            break;
    }
    return headerView;
}

#pragma mark - ClickEvent
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        _actionBlock(MATERIAL_COUNT_EDIT_TYPE_COUNT ,[NSNumber numberWithInteger:indexPath.row]);
    }
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
        if (view.tag == MATERIAL_COUNT_EDIT_SECTION_TYPE_PROFILE) {
            _isExpand = !_isExpand;
            [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)LoadMoreToTableView {
    _loadMoreBlock();
}

@end


