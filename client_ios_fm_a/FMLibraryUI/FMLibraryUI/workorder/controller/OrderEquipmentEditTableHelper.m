//
//  OrderEquipmentEditTableHelper.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/3.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "OrderEquipmentEditTableHelper.h"
#import "MarkedListHeaderView.h"
#import "CaptionTextTableViewCell.h"
#import "OrderEquipmentComponentTableViewCell.h"
#import "WorkOrderDetailEntity.h"
#import "SeperatorTableViewCell.h"
#import "CaptionMultipleTextTableViewCell.h"
#import "OnClickListener.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "AssetCoreComponentListEntity.h"

typedef NS_ENUM(NSInteger, OrderEquipmentEditTableSectionType) {
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_UNKNOW,
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME,   //名字
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE,   //编码
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS, //状态
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE,//维修类型
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC,//故障描述
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC,//维修描述
    ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT,  //核心组件
};

@interface OrderEquipmentEditTableHelper() <OnClickListener,OnItemClickListener>
@property (nonatomic, weak) CaptionMultipleTextTableViewCell * failureCell;
@property (nonatomic, weak) CaptionMultipleTextTableViewCell * repairCell;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) EquipmentStatus status;
@property (nonatomic, assign) OrderEquipmentRepairType repairType;
@property (nonatomic, strong) NSString * failureDesc;
@property (nonatomic, strong) NSString * repairDesc;

@property (nonatomic, assign) BOOL showNameAndCode;  //是否显示名称和编码

@property (nonatomic, strong) NSMutableArray * array;   //核心组件数组

@property (nonatomic, assign) CGFloat commonItemHeight;
@property (nonatomic, assign) CGFloat descItemHeight;
@property (nonatomic, assign) CGFloat headerItemHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation OrderEquipmentEditTableHelper

- (instancetype) init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    _commonItemHeight = 92;
    _descItemHeight = 174;
    _headerItemHeight = [FMSize getInstance].listHeaderHeight;
    _footerHeight = 15;
}

- (NSInteger) getSectionCount {
    NSInteger count = 4;    //状态，维修类型，故障描述，维修描述
    if(_showNameAndCode) {
        count += 2;
    }
    if([self needShowCoreComponent]) {//核心组件在整改或者替换的时候显示
        count += 1;
    }
    return count;
}

//是否需要显示核心组件
- (BOOL) needShowCoreComponent {
    return _repairType == ORDER_EQUIPMENT_REPAIR_TYPE_REPLACE || _repairType == ORDER_EQUIPMENT_REPAIR_TYPE_RECTIFY;
}

- (BOOL) needShowNameAndCode {
    return _showNameAndCode;
}

- (void) setNeedShowNameAndCode:(BOOL)needShowNameOrCode {
    _showNameAndCode = needShowNameOrCode;
}


- (void) setInfoWithName:(NSString *)name {
    _name = name;
}

- (void) setInfoWithCode:(NSString *)code {
    _code = code;
}

- (void) setInfoWithStatus:(EquipmentStatus) status {
    _status = status;
}

- (void) setInfoWithRepairType:(OrderEquipmentRepairType)repairType {
    _repairType = repairType;
}

- (void) setInfoWithFailureDesc:(NSString *)failureDesc {
    _failureDesc = failureDesc;
}

- (NSString *) getFailureDesc {
    NSString * res = @"";
    if(_failureCell) {
        res = [_failureCell text];
    }
    return res;
}

- (void) setInfoWithRepairDesc:(NSString *)repairDesc {
    _repairDesc = repairDesc;
}

- (NSString *) getRepairDesc {
    NSString * res = @"";
    if(_repairCell) {
        res = [_repairCell text];
    }
    return res;
}


