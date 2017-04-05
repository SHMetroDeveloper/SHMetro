//
//  EquipmentCoreComponentDetailTableView.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "EquipmentCoreComponentDetailTableView.h"
#import "FMUtilsPackages.h"
#import "AssetCoreComponentDetailBaseInfoTableViewCell.h"
#import "AssetCoreComponentReplaceRecordTableViewCell.h"
#import "MarkedListHeaderView.h"

typedef NS_ENUM(NSInteger, CoreComponentSectionType) {
    CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO,
    CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD,
};

static NSString *cellBaseInfoIdentifier = @"cellBaseInfoIdentifier";
static NSString *cellRecordIdentifier = @"cellRecordIdentifier";
static NSString *cellFooterIdentifier = @"cellFooterIdentifier";

@interface EquipmentCoreComponentDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *recordArray;
@property (nonatomic, assign) AssetCoreComponentDetailEntity *coreComponentDetail;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation EquipmentCoreComponentDetailTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = [FMSize getInstance].listFooterHeight;
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.delaysContentTouches = NO;
        
        [self registerClass:[AssetCoreComponentDetailBaseInfoTableViewCell class] forCellReuseIdentifier:cellBaseInfoIdentifier];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellFooterIdentifier];
        [self registerClass:[AssetCoreComponentReplaceRecordTableViewCell class] forCellReuseIdentifier:cellRecordIdentifier];
        
    }
    return self;
}

#pragma mark - Private Methods
- (void)setCoreComponentDetail:(AssetCoreComponentDetailEntity *)coreDetail {
    _coreComponentDetail = coreDetail;
    [self reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CoreComponentSectionType)getSectionType:(NSInteger)section {
    CoreComponentSectionType sectionType = CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO;
    switch (section) {
        case 0:
            sectionType = CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO;
            break;
            
        case 1:
            sectionType = CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD;
            break;
    }
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    CoreComponentSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO:
            count = 1 + 1;  //+1 Footer
            break;
        
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD:
            count = _coreComponentDetail.history.count;
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    CoreComponentSectionType sectionType = [self getSectionType:indexPath.section];
    switch (sectionType) {
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO:
            if (position == 0) {
                height = [AssetCoreComponentDetailBaseInfoTableViewCell getItemHeight];
            } else if (position == 1) {
                height = _footerHeight;
            }
            break;
            
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD:
            height = [AssetCoreComponentReplaceRecordTableViewCell getItemHeight];
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    UITableViewCell *cell = nil;
    CoreComponentSectionType sectionType = [self getSectionType:indexPath.section];
    switch (sectionType) {
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO:
            if (position == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellBaseInfoIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (position == 1) {
                cell = [tableView dequeueReusableCellWithIdentifier:cellFooterIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            }
            break;
            
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD:
            cell = [tableView dequeueReusableCellWithIdentifier:cellRecordIdentifier];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    CoreComponentSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO:{
            if (cell && [cell isKindOfClass:[AssetCoreComponentDetailBaseInfoTableViewCell class]]) {
                AssetCoreComponentDetailBaseInfoTableViewCell *custCell = (AssetCoreComponentDetailBaseInfoTableViewCell *)cell;
                [custCell setCoreComponentDetail:_coreComponentDetail];
            }
        }
            break;
            
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD:{
            if (cell && [cell isKindOfClass:[AssetCoreComponentReplaceRecordTableViewCell class]]) {
                AssetCoreComponentReplaceRecordTableViewCell *custCell = (AssetCoreComponentReplaceRecordTableViewCell *)cell;
                if (position%2 == 0) {
                    [custCell setCoreReplaced:NO];
                    [custCell setSeperatorGapped:YES];
                } else {
                    [custCell setCoreReplaced:YES];
                    [custCell setSeperatorGapped:NO];
                }
                AssetCoreComponentReplaceRecord *record = _coreComponentDetail.history[position];
                [custCell setCoreComponentReplaceHistory:record];
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    UIView *res = headerView;
    CoreComponentSectionType sectionType = [self getSectionType:section];
    switch (sectionType) {
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO:
            headerView.tag = CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO;
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"core_component_section_baseinfo" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case CORE_COMPONENT_DETTAIL_SECTION_TYPE_RECORD:
            headerView.tag = CORE_COMPONENT_DETTAIL_SECTION_TYPE_BASEINFO;
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"core_component_section_replace_record" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
    }
    
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    
}

@end




