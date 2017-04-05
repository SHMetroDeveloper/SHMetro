//
//  ReservationDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/18/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationDetailTableHelper.h"
#import "MarkedListHeaderView.h"
#import "ReservationDetailBaseView.h"
#import "ReservationDetailMaterialView.h"
#import "BaseItemView.h"
#import "BaseBundle.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "CostSumView.h"
#import "SimpleListHeaderView.h"
#import "CaptionTextTableViewCell.h"

typedef NS_ENUM(NSInteger, ReservationDetailSectionType) {
    RESERVATION_DETAIL_SECTION_UNKNOW,
    RESERVATION_DETAIL_SECTION_BASE,        //基本信息
    RESERVATION_DETAIL_SECTION_ADMINISTRATOR,  //仓库管理员
    RESERVATION_DETAIL_SECTION_RESERVEPERSON,  //预定人
    RESERVATION_DETAIL_SECTION_SUPERVISOR,  //主管
    RESERVATION_DETAIL_SECTION_RECEIVING_PERSON,  //领用人
    RESERVATION_DETAIL_SECTION_MATERIAL,  //物料
    RESERVATION_DETAIL_SECTION_COST,    //费用
    
    RESERVATION_DETAIL_SECTION_ORDER,       //关联工单
};

@interface ReservationDetailTableHelper ()<OnClickListener>

@property (readwrite, nonatomic, strong) ReservationDetailEntity * entity;

@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat orderItemHeight;
@property (readwrite, nonatomic, assign) CGFloat costItemHeight;    //费用
@property (readwrite, nonatomic, assign) CGFloat captionHeight;  //填空高度

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, strong) NSString * receivingPerson;     //领用人

@property (readwrite, nonatomic, strong) NSMutableArray *amountArray;   //实领数量
@property (readwrite, nonatomic, strong) NSString *realCost;  //实际价格

@property (readwrite, nonatomic, assign) InventoryReservationDetailType reservationType;    //预定类型

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation ReservationDetailTableHelper


- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSetting];
    }
    return self;
}

- (void) initSetting {
    _defaultItemHeight = 170;
    _orderItemHeight = 50;
    _headerHeight = 44;
    _footerHeight = 0;
    _costItemHeight = 60;
    _captionHeight = 92;
    _reservationType = INVENTORY_RESERVATION_DETAIL_TYPE_RESERVE;   //默认为预定类型
}


//设置类型
- (void) setReservationType:(InventoryReservationDetailType) type {
    _reservationType = type;
}

//设置预订人
- (void) setInfoWithReservePerson:(NSString *)reservePerson {
    _entity.reservationPersonName = reservePerson;
}

//设置仓库管理员
- (void) setInfoWithAdministrator:(NSString *)administrator {
    _entity.administratorName = administrator;
}

//设置主管
- (void) setInfoWithSupervisor:(NSString *)supervisor {
    _entity.supervisorName = supervisor;
}

//设置领用人
- (void) setInfoWithReceivingPerson:(NSString *)person {
    _receivingPerson = person;
}

- (void) setInfoWith:(ReservationDetailEntity *) entity {
    _entity = entity;
    if(_entity && [_entity.materials count] > 0) {
        if(!_amountArray) {
            _amountArray = [[NSMutableArray alloc] init];
        } else {
            [_amountArray removeAllObjects];
        }
        for(NSInteger index = 0; index<[_entity.materials count];index++) {
            [_amountArray addObject:[NSNumber numberWithFloat:0]];
        }
    }
}

- (void) setAmount:(NSNumber *) amount forMaterialAtPosition:(NSInteger) position {
    if(position >= 0 && position < [_entity.materials count] && position < [_amountArray count]) {
        _amountArray[position] = amount;
    }
}

- (void) setRealCost:(NSString *)cost {
    _realCost = cost;
}

- (NSNumber *) getOrderIdByPosition:(NSInteger) position {
    NSNumber * woId = nil;
    if(position == 0 && _entity) {
        woId = _entity.woId;
    }
    return woId;
}

