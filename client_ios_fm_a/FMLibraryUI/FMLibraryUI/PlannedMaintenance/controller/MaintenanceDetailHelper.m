//
//  MaintenanceDetailHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailHelper.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "MarkedListHeaderView.h"
#import "MaintenanceEntity.h"
#import "PlannedMaintenanceServerConfig.h"
#import "MaintenanceEventHelper.h"

#import "MaintenanceDetailBaseItemView.h"
#import "MaintenanceDetailStepItemView.h"
#import "MaintenanceDetailMaterialItemView.h"
#import "MaintenanceDetailToolItemView.h"
#import "MaintenanceDetailEquipmentItemView.h"
#import "BaseLabelView.h"
#import "MaintenanceDetailOrderItemView.h"
#import "BasePhotoView.h"

#import "MaintenanceDetailBaseModel.h"
#import "MaintenanceDetailStepModel.h"
#import "MaintenanceDetailMaterialModel.h"
#import "MaintenanceDetailToolModel.h"
#import "MaintenanceDetailEquipmentModel.h"
#import "MaintenanceDetailLocationModel.h"
#import "MaintenanceDetailOrderModel.h"

#import "WorkOrderServerConfig.h"
#import "FMTheme.h"



typedef NS_ENUM(NSInteger, PlannedMaintenanceDetailSectionType) {
    PM_DETAIL_SECTION_TYPE_UNKNOW,
    //基本信息
    PM_DETAIL_SECTION_TYPE_INFO,       //概况
    PM_DETAIL_SECTION_TYPE_STEP,   //步骤
    PM_DETAIL_SECTION_TYPE_ATTACHMENT,   //附件
    PM_DETAIL_SECTION_TYPE_MATERIAL,       //物料
    PM_DETAIL_SECTION_TYPE_TOOL, //工具
    
    //对象
    PM_DETAIL_SECTION_TYPE_EQUIPMENT,    //对象
    PM_DETAIL_SECTION_TYPE_LOCATION,    //空间位置
    
    //工单
    PM_DETAIL_SECTION_TYPE_ORDER,    //工单

};

typedef NS_ENUM(NSInteger, BasephotoDisplayType) {
    DISPLAY_TYPE_ATTACHMENT,
};

@interface MaintenanceDetailHelper ()

@property (readwrite, nonatomic, strong) MaintenanceDetailBaseItemView * baseItemView;

@property (readwrite, nonatomic, strong) MaintenanceDetailEntity * entity;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat baseInfoHeight;
@property (readwrite, nonatomic, assign) CGFloat locationItemHeight;
@property (readwrite, nonatomic, assign) CGFloat materialItemHeight;
@property (readwrite, nonatomic, assign) CGFloat toolItemHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, strong) MaintenanceDetailBaseModel * baseModel;

@property (readwrite, nonatomic, assign) MaintenanceDetailShowType showType;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation MaintenanceDetailHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSetting];
    }
    return self;
}

- (void) initSetting {
    _headerHeight = 50;
    _baseInfoHeight = 0;
    _locationItemHeight = 50;
    _footerHeight = 10;
    
    _materialItemHeight = 140;
    _toolItemHeight = 140;
    
    _showType = PM_DETAIL_SHOW_BASE;
}

- (void) setInfoWith:(MaintenanceDetailEntity *) entity {
    _entity = entity;
}

- (void) setShowType:(MaintenanceDetailShowType)showType {
    _showType = showType;
}

- (MaintenanceDetailShowType) getShowType {
    return _showType;
}

- (void) clearAll  {
    
}

//获取步骤个数
- (NSInteger) getStepCount {
    NSInteger count = 0;
    if (_entity.pmSteps && _entity.pmSteps.count > 0) {
        count = [_entity.pmSteps count];
    }
    return count;
}

//获取附件个数
- (NSInteger) getAttachmentCount {
    NSInteger count = 0;
    if (_entity.pictures && _entity.pictures.count > 0) {
        count = [_entity.pictures count];
    }
    return count;
}

