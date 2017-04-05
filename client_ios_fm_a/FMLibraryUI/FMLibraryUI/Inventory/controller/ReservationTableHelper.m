//
//  ReservationTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/14/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationTableHelper.h"
#import "FMUtilsPackages.h"
#import "CaptionTextField.h"
#import "BaseBundle.h"
#import "CaptionTextView.h"
#import "ReservationMaterialItemView.h"
#import "BaseLabelView.h"
#import "CostSumView.h"
#import "FMTheme.h"
#import "InventoryMaterialTableViewCell.h"
#import "MaterialEntity.h"



typedef NS_ENUM(NSInteger, ReservationSertionType) {
    RESERVATION_SECTION_TYPE_UNKNOW,
    RESERVATION_SECTION_TYPE_WAREHOUSE,     //仓库名称
    RESERVATION_SECTION_TYPE_ADMINISTRATOR, //仓库管理员
    RESERVATION_SECTION_TYPE_SUPERVISOR,    //主管
    RESERVATION_SECTION_TYPE_APPLICANT,     //预定人
    RESERVATION_SECTION_TYPE_DATE,          //预定时间
    RESERVATION_SECTION_TYPE_DESC,          //备注
    RESERVATION_SECTION_TYPE_MATERIAL       //物料
};

@interface ReservationTableHelper () <OnClickListener>

@property (readwrite, nonatomic, strong) NSMutableArray * materials;

@property (readwrite, nonatomic, strong) CaptionTextView * descTV;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat descHeight;
@property (readwrite, nonatomic, assign) CGFloat materialItemHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat sumItemHeight;

@property (readwrite, nonatomic, strong) NSString * warehouseName;
@property (readwrite, nonatomic, strong) NSString * administrator;
@property (readwrite, nonatomic, strong) NSString * supervisor;
@property (readwrite, nonatomic, strong) NSString * applicant;
@property (readwrite, nonatomic, strong) NSString * date;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation ReservationTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        _materials = [[NSMutableArray alloc] init];
        
        _defaultItemHeight = 92;
        _descHeight = 174;
        _materialItemHeight = 70;
        _headerHeight = 44;
        _sumItemHeight = 60;
    }
    return self;
}

- (NSMutableDictionary *) getMaterialByPosition:(NSInteger) position {
    NSMutableDictionary * material = _materials[position];
    return material;
}

- (void) setDataWithArray:(NSMutableArray *) materials {
    _materials = materials;
}

- (void) addMaterialsWithArray:(NSMutableArray *) materials {
    if(!_materials) {
        _materials = [[NSMutableArray alloc] init];
    }
    [_materials addObjectsFromArray:materials];
}


- (void) setWarehouseName:(NSString *) warehouseName {
    _warehouseName = warehouseName;
}

- (void) setApplicant:(NSString *) applicant {
    _applicant = applicant;
}

- (void) setAdministrator:(NSString *) administrator {
    _administrator = administrator;
}

- (void) setSupervisor:(NSString *) supervisor {
    _supervisor = supervisor;
}

- (void) setDate:(NSString *) date {
    _date = date;
}

- (NSString *) getDesc {
    NSString * res = [_descTV text];
    return res;
}

- (NSInteger) getMaterialsCount {
    return [_materials count];
}

- (NSString *) getTotalCost {
    double sum = 0;
    NSNumber * tmpNumber;
    for(NSDictionary * material in _materials) {
        tmpNumber = [material valueForKeyPath:@"reserveAmount"];
        double reserveAmount = tmpNumber.doubleValue;
        tmpNumber = [material valueForKeyPath:@"cost"];
        double cost = tmpNumber.doubleValue;
        sum += (cost * reserveAmount);
        
    }
//    NSString * strSum = [[NSString alloc] initWithFormat:@"%@%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], sum];
    NSString * strSum = [[NSString alloc] initWithFormat:@"%.2f", sum];
    return strSum;
}

- (NSInteger) getSectionCount {
    NSInteger count = 4;
    if([_materials count] > 0) {
        count++;
    }
    return count;
}

