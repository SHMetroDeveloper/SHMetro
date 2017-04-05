//
//  InventoryMaterialDetailTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/30.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailTableView.h"
#import "FMUtilsPackages.h"
#import "MarkedListHeaderView.h"
#import "InventoryMaterialBaseInfoTableViewCell.h"
#import "InventoryMaterialRecordTableViewCell.h"
#import "BaseBundle.h"


typedef NS_ENUM(NSInteger, MaterialDetailSectionType) {
    MATERIAL_DETAIL_SECTION_TYPE_DETAIL,
    MATERIAL_DETAIL_SECTION_TYPE_RECORD
};

@interface InventoryMaterialDetailTableView ()<UITableViewDelegate,UITableViewDataSource,OnClickListener>

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL isExpand;
@end

@implementation InventoryMaterialDetailTableView

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

- (void)setRecordArray:(NSMutableArray *)recordArray {
    if (!_recordArray) {
        _recordArray = [NSMutableArray new];
    }
    
    _recordArray = [recordArray copy];
    if (_recordArray.count > 0) {
        if (self.numberOfSections == 1) {
            [self insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if (self.numberOfSections == 2) {
            [self reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (MaterialDetailSectionType)getSectionTypeBySection:(NSInteger)section {
    MaterialDetailSectionType sectionType = MATERIAL_DETAIL_SECTION_TYPE_DETAIL;
    switch (section) {
        case 0:
            sectionType = MATERIAL_DETAIL_SECTION_TYPE_DETAIL;
            break;
            
        case 1:
            sectionType = MATERIAL_DETAIL_SECTION_TYPE_RECORD;
            break;
    }
    
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if (_recordArray.count > 0) {
        count = 2;
    } else {
        count = 1;
    }
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    MaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_DETAIL_SECTION_TYPE_DETAIL:
            count = 1 + 1;  //+1 footerViewer
            break;
            
        case MATERIAL_DETAIL_SECTION_TYPE_RECORD:
            count = _recordArray.count;
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    CGFloat height = 0;
    MaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_DETAIL_SECTION_TYPE_DETAIL:
            if (position == 1) {
                height = _footerHeight;
            } else {
                height = [InventoryMaterialBaseInfoTableViewCell getItemHeightByExpand:_isExpand
                                                                           description:_materialDetail.desc
                                                                            photoCount:_materialDetail.pictures.count
                                                                       attachmentCount:_materialDetail.attachment.count];
            }
            break;
            
        case MATERIAL_DETAIL_SECTION_TYPE_RECORD:
            height = [InventoryMaterialRecordTableViewCell getItemHeight];
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = nil;
    MaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_DETAIL_SECTION_TYPE_DETAIL:{
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
            
        case MATERIAL_DETAIL_SECTION_TYPE_RECORD:{
            cellIdentifier = @"cellRecord";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                InventoryMaterialRecordTableViewCell *custCell = [[InventoryMaterialRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                custCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
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
    MaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_DETAIL_SECTION_TYPE_DETAIL:{
            if (cell && [cell isKindOfClass:[InventoryMaterialBaseInfoTableViewCell class]]) {
                InventoryMaterialBaseInfoTableViewCell *custCell = (InventoryMaterialBaseInfoTableViewCell *)cell;
                if (_materialDetail.pictures.count > 0) {
                    custCell.showPhotos = YES;;
                }
                if (_materialDetail.attachment.count > 0) {
                    custCell.showAttachments = YES;
                }
                custCell.isExpand = _isExpand;
                custCell.materialDetail = _materialDetail;
            }
        }
            break;
            
        case MATERIAL_DETAIL_SECTION_TYPE_RECORD:{
            if (cell && [cell isKindOfClass:[InventoryMaterialRecordTableViewCell class]]) {
                InventoryMaterialDetailRecordDetail *materialRecord = _recordArray[position];
                InventoryMaterialRecordTableViewCell *custCell = (InventoryMaterialRecordTableViewCell *)cell;
                if (position == _recordArray.count - 1) {
                    custCell.seperatorGapped = NO;
                } else {
                    custCell.seperatorGapped = YES;
                }
                [custCell setInfoWithCode:materialRecord.code
                                 provider:materialRecord.provider
                                    price:materialRecord.price
                                   amount:materialRecord.number
                               realNumber:materialRecord.validNumber
                            storageInTime:materialRecord.date
                                  dueTime:materialRecord.dueDate];
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"headerIdentifier";
    UITableViewHeaderFooterView *headerView = nil;
    
    MaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case MATERIAL_DETAIL_SECTION_TYPE_DETAIL:{
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
                profileHeaderView.tag = MATERIAL_DETAIL_SECTION_TYPE_DETAIL;
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
        case MATERIAL_DETAIL_SECTION_TYPE_RECORD:{
            headerIdentifier = @"recordIdentifier";
            headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
            MarkedListHeaderView *recordHeaderView = nil;
            if (!headerView) {
                headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
            } else {
                NSArray *subViews = headerView.contentView.subviews;
                for (id view in subViews) {
                    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
                        recordHeaderView = (MarkedListHeaderView *)view;
                    }
                }
            }
            if (headerView && !recordHeaderView) {
                recordHeaderView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
                recordHeaderView.tag = MATERIAL_DETAIL_SECTION_TYPE_RECORD;
                [headerView addSubview:recordHeaderView];
            }
            if (recordHeaderView) {
                [recordHeaderView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_material_section_title_record" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
                [recordHeaderView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
                [recordHeaderView setShowEdit:NO];
            }
        }
            break;
    }
    
    return headerView;
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
        if (view.tag == MATERIAL_DETAIL_SECTION_TYPE_DETAIL) {
            _isExpand = !_isExpand;
            [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

- (void)LoadMoreToTableView {
    _loadMoreBlock();
}



@end