//获取实领物料总价
- (NSString *) getCostSumDescription {
    NSString * res = @"";
    double sum = 0;
    if(_entity && _entity.materials) {
        for(ReservationMaterial * material in _entity.materials) {
            if(_reservationType == INVENTORY_RESERVATION_DETAIL_TYPE_DELIVERY) {
//                sum += material.cost.floatValue * material.receiveAmount;   //待出库的计算领用金额
                sum = _realCost.floatValue;
            } else {
                sum += material.cost.doubleValue * material.bookAmount.doubleValue;  //其余算预定金额
            }
        }
        if(sum > 0) {
            res = [[NSString alloc] initWithFormat:@"%.2f", sum];
        } else {
            res = @"0";
        }
    }
    
    return res;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

//是否要展示领用人
- (BOOL) needShowReceivingPerson {
    BOOL res = NO;
    if(_reservationType == INVENTORY_RESERVATION_DETAIL_TYPE_DELIVERY) {
        res = YES;
    }
    return res;
}

- (NSInteger) getSectionCount {
    NSInteger count = 4;    //基本信息，仓库管理员，预定人，主管
    if([self needShowReceivingPerson]) {
        count += 1; //领用人
    }
    
    if(_entity && [_entity.materials count] > 0) {  //如果有物料也需要展示总费用
        count += 2;
    }
    if(_entity.woId) {  //工单
        count += 1;
    }
    
    return count;
}

- (ReservationDetailSectionType) getSectionTypeBySection:(NSInteger) section {
    ReservationDetailSectionType type = RESERVATION_DETAIL_SECTION_UNKNOW;
    
    if(section >= 4 && ![self needShowReceivingPerson]) {
        section += 1;
    }
    
    if (section >= 5 && [_entity.materials count] == 0) {    //如果没有物料，则忽略
        section += 2;
    }
    
    switch(section) {
        case 0:
            type = RESERVATION_DETAIL_SECTION_BASE;
            break;
        case 1:
            type = RESERVATION_DETAIL_SECTION_ADMINISTRATOR;
            break;
        case 2:
            type = RESERVATION_DETAIL_SECTION_RESERVEPERSON;
            break;
        case 3:
            type = RESERVATION_DETAIL_SECTION_SUPERVISOR;
            break;
        case 4:
            type = RESERVATION_DETAIL_SECTION_RECEIVING_PERSON;
            break;
        case 5:
            type = RESERVATION_DETAIL_SECTION_MATERIAL;
            break;
        case 6:
            type = RESERVATION_DETAIL_SECTION_COST;
            break;
        case 7:
            type = RESERVATION_DETAIL_SECTION_ORDER;
            break;
    }
    return type;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self getSectionCount];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    ReservationDetailSectionType type = [self getSectionTypeBySection:section];
    NSInteger count = 0;
    switch(type) {
        case RESERVATION_DETAIL_SECTION_BASE:
            count = 1 + 1;
            break;

        case RESERVATION_DETAIL_SECTION_ADMINISTRATOR:
            count = 1;
            break;
        case RESERVATION_DETAIL_SECTION_RESERVEPERSON:
            count = 1;
            break;
        case RESERVATION_DETAIL_SECTION_SUPERVISOR:
            count = 1;
            break;
        case RESERVATION_DETAIL_SECTION_RECEIVING_PERSON:
            count = 1;
            break;
            
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            count = [_entity.materials count];
            break;
        case RESERVATION_DETAIL_SECTION_COST:
            count = 1+1;
            break;
            

            
        case RESERVATION_DETAIL_SECTION_ORDER:
            if(_entity.woId) {
                count = 1 + 1;
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
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    BOOL isFooter = NO;
    ReservationDetailSectionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_DETAIL_SECTION_BASE:
            if(position == 0) {
                itemHeight = [ReservationDetailBaseView calculateHeightByDesc:_entity.reservationNote width:width];
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            if(position >= 0 && position < [_entity.materials count]) {
                itemHeight = [ReservationDetailMaterialView calculateHeight];
            }
            break;
        case RESERVATION_DETAIL_SECTION_COST:
            if(position == 0) {
                itemHeight = _costItemHeight;
            } else {
                isFooter = YES;
            }
            break;
            
        case RESERVATION_DETAIL_SECTION_RESERVEPERSON:
            itemHeight = _captionHeight;
            break;
        case RESERVATION_DETAIL_SECTION_ADMINISTRATOR:
            itemHeight = _captionHeight;
            break;
        case RESERVATION_DETAIL_SECTION_SUPERVISOR:
            itemHeight = _captionHeight;
            break;
        case RESERVATION_DETAIL_SECTION_RECEIVING_PERSON:
            itemHeight = _captionHeight;
            break;
            
        case RESERVATION_DETAIL_SECTION_ORDER:
            if(position == 0) {
                itemHeight = _orderItemHeight;
            }
            break;
        
        default:
            break;
    }
    
    return itemHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = 0;
    ReservationDetailSectionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_DETAIL_SECTION_BASE:
            headerHeight = _headerHeight;
            break;
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            headerHeight = _headerHeight;
            break;
        case RESERVATION_DETAIL_SECTION_COST:
            break;
        case RESERVATION_DETAIL_SECTION_ORDER:
            headerHeight = _headerHeight;
            break;
            
        default:
            break;
    }
    return headerHeight;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    SimpleListHeaderView *headerView = [[SimpleListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    [headerView setTitleFont:[FMFont fontWithSize:15]];
    [headerView setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    ReservationDetailSectionType type = [self getSectionTypeBySection:section];
    switch(type) {
        case RESERVATION_DETAIL_SECTION_BASE:
            [headerView setShowTopLine:NO showBottomLine:NO];
            [headerView setInfoWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_base" inTable:nil]];
            break;
            
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            [headerView setShowTopLine:NO showBottomLine:NO];
            [headerView setInfoWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_material" inTable:nil]];
            break;
            
        case RESERVATION_DETAIL_SECTION_ORDER:
            [headerView setShowTopLine:NO showBottomLine:NO];
            [headerView setInfoWithText: [[BaseBundle getInstance] getStringByKey:@"inventory_detail_order" inTable:nil]];
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
    ReservationDetailBaseView * baseItemView;
    ReservationDetailMaterialView * materialItemView = nil;
    BaseItemView *orderItemView = nil;
    CostSumView *costItemView = nil;
    SeperatorView *seperator;
    CaptionTextTableViewCell *captionCell;
    
    
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    UITableViewCell * cell;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;

    
    BOOL isFooter = NO;
    ReservationDetailSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case RESERVATION_DETAIL_SECTION_BASE:
            if(position == 0) {
                itemHeight = [ReservationDetailBaseView calculateHeightByDesc:_entity.reservationNote width:width];
                cellIdentifier = @"CellBase";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[ReservationDetailBaseView class]]) {
                            baseItemView = view;
                            break;
                        }
                    }
                }
                if(cell && !baseItemView) {
                    baseItemView = [[ReservationDetailBaseView alloc] init];
                    [cell addSubview:baseItemView];
                }
                if(baseItemView) {
                    NSString * strDate = @"";
                    if(_entity && ![FMUtils isNumberNullOrZero:_entity.reservationDate]) {
                        NSDate * date = [FMUtils timeLongToDate:_entity.reservationDate];
                        strDate = [FMUtils getDayStr:date];
                    }
                    [baseItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [baseItemView setInfoWithCode:_entity.reservationCode warehouse:_entity.warehouseName date:strDate orderCode:_entity.woCode desc:_entity.reservationNote status:_entity.status];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                isFooter = YES;
            }
            
            break;
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            if(position >= 0 && position < [_entity.materials count]) {
                itemHeight = [ReservationDetailMaterialView calculateHeight];
                cellIdentifier = @"CellMaterial";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[ReservationDetailMaterialView class]]) {
                            materialItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = view;
                        }
                    }
                }
                if(cell && !materialItemView) {
                    materialItemView = [[ReservationDetailMaterialView alloc] init];
                    if(_reservationType == INVENTORY_RESERVATION_DETAIL_TYPE_DELIVERY) {
                        [materialItemView setShowReceiveAmount:YES];
                        [materialItemView setShowPirce:NO];
                    } else {
                        [materialItemView setShowReceiveAmount:NO];
                        [materialItemView setShowPirce:YES];
                    }
                    [cell addSubview:materialItemView];
                }
                
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_entity.materials count]) {
                        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
                    }
                }
                if(materialItemView) {
                    materialItemView.tag = position;
                    ReservationMaterial * material = _entity.materials[position];
                    NSNumber * tmpNumber = _amountArray[position];
                    material.receiveAmount = tmpNumber;
                    [materialItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [materialItemView setInfoWithMaterial:material];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                isFooter = YES;
            }
            
            break;
        case RESERVATION_DETAIL_SECTION_COST:
            if(position == 0) {
                itemHeight = _costItemHeight;
                cellIdentifier = @"CellCostSum";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[CostSumView class]]) {
                            costItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = view;
                        }
                    }
                }
                if(cell && !costItemView) {
                    costItemView = [[CostSumView alloc] init];
                    [cell addSubview:costItemView];
                }
                
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    
                }
                if(costItemView) {
                    costItemView.tag = position;
                    [costItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [costItemView setInfoWithCost:[self getCostSumDescription]];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                isFooter = YES;
            }
            break;
            
        case RESERVATION_DETAIL_SECTION_RESERVEPERSON:{
            cellIdentifier = @"CellReservation";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_reservation_person" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_reservation_person_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:NO];
                
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
        }
            break;
        case RESERVATION_DETAIL_SECTION_ADMINISTRATOR:{
            cellIdentifier = @"CellAdministrator";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_administrator_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:NO];
                
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
        }
            break;
        case RESERVATION_DETAIL_SECTION_SUPERVISOR:{
            cellIdentifier = @"CellSupervisor";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                captionCell = [[CaptionTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [captionCell setTitle:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor" inTable:nil]];
                [captionCell setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"inventory_out_supervisor_placeholder" inTable:nil]];
                [captionCell setReadonly:YES];
                [captionCell setShowMark:NO];
                
                captionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [captionCell setOnClickListener:self];
            }
            captionCell.tag = sectionType;
            cell = captionCell;
        }
            break;
        case RESERVATION_DETAIL_SECTION_RECEIVING_PERSON:
            cellIdentifier = @"CellReceivingPerson";
            captionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
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
            
        case RESERVATION_DETAIL_SECTION_ORDER:
            if(position == 0) {
                itemHeight = _orderItemHeight;
                cellIdentifier = @"CellOrder";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[BaseItemView class]]) {
                            orderItemView = (BaseItemView *)view;
                            break;
                        } else if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;
                        }
                    }
                }
                if(cell && !orderItemView) {
                    orderItemView = [[BaseItemView alloc] init];
                    [orderItemView setShowMore:YES];
                    [orderItemView setPaddingLeft:paddingLeft];
                    [orderItemView setPaddingRight:paddingLeft];
                    [orderItemView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
                    [orderItemView addTarget:self action:@selector(OnOrderItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:orderItemView];
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(orderItemView) {
                    orderItemView.tag = position;
                    [orderItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [orderItemView setInfoWithName:_entity.woCode];
                }
                if (seperator) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                }
            } else {
                isFooter = YES;
            }
            break;
        
            
        default:
            break;
    }
    if(isFooter) {
        SeperatorView * footerItemView;
        itemHeight = _footerHeight;
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        } else {
            NSArray * subViews = [cell subviews];
            for(id view in subViews) {
                if([view isKindOfClass:[SeperatorView class]]) {
                    footerItemView = view;
                    break;
                }
            }
        }
        if(cell && !footerItemView) {
            footerItemView = [[SeperatorView alloc] init];
            [footerItemView setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND]];
            [cell addSubview:footerItemView];
        }
        if(footerItemView) {
            [footerItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (cell) {
        if([cell isKindOfClass:[CaptionTextTableViewCell class]]) {
            ReservationDetailSectionType sectionType = [self getSectionTypeBySection:section];
            CaptionTextTableViewCell *captionCell = (CaptionTextTableViewCell *)cell;
            switch (sectionType) {
                case RESERVATION_DETAIL_SECTION_RESERVEPERSON:
                    [captionCell setText:_entity.reservationPersonName];
                    break;
                    
                case RESERVATION_DETAIL_SECTION_ADMINISTRATOR:
                    [captionCell setText:_entity.administratorName];
                    break;
                    
                case RESERVATION_DETAIL_SECTION_SUPERVISOR:
                    [captionCell setText:_entity.supervisorName];
                    break;
                    
                case RESERVATION_DETAIL_SECTION_RECEIVING_PERSON:
                    [captionCell setText:_receivingPerson];
                    break;
                    
            }
        }
    }
}


#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    ReservationDetailSectionType type = [self getSectionTypeBySection:section];
    NSMutableDictionary * data;
    ReservationMaterial * material;
    switch(type) {
        case RESERVATION_DETAIL_SECTION_BASE:
            break;
        case RESERVATION_DETAIL_SECTION_MATERIAL:
            data = [[NSMutableDictionary alloc] init];
            if(position >= 0 && position < [_entity.materials count]) {
                material = _entity.materials[position];
                [data setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
                [data setValue:material forKeyPath:@"material"];
                [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_MATERIAL data:data];
            }
            
            break;
        case RESERVATION_DETAIL_SECTION_ORDER:
            [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ORDER data:[NSNumber numberWithInteger:position]];
            break;
        default:
            break;
    }
    
}

- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[CaptionTextTableViewCell class]]) {
        NSInteger tag = view.tag;
        switch (tag) {
            case RESERVATION_DETAIL_SECTION_RESERVEPERSON:
                [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_RESERVEPERSON data:nil];
                break;
                
            case RESERVATION_DETAIL_SECTION_ADMINISTRATOR:
                [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ADMINISTRATOR data:nil];
                break;
                
            case RESERVATION_DETAIL_SECTION_SUPERVISOR:
                [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_SUPERVISOR data:nil];
                break;
            
            case RESERVATION_DETAIL_SECTION_RECEIVING_PERSON:
                [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SELECT_RECEIVING_PERSON data:nil];
                break;
            default:
                break;
        }
    }
}

- (void) OnOrderItemClicked:(id) sender {
    UIView * view = sender;
    NSInteger position = view.tag;
    [self notifyEvent:INVENTORY_RESERVATION_DETAIL_EVENT_SHOW_ORDER data:[NSNumber numberWithInteger:position]];
}

- (void) notifyEvent:(InventoryReservationDetailEventType) type data:(id) data {
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
