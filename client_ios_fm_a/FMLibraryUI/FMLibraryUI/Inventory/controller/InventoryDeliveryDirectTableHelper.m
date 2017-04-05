//
//  InventoryStorageOutTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/25/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryDeliveryDirectTableHelper.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "CaptionTextField.h"
#import "InventoryMaterialTableViewCell.h"
#import "CaptionTextTableViewCell.h"

typedef NS_ENUM(NSInteger, InventoryDeliveryDirectTableSectionType) {
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_UNKNOW,
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE,
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR,
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR,
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON,
    INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL,
};

@interface InventoryDeliveryDirectTableHelper () <OnClickListener>


@property (readwrite, nonatomic, strong) NSString * warehouseName;
@property (readwrite, nonatomic, strong) NSString * administrator;
@property (readwrite, nonatomic, strong) NSString * supervisor;
@property (readwrite, nonatomic, strong) NSString * receivingPerson;
@property (readwrite, nonatomic, strong) NSMutableArray * materialArray;
@property (readwrite, nonatomic, strong) NSMutableArray * amountArray;  //数量数组

@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, assign) CGFloat captionHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation InventoryDeliveryDirectTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
    }
    return self;
}

- (void) initSettings {
    _headerHeight = [FMSize getInstance].listHeaderHeight;
    _captionHeight = 92;
}


//设置仓库信息
- (void) setInfoWithWarehouseName:(NSString *) warehouse {
    _warehouseName = warehouse;
}

//设置仓库管理员
- (void) setInfoWithAdministrator:(NSString *) administrator {
    _administrator = administrator;
}

//设置主管
- (void) setInfoWithSupervisor:(NSString *) supervisor {
    _supervisor = supervisor;
}

//设置领用人
- (void) setInfoWithReceivingPerson:(NSString *) person {
    _receivingPerson = person;
}

//设置物料数组
- (void) setInfoWithMaterials:(NSMutableArray *) array {
    _materialArray = array;
    NSInteger count = [array count];
    if(!_amountArray) {
        _amountArray = [[NSMutableArray alloc] init];
    } else {
        [_amountArray removeAllObjects];
    }
    for(NSInteger index = 0; index < count;index++) {
        NSNumber * tmpCount = [NSNumber numberWithFloat:0];
        [_amountArray addObject:tmpCount];
    }
}

//添加物料
- (void) addMaterial:(MaterialEntity *) material amount:(CGFloat) amount {
    if(!_materialArray) {
        _materialArray = [[NSMutableArray alloc] init];
    }
    if(!_amountArray) {
        _amountArray = [[NSMutableArray alloc] init];
    }
    [_materialArray addObject:material];
    [_amountArray addObject:[NSNumber numberWithFloat:amount]];
}


//设置物料的出库量
- (void) setAmount:(NSNumber *) amount forMaterial:(NSNumber *) inventoryId {
    NSInteger index = 0;
    for(MaterialEntity * material in _materialArray) {
        if([material.inventoryId isEqualToNumber:inventoryId]) {
            _amountArray[index] = amount;
            break;
        }
        index++;
    }
}

//添加物料
- (void) addMaterial:(MaterialEntity *) material {
    [self addMaterial:material amount:0];
}

- (void) deleteMaterial:(MaterialEntity *) material {
    if(material) {
        NSInteger index = 0;
        for(MaterialEntity * obj in _materialArray) {
            if([obj.inventoryId isEqualToNumber:material.inventoryId]) {
                [_materialArray removeObjectAtIndex:index];
                break;
            }
            index++;
        }
    }
}

- (void) deleteMaterialAtPosition:(NSInteger) position {
    if(position >= 0 && position < [_materialArray count]) {
        [_materialArray removeObjectAtIndex:position];
    }
    if (position >= 0 && position < [_amountArray count]) {
        [_amountArray removeObjectAtIndex:position];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (NSInteger) getSectionCount {
    NSInteger count = 5;    //仓库，仓库管理员，主管，领用人，物料
    
    return count;
}

- (InventoryDeliveryDirectTableSectionType) getSectionTypeBySection:(NSInteger) section {
    InventoryDeliveryDirectTableSectionType sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE;
            break;
        case 1:
            sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR;
            break;
        case 2:
            sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON;
            break;
        case 3:
            sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR;
            break;
        
            
        case 4:
            sectionType = INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL;
            break;
            
        default:
            break;
    }
    return sectionType;
}

#pragma mark - tabbleView datasource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self getSectionCount];
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE:
            count = 1;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR:
            count = 1;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR:
            count = 1;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON:
            count = 1;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            count = [_materialArray count];
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            if([_materialArray count] > 0) {
                height = _headerHeight;
            }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE:
            height = _captionHeight;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR:
            height = _captionHeight;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR:
            height = _captionHeight;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON:
            height = _captionHeight;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            height = [InventoryMaterialTableViewCell calculateHeight];
            break;
        default:
            break;
    }
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat paddingTop = 8;
    
    UILabel * headerLbl;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(padding, paddingTop, width-padding*2, _headerHeight-paddingTop)];
            [headerLbl setText: [[BaseBundle getInstance] getStringByKey:@"inventory_out_header_material" inTable:nil]];
            headerLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            [headerView addSubview:headerLbl];
            break;
        default:
            break;
    }
    
    return headerView;
}