//获取物料个数
- (NSInteger) getMaterialCount {
    NSInteger count = 0;
    if (_entity.pmMaterials && _entity.pmMaterials.count > 0) {
        count = [_entity.pmMaterials count];
    }
    return count;
}

//获取工具个数
- (NSInteger) getToolCount {
    NSInteger count = 0;
    if (_entity.pmTools && _entity.pmTools.count > 0) {
        count = [_entity.pmTools count];
    }
    return count;
}


//获取设备个数
- (NSInteger) getEquipmentCount {
    NSInteger count = 0;
    if (_entity.equipments && _entity.equipments.count > 0) {
        count = [_entity.equipments count];
    }
    return count;
}


//获取位置个数
- (NSInteger) getLocationCount {
    NSInteger count = 0;
    if (_entity.spaces && _entity.spaces.count > 0) {
        count = [_entity.spaces count];
    }
    return count;
}

//获取工单个数
- (NSInteger) getOrderCount {
    NSInteger count = 0;
    if (_entity.workOrders && _entity.workOrders.count > 0) {
        count = [_entity.workOrders count];
    }
    return count;
}

//判断是否有数据
- (BOOL) hasData {
    BOOL res = YES;
    switch(_showType) {
        case PM_DETAIL_SHOW_ORDER:
            if([self getOrderCount] == 0) {
                res = NO;
            }
            break;
        case PM_DETAIL_SHOW_TARGET:
            if([self getEquipmentCount] == 0 && [self getLocationCount] == 0) {
                res = NO;
            }
            break;
        default:
            break;
    }
    return res;
}

//获取 section 个数
- (NSInteger) getSectionCount {
    NSInteger count = 0;
    switch(_showType) {
        case PM_DETAIL_SHOW_BASE:
            count = 1;
            if ([self getStepCount] > 0) {
                count += 1;
            }
            if ([self getAttachmentCount] > 0) {
                count += 1;
            }
            if ([self getMaterialCount] > 0) {
                count += 1;
            }
            if ([self getToolCount] > 0) {
                count += 1;
            }
            break;
        case PM_DETAIL_SHOW_TARGET:
            count = 0;
            if ([self getEquipmentCount] > 0) {
                count += 1;
            }
            if ([self getLocationCount] > 0) {
                count += 1;
            }
            break;
        case PM_DETAIL_SHOW_ORDER:
            count = 1;
            break;
        default:
            break;
    }

    return count;
}


- (PlannedMaintenanceDetailSectionType) getSectionType:(NSInteger) index {
    PlannedMaintenanceDetailSectionType sectionType = PM_DETAIL_SECTION_TYPE_UNKNOW;
    switch (_showType) {
        case PM_DETAIL_SHOW_BASE:
            if (index >= 1 && [self getStepCount] == 0) {
                index += 1;
            }
            if (index >= 2 && [self getAttachmentCount] == 0) {
                index += 1;
            }
            if (index >= 3 && [self getMaterialCount] == 0) {
                index += 1;
            }
            if (index >= 4 && [self getToolCount] == 0) {
                index += 1;
            }
            switch(index) {
                case 0:
                    sectionType = PM_DETAIL_SECTION_TYPE_INFO;
                    break;
                case 1:
                    sectionType = PM_DETAIL_SECTION_TYPE_STEP;
                    break;
                case 2:
                    sectionType = PM_DETAIL_SECTION_TYPE_ATTACHMENT;
                    break;
                case 3:
                    sectionType = PM_DETAIL_SECTION_TYPE_MATERIAL;
                    break;
                case 4:
                    sectionType = PM_DETAIL_SECTION_TYPE_TOOL;
                    break;
            }
            break;
        case PM_DETAIL_SHOW_TARGET:
            if (index >= 0 && [self getEquipmentCount] == 0) {
                index += 1;
            }
            if (index >= 1 && [self getLocationCount] == 0) {
                index += 1;
            }
            switch(index) {
                case 0:
                    sectionType = PM_DETAIL_SECTION_TYPE_EQUIPMENT;
                    break;
                case 1:
                    sectionType = PM_DETAIL_SECTION_TYPE_LOCATION;
                    break;
            }
            break;
        case PM_DETAIL_SHOW_ORDER:
            if(index == 0) {
                sectionType = PM_DETAIL_SECTION_TYPE_ORDER;
            }
            break;
            
        default:
            sectionType = PM_DETAIL_SECTION_TYPE_UNKNOW;
            break;
    }
    return sectionType;
}

