//
//  WorkOrderDetailEquipmentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/14.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailEquipmentViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "WorkOrderDetailEquipmentItemView.h"
#import "SeperatorView.h"
#import "WriteOrderAddEquipmentViewController.h"
#import "WriteOrderEquipmentExViewController.h"
#import "ImageItemView.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderBusiness.h"
#import "DXAlertView.h"
#import "QRCodeViewController.h"
#import "BaseDataEntity.h"
#import "BaseDataDbHelper.h"
#import "EquipmentQrcode.h"


@interface WorkOrderDetailEquipmentViewController () <UITableViewDelegate, UITableViewDataSource, OnMessageHandleListener, OnQrCodeScanFinishedListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;    //
@property (readwrite, nonatomic, strong) UITableView * equipmentTableView;  //

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度


@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * equipments;
@property (readwrite, nonatomic, strong) NSNumber * woId;

@property (readwrite, nonatomic, assign) NSInteger curIndex;

@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;

@property (readwrite, nonatomic, strong) EquipmentQrcode * equipQrcode;
@property (readwrite, nonatomic, assign) BOOL backFromQrcode;
@end

@implementation WorkOrderDetailEquipmentViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_detail_equipment" inTable:nil]];
    if(_editable) {
//        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil],  nil];
//        [self setMenuWithArray:menus];
        
        UIImage *scanImage = [[FMTheme getInstance] getImageByName:@"patrol_qrcode_scanner"];
        UIImage *addImage = [[FMTheme getInstance] getImageByName:@"icon_home_add"];
        [self setMenuWithArray:@[addImage, scanImage]];
    }
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _business = [WorkOrderBusiness getInstance];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _equipmentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _equipmentTableView.delegate = self;
        _equipmentTableView.dataSource = self;
        _equipmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _equipmentTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_equipment_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_equipmentTableView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_backFromQrcode) {
        _backFromQrcode = NO;
        if([self isQrCodeOK]) {
            if(_curIndex == -1) {   //通过扫描添加故障设备
                NSNumber * eqId = [_equipQrcode getEquipmentId];
                Device * dev = [[BaseDataDbHelper getInstance] queryDeviceById:eqId];
                if(dev) {
                    WorkOrderEquipment * equip = [[WorkOrderEquipment alloc] init];
                    equip.equipmentId = [dev.eqId copy];
                    equip.equipmentCode = [dev.code copy];
                    equip.equipmentName = [dev.name copy];
                    equip.equipmentStatus = EQUIP_STATUS_USING; //默认使用中
                    equip.finished = YES;   //扫描添加的设备默认完成
                    equip.needScan = NO;    //不是
                    [_equipments addObject:equip];
                    _curIndex = [_equipments count] - 1;
                }
            }
            [self gotoEditEquipment:_curIndex];
        } else {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_qrcode_error" inTable:nil]  time:DIALOG_ALIVE_TIME_SHORT];
        }
    } else {
        [self updateList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    if(position == 0) {
        [self gotoAddEquipment];
    } else if(position == 1) {
        [self gotoScanQrCode:-1];
    }
}


- (void) setWoId:(NSNumber *)woId {
    _woId = [woId copy];
}

- (void) setEquipments:(NSMutableArray *)equipments {
    _equipments = equipments;
    
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}


- (void) updateList {
    [_equipmentTableView reloadData];
    
    if([_equipments count] == 0) {
        [_noticeLbl setHidden:NO];
    } else {
        [_noticeLbl setHidden:YES];
    }
}

- (BOOL) isQrCodeOK {
    BOOL res = NO;
    if(_curIndex >= 0 && _curIndex < [_equipments count]) {
        WorkOrderEquipment * equip = _equipments[_curIndex];
        NSNumber * eqId = [_equipQrcode getEquipmentId];
        if([eqId isEqualToNumber:equip.equipmentId]) {
            res = YES;
        }
    } if (_curIndex == -1) {    //新加设备
        NSNumber * eqId = [_equipQrcode getEquipmentId];
        if(![FMUtils isNumberNullOrZero:eqId]) {
            res = YES;
        }
    }
    return res;
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_equipments count];
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger position = indexPath.row;
    CGFloat padding = 10;
    WorkOrderEquipment * equip = _equipments[position];
    itemHeight = [WorkOrderDetailEquipmentItemView calculateHeightByInfo:equip andWidth:_realWidth andPaddingLeft:padding andPaddingRight:padding];
    return itemHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    UITableViewCell * cell;
    NSString * cellIdentifer;
    
    CGFloat itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    WorkOrderDetailEquipmentItemView * itemView;
    SeperatorView * seperator;
    
    CGFloat padding = 17;
    CGFloat width = _realWidth;
    cellIdentifer = @"Cell";
    WorkOrderEquipment * equip = _equipments[position];
    itemHeight = [WorkOrderDetailEquipmentItemView calculateHeightByInfo:equip andWidth:_realWidth andPaddingLeft:padding andPaddingRight:padding];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            if(!_editable) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[WorkOrderDetailEquipmentItemView class]]) {
                    itemView = subView;
                } else if([subView isKindOfClass:[SeperatorView class]]) {
                    seperator = subView;
                }
            }
        }
        if(cell && !itemView) {
            itemView = [[WorkOrderDetailEquipmentItemView alloc] init];
            [cell addSubview:itemView];
        }
        if(cell && !seperator) {
            seperator = [[SeperatorView alloc] init];
            [cell addSubview:seperator];
        }
        if(seperator) {
            if(position < [_equipments count] - 1) {
                //            if(position < [_orderDetail.workOrderTools count] - 1) {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
            } else {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
        }
        if(itemView) {
            [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
            [itemView setInfoWithCreateCode:equip.equipmentCode
                                       name:equip.equipmentName
                                       desc:equip.failureDesc
                                     repair:equip.repairDesc
                                   finished:equip.finished
                                   needScan:equip.needScan];
        }
   
    return cell;
}


#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if(_editable) {
        if(position >= 0 && position < [_equipments count]) {
            //        if(position >= 0 && position < [_orderDetail.workOrderTools count]) {
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
        DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_notice_delete_equipment" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        alertView.leftBlock = ^(){
            [self requestDeleteEquipment:position];
        };
        alertView.rightBlock = ^(){
            
        };
        [alertView show];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
}


