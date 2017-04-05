//
//  EquipmentDetailHelper.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/3.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentDetailHelper.h"
//工具类
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "NetPage.h"
//封装类
#import "MarkedListHeaderView.h"
#import "PhotoShowHelper.h"
#import "SeperatorView.h"
#import "PatrolDBHelper.h"
//cell
#import "AssetBaseInfoView.h"
#import "AssetContractView.h"
#import "AssetFactoryView.h"
#import "AssetOrderRecordView.h"
#import "AssetBaseParemeterView.h"
#import "AssetBaseServiceAreaView.h"
#import "ContractQueryItemView.h"
#import "AssetPatrolTableViewCell.h"
#import "AssetWorkOrderTableViewCell.h"
#import "AssetCoreComponentListTableViewCell.h"
#import "AssetPatrolHistoryTableViewCell.h"

//实体类
#import "EquipmentUndoPatrolModel.h"
#import "AssetUndoWorkOrderEntity.h"


typedef NS_ENUM(NSInteger, AssetManagementDetailSectionType) {
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW,  //未知
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO,  //基本信息
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM,   //参数信息
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA,  //服务区域
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL,   //待处理巡检任务
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER,  //待处理工单
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS,  //生产商
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER,  //供应商
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER,  //安装单位
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT,  //设备绑定的合同

    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN,  //维保记录
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED,  //维修记录
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL,  //巡检记录
    
    ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT,  //核心组件
};


@interface EquipmentDetailHelper() <OnClickListener>

@property (readwrite, nonatomic, strong) NetPage * page;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footHeight;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) AssetOrderRecordType recordType;

@property (nonatomic, assign) AssetManagementDetailShowType showType;

@property (nonatomic, strong) AssetEquipmentDetailEntity *equipmentDetail;
@property (nonatomic, strong) NSMutableArray *undoPatrolArray;
@property (nonatomic, strong) NSMutableArray *undoWorkOrderArray;

@property (nonatomic, assign) BOOL baseinfoFlexible;  //是否收缩展示页面
@property (nonatomic, assign) BOOL paremeterFlexible;  //是否收缩展示页面
@property (nonatomic, assign) BOOL areaFlexible;  //是否收缩展示页面

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation EquipmentDetailHelper

- (instancetype) initWithContext:(BaseViewController *) context {
    self = [super init];
    if (self) {
        CGRect frame = [context getContentFrame];
        _showType = ASSET_MANAGEMENT_DETAIL_BASIC_INFO;
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _headerHeight = 50;
        _footHeight = 10;
        _dataArray = [NSMutableArray new];
        _baseinfoFlexible = NO;
        
        _page = [[NetPage alloc] init];
    }
    return self;
}

- (void) removeAllOrders {
    if(_dataArray) {
        [_dataArray removeAllObjects];
    }
    [_page reset];
}

- (void) setPage:(NetPage *)page {
    _page = page;
}

- (NetPage *) getPage {
    return _page;
}

- (NetPage *) resetPage {
    [_page reset];
    return _page;
}

- (BOOL) isFirstPage {
    return [_page isFirstPage];
}

- (BOOL) hasMorePage {
    return [_page haveMorePage];
}

- (NSInteger) getOrderCount {
    return [_dataArray count];
}

- (void) setEquipmentDetailInfo:(AssetEquipmentDetailEntity *) entity {
    if (!_equipmentDetail) {
        _equipmentDetail = [[AssetEquipmentDetailEntity alloc] init];
    }
    _equipmentDetail = entity;
}

- (void) addDataRecordInfo:(NSMutableArray *) dataArray andPage:(NetPage *)page byType:(AssetOrderRecordType) type {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    if (_recordType != type) {
        //切换数据源的时候保证维保和维护的数据不会窜
        [_dataArray removeAllObjects];
    }
    switch (type) {
        case ASSET_ORDER_RECORD_TYPE_FIXED:
            _recordType = ASSET_ORDER_RECORD_TYPE_FIXED;
            [_dataArray addObjectsFromArray:dataArray];
            _page = page;
            break;
        case ASSET_ORDER_RECORD_TYPE_MAINTAIN:
            _recordType = ASSET_ORDER_RECORD_TYPE_MAINTAIN;
            [_dataArray addObjectsFromArray:dataArray];
            _page = page;
            break;
        case ASSET_CONTRACT_RECORD:
            _recordType = ASSET_CONTRACT_RECORD;
            [_dataArray addObjectsFromArray:dataArray];
            _page = page;
            break;
        case ASSET_PATROL_RECORD:
            _recordType = ASSET_PATROL_RECORD;
            [_dataArray addObjectsFromArray:dataArray];
            _page = page;
            break;
        case ASSET_CORE_COMPONENT:
            _recordType = ASSET_CORE_COMPONENT;
            [_dataArray addObjectsFromArray:dataArray];
            break;
    }
}

