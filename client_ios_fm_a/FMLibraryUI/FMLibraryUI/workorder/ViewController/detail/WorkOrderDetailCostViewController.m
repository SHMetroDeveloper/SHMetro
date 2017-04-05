//
//  WorkOrderDetailCostViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailCostViewController.h"
#import "WriteOrderAddChargeViewController.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "CostSumView.h"
#import "WorkOrderDetailChargeItemView.h"
#import "WorkOrderDetailEntity.h"
#import "WorkOrderBusiness.h"


@interface WorkOrderDetailCostViewController () <UITableViewDelegate, UITableViewDataSource, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) UIView * topContainerView;
@property (readwrite, nonatomic, strong) UILabel * materialLbl;

@property (readwrite, nonatomic, strong) UIButton * selectedBtn;
@property (readwrite, nonatomic, strong) UIImageView * selectImgView;
@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;

@property (readwrite, nonatomic, strong) UITableView * chargeTableView;

@property (readwrite, nonatomic, strong) NSMutableArray * charges;
@property (readwrite, nonatomic, strong) NSNumber * materialCharge;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) CGFloat topContainerHeight;
@property (readwrite, nonatomic, assign) CGFloat chargeItemHeight;
@property (readwrite, nonatomic, assign) CGFloat sumItemHeight;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, assign) NSInteger position;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) WorkOrderDetail * orderDetail;

@property (readwrite, nonatomic, assign) BOOL selectMaterial;
@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailCostViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_detail_cost" inTable:nil]];
    if(_editable) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil],  nil];
        [self setMenuWithArray:menus];
    }
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSelectImgView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self requestData];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [[WorkOrderBusiness alloc] init];
        _orderDetail = [[WorkOrderDetail alloc] init];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _topContainerHeight = 48;
        _paddingTop = 13;
        _chargeItemHeight = 45;
        _sumItemHeight = 60;
        _imgWidth = 18*1.184;
        CGFloat paddingLeft = 17;
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        
        _btnWidth = paddingLeft * 2 + _imgWidth;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, _paddingTop, _realWidth, _topContainerHeight)];
        
        _topContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
       
        _materialLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, _realWidth-_btnWidth-paddingLeft, _topContainerHeight)];
        _selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-_btnWidth, 0, _btnWidth, _topContainerHeight)];
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(paddingLeft, (_topContainerHeight-_imgWidth)/2, _imgWidth, _imgWidth)];
        
        _topSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, _topContainerHeight-seperatorHeight, _realWidth, seperatorHeight)];
        
        _materialLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _materialLbl.font = [FMFont getInstance].defaultFontLevel2;
        _materialLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_cost_tool" inTable:nil];
        
        
        [_selectedBtn addTarget:self action:@selector(onMaterialChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        [_selectedBtn addSubview:_selectImgView];
        
        [_topContainerView addSubview:_materialLbl];
        [_topContainerView addSubview:_selectedBtn];
        [_topContainerView addSubview:_topSeperator];
        
        
        _chargeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topContainerHeight + _paddingTop * 2, _realWidth, _realHeight - _paddingTop * 2 - _topContainerHeight)];
        
        _chargeTableView.delegate = self;
        _chargeTableView.dataSource = self;
        _chargeTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _chargeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [_mainContainerView addSubview:_topContainerView];
        [_mainContainerView addSubview:_chargeTableView];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self gotoAddCharge];
}

- (void) updateSelectImgView {
    if(_selectMaterial) {
        [_selectImgView setImage:[[FMTheme getInstance] getImageByName:@"checked_on"]];
    } else {
        [_selectImgView setImage:[[FMTheme getInstance] getImageByName:@"checked_off"]];
    }
}

- (void) updateList {
    [self updateSelectImgView];
    [_chargeTableView reloadData];
}

- (void) setInfoWith:(NSMutableArray *) array {
    _charges = array;
    [self updateList];
}

