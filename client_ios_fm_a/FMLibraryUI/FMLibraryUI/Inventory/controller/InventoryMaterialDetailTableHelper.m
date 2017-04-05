//
//  InventoryMaterialDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "InventoryMaterialDetailTableHelper.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "InventoryMaterialBaseInfoTableViewCell.h"
#import "MarkedListHeaderView.h"
#import "InventoryDeliveryBatchTableViewCell.h"
#import "InventoryTransferWarehouseSelectView.h"
//#import "CaptionTextTableViewCell.h"
#import "OptionSelectTableViewCell.h"

typedef NS_ENUM(NSInteger, InventoryMaterialDetailSectionType) {
    INVENTORY_MATERIAL_DETAIL_SECTION_UNKNOW,
    INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL, //物料
    INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC,    //原仓库管理员
    INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET,    //目标仓库管理员
    INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON,    //领用人
    INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR,    //主管
    INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE, //仓库信息，移库时使用
    INVENTORY_MATERIAL_DETAIL_SECTION_BATCH,    //批次
};

@interface InventoryMaterialDetailTableHelper () <OnClickListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) InventoryTransferWarehouseSelectView * warehouseView;  //

@property (readwrite, nonatomic, strong) InventoryMaterialDetail * material;
@property (readwrite, nonatomic, strong) NSMutableArray * batchArray;

@property (readwrite, nonatomic, strong) NSMutableArray * amountArray;  //出库数量

@property (readwrite, nonatomic, assign) BOOL expand;   //物料信息是否展开

@property (readwrite, nonatomic, assign) InventoryMaterialTableViewType tableViewType;

@property (readwrite, nonatomic, assign) CGFloat captionHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, assign) CGFloat warehouseHeight;
@property (readwrite, nonatomic, assign) CGFloat handlerHeight;

@property (readwrite, nonatomic, strong) NSNumber * reservedAmount;//预定数量

@property (readwrite, nonatomic, assign) BOOL showTransfer; //显示移库信息
@property (readwrite, nonatomic, strong) NSString * srcName;//源仓库名
@property (readwrite, nonatomic, strong) NSString * targetName;//目标仓库名

@property (readwrite, nonatomic, strong) NSString * srcAdministrator;   //原仓库管理员
@property (readwrite, nonatomic, strong) NSString * targetAdministrator;//目标仓库管理员
@property (readwrite, nonatomic, strong) NSString * supervisor;         //主管
@property (readwrite, nonatomic, strong) NSString * receivingPerson;    //领用人

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation InventoryMaterialDetailTableHelper
- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
    }
    return self;
}

- (void) initSettings {
    _expand = NO;
    _headerHeight = [FMSize getInstance].listHeaderHeight;
    _footerHeight = [FMSize getInstance].listFooterHeight;
    _captionHeight = [OptionSelectTableViewCell getItemHeight];
    _warehouseHeight = 120;
    _handlerHeight = 50;
}

- (void) setInventoryMaterialTableViewType:(InventoryMaterialTableViewType) type {
    _tableViewType = type;
}

- (void) setInfoWithMaterialDetail:(InventoryMaterialDetail *) material {
    _material = material;
}

- (void) setInfoWithBatchArray:(NSMutableArray *) array {
    _batchArray = array;
    if(!_amountArray) {
        _amountArray = [[NSMutableArray alloc] init];
    }
    for(NSInteger index = 0; index<[array count];index++) {
        [_amountArray addObject:[NSNumber numberWithFloat:0]];
    }
}

- (void) addBatchArray:(NSMutableArray *) array {
    if(!_batchArray) {
        _batchArray = [[NSMutableArray alloc] init];
    }
    if(!_amountArray) {
        _amountArray = [[NSMutableArray alloc] init];
    }
    [_batchArray addObjectsFromArray:array];
    for(NSInteger index = 0; index<[array count];index++) {
        [_amountArray addObject:[NSNumber numberWithFloat:0]];
    }
}

//设置预定数量
- (void) setReservedAmount:(NSNumber *) amount {
    _reservedAmount = amount;
}