- (void) setInfoWithComponents:(NSMutableArray *) array {
    _array = array;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

- (OrderEquipmentEditTableSectionType) getSectionTypeBySection:(NSInteger) section {
    OrderEquipmentEditTableSectionType sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_UNKNOW;
    if((section >= 0) && ![self needShowNameAndCode]) {
        section += 2;
    }
    if(section >= 6 && ![self needShowCoreComponent]) {
        section += 1;
    }
    switch(section) {
        case 0:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME;
            break;
        case 1:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE;
            break;
        case 2:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS;
            break;
        case 3:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE;
            break;
        case 4:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC;
            break;
        case 5:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC;
            break;
        case 6:
            sectionType = ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT;
            break;
            
    }
    
    return sectionType;
}

#pragma mark - DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self getSectionCount];
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            count = 1;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            count = 1;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            count = 1;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            count = 1;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            count = 1;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            count = 1; //footer
            if ([self needShowCoreComponent]) {   //如果有核心组件，显示分割区域
                count += 1;
            }
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            count = [_array count] + 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            itemHeight = _commonItemHeight;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            itemHeight = _commonItemHeight;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            itemHeight = _commonItemHeight;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            itemHeight = _commonItemHeight;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            itemHeight = _descItemHeight;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            if (position == 0) {
                itemHeight = _descItemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            if(position >= 0 && position < [_array count]) {
                itemHeight = [OrderEquipmentComponentTableViewCell getCellHeight];
            } else {
                itemHeight = _footerHeight;
            }
            break;
        default:
            break;
    }
    return itemHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            height = 50;
            break;
        default:
            break;
    }
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MarkedListHeaderView * headerView;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerItemHeight)];
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_equipment_header_core" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowMark:YES];
            [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            break;
        default:
            break;
    }

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    CaptionTextTableViewCell * captionCell;
    OrderEquipmentComponentTableViewCell * componentCell;
    CaptionMultipleTextTableViewCell * multiTextCell;
    NSString * cellIdentifier = @"";
    
    BOOL isFooter = NO;
    
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            cellIdentifier = @"CellName";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setShowOneLine:YES];
                [captionCell setReadonly:YES];
                [captionCell setOnClickListener:self];
            }
            cell = captionCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = sectionType;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            cellIdentifier = @"CellCode";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setShowOneLine:YES];
                [captionCell setReadonly:YES];
                [captionCell setOnClickListener:self];
            }
            cell = captionCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = sectionType;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            cellIdentifier = @"CellStatus";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setShowOneLine:YES];
                [captionCell setReadonly:YES];
                [captionCell setOnClickListener:self];
            }
            cell = captionCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = sectionType;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            cellIdentifier = @"CellRepairType";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setShowOneLine:YES];
                [captionCell setReadonly:YES];
                [captionCell setOnClickListener:self];
            }
            cell = captionCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = sectionType;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            cellIdentifier = @"CellFailureDesc";
            multiTextCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!multiTextCell) {
                multiTextCell = [[CaptionMultipleTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [multiTextCell setText:_failureDesc];
                _failureCell = multiTextCell;
            }
            cell = multiTextCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.tag = sectionType;
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            if(position == 0) {
                cellIdentifier = @"CellRepairDesc";
                multiTextCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!multiTextCell) {
                    multiTextCell = [[CaptionMultipleTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [multiTextCell setText:_repairDesc];
                    _repairCell = multiTextCell;
                }
                cell = multiTextCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.tag = sectionType;
            } else {
                isFooter = YES;
            }
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            if(position >= 0 && position < [_array count]) {
                cellIdentifier = @"CellComponent";
                componentCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!componentCell) {
                    componentCell = [[OrderEquipmentComponentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                    [componentCell setOnItemClickListener:self];
                }
                cell = componentCell;
                cell.tag = position;
            } else {
                isFooter = YES;
            }
            break;
        default:
            break;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = sectionType;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    CaptionTextTableViewCell * captionCell;
    CaptionMultipleTextTableViewCell * captionMultipleCell;
    OrderEquipmentComponentTableViewCell * componentCell;
//    WorkOrderDetailEquipmentComponent * component;
    AssetCoreComponentListEntity *component;
    switch(sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            captionCell = (CaptionTextTableViewCell *)cell;
            [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil]];
            [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name_placeholder" inTable:nil]];
            [captionCell setText:_name];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            captionCell = (CaptionTextTableViewCell *)cell;
            [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil]];
            [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code_placeholder" inTable:nil]];
            [captionCell setText:_code];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            captionCell = (CaptionTextTableViewCell *)cell;
            [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_status" inTable:nil]];
            [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_status_placeholder" inTable:nil]];
            [captionCell setText:[AssetManagementConfig getEquipmentStatusStrByStatus:_status]];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            captionCell = (CaptionTextTableViewCell *)cell;
            [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_type" inTable:nil]];
            [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_type_placeholder" inTable:nil]];
            [captionCell setText:[WorkOrderServerConfig getOrderEquipmentRepairTypeDesc:_repairType]];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_FAILURE_DESC:
            captionMultipleCell = (CaptionMultipleTextTableViewCell *)cell;
            [captionMultipleCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil]];
            [captionMultipleCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc_placeholder" inTable:nil]];
            
//            [captionMultipleCell setText:_repairType];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIR_DESC:
            if(position == 0) {
                captionMultipleCell = (CaptionMultipleTextTableViewCell *)cell;
                [captionMultipleCell setTitle:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil]];
                [captionMultipleCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair_placeholder" inTable:nil]];
//                [captionMultipleCell setText:_repairType];
            }
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            if(position >= 0 && position < [_array count]) {
                componentCell = (OrderEquipmentComponentTableViewCell *)cell;
                
                component = _array[position];
                
                componentCell.code = component.code;
                componentCell.name = component.name;
            }
            break;
        default:
            break;
    }
}

#pragma mark - 点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_DETAIL data:[NSNumber numberWithInteger:position]];
            break;
            
        default:
            break;
    }
}

#pragma mark - 删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL res = NO;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            res = YES;
            break;
            
        default:
            break;
    }
    return res;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    OrderEquipmentEditTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_COMPONENT:
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                if(position >= 0 && position < [_array count]) {
                    [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_REPAIR data:[NSNumber numberWithInteger:position]];
                }
            }
            break;
            
        default:
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [[BaseBundle getInstance] getStringByKey:@"order_equipment_component_operation_replace" inTable:nil];
    return NSLocalizedString(@"order_equipment_component_operation_replace", nil);
}




#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    OrderEquipmentEditTableSectionType sectionType = view.tag;
    switch (sectionType) {
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_NAME:
            [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SELECT_EQUIPMENT data:nil];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_CODE:
            [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SELECT_EQUIPMENT data:nil];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_STATUS:
            [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SELECT_STATUS data:nil];
            break;
        case ORDER_EQUIPMENT_EDIT_TABLE_SECTION_TYPE_REPAIRTYPE:
            [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SELECT_REPAIR_TYPE data:nil];
            break;
        default:
            break;
    }
}

- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[OrderEquipmentComponentTableViewCell class]]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            NSInteger tag = view.tag;
            if(tag >= 0 && tag < [_array count]) {
                [self notifyEvent:WO_EQUIPMENT_EDIT_EVENT_SHOW_COMPONENT_REPAIR data:[NSNumber numberWithInteger:tag]];
            }
        }
    }
}

#pragma mark - 事件通知
- (void) notifyEvent:(OrderEquipmentEditEventType) type data:(id) data {
    if(_handler) {
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

@end