//设置待处理巡检任务
- (void) setUndoPatrol:(NSMutableArray *)undoPatrolArray {
    _undoPatrolArray = undoPatrolArray;
}

//设置待处理工单
- (void) setUndoWorkOder:(NSMutableArray *)undoWorkOrder {
    _undoWorkOrderArray = undoWorkOrder;
}

- (void) setShowType:(AssetManagementDetailShowType) showType {
    _showType = showType;
}

//获取维修工单个数
- (NSInteger) getFixedOrderCount {
    NSInteger count = [_dataArray count];
    return count;
}

//获取维保工单个数
- (NSInteger) getMaintainOrderCount {
    NSInteger count = [_dataArray count];
    return count;
}

- (NSInteger) getContractCount {
    NSInteger count = [_dataArray count];
    return count;
}

- (NSInteger) getPatrolCount {
    NSInteger count = [_dataArray count];
    return count;
}

- (NSInteger) getCoreComponentCount {
    NSInteger count = [_dataArray count];
    return count;
}

//判断是否有数据
- (BOOL) hasData {
    BOOL res = YES;
    switch(_showType) {
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            if([self getFixedOrderCount] == 0) {
                res = NO;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            if([self getMaintainOrderCount] == 0) {
                res = NO;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
            if([self getContractCount] == 0) {
                res = NO;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            if([self getPatrolCount] == 0) {
                res = NO;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            if([self getCoreComponentCount] == 0) {
                res = NO;
            }
            break;
        default:
            break;
    }
    return res;
}

//- (BOOL) hasContract {
//    BOOL res = YES;
//    switch(_showType) {
//        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
//            if([self getSectionCount] == 0) {
//                res = NO;
//            }
//            break;
//        default:
//            break;
//    }
//    res = NO;
//    return res;
//}

- (BOOL) hasFactory {
    BOOL res = YES;
    switch(_showType) {
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            if([self getSectionCount] == 0) {
                res = NO;
            }
            break;
        default:
            break;
    }
    return res;
}

- (AssetManagementDetailShowType) getShowType {
    return _showType;
}

- (NSInteger) getSectionCount {
    NSInteger count = 0;   //
    switch (_showType) {
        case ASSET_MANAGEMENT_DETAIL_UNKNOW:
            break;
            
        case ASSET_MANAGEMENT_DETAIL_BASIC_INFO:
            if (_baseinfoFlexible) {
                count = 3;  //基本信息 + 参数 + 服务区域 + 待处理巡检任务 + 待处理工单
            } else {
                count = 1;  //基本信息 + 待处理巡检任务 + 待处理工单
            }
            if (_undoPatrolArray.count > 0) {
                count += 1;
            }
            if (_undoWorkOrderArray.count > 0) {
                count += 1;
            }
            break;
        
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            count = 0;
            if (_equipmentDetail.manufacturer) {
                count += 1;
            }
            if (_equipmentDetail.provider) {
                count += 1;
            }
            if (_equipmentDetail.installer) {
                count += 1;
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:    //合同
            count = 1;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            count = 1;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            count = 1;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            count = 1;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            count = 1;
            break;
    }
    return count;
}

- (AssetManagementDetailSectionType) getSectionTypeBySection:(NSInteger) section {
    AssetManagementDetailSectionType sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW;
    switch (_showType) {
        case ASSET_MANAGEMENT_DETAIL_UNKNOW:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_BASIC_INFO:
            if (_baseinfoFlexible) {
                switch (section) {
                    case 0:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO;
                        break;
                    case 1:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM;
                        break;
                    case 2:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA;
                        break;
                    case 3:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL;
                        break;
                    case 4:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER;
                        break;
                }
            } else {
                switch (section) {
                    case 0:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO;
                        break;
                    case 1:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL;
                        break;
                    case 2:
                        sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER;
                        break;
                }
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MANUFACTURER:
            if(section >=0 && !_equipmentDetail.manufacturer) {
                section += 1;
            }
            if(section >=1 && !_equipmentDetail.provider) {
                section += 1;
            }
            if(section >=2 && !_equipmentDetail.installer) {
                section += 1;
            }
            switch (section) {
                case 0:
                    sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS;
                    break;
                case 1:
                    sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER;
                    break;
                case 2:
                    sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER;
                    break;
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CONTRACT:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_MAINTAIN_RECORD:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_FIXED_RECORD:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_PATROL:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_CORE_COMPONENT:
            sectionType = ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT;
            break;
    }
    return sectionType;
}



#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self getSectionCount];
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            count = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            if (_equipmentDetail) {
                count = 1;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            if (_equipmentDetail.params.count > 0) {
                count = _equipmentDetail.params.count;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            if (_equipmentDetail.serviceZones.count > 0) {
                count = _equipmentDetail.serviceZones.count;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            if (_undoPatrolArray.count > 0) {
                count = _undoPatrolArray.count;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            if (_undoWorkOrderArray.count > 0) {
                count = _undoWorkOrderArray.count;
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            if (_equipmentDetail.manufacturer) {
                count = 1;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            if (_equipmentDetail.provider) {
                count = 1;
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            if (_equipmentDetail.installer) {
                count = 1;
            }
            break;
            
        
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            if (_recordType == ASSET_CONTRACT_RECORD && _dataArray) {
                count = [_dataArray count];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:
            if (_recordType == ASSET_ORDER_RECORD_TYPE_MAINTAIN && _dataArray) {
                count = [_dataArray count];
            }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:
            if (_recordType == ASSET_ORDER_RECORD_TYPE_FIXED && _dataArray) {
                count = [_dataArray count];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            if (_recordType == ASSET_PATROL_RECORD && _dataArray) {
                count = [_dataArray count];
            }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            if (_recordType == ASSET_CORE_COMPONENT && _dataArray) {
                count = [_dataArray count];
            }
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    CGFloat height = 0;
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            height = [AssetBaseInfoView calculateHeightBybaseInfoEntity:_equipmentDetail andFlexible:_baseinfoFlexible andWidth:_realWidth];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            height = [AssetBaseParemeterView calculaterHeightBy:_equipmentDetail.params[position] andFlexible:_paremeterFlexible];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            height = [AssetBaseServiceAreaView calculaterHeightBy:_equipmentDetail.serviceZones[position] andFlexible:_areaFlexible];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            height = [AssetPatrolTableViewCell getItemHeight];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            height = [AssetWorkOrderTableViewCell getItemHeight];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            height = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_MANUFACTURER];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            height = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_SUPPLIER];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            height = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_INSTALLER];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            height = [ContractQueryItemView getItemHeight];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:{
            AssetWorkOrderMaintainEntity * entity = [_dataArray objectAtIndex:position];
            height = [AssetOrderRecordView calculateMaintainHeightBy:entity andWidth:_realWidth];
        }
            break;
        
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:{
            AssetWorkOrderFixedEntity * entity = [_dataArray objectAtIndex:position];
            height = [AssetOrderRecordView calculateFixedHeightBy:entity andWidth:_realWidth];
        }
            break;
        
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            height = [AssetPatrolHistoryTableViewCell getItemHeight];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            height = [AssetCoreComponentListTableViewCell getItemHeight];
            break;
    }
    return height;
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    CGFloat itemHeight = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    SeperatorView *seperator = nil;
    
    AssetBaseInfoView *baseInfoItemView = nil;
    AssetBaseParemeterView *baseParemeterView = nil;
    AssetBaseServiceAreaView *baseServiceAreaView = nil;

    AssetFactoryView * manuFacturerItemView = nil;
    AssetFactoryView * supplierItemView = nil;
    AssetFactoryView * installerItemView = nil;
    
    ContractQueryItemView *contractItemView = nil;
    
    AssetOrderRecordView * maintainRecordItemView = nil;
    
    AssetOrderRecordView * fixedRecordItemView = nil;
    
    UIView *patrolItemView = nil;
    
    UIView *coreComponentItemView = nil;
    
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:{
            cellIdentifier = @"CellBaseInfo";
            itemHeight = [AssetBaseInfoView calculateHeightBybaseInfoEntity:_equipmentDetail andFlexible:_baseinfoFlexible andWidth:_realWidth];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetBaseInfoView class]]) {
                        baseInfoItemView = (AssetBaseInfoView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !baseInfoItemView) {
                baseInfoItemView = [[AssetBaseInfoView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:baseInfoItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
            }
            if (baseInfoItemView) {
                [baseInfoItemView setBasicInfoWith:_equipmentDetail];
                [baseInfoItemView setFlexible:_baseinfoFlexible];
            }
        }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:{
            cellIdentifier = @"CellBaseParemeter";
            itemHeight = [AssetBaseParemeterView calculaterHeightBy:_equipmentDetail.params[position] andFlexible:_paremeterFlexible];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetBaseParemeterView class]]) {
                        baseParemeterView = (AssetBaseParemeterView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !baseParemeterView) {
                baseParemeterView = [[AssetBaseParemeterView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:baseParemeterView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (position == _equipmentDetail.params.count - 1) {
                    [seperator setDotted:NO];
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                } else {
                    [seperator setDotted:YES];
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
                }
            }
            if (baseParemeterView) {
                [baseParemeterView setParemeterInfoWith:_equipmentDetail.params[position]];
                [baseParemeterView setFlexible:_paremeterFlexible];
            }
        }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:{
            cellIdentifier = @"CellBaseArea";
            itemHeight = [AssetBaseServiceAreaView calculaterHeightBy:_equipmentDetail.serviceZones[position] andFlexible:_areaFlexible];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetBaseServiceAreaView class]]) {
                        baseServiceAreaView = (AssetBaseServiceAreaView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !baseServiceAreaView) {
                baseServiceAreaView = [[AssetBaseServiceAreaView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:baseServiceAreaView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
            }
            if (baseServiceAreaView) {
                [baseServiceAreaView setServiceAreaInfoWith:_equipmentDetail.serviceZones[position]];
                [baseServiceAreaView setFlexible:_areaFlexible];
            }
        }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:{
            cellIdentifier = @"CellBasePatrol";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                AssetPatrolTableViewCell *custCell = [[AssetPatrolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell = custCell;
            }
            if (cell) {
                EquipmentUndoPatrolModel *undoPatrolModel = _undoPatrolArray[position];
                AssetPatrolTableViewCell *custCell = (AssetPatrolTableViewCell *)cell;
                if (position == _undoPatrolArray.count - 1) {
                    [custCell setSeperatorGapped:NO];
                } else {
                    [custCell setSeperatorGapped:YES];
                }
                NSString *undoPatrolTitle = [NSString stringWithFormat:@"%@-%@",undoPatrolModel.taskName,undoPatrolModel.spotName];
                [custCell setPatrolInfoWith:undoPatrolTitle finished:undoPatrolModel.finished];
            }
        }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:{
            cellIdentifier = @"CellBaseWorkOrder";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                AssetWorkOrderTableViewCell *custCell = [[AssetWorkOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell = custCell;
            }
            if (cell) {
                AssetUndoWorkOrderEntity *workorderEntity = _undoWorkOrderArray[position];
                AssetWorkOrderTableViewCell *custCell = (AssetWorkOrderTableViewCell *)cell;
                if (position == _undoWorkOrderArray.count - 1) {
                    [custCell setSeperatorGapped:NO];
                } else {
                    [custCell setSeperatorGapped:YES];
                }
                
                [custCell setInfoWithCode:workorderEntity.code time:workorderEntity.createDateTime desc:workorderEntity.woDescription status:workorderEntity.status];
            }
        }
            break;

        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:{
            cellIdentifier = @"manufacturer";
            itemHeight = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_MANUFACTURER];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetFactoryView class]]) {
                        manuFacturerItemView = (AssetFactoryView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !manuFacturerItemView) {
                manuFacturerItemView = [[AssetFactoryView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:manuFacturerItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if (manuFacturerItemView) {
                [manuFacturerItemView setAssetFactoryInfoWith:_equipmentDetail andContractType:ASSET_FACTORY_MANUFACTURER];
            }
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:{
            cellIdentifier = @"supplier";
            itemHeight = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_SUPPLIER];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetFactoryView class]]) {
                        supplierItemView = (AssetFactoryView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !supplierItemView) {
                supplierItemView = [[AssetFactoryView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:supplierItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if (supplierItemView) {
                [supplierItemView setAssetFactoryInfoWith:_equipmentDetail andContractType:ASSET_FACTORY_SUPPLIER];
            }
        }
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:{
            cellIdentifier = @"installer";
            itemHeight = [AssetFactoryView calculateHeightBybaseInfoEntity:_equipmentDetail andWidth:_realWidth andContractType:ASSET_FACTORY_INSTALLER];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetFactoryView class]]) {
                        installerItemView = (AssetFactoryView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !installerItemView) {
                installerItemView = [[AssetFactoryView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:installerItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if (installerItemView) {
                [installerItemView setAssetFactoryInfoWith:_equipmentDetail andContractType:ASSET_FACTORY_INSTALLER];
            }
        }
            break;
            
            
        
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT: {
            cellIdentifier = @"contractRecord";
            ContractEntity *entity = [_dataArray objectAtIndex:position];
            itemHeight = [ContractQueryItemView getItemHeight];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[ContractQueryItemView class]]) {
                        contractItemView = (ContractQueryItemView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !contractItemView) {
                contractItemView = [[ContractQueryItemView alloc] init];
                [cell addSubview:contractItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if(contractItemView) {
                [contractItemView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [contractItemView setInfoWithContract:entity];
                contractItemView.tag = position;
            }
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:{
            cellIdentifier = @"maintainRecord";
            AssetWorkOrderMaintainEntity * entity = [_dataArray objectAtIndex:position];
            itemHeight = [AssetOrderRecordView calculateMaintainHeightBy:entity andWidth:_realWidth];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetOrderRecordView class]]) {
                        maintainRecordItemView = (AssetOrderRecordView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !maintainRecordItemView) {
                maintainRecordItemView = [[AssetOrderRecordView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:maintainRecordItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if (maintainRecordItemView) {
                [maintainRecordItemView setMaintainRecordData:entity];
            }
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:{
            cellIdentifier = @"fixedRecord";
            AssetWorkOrderFixedEntity * entity = [_dataArray objectAtIndex:position];
            itemHeight = [AssetOrderRecordView calculateFixedHeightBy:entity andWidth:_realWidth];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[AssetOrderRecordView class]]) {
                        fixedRecordItemView = (AssetOrderRecordView *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !fixedRecordItemView) {
                fixedRecordItemView = [[AssetOrderRecordView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:fixedRecordItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if (fixedRecordItemView) {
                [fixedRecordItemView setFixedRecordData:entity];
            }
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:{
            cellIdentifier = @"CellPatrolRecord";
            AssetPatrolRecordEntity *entity = [_dataArray objectAtIndex:position];
            itemHeight = [AssetPatrolHistoryTableViewCell getItemHeight];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                AssetPatrolHistoryTableViewCell *custCell = [[AssetPatrolHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell = custCell;
            }
            if (cell) {
                AssetPatrolHistoryTableViewCell *custCell = (AssetPatrolHistoryTableViewCell *)cell;
                if (position == _dataArray.count-1) {
                    [custCell setSeperatorGapped:NO];
                } else {
                    [custCell setSeperatorGapped:YES];
                }
                [custCell setPatrolHistory:entity];
            }
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:{
            cellIdentifier = @"CellCoreComponent";
            AssetCoreComponentListEntity *entity = [_dataArray objectAtIndex:position];
            itemHeight = [ContractQueryItemView getItemHeight];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                AssetCoreComponentListTableViewCell *custCell = [[AssetCoreComponentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell = custCell;
            }
            if (cell) {
                AssetCoreComponentListTableViewCell *custCell = (AssetCoreComponentListTableViewCell *)cell;
                if (position == _dataArray.count-1) {
                    [custCell setSeperatorGapped:NO];
                } else {
                    [custCell setSeperatorGapped:YES];
                }
                [custCell setEquipmentCode:entity.code andName:entity.name];
            }
        }
            break;
    }
            
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            height = _headerHeight;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            height = _headerHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            height = _headerHeight;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            height = 0;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_baseinfo" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            
            if (_baseinfoFlexible) {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
            } else {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
            }
            [headerView setOnClickListener:self];
            [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_paremeter" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            if (_paremeterFlexible) {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
            } else {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
            }
            [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_area" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            if (_areaFlexible) {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
            } else {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
            }
            [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
            [headerView setOnClickListener:self];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_undo_patrol" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setDescLabel:nil content:[[BaseBundle getInstance] getStringByKey:@"equipment_header_btn_undo_patrol_syn" inTable:nil]];
            [headerView setOnClickListener:self];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_undo_workorder" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            if (![FMUtils isStringEmpty:_equipmentDetail.manufacturer.name]) {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_manufactory" inTable:nil],_equipmentDetail.manufacturer.name] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            } else {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_manufactory" inTable:nil]] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            }
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            if (![FMUtils isStringEmpty:_equipmentDetail.provider.name]) {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_provider" inTable:nil],_equipmentDetail.provider.name] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            } else {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_provider" inTable:nil]] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            }
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            if (![FMUtils isStringEmpty:_equipmentDetail.installer.name]) {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_installer" inTable:nil],_equipmentDetail.installer.name] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            } else {
                [headerView setInfoWithName:[NSString stringWithFormat:@"%@",[[BaseBundle getInstance] getStringByKey:@"equipment_header_title_installer" inTable:nil]] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            }
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            [headerView setShowBottomBorder:YES withPaddingLeft:0 paddingRight:0];
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            headerView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:
            headerView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:
            headerView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            headerView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            headerView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            headerView = nil;
            break;
    }
    
    headerView.tag = sectionType;
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    CGFloat height = 0;
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            height = _footHeight;
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            height = 0;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            height = 0;
            break;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _footHeight)];
    footView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            footView = nil;
            break;
        
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            footView = nil;
            break;

        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:
            footView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:
            footView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:
            footView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:
            footView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:
            footView = nil;
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_UNKNOW:
            footView = nil;
            break;
    }
    
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    AssetManagementDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
            [self notifyEvent:ASSET_EVENT_PATROL_UNDO data:[NSNumber numberWithInteger:position]];
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_WORKORDER:
            [self notifyEvent:ASSET_EVENT_WORK_ORDER_UNDO data:[NSNumber numberWithInteger:position]];
            break;
            
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MANUFACTURERS:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PROVIDER:
            break;
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_INSTALLER:
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CONTRACT:{
            ContractEntity *entity = _dataArray[position];
            [self notifyEvent:ASSET_EVENT_CONTRACT data:entity.contractId];
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_MAINTAIN:{
            AssetWorkOrderMaintainEntity * entity = [_dataArray objectAtIndex:position];
            NSNumber * woId = entity.woId;
            [self notifyEvent:ASSET_EVENT_ORDER_RECORD_MAINTAIN data:woId];
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_FIXED:{
            AssetWorkOrderFixedEntity * entity = [_dataArray objectAtIndex:position];
            NSNumber * woId = entity.woId;
            [self notifyEvent:ASSET_EVENT_ORDER_RECORD_FIXED data:woId];
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_PATROL:{
            AssetPatrolRecordEntity *entity = [_dataArray objectAtIndex:position];
            [self notifyEvent:ASSET_EVENT_PATROL_HISTORY data:entity];
        }
            break;
            
        case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_CORE_COMPONENT:{
            AssetCoreComponentListEntity *entity = [_dataArray objectAtIndex:position];
            [self notifyEvent:ASSET_EVENT_CORE_COMPONENT data:entity.eqCoreId];
        }
            break;
    }
    
}



#pragma mark - 监听代理
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) notifyEvent:(AssetDetailEventType) type data:(id) data {
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


#pragma mark - 处理代理信息

- (void)onClick:(UIView *)view {
    if ([view isKindOfClass:[MarkedListHeaderView class]]) {
        AssetManagementDetailSectionType sectionType = view.tag;
        switch (sectionType) {
            case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_INFO:
                _baseinfoFlexible = !_baseinfoFlexible;
                [self notifyEvent:ASSET_EVENT_FlEX_BASEINFO data:[NSNumber numberWithBool:_baseinfoFlexible]];
                break;
            case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PARAM:
                _paremeterFlexible = !_paremeterFlexible;
                [self notifyEvent:ASSET_EVENT_FlEX_PAREMETER data:[NSNumber numberWithBool:_paremeterFlexible]];
                break;
            case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_SERVICEAREA:
                _areaFlexible = !_areaFlexible;
                [self notifyEvent:ASSET_EVENT_FlEX_SERVICEAREA data:[NSNumber numberWithBool:_areaFlexible]];
                break;
            case ASSET_MANAGEMENT_DETAIL_SECTION_TYPE_BASIC_PATROL:
                [self notifyEvent:ASSET_EVENT_PATROL_SYC data:nil];
                break;
            default:
                break;
        }
    }
}

- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if(msgOrigin && [msgOrigin isEqualToString:NSStringFromClass([AssetBaseInfoView class])]) {
            NSMutableArray *photoArray = [msg valueForKeyPath:@"photosArray"];
            NSNumber *position = [msg valueForKeyPath:@"position"];
            [self showPhoto:photoArray andPosition:position];
        }
    }
}


- (void) showPhoto:(NSMutableArray *) photos andPosition:(NSNumber *) position {
    NSMutableDictionary * photoParams = [[NSMutableDictionary alloc] init];
    [photoParams setValue:photos forKeyPath:@"PhotosArray"];
    [photoParams setValue:position forKeyPath:@"position"];
    
    [self notifyEvent:ASSET_EVENT_SHOW_PHOTO data:photoParams];
}

@end