//设置源仓库名及目标仓库名
- (void) setSrcWarehouse:(NSString *) srcName targetWarehouse:(NSString *) targetName {
    _srcName = srcName;
    _targetName = targetName;
}

//设置源仓库管理员，及目标仓库管理员
- (void) setSrcAdministrator:(NSString *)srcAdministrator andTargetAdministrator:(NSString *)targetAdministrator {
    if (![FMUtils isStringEmpty:srcAdministrator]) {
        _srcAdministrator = srcAdministrator;
    }
    if (![FMUtils isStringEmpty:targetAdministrator]) {
        _targetAdministrator = targetAdministrator;
    }
}

//设置主管及领用人
- (void) setSupervisor:(NSString *)supervisor {
    _supervisor = supervisor;
}

- (void) setReceivingPerson:(NSString *)receivingPerson {
    _receivingPerson = receivingPerson;
}

//设置批次的出库数量
- (void) setAmount:(NSNumber *) amount forBatch:(NSNumber *) batchId {
    NSInteger index = 0;
    NSInteger count = [_batchArray count];
    for(index = 0; index < count; index++) {
        InventoryMaterialDetailBatchEntity * batch = _batchArray[index];
        if([batch.batchId isEqualToNumber:batchId]) {
            _amountArray[index] = amount;
            break;
        }
    }
}

//设定消息监听者
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

//获取出库数量
- (NSNumber *) getDeliveryAmount {
    NSNumber * amount = 0;
    NSInteger index = 0;
    double sum = 0;
    NSInteger count = [_amountArray count];
    for(; index < count; index++) {
        NSNumber * tmpNumber = _amountArray[index];
        sum += tmpNumber.doubleValue;
    }
    amount = [NSNumber numberWithDouble:sum];
    return amount;
}

//显示仓库
- (BOOL) needShowWarehouse {
    BOOL res = NO;
    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE) {
        res = YES;
    }
    return res;
}

//在二维码扫描情况下移库显示原仓库管理员
- (BOOL) needShowAdministratorSrc {
    BOOL res = NO;
    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE) {        //二维码移库情况下
        res = YES;
    } else if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {  //二维码出库情况下
        res = YES;
    }
    return res;
}

//在二维码扫描情况下移库显示目标仓库管理员
- (BOOL) needShowAdministratorTarget {
    BOOL res = NO;
    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE) {
        res = YES;
    }
    return res;
}

//是否显示主管
- (BOOL) needShowSupervisor {
    BOOL res = NO;
    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {
        res = YES;
    }
    return res;
}

//是否显示领用人
- (BOOL) needShowReceivingPerson {
    BOOL res = NO;
    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {
        res = YES;
    }
    return res;
}



#pragma mark - datasource
- (NSInteger) getSectionCount {
    NSInteger count = 2;    //基本信息，物资记录
    
    if([self needShowAdministratorSrc]) {   //源仓库管理员
        count += 1;
    }
    
    if([self needShowAdministratorTarget]) {  //目标仓库管理员
        count += 1;
    }
    
    if([self needShowSupervisor]) {    //主管
        count += 1;
    }
    
    if([self needShowReceivingPerson]) {  //显示领用人
        count += 1;
    }
    
    if([self needShowWarehouse]) { //显示移库
        count += 1;
    }
    
    return count;
}