#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_editable) {
        NSInteger position = indexPath.row;
        if(position < [_equipments count]) {
            WorkOrderEquipment * equip = _equipments[position];
            
            if(equip.needScan && !equip.finished) {
                
                [self gotoScanQrCode:position];
            }
            else {
                
                [self gotoEditEquipment:position];
            }
        }
    }
}

#pragma mark - 处理成功
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WriteOrderAddEquipmentViewController class])]) {
            WorkOrderEquipment * equip = [msg valueForKeyPath:@"result"];
            
            [self updateEquipment:equip];
        } else if([strOrigin isEqualToString:NSStringFromClass([WriteOrderEquipmentExViewController class])]) {
            WorkOrderEquipment * equip = [msg valueForKeyPath:@"result"];
            
            [self updateEquipment:equip];
        }
    }
}

#pragma marl - 网络上传
- (void) requestDeleteEquipment:(NSInteger) position {   
    [self showLoadingDialog];
    WorkOrderEquipment * equipment = _equipments[position];
    WorkOrderEquipmentEditRequestParam * param = [[WorkOrderEquipmentEditRequestParam alloc] init];
    param.woId = _woId;
    param.equipmentId = equipment.equipmentId;
    param.operateType = WORK_ORDER_EQUIPMENT_TYPE_DELETE;
    [_business saveOrderEquipment:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [_equipments removeObjectAtIndex:position];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateList];
        });
        
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_equipment_delete_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}


- (void) updateEquipment:(WorkOrderEquipment *) equip {
    NSInteger count = [_equipments count];
    
    if(_curIndex >= 0 && _curIndex < count) {
        WorkOrderEquipment * eq = _equipments[_curIndex];
        eq.failureDesc = equip.failureDesc;
        eq.repairDesc = equip.repairDesc;
        eq.finished = YES;
        _equipments[_curIndex] = eq;
    } else {
        [_equipments addObject:equip];
    }
}

- (NSMutableArray *) getEquipmentIds {
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    for(WorkOrderEquipment * equip in _equipments) {
        [ids addObject:[equip.equipmentId copy]];
    }
    return ids;
}

#pragma mark - 二维码扫描结果
- (void) onQrCodeScanFinished:(NSString *)result {
    _equipQrcode = [[EquipmentQrcode alloc] initWithString:result];
    _backFromQrcode = YES;
}

//根据编码查询设备是否存在
- (BOOL) isEquipExistByCode:(NSString *) code {
    BOOL res = NO;
    for(WorkOrderEquipment * equip in _equipments) {
        if(![FMUtils isStringEmpty:code] && [code isEqualToString:equip.equipmentCode]) {
            res = YES;
        }
    }
    return res;
}

#pragma mark - 页面跳转
- (void) gotoEditEquipment:(NSInteger) position {
    NSLog(@"编辑故障设备");
    if(position >=0 && position < [_equipments count]) {
        _curIndex = position;
        WorkOrderEquipment * equip = _equipments[position];
//        WriteOrderAddEquipmentViewController * editVC = [[WriteOrderAddEquipmentViewController alloc] initWithType:ORDER_EQUIPMENT_OPERATE_TYPE_EDIT andTitleName:equip.equipmentName];
        WriteOrderEquipmentExViewController * editVC = [[WriteOrderEquipmentExViewController alloc] initWithType:ORDER_EQUIPMENT_OPERATE_TYPE_EDIT andTitleName:equip.equipmentName];
        
        [editVC setInfoWith:equip];
        [editVC setWorkOrderId:_woId];
        [editVC setOnMessageHandleListener:self];
        [self gotoViewController:editVC];
    }
}

- (void) gotoAddEquipment {
//    WriteOrderAddEquipmentViewController * vc = [[WriteOrderAddEquipmentViewController alloc] initWithType:ORDER_EQUIPMENT_OPERATE_TYPE_ADD andTitleName:nil];
    WriteOrderEquipmentExViewController * vc = [[WriteOrderEquipmentExViewController alloc] initWithType:ORDER_EQUIPMENT_OPERATE_TYPE_ADD andTitleName:nil];
    _curIndex = -1;
    [vc setWorkOrderId:_woId];
    [vc setOnMessageHandleListener:self];
    [vc setEquipmentArrayWithIds:[self getEquipmentIds]];
    [self gotoViewController:vc];
}

- (void) gotoScanQrCode:(NSInteger) position {
    _curIndex = position;
    QrCodeViewController * vc = [[QrCodeViewController alloc] init];
    [vc setOnQrCodeScanFinishedListener:self];
    [self gotoViewController:vc];
}

@end