#pragma mark - delegate
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSString *cellIdentifier = @"Cell";
    NSInteger section = indexPath.section;
    
    InventoryMaterialTableViewCell * materialCell;
    CaptionTextTableViewCell * captionCell;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE:
            cellIdentifier = @"CellWarehouse";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_out_header_warehouse" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
                [captionCell setDesc: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_amount" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:YES];
                [captionCell setShowOneLine:YES];
                
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR:
            cellIdentifier = @"CellAdministrator";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:YES];

                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR:
            cellIdentifier = @"CellSupervisor";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
            break;
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON:
            cellIdentifier = @"CellPerson";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!captionCell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_out_person" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_person_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:YES];
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
            break;
            
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            cellIdentifier = @"CellMaterial";
            materialCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!materialCell) {
                materialCell = [[InventoryMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [materialCell setType:INVENTORY_MATERIAL_OUT_CELL];
            }
            cell = materialCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    if(cell) {
        if ([cell isKindOfClass:[InventoryMaterialTableViewCell class]]) {
            InventoryMaterialTableViewCell *materialCell = (InventoryMaterialTableViewCell *)cell;
            MaterialEntity * material = _materialArray[position];
            NSNumber * tmpNumber;
            if(position < [_amountArray count]) {
                tmpNumber = _amountArray[position];
            }
            
            [materialCell setInfoWithMaterial:material amount:tmpNumber];
            if(position == [_materialArray count] - 1) {
                [materialCell setShowFullSeperator:YES];
            } else {
                [materialCell setShowFullSeperator:NO];
            }
        } else if([cell isKindOfClass:[CaptionTextTableViewCell class]]) {
            InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
            CaptionTextTableViewCell * captionCell = (CaptionTextTableViewCell *) cell;
            switch(sectionType) {
                case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE:
                    [captionCell setText:_warehouseName];
                    break;
                case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR:
                    [captionCell setText:_administrator];
                    break;
                case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR:
                    [captionCell setText:_supervisor];
                    break;
                case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON:
                    [captionCell setText:_receivingPerson];
                    break;
                default:
                    break;
            }
        }
    }
    
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL res = NO;
    NSInteger section = indexPath.section;
    
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            res = YES;
            break;
        default:
            break;
    }
    return res;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    NSMutableArray *rowAction = [NSMutableArray new];
    
    //删除
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSInteger materialPosition = indexPath.row;
        if(materialPosition >= 0 && materialPosition < [_materialArray count]) {
            MaterialEntity * material = _materialArray[materialPosition];
            NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:material, @"material", [NSNumber numberWithInteger:position], @"position", nil];
            [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_DELETE_MATERIAL data:data];
        }
    }];
    deleteAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
    
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            [rowAction addObject:deleteAction];
            break;
        default:
            break;
    }
    return rowAction;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSMutableDictionary * data;
    MaterialEntity * material;
    InventoryDeliveryDirectTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_MATERIAL:
            material = _materialArray[position];
            data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:material, @"material", [NSNumber numberWithInteger:position], @"position", nil];
            break;
        default:
            break;
    }
    
    if(data) {
        [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_SHOW_MATERIAL data:data];
    }
}

#pragma mark - 事件通知
- (void) notifyEvent:(InventoryDeliveryTableEventType) type data:(id) data {
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

#pragma mark - 点击事件
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[CaptionTextTableViewCell class]]) {
        NSInteger tag = view.tag;
        switch (tag) {
            case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_WAREHOUSE:
                [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_SELECT_WAREHOUSE data:nil];
                break;
            case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_ADMINISTRATOR:
                [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_SELECT_ADMINISTRATOR data:nil];
                break;
            case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_SUPERVISOR:
                [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_SELECT_SUPERVISOR data:nil];
                break;
            case INVENTORY_DELIVERY_DIRECT_SECTION_TYPE_RECEIVING_PERSON:
                [self notifyEvent:INVENTORY_DELIVERY_TABLE_EVENT_SELECT_RECEIVING_PERSON data:nil];
                break;
            default:
                break;
        }
    }
}

@end