- (void) setMaterialCharge:(NSNumber *)materialCharge {
    _materialCharge = [materialCharge copy];
    [self updateList];
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (void) setWorkOrderId:(NSNumber *)woId {
    _woId = [woId copy];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}



- (NSString *) getTotalCost {
    CGFloat sum = 0;
    for(WorkOrderChargeItem * item in _charges) {
        if(item.amount) {
            sum += item.amount.floatValue;
        }
    }
    if(_selectMaterial) {
        sum += _materialCharge.floatValue;
    }
    NSString * strSum = [[NSString alloc] initWithFormat:@"%.2f", sum];
    return strSum;
}

#pragma mark - 物料选择
- (void) onMaterialChanged:(id) sender {
    _selectMaterial = !_selectMaterial;
    [self updateList];
}

- (NSInteger) getChargeCount {
    NSInteger count = [_charges count];
    if(_selectMaterial) {   //物料费用
        count += 1;
    }
    return count;
}

- (WorkOrderChargeItem *) getChargeByPosition:(NSInteger) position {
    WorkOrderChargeItem * charge;
    if(position < [_charges count]) {
        charge = _charges[position];
    } else {
        charge = [[WorkOrderChargeItem alloc] init];
        charge.name = [[BaseBundle getInstance] getStringByKey:@"order_cost_tool" inTable:nil];
        charge.amount = _materialCharge;
    }
    return charge;
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self getChargeCount] + 1;
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    if(position < [self getChargeCount]) {
        height = _chargeItemHeight;
    } else {
        height = _sumItemHeight;
    }
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    UITableViewCell * cell;
    NSString * cellIdentifer;
    
    CGFloat itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    WorkOrderDetailChargeItemView * chargeItemView;
    SeperatorView * seperator;
    CostSumView * sumItemView;
    
    CGFloat padding = 17;
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    if(position < [self getChargeCount]) {
        cellIdentifer = @"CellCharge";
        itemHeight = _chargeItemHeight;
        
        WorkOrderChargeItem * charge = [self getChargeByPosition:position];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[WorkOrderDetailChargeItemView class]]) {
                    chargeItemView = subView;
                } else if([subView isKindOfClass:[SeperatorView class]]) {
                    seperator = subView;
                }
            }
        }
        if(cell && !chargeItemView) {
            chargeItemView = [[WorkOrderDetailChargeItemView alloc] init];
            [cell addSubview:chargeItemView];
        }
        if(cell && !seperator) {
            seperator = [[SeperatorView alloc] init];
            [cell addSubview:seperator];
        }
        if(seperator) {
            if(position < [_charges count] - 1) {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
            } else {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
            }
        }
        if(chargeItemView) {
            [chargeItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
            [chargeItemView setInfoWithName:charge.name amount:charge.amount];
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
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }
        if(sumItemView) {
            NSString * strCost = [self getTotalCost];
            [sumItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
            [sumItemView setInfoWithCost:strCost];
        }
    }
    
    return cell;
}

#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if(_editable) {
        if(position >= 0 && position < [_charges count]) {
//            return YES;
        }
    }
    return NO;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSInteger position = indexPath.row;
//        if(position >= 0 && position < [_charges count]) {
//            [self deleteChargeByIndex:position];
//            [_charges removeObjectAtIndex:position];
//            [self notifyChargeUpdate];
//            [self updateList];
//        }
//    }
    if(_editable) {
        NSInteger position = indexPath.row;
        if(position < [_charges count]) {
            [self gotoEditCharge:position];
        } else if(_selectMaterial && position == [_charges count]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_charge_edit_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
    return [[BaseBundle getInstance] getStringByKey:@"work_order_charge_modify" inTable:nil];
}



#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_editable) {
        NSInteger position = indexPath.row;
        if(position < [_charges count]) {
            [self gotoEditCharge:position];
        } else if(_selectMaterial && position == [_charges count]) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_charge_edit_notice_material" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}

#pragma mark - 数据更新
- (void) notifyChargeUpdate {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:_charges forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WriteOrderAddChargeViewController class])]) {
            WorkOrderChargeItem * charge = [msg valueForKeyPath:@"result"];
            if(_tag < 0) {
                if(!_charges) {
                    _charges = [[NSMutableArray alloc] init];
                }
                [_charges addObject:charge];
            } else {
                if(_position < [_charges count]) {
                    _charges[_position] = charge;
                }
            }
            [self updateList];
            [self notifyChargeUpdate];
        }
    }
}

#pragma mark - 添加工具
//添加收费项
- (void) gotoAddCharge {
    WriteOrderAddChargeViewController * addVC = [[WriteOrderAddChargeViewController alloc] init];
    _tag = -1;
    [addVC setWorkOrderId:_woId];
    [addVC setOperateType:WORK_ORDER_CHARGE_TYPE_ADD];
    [addVC setOnMessageHandleListener:self];
    [self gotoViewController:addVC];
}

//修改收费项
- (void) gotoEditCharge:(NSInteger) position {
    WorkOrderChargeItem * charge = _charges[position];
    WriteOrderAddChargeViewController * editVC = [[WriteOrderAddChargeViewController alloc] init];
    _tag = position;
    [editVC setOperateType:WORK_ORDER_CHARGE_TYPE_MODIFY];
    [editVC setChargeInfoWithEntity:charge];
    [editVC setOnMessageHandleListener:self];
    [self gotoViewController:editVC];
}




//删除收费项
- (void) deleteChargeByIndex:(NSInteger) position {
    WorkOrderChargeItem * charge = _charges[position];
    WorkOrderChargeSaveRequestParam * param = [[WorkOrderChargeSaveRequestParam alloc] init];
    param.woId = _woId;
    param.operateType = WORK_ORDER_CHARGE_TYPE_DELETE;
    param.chargeId = charge.chargeId;
    param.name = charge.name;
    param.amount = charge.amount.doubleValue;
    
    [_business saveWorkOrderCharge:param success:^(NSInteger key, id object) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_charge_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//#pragma mark - 数据刷新
//- (void) requestData {
//    [self showLoadingDialog];
//    if (!_charges) {
//        _charges = [[NSMutableArray alloc] init];
//    }
//    [_business getDetailInfoOfOrder:_woId success:^(NSInteger key, id object) {
//        [self hideLoadingDialog];
//        if (!_orderDetail) {
//            _orderDetail = [[WorkOrderDetail alloc] init];
//        }
//        _orderDetail = object;
//        _charges = _orderDetail.charges;
//        [self updateList];
//    } fail:^(NSInteger key, NSError *error) {
//        [self hideLoadingDialog];
//        _orderDetail = nil;
//        _charges = _orderDetail.charges;
//        [self updateList];
//    }];
//}

@end




