//
//  WorkOrderDetailMaterialViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//


#import "WorkOrderDetailMaterialViewController.h"
#import "WriteOrderAddMaterialViewController.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "WorkOrderDetailMaterialItemView.h"
#import "CostSumView.h"
#import "ImageItemView.h"
#import "WorkOrderBusiness.h"
#import "WorkOrderDetailEntity.h"
#import "CaptionTextField.h"
#import "InfoSelectViewController.h"
#import "BaseLabelView.h"
#import "DXAlertView.h"
#import "WarehouseEntity.h"


typedef NS_ENUM(NSInteger, WorkOrderMaterialSectionType) {
    WO_MATERIAL_SECTION_UNKNOW,
    WO_MATERIAL_SECTION_WAREHOUSE,
    WO_MATERIAL_SECTION_MATERIAL,
};

@interface WorkOrderDetailMaterialViewController () <UITableViewDelegate, UITableViewDataSource, OnMessageHandleListener, OnClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * materialTableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeView;    //提示

@property (readwrite, nonatomic, strong) WarehouseEntity * warehouse;
@property (readwrite, nonatomic, strong) NSMutableArray * materials;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat warehouseItemHeight;
@property (readwrite, nonatomic, assign) CGFloat materialItemHeight;
@property (readwrite, nonatomic, assign) CGFloat sumItemHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, assign) NSInteger position;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailMaterialViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_detail_material" inTable:nil]];
    if(_editable) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil],  nil];
        [self setMenuWithArray:menus];
    }
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = YES;
        [self requestMaterials];
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        _business = [WorkOrderBusiness getInstance];
        _page = [[NetPage alloc] init];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _warehouseItemHeight = 92;
        _materialItemHeight = 70;
        _sumItemHeight = 60;
        _headerHeight = 44;
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _materialTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        
        _materialTableView.delegate = self;
        _materialTableView.dataSource = self;
        _materialTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _materialTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _noticeView = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight - _noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_material_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeView setHidden:YES];
        [_noticeView setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeView setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_materialTableView];
        [_mainContainerView addSubview:_noticeView];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if([FMUtils isNumberNullOrZero:[self getWarehouseId]]) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_warehouse" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        [self gotoAddMaterial];
    }
}


- (void) setInfoWithMaterials:(NSArray *) materials {
    if(!_materials) {
        _materials = [[NSMutableArray alloc] init];
    } else {
        [_materials removeAllObjects];
    }
    [_materials addObjectsFromArray:materials];
    [self updateList];
}