- (ReservationSertionType) getSectionTypeBySection:(NSInteger) section {
    ReservationSertionType type = RESERVATION_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            type = RESERVATION_SECTION_TYPE_WAREHOUSE;
            break;
        case 1:
            type = RESERVATION_SECTION_TYPE_ADMINISTRATOR;
            break;
        case 2:
            type = RESERVATION_SECTION_TYPE_SUPERVISOR;
            break;
        case 3:
            type = RESERVATION_SECTION_TYPE_APPLICANT;
            break;
            
//        case 2:
//            type = RESERVATION_SECTION_TYPE_DATE;
//            break;
//        case 3:
//            type = RESERVATION_SECTION_TYPE_DESC;
//            break;
        case 4:
            type = RESERVATION_SECTION_TYPE_MATERIAL;
            break;
    }
    return type;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self getSectionCount];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    ReservationSertionType type = [self getSectionTypeBySection:section];
    NSInteger count = 0;
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_SUPERVISOR:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_APPLICANT:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_DATE:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_DESC:
            count = 1;
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:
            count = [_materials count];
            if(count > 0) {
                count += 1; //花费和
            }
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ReservationSertionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
            itemHeight = _defaultItemHeight;
            break;
        case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
            itemHeight = _defaultItemHeight;
            break;
        case RESERVATION_SECTION_TYPE_SUPERVISOR:
            itemHeight = _defaultItemHeight;
            break;
        case RESERVATION_SECTION_TYPE_APPLICANT:
            itemHeight = _defaultItemHeight;
            break;
        case RESERVATION_SECTION_TYPE_DATE:
            itemHeight = _defaultItemHeight;
            break;
        case RESERVATION_SECTION_TYPE_DESC:
            itemHeight = _descHeight;
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:
            if(position >= 0 && position < [_materials count]) {
                itemHeight = [InventoryMaterialTableViewCell calculateHeight];
            } else {
                itemHeight = _sumItemHeight;
            }
            break;
        default:
            break;
    }
    return itemHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = 0;
    
    ReservationSertionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
        case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
        case RESERVATION_SECTION_TYPE_SUPERVISOR:
        case RESERVATION_SECTION_TYPE_APPLICANT:
        case RESERVATION_SECTION_TYPE_DATE:
        case RESERVATION_SECTION_TYPE_DESC:
            headerHeight = 0;
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:
            headerHeight = _headerHeight;
            break;
        default:
            break;
    }
    return headerHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = nil;
    ReservationSertionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
        case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
        case RESERVATION_SECTION_TYPE_SUPERVISOR:
        case RESERVATION_SECTION_TYPE_APPLICANT:
        case RESERVATION_SECTION_TYPE_DATE:
        case RESERVATION_SECTION_TYPE_DESC:
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:{
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _headerHeight)];
            headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.font = [FMFont fontWithSize:15];
            titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            titleLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_material" inTable:nil];;
            [titleLbl setFrame:CGRectMake(17, 7, 90, 37)];
            [headerView addSubview:titleLbl];
        }
            break;
            
        default:
            break;
    }
    
    return headerView;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *cellIdentifier = @"Cell";
    CaptionTextField * textItemView;