//获取对应模块的数据实体
- (id) getModelBySection:(NSInteger) section position:(NSInteger) position {
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    id model = nil;
    MaintenanceDetailStepEntity * step;
    MaintenanceDetailMaterialEntity * material;
    MaintenanceDetailToolEntity * tool;
    MaintenanceDetailEquipmentEntity * equipment;
    MaintenanceDetailLocationEntity * location;
    MaintenanceDetailOrderEntity * order;
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            if(!_baseModel && _entity) {
                _baseModel = [[MaintenanceDetailBaseModel alloc] init];
                
                _baseModel.name = [_entity.name copy];
                _baseModel.maintenanceStatus = [PlannedMaintenanceServerConfig getMaintenanceStatsDesc:_entity.status];
                _baseModel.influence = [_entity.influence copy];
                _baseModel.period = [_entity.period copy];
                _baseModel.dateFirstTodoDesc = [FMUtils getDayStr:[FMUtils timeLongToDate:_entity.dateFirstTodo]];
                _baseModel.dateNextTodoDesc = [FMUtils getDayStr:[FMUtils timeLongToDate:_entity.dateNextTodo]];
                _baseModel.genStatusDesc = _entity.autoGenerateOrder?[[BaseBundle getInstance] getStringByKey:@"maintenance_auto_order_yes" inTable:nil]:[[BaseBundle getInstance] getStringByKey:@"maintenance_auto_order_yes" inTable:nil];
                _baseModel.estimatedWorkingTime = _entity.estimatedWorkingTime;
                
                NSInteger tmp = _entity.ahead.integerValue;
                if(tmp > 1) {
                    _baseModel.aheadDesc = [[NSString alloc] initWithFormat:@"%ld %@", tmp, [[BaseBundle getInstance] getStringByKey:@"maintenance_day_multi" inTable:nil]];
                } else if(tmp == 1) {
                    _baseModel.aheadDesc = [[NSString alloc] initWithFormat:@"%ld %@", tmp, [[BaseBundle getInstance] getStringByKey:@"maintenance_order" inTable:nil]];
                } else {
                    _baseModel.aheadDesc = [[NSString alloc] initWithFormat:@"%ld %@", tmp, [[BaseBundle getInstance] getStringByKey:@"maintenance_order" inTable:nil]];
                }
            }
            
            model = _baseModel;
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            if(position >= 0 && position < [self getStepCount]) {
                step = _entity.pmSteps[position];
                MaintenanceDetailStepModel * stepModel = [[MaintenanceDetailStepModel alloc] init];
                stepModel.group = step.workTeamName;
                stepModel.content = step.step;
                stepModel.step = [[NSString alloc] initWithFormat:@"%ld", step.sort];
                
                model = stepModel;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            if(position >= 0 && position < [self getMaterialCount]) {
                material = _entity.pmMaterials[position];
                MaintenanceDetailMaterialModel * materialModel = [[MaintenanceDetailMaterialModel alloc] init];
                materialModel.name = material.name;
                materialModel.brand = material.brand;
                materialModel.model = material.model;
                materialModel.amountDesc = [[NSString alloc] initWithFormat:@"%ld", (material.amount)];
                
                model = materialModel;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            if(position >= 0 && position < [self getToolCount]) {
                tool = _entity.pmTools[position];
                MaintenanceDetailToolModel * toolModel = [[MaintenanceDetailToolModel alloc] init];
                toolModel.name = tool.name;
                toolModel.model = tool.model;
                toolModel.amountDesc = [[NSString alloc] initWithFormat:@"%ld", (tool.amount)];
                
                model = toolModel;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            if(position >= 0 && position < [self getEquipmentCount]) {
                equipment = _entity.equipments[position];
                MaintenanceDetailEquipmentModel * equipmentModel = [[MaintenanceDetailEquipmentModel alloc] init];
                equipmentModel.code = equipment.code;
                equipmentModel.name = equipment.name;
                equipmentModel.location = equipment.location;
                equipmentModel.system = equipment.eqSystemName;
                
                model = equipmentModel;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            if(position >= 0 && position < [self getLocationCount]) {
                location = _entity.spaces[position];
                MaintenanceDetailLocationModel * locationModel = [[MaintenanceDetailLocationModel alloc] init];
                locationModel.name = location.location;
                
                model = locationModel;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            if(position >= 0 && position < [self getOrderCount]) {
                order = _entity.workOrders[position];
                MaintenanceDetailOrderModel * orderModel = [[MaintenanceDetailOrderModel alloc] init];
                orderModel.code = order.code;
                orderModel.status = order.status;
//                [WorkOrderServerConfig getOrderStatusDesc:order.status];
                orderModel.time = [FMUtils timeLongToDateStringWithOutYear:order.createDateTime];
                orderModel.applicant = order.applicantName;
                orderModel.location = order.location;
                
                model = orderModel;
            }
            break;
        default:
            break;
            
    }
    return model;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self getSectionCount];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            count = 1 + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            count = [self getStepCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            count = [self getAttachmentCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            count = [self getMaterialCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            count = [self getToolCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            count = [self getEquipmentCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            count = [self getLocationCount] + 1;
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            count = [self getOrderCount] + 1;
            break;
        default:
            count = 0;
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            if(position == 0) {
                MaintenanceDetailBaseModel * baseModel = [self getModelBySection:section position:position];
                _baseInfoHeight = [MaintenanceDetailBaseItemView calculateHeightByModel:baseModel width:width];
                itemHeight = _baseInfoHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            if(position < [self getStepCount]) {
                MaintenanceDetailStepModel * stepModel = [self getModelBySection:section position:position];
                itemHeight = [MaintenanceDetailStepItemView calculateHeightByModel:stepModel width:width];
            } else {
                itemHeight = _footerHeight;
            }
            break;
            
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            if(position < [self getAttachmentCount]) {
                itemHeight = _locationItemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            if(position < [self getMaterialCount]) {
                itemHeight = _materialItemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            if(position < [self getToolCount]) {
                itemHeight = _toolItemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            if(position < [self getEquipmentCount]) {
                MaintenanceDetailEquipmentModel * equipModel = [self getModelBySection:section position:position];
                itemHeight = [MaintenanceDetailEquipmentItemView calculateHeightByModel:equipModel andWidth:width];
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            if(position < [self getLocationCount]) {
                MaintenanceDetailLocationModel * locationModel = [self getModelBySection:section position:position];
                itemHeight = [BaseLabelView calculateHeightByInfo:locationModel.name font:nil desc:nil labelFont:nil andLabelWidth:0 andWidth:width];
                if(itemHeight < _locationItemHeight) {
                    itemHeight = _locationItemHeight;
                }
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            if(position < [self getOrderCount]) {
                MaintenanceDetailOrderModel * orderModel = [self getModelBySection:section position:position];
                itemHeight = [MaintenanceDetailOrderItemView calculateHeightByModel:orderModel andWidth:width];
            } else {
                itemHeight = _footerHeight;
            }
            break;
        default:
            itemHeight = 0;
            break;
    }
    itemHeight = ceilf(itemHeight);
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIdentifier = @"Cell";
    
    MaintenanceDetailStepItemView * stepItemView = nil;
    MaintenanceDetailMaterialItemView * materialItemView = nil;
    MaintenanceDetailToolItemView * toolItemView = nil;
    MaintenanceDetailEquipmentItemView * equipmentItemView = nil;
    BaseLabelView * locationItemView = nil;
    MaintenanceDetailOrderItemView * orderItemView = nil;
    
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    //    CGFloat paddingLeft = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UITableViewCell * cell;
    BOOL isFooter = NO;
    id obj = [self getModelBySection:section position:position];
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    CGFloat padding = [FMSize getInstance].defaultPadding;

    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            if(position == 0) {
                MaintenanceDetailBaseModel * baseModel = obj;
                itemHeight = [MaintenanceDetailBaseItemView calculateHeightByModel:baseModel width:width];
                cellIdentifier = @"CellBase";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if(cell && !_baseItemView) {
                    _baseItemView = [[MaintenanceDetailBaseItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    
                    [cell addSubview:_baseItemView];
                }
                if(_baseItemView) {
                    [_baseItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [_baseItemView setInfoWith:baseModel];
                }
            } else {
                isFooter = YES;
            }
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            isFooter = YES;
            if(position < [self getStepCount]) {
                MaintenanceDetailStepModel * stepModel = obj;
                isFooter = NO;
                itemHeight = [MaintenanceDetailStepItemView calculateHeightByModel:stepModel width:width];
                cellIdentifier = @"CellStep";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceDetailStepItemView class]]) {
                            stepItemView = (MaintenanceDetailStepItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !stepItemView) {
                    stepItemView = [[MaintenanceDetailStepItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:stepItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getStepCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(stepItemView) {
                    [stepItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [stepItemView setInfoWith:stepModel];
                }
            }
            break;
            
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            if(_entity.pictures && position < [_entity.pictures count]) {
                //附件
                MaintenanceDetailAttachmentEntity * attachment = _entity.pictures[position];
                cellIdentifier = @"CellAttachment";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } else {
                    NSArray *subViews = [cell subviews];
                    for (UIView *view in subViews) {
                        if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if (cell) {
                    [cell.textLabel setText:attachment.fileName];
                    cell.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
                    cell.textLabel.font = [FMFont getInstance].font42;
                }
                if (cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if (seperator) {
                    if (position < _entity.pictures.count - 1) {
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake([FMSize getInstance].defaultPadding, _locationItemHeight-[FMSize getInstance].seperatorHeight, width-[FMSize getInstance].defaultPadding*2, [FMSize getInstance].seperatorHeight)];
                    } else {
                        [seperator setDotted:NO];
                        [seperator setFrame:CGRectMake(0, _locationItemHeight-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
                    }
                }
            } else {
                isFooter = YES;
            }
            break;
            
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            isFooter = YES;
            if(position < [self getMaterialCount]) {
                MaintenanceDetailMaterialModel * materialModel = obj;
                isFooter = NO;
                itemHeight = _materialItemHeight;
                cellIdentifier = @"CellMaterial";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceDetailMaterialItemView class]]) {
                            materialItemView = (MaintenanceDetailMaterialItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !materialItemView) {
                    materialItemView = [[MaintenanceDetailMaterialItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:materialItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getMaterialCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(materialItemView) {
                    [materialItemView setInfoWith:materialModel];
                }
            }
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            isFooter = YES;
            if(position < [self getToolCount]) {
                MaintenanceDetailToolModel * toolModel = obj;
                isFooter = NO;
                itemHeight = _toolItemHeight;
                cellIdentifier = @"CellTool";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceDetailToolItemView class]]) {
                            toolItemView = (MaintenanceDetailToolItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !toolItemView) {
                    toolItemView = [[MaintenanceDetailToolItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:toolItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getToolCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(toolItemView) {
                    [toolItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [toolItemView setInfoWith:toolModel];
                }
            }
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            isFooter = YES;
            if(position < [self getEquipmentCount]) {
                MaintenanceDetailEquipmentModel * equipModel = obj;
                isFooter = NO;
                itemHeight = [MaintenanceDetailEquipmentItemView calculateHeightByModel:equipModel andWidth:width];
                
                cellIdentifier = @"CellEquipment";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceDetailEquipmentItemView class]]) {
                            equipmentItemView = (MaintenanceDetailEquipmentItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !equipmentItemView) {
                    equipmentItemView = [[MaintenanceDetailEquipmentItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:equipmentItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getEquipmentCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(equipmentItemView) {
                    [equipmentItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [equipmentItemView setInfoWith:equipModel];
                }
            }
            
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            isFooter = YES;
            if(position < [self getLocationCount]) {
                MaintenanceDetailLocationModel * locationModel = obj;
                isFooter = NO;
                 itemHeight = [BaseLabelView calculateHeightByInfo:locationModel.name font:nil desc:nil labelFont:nil andLabelWidth:0 andWidth:width];
                if(itemHeight < _locationItemHeight) {
                    itemHeight = _locationItemHeight;
                }
                cellIdentifier = @"CellLocation";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[BaseLabelView class]]) {
                            locationItemView = (BaseLabelView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !locationItemView) {
                    locationItemView = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:locationItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getLocationCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(locationItemView) {
                    [locationItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    
                    [locationItemView setContent:locationModel.name];
                }
            }
            
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            isFooter = YES;
            if(position < [self getOrderCount]) {
                MaintenanceDetailOrderModel * orderModel = obj;
                isFooter = NO;
                itemHeight = [MaintenanceDetailOrderItemView calculateHeightByModel:orderModel andWidth:width];
                
                cellIdentifier = @"CellOrder";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceDetailOrderItemView class]]) {
                            orderItemView = (MaintenanceDetailOrderItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !orderItemView) {
                    orderItemView = [[MaintenanceDetailOrderItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:orderItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getOrderCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(orderItemView) {
                    [orderItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [orderItemView setInfoWith:orderModel];
                }
            }
            
            break;
        default:
            itemHeight = 0;
            break;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        SeperatorView * footerView;
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[SeperatorView class]]) {
                    footerView = subView;
                }
            }
        }
        if(cell && !footerView) {
            footerView = [[SeperatorView alloc] init];
            [cell addSubview:footerView];
        }
        if(footerView) {
            [footerView setFrame:CGRectMake(0, 0, width, seperatorHeight)];
            [footerView setShowBottomBound:NO];
            [footerView setShowTopBound:YES];
            if(position > 0) {
                [footerView setShowTopBound:YES];
            } else {
                [footerView setShowTopBound:NO];
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    UIView * res;
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    res = headerView;
    NSString* strHeader = nil;
    
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_base_info" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_step" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_attachment" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_material" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_tool" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_equipment" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"maintenance_location" inTable:nil];
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            break;
        default:
            break;
    }
    [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
    [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
    headerView.tag = sectionType;
    return res;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = _headerHeight;
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            break;
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            headerHeight = 0;
            break;
        default:
            headerHeight = 0;
            break;
    }
    return headerHeight;
}


#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    PlannedMaintenanceDetailSectionType sectionType = [self getSectionType:section];
    
    switch(sectionType) {
        case PM_DETAIL_SECTION_TYPE_INFO:
            break;
        case PM_DETAIL_SECTION_TYPE_STEP:
            break;
        case PM_DETAIL_SECTION_TYPE_ATTACHMENT:
            [self notifyEvent:PM_DETAIL_EVENT_SHOW_ATTACHMENT_DETAIL data:[NSNumber numberWithInteger:position]];
            break;
        case PM_DETAIL_SECTION_TYPE_MATERIAL:
            break;
        case PM_DETAIL_SECTION_TYPE_TOOL:
            break;
        case PM_DETAIL_SECTION_TYPE_EQUIPMENT:
            break;
        case PM_DETAIL_SECTION_TYPE_LOCATION:
            break;
        case PM_DETAIL_SECTION_TYPE_ORDER:
            [self notifyShowOrderDetail:position];
            break;
        default:
            break;
    }
}

- (void) notifyShowOrderDetail:(NSInteger) posiiton {
    if(posiiton >= 0 && posiiton < [self getOrderCount]) {
        MaintenanceDetailOrderEntity * order = _entity.workOrders[posiiton];
        [self notifyEvent:PM_DETAIL_EVENT_SHOW_ORDER_DETAIL data:order];
    }
}


#pragma mark - 通知
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) notifyEvent:(MaintenanceDetailEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:[NSNumber numberWithInteger:type] forKeyPath:@"msgType"];
        [msg setValue:data forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

@end