- (InventoryMaterialDetailSectionType) getSectionTypeBySection:(NSInteger) section {
    InventoryMaterialDetailSectionType sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_UNKNOW;
    if(![self needShowAdministratorSrc] && section >= 1) {
        section++;
    }
    if(![self needShowAdministratorTarget] && section >= 2) {
        section++;
    }
    if(![self needShowSupervisor] && section >= 3) {
        section++;
    }
    if(![self needShowReceivingPerson] && section >= 4) {
        section++;
    }
    if(![self needShowWarehouse] && section >= 5) {
        section++;
    }
    
    switch(section) {
        case 0:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL;
            break;
        case 1:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC;
            break;
        case 2:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET;
            break;
        case 3:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON;
            break;
        case 4:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR;
            break;
        case 5:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE;
            break;
        case 6:
            sectionType = INVENTORY_MATERIAL_DETAIL_SECTION_BATCH;
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
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
            count = 1 + 1;  //footer + 1
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            if([self needShowAdministratorTarget] || [self needShowReceivingPerson] || [self needShowSupervisor]) {
                count = 0;
            } else {
                count = 1;  //footer
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            if([self needShowReceivingPerson] || [self needShowSupervisor]) {
                count = 0;
            } else {
                count = 1;  //footer
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            if([self needShowSupervisor]) {
                count = 0;
            } else {
                count = 1;  //footer
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            count = 1;  //footer
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE:
            count = 1;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            count = [_batchArray count] + 1;  //footer + 1
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
            height = _headerHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            height = _headerHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            height = _headerHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            height = _headerHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            height = _headerHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE:
            height = 0;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            height = _headerHeight;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    BOOL isFooter = NO;
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
            if(position == 0) {
                height = [InventoryMaterialBaseInfoTableViewCell getItemHeightByExpand:_expand description:_material.desc photoCount:0 attachmentCount:0];
            } else {
                isFooter = YES;
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            isFooter = YES;
            break;
            
        case INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE:
            height = _warehouseHeight;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            if(position >= 0 && position < [_batchArray count]) {
                height = [InventoryDeliveryBatchTableViewCell calculateHeight];
            } else {
                isFooter = YES;
            }
            break;
        default:
            break;
    }
    if(isFooter) {
        height = _footerHeight;
    }
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    MarkedListHeaderView *headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
    CGFloat padding = 15;
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    NSString *strAmount = [[NSString alloc] initWithFormat:@"%0.2f", [self getDeliveryAmount].doubleValue];
    UIColor *labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
    UIFont *labelFont = [FMFont getInstance].defaultFontLevel2;
    UIFont *contentFont = [FMFont fontWithSize:15];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
            if(_reservedAmount > 0) {
                NSString * strDesc = [[NSString alloc] initWithFormat:@"%0.2f", _reservedAmount.doubleValue];
                [headerView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_header_material" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_LABEL];
                [headerView setDescLabelColor:labelColor contentColor:contentColor];
                [headerView setDescLabelFont:labelFont contentFont:contentFont];
                [headerView setDescLabel: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_header_reserved_amount" inTable:nil] content:strDesc];
            } else {
                [headerView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_header_material" inTable:nil] desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            }
            if(_expand) {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_up"]];
            } else {
                [headerView setRightImage:[[FMTheme getInstance] getImageByName:@"patrol_arrow_down"]];
            }
            [headerView setRightImgWidth:[FMSize getInstance].imgWidthLevel3];
            [headerView setOnClickListener:self];
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator" inTable:nil] desc:_srcAdministrator andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            } else if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE){
                [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_src" inTable:nil] desc:_srcAdministrator andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            }
            [headerView setDescLabelColor:labelColor contentColor:contentColor];
            [headerView setDescLabelFont:labelFont contentFont:contentFont];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            if([self needShowAdministratorTarget] || [self needShowReceivingPerson] || [self needShowSupervisor]) {
                [headerView setShowBottomBorder:YES withPaddingLeft:padding paddingRight:padding];
                [headerView setBottomBorderDotted:YES];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_target" inTable:nil] desc:_targetAdministrator andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescLabelColor:labelColor contentColor:contentColor];
            [headerView setDescLabelFont:labelFont contentFont:contentFont];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            if([self needShowAdministratorSrc]) {
                [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
            }
            if([self needShowReceivingPerson] || [self needShowSupervisor]) {
                [headerView setShowBottomBorder:YES withPaddingLeft:padding paddingRight:padding];
                [headerView setBottomBorderDotted:YES];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"inventory_out_person" inTable:nil] desc:_receivingPerson andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescLabelColor:labelColor contentColor:contentColor];
            [headerView setDescLabelFont:labelFont contentFont:contentFont];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            if([self needShowAdministratorTarget] || [self needShowAdministratorSrc]) {
                [headerView setShowTopBorder:NO withPaddingLeft:padding paddingRight:padding];
            }
            if([self needShowSupervisor]) {
                [headerView setShowBottomBorder:YES withPaddingLeft:padding paddingRight:padding];
                [headerView setBottomBorderDotted:YES];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            [headerView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor" inTable:nil] desc:_supervisor andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_ONLY];
            [headerView setDescLabelColor:labelColor contentColor:contentColor];
            [headerView setDescLabelFont:labelFont contentFont:contentFont];
            [headerView setShowMore:YES];
            [headerView setOnClickListener:self];
            if([self needShowAdministratorTarget] || [self needShowAdministratorSrc] || [self needShowReceivingPerson]) {
                [headerView setShowTopBorder:NO withPaddingLeft:padding paddingRight:padding];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE:
            headerView = nil;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_RESERVATION) {
                [headerView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_header_batch" inTable:nil] desc:strAmount andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_LABEL];
                [headerView setDescLabel: [[BaseBundle getInstance] getStringByKey:@"inventory_out_detail_header_batch_amount" inTable:nil] content:strAmount];
            } else if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE) {
                [headerView setInfoWithName: [[BaseBundle getInstance] getStringByKey:@"inventory_shift_detail_header_batch" inTable:nil] desc:strAmount andDescStyle:LIST_HEADER_DESC_STYLE_TEXT_LABEL];
                [headerView setDescLabel: [[BaseBundle getInstance] getStringByKey:@"inventory_shift_detail_header_batch_amount" inTable:nil] content:strAmount];
            }
            [headerView setDescLabelColor:labelColor contentColor:contentColor];
            [headerView setDescLabelFont:labelFont contentFont:contentFont];
            break;
            
        default:
            break;
    }
    headerView.tag = sectionType;
    return headerView;
}

#pragma mark - delegate
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    NSString *cellIdentifier = @"Cell";
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    BOOL isFooter = NO;
    
    InventoryMaterialBaseInfoTableViewCell * materialCell;
    InventoryDeliveryBatchTableViewCell * batchCell;
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
            if(position == 0) {
                cellIdentifier = @"CellMaterial";
                materialCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!materialCell) {
                    materialCell = [[InventoryMaterialBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    materialCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell = materialCell;
            } else {
                isFooter = YES;
            }
            
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            isFooter = YES;
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_WAREHOUSE:
            cellIdentifier = @"CellWarehouse";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(_warehouseView) {
                    [cell addSubview:_warehouseView];
                }
            }
            if(!_warehouseView) {
                _warehouseView = [[InventoryTransferWarehouseSelectView alloc] init];
                _warehouseView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
                [_warehouseView setShowBottomSeperator:NO];
                [_warehouseView setOnItemClickListener:self];
                [cell addSubview:_warehouseView];
            }
            if(_warehouseView) {
                CGFloat width = CGRectGetWidth(tableView.frame);
                [_warehouseView setFrame:CGRectMake(0, 0, width, _warehouseHeight)];
                [_warehouseView setInfoWithSrcWarehouse:_srcName targetWarehouse:_targetName];
            }
            
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            if(position >= 0 && position < [_batchArray count]) {
                cellIdentifier = @"CellBatch";
                batchCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!batchCell) {
                    batchCell = [[InventoryDeliveryBatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                cell = batchCell;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    if (cell) {
        if([cell isKindOfClass:[InventoryMaterialBaseInfoTableViewCell class]]) {
            InventoryMaterialBaseInfoTableViewCell *materialCell = (InventoryMaterialBaseInfoTableViewCell *)cell;
            materialCell.showPhotos = NO;
            materialCell.showAttachments = NO;
            materialCell.isExpand = _expand;
            [materialCell setMaterialDetail:_material];
        } else if([cell isKindOfClass:[InventoryDeliveryBatchTableViewCell class]]) {
            InventoryDeliveryBatchTableViewCell *batchCell = (InventoryDeliveryBatchTableViewCell *)cell;
            if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {
                [batchCell setAmountType:INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_DELIVERY];
            } else if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE) {
                [batchCell setAmountType:INVENTORTY_BATCH_TABLE_VIEW_CELL_TYPE_SHIFT];
            }
            
            InventoryMaterialDetailBatchEntity *batch = _batchArray[position];
            NSNumber *tmpNumber = _amountArray[position];
            
            [batchCell setInfoWithBatch:batch outNumber:tmpNumber];
            
            if(position < [_batchArray count] - 1) {
                [batchCell setShowFullSeperator:NO];
            } else {
                [batchCell setShowFullSeperator:YES];
            }
        } else if ([cell isKindOfClass:[OptionSelectTableViewCell class]]) {
            InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
            OptionSelectTableViewCell *captionCell = (OptionSelectTableViewCell *)cell;
            switch(sectionType) {
                case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
                    if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_DELIVERY_QRCODE) {
                        [captionCell setPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator_placeholder" inTable:nil]];
                    } else if (_tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_NORMAL || _tableViewType == INVENTORY_MATERIAL_DETAIL_TABLE_VIEW_TYPE_SHIFT_QRCODE){
                        [captionCell setPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_src_placeholder" inTable:nil]];
                    }
                    [captionCell setContent:_srcAdministrator];
                    
                    break;
                case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
                    [captionCell setPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"inventory_transfer_administrator_target_placeHolder" inTable:nil]];
                    [captionCell setContent:_targetAdministrator];
                    break;
                case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
                    [captionCell setPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_person_placeholder" inTable:nil]];
                    [captionCell setContent:_receivingPerson];
                    break;
                case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
                    [captionCell setPlaceHolder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor_placeholder" inTable:nil]];
                    [captionCell setContent:_supervisor];
                    break;
                default:
                    break;
            }
        }
    }
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSMutableDictionary * data;
    InventoryMaterialDetailBatchEntity * batch;
    InventoryMaterialDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case INVENTORY_MATERIAL_DETAIL_SECTION_BATCH:
            if(position >= 0 && position < [_batchArray count]) {
                batch = _batchArray[position];
                data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:batch, @"batch", [NSNumber numberWithInteger:position], @"position", nil];
            }
            
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
            if (position == 0) {
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_SRC data:nil];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
            if (position == 0) {
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_TARGET data:nil];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
            if (position == 0) {
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_RECIVING_PERSON data:nil];
            }
            break;
        case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
            if (position == 0) {
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_SUPERVISOR data:nil];
            }
            break;
        default:
            break;
    }
    
    if(data) {
        [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_EDIT_AMOUNT data:data];
    }
}

#pragma mark - 点击列表头
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[MarkedListHeaderView class]]) {
        InventoryMaterialDetailSectionType sectionType = view.tag;
        switch (sectionType) {
            case INVENTORY_MATERIAL_DETAIL_SECTION_MATERIAL:
                _expand = !_expand;
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_NEED_UPDATE data:nil];
                break;
            case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_SRC:
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_SRC data:nil];
                break;
            case INVENTORY_MATERIAL_DETAIL_SECTION_ADMINISTRATOR_TARGET:
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_ADMINISTRATOR_TARGET data:nil];
                break;
            case INVENTORY_MATERIAL_DETAIL_SECTION_RECEIVING_PERSON:
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_RECIVING_PERSON data:nil];
                break;
            case INVENTORY_MATERIAL_DETAIL_SECTION_SUPERVISOR:
                [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_SUPERVISOR data:nil];
                break;
            default:
                break;
        }
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _warehouseView) {
        InventoryTransferWarehouseSelectType type = subView.tag;
        if(type == INVENTORY_TRANSFER_WAREHOUSE_SELECT_TARGET) {
            [self notifyEvent:INVENTORY_MATERIAL_DETAIL_EVENT_SELECT_WAREHOUSE_TARGET data:nil];
        }
    }
}

#pragma mark - 事件通知
- (void) notifyEvent:(InventoryMaterialDetailEventType) type data:(id) data {
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