//    ReservationMaterialItemView * materialItemView = nil;
    InventoryMaterialTableViewCell * materialCell;
    CostSumView * materialSumItemView = nil;
    
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    UITableViewCell * cell;
    
    
    ReservationSertionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
            itemHeight = _defaultItemHeight;
            cellIdentifier = @"CellWarehouse";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[CaptionTextField class]]) {
                        textItemView = view;
                        break;
                    }
                }
            }
            if(cell && !textItemView) {
                textItemView = [[CaptionTextField alloc] init];
                [textItemView setEditable:NO];
                [textItemView setShowMark:YES];
                [textItemView setOnClickListener:self];
                [textItemView setShowOneLine:YES];
                [cell addSubview:textItemView];
            }
            if(textItemView) {
                [textItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                textItemView.tag = RESERVATION_SECTION_TYPE_WAREHOUSE;
                [textItemView setTitle:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name" inTable:nil]];
                [textItemView setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
                [textItemView setDesc: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_amount" inTable:nil]];
                [textItemView setText:_warehouseName];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case RESERVATION_SECTION_TYPE_APPLICANT:
            itemHeight = _defaultItemHeight;
            cellIdentifier = @"CellApplicant";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[CaptionTextField class]]) {
                        textItemView = view;
                        break;
                    }
                }
            }
            if(cell && !textItemView) {
                textItemView = [[CaptionTextField alloc] init];
                [textItemView setEditable:NO];
                [textItemView setShowMark:YES];
                [cell addSubview:textItemView];
            }
            if(textItemView) {
                textItemView.tag = RESERVATION_SECTION_TYPE_APPLICANT;
                [textItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [textItemView setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_person" inTable:nil]];
                [textItemView setText:_applicant];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
            itemHeight = _defaultItemHeight;
            cellIdentifier = @"CellApplicant";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[CaptionTextField class]]) {
                        textItemView = view;
                        break;
                    }
                }
            }
            if(cell && !textItemView) {
                textItemView = [[CaptionTextField alloc] init];
                [textItemView setEditable:NO];
                [textItemView setShowMark:YES];
                [textItemView setOnClickListener:self];
                [cell addSubview:textItemView];
            }
            if(textItemView) {
                textItemView.tag = RESERVATION_SECTION_TYPE_ADMINISTRATOR;
                [textItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [textItemView setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator" inTable:nil]];
                [textItemView setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_administrator_placeholder" inTable:nil]];
                [textItemView setText:_administrator];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case RESERVATION_SECTION_TYPE_SUPERVISOR:
            itemHeight = _defaultItemHeight;
            cellIdentifier = @"CellApplicant";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[CaptionTextField class]]) {
                        textItemView = view;
                        break;
                    }
                }
            }
            if(cell && !textItemView) {
                textItemView = [[CaptionTextField alloc] init];
                [textItemView setEditable:NO];
                [textItemView setShowMark:YES];
                [textItemView setOnClickListener:self];
                [cell addSubview:textItemView];
            }
            if(textItemView) {
                textItemView.tag = RESERVATION_SECTION_TYPE_SUPERVISOR;
                [textItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [textItemView setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_supervisor" inTable:nil]];
                [textItemView setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_supervisor_placeholder" inTable:nil]];
                [textItemView setText:_supervisor];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case RESERVATION_SECTION_TYPE_DATE:
            itemHeight = _defaultItemHeight;
            cellIdentifier = @"CellDate";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[CaptionTextField class]]) {
                        textItemView = view;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(cell && !textItemView) {
                textItemView = [[CaptionTextField alloc] init];
                [textItemView setEditable:NO];
                [textItemView setOnClickListener:self];
                [cell addSubview:textItemView];
            }
            if(textItemView) {
                textItemView.tag = RESERVATION_SECTION_TYPE_DATE;
                [textItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [textItemView setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_time" inTable:nil]];
                [textItemView setText:_date];
            }
            break;
        case RESERVATION_SECTION_TYPE_DESC:
            itemHeight = CGRectGetWidth(_descTV.frame);
            if(itemHeight == 0) {
                itemHeight = _descHeight;
            }
            cellIdentifier = @"CellDesc";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if(cell && !_descTV) {
                _descTV = [[CaptionTextView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [_descTV setTitle: [[BaseBundle getInstance] getStringByKey:@"inventory_reserve_desc" inTable:nil]];
                [_descTV setPlaceholder: [[BaseBundle getInstance] getStringByKey:@"requirement_req_desc_placeholder" inTable:nil]];
                [cell addSubview:_descTV];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:
            if(position < [_materials count]) {
                itemHeight = [InventoryMaterialTableViewCell calculateHeight];
                cellIdentifier = @"CellMaterial";
                materialCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!materialCell) {
                    materialCell = [[InventoryMaterialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    [materialCell setType:INVENTORY_MATERIAL_RESERVE_CELL];
                }
                cell = materialCell;
            } else {
                itemHeight = _sumItemHeight;
                cellIdentifier = @"CellMaterialSum";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[CostSumView class]]) {
                            materialSumItemView = (CostSumView *) view;
                            break;
                        }
                    }
                }
                if(cell && !materialSumItemView) {
                    materialSumItemView = [[CostSumView alloc] init];
                    [cell addSubview:materialSumItemView];
                }
                if(materialSumItemView) {
                    [materialSumItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [materialSumItemView setInfoWithCost:[self getTotalCost]];
                }
            }
            
            break;
        default:
            break;
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(cell) {
        NSInteger position = indexPath.row;
        if([cell isKindOfClass:[InventoryMaterialTableViewCell class]]) {
            InventoryMaterialTableViewCell * materialCell = (InventoryMaterialTableViewCell*)cell;
            NSDictionary * dic = _materials[position];
            NSNumber * reserveAmount = [dic valueForKeyPath:@"reserveAmount"];
//            NSNumber * cost = [dic valueForKeyPath:@"cost"];
            NSNumber * tmpNumber = [dic valueForKeyPath:@"realNumber"];
            MaterialEntity * material = [[MaterialEntity alloc] init];
            material.materialCode = [dic valueForKeyPath:@"code"];
            material.materialName = [dic valueForKeyPath:@"name"];
            material.materialBrand = [dic valueForKeyPath:@"brand"];
            material.materialModel = [dic valueForKeyPath:@"model"];
            material.materialUnit = [dic valueForKeyPath:@"unit"];
            material.realNumber = tmpNumber;
            [materialCell setInfoWithMaterial:material];
            [materialCell setInfoWithAmount:reserveAmount];
        }
    }
    
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    ReservationSertionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_SECTION_TYPE_WAREHOUSE:
        case RESERVATION_SECTION_TYPE_APPLICANT:
        case RESERVATION_SECTION_TYPE_DATE:
        case RESERVATION_SECTION_TYPE_DESC:
            break;
        case RESERVATION_SECTION_TYPE_MATERIAL:
            if(position >= 0 && position < [_materials count]) {
                [self notifyEditMaterial:position];
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    ReservationSertionType type = [self getSectionTypeBySection:section];
    if(type == RESERVATION_SECTION_TYPE_MATERIAL) {
        if(position >= 0 && position < [_materials count]) {
            return YES;
        }
    }
    return NO;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger position = indexPath.row;
        NSInteger section = indexPath.section;
        ReservationSertionType type = [self getSectionTypeBySection:section];
        if(type == RESERVATION_SECTION_TYPE_MATERIAL) {
            if(position >= 0 && position < [_materials count]) {
                [self notifyEvent:INVENTORY_RESERVATION_EVENT_DELETE_MATERIAL data:[NSNumber numberWithInteger:position]];
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
}


- (void) notifyEditMaterial:(NSInteger) position {
    [self notifyEvent:INVENTORY_RESERVATION_EVENT_EDIT_MATERIAL data:[NSNumber numberWithInteger:position]];
}

- (void) notifyEvent:(InventoryReservationEventType) type data:(id) data {
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


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}


#pragma mark --- 点击事件
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[CaptionTextField class]]) {
        ReservationSertionType type = view.tag;
        switch(type) {
            case RESERVATION_SECTION_TYPE_WAREHOUSE:
                [self notifyEvent:INVENTORY_RESERVATION_EVENT_SELECT_WAREHOUSE data:nil];
                break;
            case RESERVATION_SECTION_TYPE_ADMINISTRATOR:
                [self notifyEvent:INVENTORY_RESERVATION_EVENT_SELECT_ADMINISTRATOR data:nil];
                break;
            case RESERVATION_SECTION_TYPE_SUPERVISOR:
                [self notifyEvent:INVENTORY_RESERVATION_EVENT_SELECT_SUPERVISOR data:nil];
                break;
            case RESERVATION_SECTION_TYPE_DATE:
//                [self notifyEvent:INVENTORY_RESERVATION_EVENT_SELECT_DATE data:nil];
                break;
            default:
                break;
        }
    }
}


@end
