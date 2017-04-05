//
//  InventoryTransferTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 12/6/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryTransferTableHelper.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "CaptionTextField.h"
#import "InventoryMaterialTableViewCell.h"
#import "CaptionTextTableViewCell.h"

typedef NS_ENUM(NSInteger, InventoryTransferTableSectionType) {
    INVENTORY_TRANSFER_SECTION_TYPE_UNKNOW,
    INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC,      //原仓库管理员
    INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET,   //目标仓库管理员
    INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL,               //物料
};

@interface InventoryTransferTableHelper () <OnClickListener>

@property (readwrite, nonatomic, strong) NSMutableArray * materialArray;
@property (readwrite, nonatomic, strong) NSMutableArray * amountArray;  //数量数组

@property (readwrite, nonatomic, strong) NSString * srcAdministrator;   //原仓库管理员
@property (readwrite, nonatomic, strong) NSString * targetAdministrator;//目标仓库管理员

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat adminItemHeight;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation InventoryTransferTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
    }
    return self;
}

- (void) initSettings {
    _headerHeight = [FMSize getInstance].listHeaderHeight;
    _srcAdministrator = nil;
    _targetAdministrator = nil;
    _adminItemHeight = 92;
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
        NSNumber *tmpCount = [NSNumber numberWithFloat:0];
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

//设置源仓库管理员
- (void) setSrcAdministrator:(NSString *)srcAdministrator {
    _srcAdministrator = srcAdministrator;
}

//设置目标仓库管理员
- (void) setTargetAdministrator:(NSString *)targetAdministrator {
    _targetAdministrator = targetAdministrator;
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
    if(position >= 0 && position < [_amountArray count]) {
        [_amountArray removeObjectAtIndex:position];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (NSInteger) getSectionCount {
    NSInteger count = 0;
    if(_srcAdministrator) {
        count++;
    }
    if(_targetAdministrator) {
        count++;
    }
    if ([_materialArray count] > 0) {
        count++;
    }
    return count;
}

- (InventoryTransferTableSectionType) getSectionTypeBySection:(NSInteger) section {
    InventoryTransferTableSectionType sectionType = INVENTORY_TRANSFER_SECTION_TYPE_UNKNOW;
    if(!_srcAdministrator && section == 0) {
        section++;
    }
    if(!_targetAdministrator && section == 1) {
        section++;
    }
    switch(section) {
        case 0:
            sectionType = INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC;
            break;
        case 1:
            sectionType = INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET;
            break;
        case 2:
            sectionType = INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL;
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
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
            count = 1;
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
            count = 1;
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
            count = [_materialArray count];
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
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
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
            height = _adminItemHeight;
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
            height = _adminItemHeight;
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
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
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
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
    CaptionTextTableViewCell * srcCell;
    CaptionTextTableViewCell * targetCell;
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
            cellIdentifier = @"CellAdminSrc";
            srcCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!srcCell) {
                srcCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [srcCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_src" inTable:nil]];
                [srcCell setReadonly:YES];
                [srcCell setShowMark:YES];
                srcCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [srcCell setOnClickListener:self];
                
            }
            srcCell.tag = sectionType;
            cell = srcCell;
            break;
            
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
            cellIdentifier = @"CellAdminTarget";
            targetCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!targetCell) {
                targetCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [targetCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_target" inTable:nil]];
                [targetCell setReadonly:YES];
                [targetCell setShowMark:YES];
                targetCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [targetCell setOnClickListener:self];
            }
            targetCell.tag = sectionType;
            cell = targetCell;
            break;
            
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
            cellIdentifier = @"CellMaterial";
            materialCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!materialCell) {
                materialCell = [[InventoryMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [materialCell setType:INVENTORY_MATERIAL_MOVE_CELL];
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
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
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
            CaptionTextTableViewCell * textCell = (CaptionTextTableViewCell *) cell;
            switch(sectionType) {
                case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
                    [textCell setText:_srcAdministrator];
                    break;
                case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
                    [textCell setText:_targetAdministrator];
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
    
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
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
            [self notifyEvent:INVENTORY_TRANSFER_TABLE_EVENT_DELETE_MATERIAL data:data];
        }
    }];
    deleteAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
    
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
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
    
    NSLog(@"点击事件");
    
    NSMutableDictionary * data;
    MaterialEntity * material;
    InventoryTransferTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
            break;
        case INVENTORY_TRANSFER_SECTION_TYPE_MATERIAL:
            material = _materialArray[position];
            data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:material, @"material", [NSNumber numberWithInteger:position], @"position", nil];
            break;
        default:
            break;
    }
    
    if(data) {
        [self notifyEvent:INVENTORY_TRANSFER_TABLE_EVENT_SHOW_MATERIAL data:data];
    }
}

#pragma mark - 事件通知
- (void) notifyEvent:(InventoryTransferTableEventType) type data:(id) data {
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
        switch(tag) {
            case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_SRC:
                [self notifyEvent:INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_SRC data:nil];
                break;
            case INVENTORY_TRANSFER_SECTION_TYPE_ADMINISTRATOR_TARGET:
                [self notifyEvent:INVENTORY_TRANSFER_TABLE_EVENT_SELECT_ADMINISTRATOR_TARGET data:nil];
                break;
        }
    }
}

@end