- (void) setWorkOrderId:(NSNumber *)woId {
    _woId = [woId copy];
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

- (NSString *) getTotalCost {
    CGFloat sum = 0;
    NSNumber * tmpNumber;
    for(WorkOrderMaterial * material in _materials) {
//        if(tool.cost) {
//            tmpNumber = [FMUtils stringToNumber:tool.amount];
//            sum += (tool.cost.floatValue * tmpNumber.floatValue);
//        }
    }
    NSString * strSum = [[NSString alloc] initWithFormat:@"%.2f", [[BaseBundle getInstance] getStringByKey:@"yuan_symbol" inTable:nil], sum];
    return strSum;
}

- (void) updateList {
    [_materialTableView reloadData];
}

//获取仓库ID
- (NSNumber *) getWarehouseId {
    NSNumber * warehouseId;
    if([_materials count] > 0) {
        WorkOrderMaterial * material = _materials[0];
        warehouseId = material.warehouseId;
    } else if(_warehouse){
        warehouseId = _warehouse.warehouseId;
    }
    return warehouseId;
}

//获取仓库名称
- (NSString *) getWarehouseName {
    NSString * name;
    if([_materials count] > 0) {
        WorkOrderMaterial * material = _materials[0];
        name = material.warehouseName;
    } else if(_warehouse){
        name = _warehouse.name;
    }
    return name;
}

- (NSInteger) getSectionCount {
    NSInteger count = 1;
    if([_materials count] > 0) {
        count++;
    }
    return count;
}

//
- (WorkOrderMaterialSectionType) getSectionTypeBy:(NSInteger) section {
    WorkOrderMaterialSectionType sectionType = WO_MATERIAL_SECTION_UNKNOW;
    switch(section) {
        case 0:
            sectionType = WO_MATERIAL_SECTION_WAREHOUSE;
            break;
        case 1:
            sectionType = WO_MATERIAL_SECTION_MATERIAL;
            break;
    }
    return sectionType;
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [self getSectionCount];
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            count = 1;
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            count = [_materials count];
//            count = [_materials count] + 1; //sum
            break;
        default:
            break;
    }
    
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            height = _warehouseItemHeight;
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            if(position < [_materials count]) {
                height = _materialItemHeight;
            } else {
                height = _sumItemHeight;
            }
            break;
        default:
            break;
    }
    
    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            height = _headerHeight;
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
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    BaseLabelView * headerLbl;
    
    CGFloat paddingTop = 7;
    
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            headerLbl = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, paddingTop, width, _headerHeight-paddingTop)];
            [headerLbl setContent:[[BaseBundle getInstance] getStringByKey:@"order_material_list" inTable:nil]];
            [headerLbl setContentFont:[FMFont fontWithSize:15]];
            [headerLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
            [headerView addSubview:headerLbl];
            break;
        default:
            break;
    }
    return headerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    UITableViewCell * cell;
    NSString * cellIdentifer;
    
    NSInteger section = indexPath.section;
    CGFloat itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CaptionTextField * warehouseItemView;
    WorkOrderDetailMaterialItemView * materialItemView;
    SeperatorView * seperator;
    CostSumView * sumItemView;
    
    CGFloat padding = 17;
    CGFloat width = CGRectGetWidth(tableView.frame);
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            cellIdentifer = @"CellWarehouse";
            itemHeight = _warehouseItemHeight;
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else {
                NSArray * subViews = [cell subviews];
                for(id subView in subViews) {
                    if([subView isKindOfClass:[CaptionTextField class]]) {
                        warehouseItemView = subView;
                        break;
                    }
                }
            }
            if(cell && !warehouseItemView) {
                warehouseItemView = [[CaptionTextField alloc] init];
                [warehouseItemView setTitle:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name" inTable:nil]];
                [warehouseItemView setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"order_warehouse_name_placeholder" inTable:nil]];
                [warehouseItemView setDesc: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_amount" inTable:nil]];
                [warehouseItemView setEditable:NO];
                [warehouseItemView setShowMark:YES];
                [warehouseItemView setOnClickListener:self];
                [cell addSubview:warehouseItemView];
                
            }
            if(warehouseItemView) {
                [warehouseItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                [warehouseItemView setText:[self getWarehouseName]];
            }
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            if(position < [_materials count]) {
                cellIdentifer = @"CellMaterial";
                itemHeight = _materialItemHeight;
                WorkOrderMaterial * material = _materials[position];
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
                    if(!_editable) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id subView in subViews) {
                        if([subView isKindOfClass:[WorkOrderDetailMaterialItemView class]]) {
                            materialItemView = subView;
                        } else if([subView isKindOfClass:[SeperatorView class]]) {
                            seperator = subView;
                        }
                    }
                }
                if(cell && !materialItemView) {
                    materialItemView = [[WorkOrderDetailMaterialItemView alloc] init];
                    [cell addSubview:materialItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_materials count] - 1) {
                        [seperator setDotted:YES];
                        [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
                    } else {
                        [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    }
                }
                if(materialItemView) {
                    [materialItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [materialItemView setInfoWithCreateName:material.materialName model:material.materialModel brand:material.materialBrand unit:material.materialUnit count:material.amount];
                }
            } else {
                cellIdentifer = @"CellSum";
                itemHeight = _sumItemHeight;
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id subView in subViews) {
                        if([subView isKindOfClass:[CostSumView class]]) {
                            sumItemView = subView;
                        } else if([subView isKindOfClass:[SeperatorView class]]) {
                            seperator = subView;
                        }
                    }
                }
                if(cell && !sumItemView) {
                    sumItemView = [[CostSumView alloc] init];
                    [cell addSubview:sumItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    
                }
                if(sumItemView) {
                    NSString * strCost = [self getTotalCost];
                    [sumItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [sumItemView setInfoWithCost:strCost];
                }
            }
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if(_editable) {
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
        WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
        switch(sectionType) {
            case WO_MATERIAL_SECTION_WAREHOUSE:
                break;
            case WO_MATERIAL_SECTION_MATERIAL:
                if(position >= 0 && position < [_materials count]) {
                    //删除
                    DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_alert_delete_material" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
                    alertView.leftBlock = ^(){
                        [self requestDeleteMaterial:position];
                    };
                    alertView.rightBlock = ^(){
                    };
                    [alertView show];
                    
                }
                break;
            default:
                break;
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
}


#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    WorkOrderMaterialSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case WO_MATERIAL_SECTION_WAREHOUSE:
            if(_editable && [_materials count] == 0) {
                [self gotoSelectWarehouse];
            }
            break;
        case WO_MATERIAL_SECTION_MATERIAL:
            if(_editable && position < [_materials count]) {
                [self gotoEditMaterial:position];
            }
            break;
        default:
            break;
    }
}

#pragma mark - 数据更新
- (void) notifyMaterialUpdate {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:_materials forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

//请求物料数据
- (void) requestMaterials {
    if(!_page) {
        _page = [[NetPage alloc] init];
    } else {
        [_page reset];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoadingDialog];
    });
    [self notifyMaterialUpdate];
    [self requestMaterialWithPage];
}

