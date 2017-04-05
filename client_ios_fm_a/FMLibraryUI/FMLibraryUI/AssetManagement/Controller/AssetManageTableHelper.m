//
//  AssetManageHelper.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetManageTableHelper.h"
#import "FMUtilsPackages.h"

#import "SeperatorView.h"
#import "MarkedListHeaderView.h"

//entity
#import "AssetManagementEntity.h"

#import "FMTheme.h"
//cell
#import "AssetProfileView.h"
#import "EquipmentListView.h"
#import "ShowMoreDetailView.h"
#import "BaseBundle.h"

typedef NS_ENUM(NSInteger, AssetManageSectionType) {
    ASSET_MANAGE_PROFILE = 0,   //资产概况
    ASSET_MANAGE_EQUIPMENT = 1,   //设备列表
};

@interface AssetManageTableHelper()

@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat footHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * dataArray;

@property (readwrite, nonatomic, assign) NSInteger equipAmount;
@property (readwrite, nonatomic, assign) NSInteger systemAmount;
@property (readwrite, nonatomic, assign) NSInteger maintainAmount;


@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation AssetManageTableHelper

- (instancetype) initWithContext:(BaseViewController *) context {
    self = [super init];
    if(self) {
        CGRect frame = [context getContentFrame];
        _realWidth = frame.size.width;
        _realHeight = frame.size.height;
        
        _footHeight = 10;
        _headerHeight = 50;
        _showMoreHeight = [ShowMoreDetailView calculateHeight];
    }
    return self;
}


- (void) addEquipmentWithArray:(NSMutableArray *) array {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    _dataArray = [array copy];
}

//设置资产概况
- (void) setInfoWithAmount:(NSInteger) amount system:(NSInteger) systemCount maintain:(NSInteger) maintainCount {
    _equipAmount = amount;
    _systemAmount = systemCount;
    _maintainAmount = maintainCount;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [self notifyEvent:ASSET_MANAGE_DID_SCROLL data:[NSNumber numberWithFloat:offsetY]];
    }
}

#pragma mark UITableView Delegate
- (AssetManageSectionType) getSectionTypeBy:(NSInteger) section {
    AssetManageSectionType sectionType = ASSET_MANAGE_PROFILE;
    if (section == 0) {
        sectionType = ASSET_MANAGE_PROFILE;
    } else if (section == 1) {
        sectionType = ASSET_MANAGE_EQUIPMENT;
    }
    return sectionType;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    AssetManageSectionType sectionType = [self getSectionTypeBy:section];
    switch (sectionType) {
        case ASSET_MANAGE_PROFILE:
            count = 1;
            break;
            
        case ASSET_MANAGE_EQUIPMENT:
            if (_dataArray.count == 0) {
                count = 0;
            } else if (_dataArray.count == 1){
                count = 1;
            } else if (_dataArray.count == 2){
                count = 2;
            } else {
                count = 3;
            }
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    AssetManageSectionType sectionType = [self getSectionTypeBy:section];
    
    switch (sectionType) {
        case ASSET_MANAGE_PROFILE:
            height = [AssetProfileView calculateHeightByWidth:_realWidth andTotalAmount:_equipAmount category:_systemAmount planmaintain:_maintainAmount];
            break;
            
        case ASSET_MANAGE_EQUIPMENT:
            height = [EquipmentListView calculateHeight];  //设备cell的高度
            if (position == 2) {
                height = _showMoreHeight;  //查看全部cell的高度
            }
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell * cell = nil;
    SeperatorView * seperator = nil;
    AssetProfileView * assetProfileItemView = nil;
    EquipmentListView * equipmentItemView = nil;
    ShowMoreDetailView * showMoreItemView = nil;
    AssetManagementEquipmentsEntity * itemEntity = nil;
    
    CGFloat itemHeight = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].padding50;
    
    AssetManageSectionType sectionType = [self getSectionTypeBy:section];
    switch (sectionType) {
        case ASSET_MANAGE_PROFILE:{
            cellIdentifier = @"CellAssetProfile";
            itemHeight = [AssetProfileView calculateHeightByWidth:_realWidth andTotalAmount:_equipAmount category:_systemAmount planmaintain:_maintainAmount];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetProfileView class]]) {
                        assetProfileItemView = view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !assetProfileItemView) {
                assetProfileItemView = [[AssetProfileView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:assetProfileItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
            }
            if (assetProfileItemView) {
                [assetProfileItemView setInfoWithAssetTotalAmount:_equipAmount Assetcategory:_systemAmount PlanMaintain:_maintainAmount];
            }
            break;
        }
        case ASSET_MANAGE_EQUIPMENT:{
            cellIdentifier = @"CellEquipment";
            itemHeight = [EquipmentListView calculateHeight];
            if (position == 2) {
                itemHeight = _showMoreHeight;
            }
            if (position <= 1) {
                itemEntity = [_dataArray objectAtIndex:position];
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[EquipmentListView class]]) {
                        equipmentItemView = view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    } else if ([view isKindOfClass:[ShowMoreDetailView class]]) {
                        showMoreItemView = view;
                    }
                }
            }
            if (cell && !equipmentItemView) {
                equipmentItemView = [[EquipmentListView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                if (position != 2) {
                    [cell addSubview:equipmentItemView];
                }
            }
            if (position == 2 && cell && !showMoreItemView) {
                showMoreItemView = [[ShowMoreDetailView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:showMoreItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (_dataArray.count >=2 && position == 0) {
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                } else {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                    [seperator setDotted:NO];
                }
            }
            if (equipmentItemView) {
                [equipmentItemView setInfoWithTitle:[itemEntity getEquipmentNameDesc]
                                           category:itemEntity.equSysName
                                           location:itemEntity.location
                                             status:itemEntity.status.integerValue
                                             repair:itemEntity.repairNumber
                                        maintecance:itemEntity.maintainNumber];
            }
            
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AssetManageSectionType sectionType = [self getSectionTypeBy:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    
    switch (sectionType) {
        case ASSET_MANAGE_PROFILE:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"asset_header_title_profile" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case ASSET_MANAGE_EQUIPMENT:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"asset_header_title_equipment" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return _footHeight;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _footHeight)];
    seperatorView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    if (section == 0) {
        return seperatorView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    if (indexPath.section == 1) {
        if (position <= 1) {
            AssetManagementEquipmentsEntity * data = [_dataArray objectAtIndex:position];
            [self notifyEvent:ASSET_MANAGE_SHOW_DETAIL data:data];
        } else {
            [self notifyEvent:ASSET_MANAGE_SHOW_MORE data:nil];
        }
    }
}

- (void) notifyEvent:(AssetManageEventType) type data:(id) data {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

@end