- (void) requestMaterialWithPage {
    BaseDataGetWorkOrderMaterialParam * param = [[BaseDataGetWorkOrderMaterialParam alloc] initWithOrderId:_woId page:_page];
    
    [_business getMaterialList:param success:^(NSInteger key, id object) {
        BaseDataGetWorkOrderMaterialResponseData * data = object;
        [_page setPage:data.page];
        if(!_materials) {
            _materials = [[NSMutableArray alloc] init];
        } else if([_page isFirstPage]) {
            [_materials removeAllObjects];
        }
        [_materials addObjectsFromArray:data.contents];
        if([_page haveMorePage]) {
            [_page nextPage];
            [self requestMaterialWithPage];
        } else {
            [self updateList];
            [self hideLoadingDialog];
        }
    } fail:^(NSInteger key, NSError *error) {
        if([_materials count] > 0) {
            [_materials removeAllObjects];
        }
        [self hideLoadingDialog];
        [self updateList];
        
    }];
}

- (void) requestDeleteMaterial:(NSInteger) position {
    BaseDataReserveMaterialParam * param = [[BaseDataReserveMaterialParam alloc] init];
    param.woId = _woId;
    param.warehouseId = [self getWarehouseId];
    [self showLoadingDialog];
    
    for(NSInteger index = 0; index < [_materials count]; index++) {
        WorkOrderMaterial * woMaterial = _materials[index];
        if(index != position) {
            ReserveMaterialEntity * material = [[ReserveMaterialEntity alloc] init];
            material.inventoryId = [woMaterial.inventoryId copy];
            material.amount = [NSNumber numberWithInteger:woMaterial.amount];
            material.dueDate = [woMaterial.dueDate copy];
            
            [param.inventories addObject:material];
        }
    }
    
    [_business reserveMaterial:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [_materials removeObjectAtIndex:position];
        [self updateList];
        [self notifyMaterialUpdate];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_material_delete_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}


#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WriteOrderAddMaterialViewController class])]) {
            _needUpdate = YES;
        } else if([strOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            _warehouse = [msg valueForKeyPath:@"result"];
            [self updateList];
        }
    }
}

#pragma mark --- 选择仓库
- (void) onClick:(UIView *)view {
    if([view isKindOfClass:[CaptionTextField class]]) {
        if(![self checkWarehouseInUse]) {
            [self gotoSelectWarehouse];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage: [[BaseBundle getInstance] getStringByKey:@"inventory_notice_warehouse_using" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

//检测仓库是否正在使用中
- (BOOL) checkWarehouseInUse {
    BOOL res = NO;
    if([_materials count] > 0) {
        res = YES;
    }
    return res;
}

#pragma mark - 操作工具
//选择仓库
- (void) gotoSelectWarehouse {
    if(_editable) {
        NSDictionary * param  = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"selectAll", nil];
        InfoSelectViewController * vc = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_WAREHOUSE_INFO_SELECT andParam:param];
        [vc setOnMessageHandleListener:self];
        [self gotoViewController:vc];
    }
}

//添加工具
- (void) gotoAddMaterial {
    WriteOrderAddMaterialViewController * addVC = [[WriteOrderAddMaterialViewController alloc] initWithOperateType:ORDER_MATERIAL_OPERATE_TYPE_ADD];
    _tag = ORDER_MATERIAL_OPERATE_TYPE_ADD;
    [addVC setOnMessageHandleListener:self];
    [addVC setInfoWithMaterialArray:_materials];
    [addVC setInfoWithOrderId:_woId warehouseId:[self getWarehouseId]];
    [self gotoViewController:addVC];
}
//编辑工具
- (void) gotoEditMaterial:(NSInteger) position {
    WorkOrderMaterial * material = _materials[position];
    WriteOrderAddMaterialViewController * editVC = [[WriteOrderAddMaterialViewController alloc] initWithOperateType:ORDER_MATERIAL_OPERATE_TYPE_EDIT];
    _tag = ORDER_MATERIAL_OPERATE_TYPE_EDIT;
    _position = position;
    [editVC setInfoWith:material];
    [editVC setInfoWithMaterialArray:_materials];
    [editVC setInfoWithOrderId:_woId warehouseId:[self getWarehouseId]];
    [editVC setOnMessageHandleListener:self];
    [self gotoViewController:editVC];
}

@end



