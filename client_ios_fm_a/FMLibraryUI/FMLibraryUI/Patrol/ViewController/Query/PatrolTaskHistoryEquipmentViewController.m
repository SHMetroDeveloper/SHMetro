//
//  PatrolTaskHistoryEquipmentViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskHistoryEquipmentViewController.h"
#import "FMTheme.h"
#import "PatrolHistoryEquipmentBaseInfoView.h"
#import "PatrolHistoryEquipmentContentItemView.h"
#import "PatrolHistoryEquipmentOrderItemView.h"
#import "SeperatorView.h"
#import "MarkedListHeaderView.h"
#import "WorkOrderDetailViewController.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "WorkOrderServerConfig.h"

#import "NewReportViewController.h"
#import "PowerManager.h"
#import "ReportFunctionPermission.h"
#import "MenuAlertContentView.h"
#import "TaskAlertView.h"
#import "PhotoShowHelper.h"
#import "PatrolBusiness.h"
#import "QuickReportViewController.h"

typedef enum {
    EQUIP_SECTION_TYPE_UNKNOW,
    EQUIP_SECTION_TYPE_INFO,    //设备信息
    EQUIP_SECTION_TYPE_CONTENT, //设备内容
    EQUIP_SECTION_TYPE_ORDER    //工单列表
}PatrolHistoryEquipSectionType;

@interface PatrolTaskHistoryEquipmentViewController () <OnMessageHandleListener, OnClickListener>
@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;


@property (readwrite, nonatomic, strong) PatrolTaskHistoryEquipment * equip;
@property (readwrite, nonatomic, strong) Position * location;

@property (readwrite, nonatomic, assign) CGFloat infoItemHeight;
@property (readwrite, nonatomic, assign) CGFloat contentItemHeight;
@property (readwrite, nonatomic, assign) CGFloat orderItemHeight;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) BOOL needBack;
@property (readwrite, nonatomic, assign) NSInteger curIndex;

@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;   //事件处理


@property (readwrite, nonatomic, strong) PowerManager * manager;

@property (readwrite, nonatomic, strong) TaskAlertView * alertView; //弹出框
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度

@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;
@property (readwrite, nonatomic, strong) PatrolBusiness * business;
@end


@implementation PatrolTaskHistoryEquipmentViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    if(_equip) {
        if([_equip.eqId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            [self setTitleWith:[[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_comprehensive" inTable:nil]]];
        } else {
            [self setTitleWith: _equip.code];
        }
    } else {
        [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"patrol_device" inTable:nil]];
    }
    [self setBackAble:YES];
}


- (void) initLayout {
    if(!_mainContainerView) {
        
        _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        _business = [[PatrolBusiness alloc] init];
        
        _infoItemHeight = 100;
        _contentItemHeight = 120;
        _orderItemHeight = 60;
        
        _headerHeight = [FMSize getInstance].listHeaderHeight;
        _footerHeight = 15;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        [_mainContainerView addSubview:_tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initFunctionPermissionUpdateHandler];
    [self initPermission];
    [self initAlertView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void) initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat contentHeight = 300;
    
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:(contentHeight + 40)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
}

- (void) initPermission {
    _manager = [PowerManager getInstance];
}

- (void) initFunctionPermissionUpdateHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FunctionPermissionUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateFunctionPermission)
                                                 name: @"FunctionPermissionUpdate"
                                               object: nil];
}

- (void) updateFunctionPermission {
    [self updateList];
}

- (BOOL) canReport {
    BOOL res = YES;
//    FunctionPermission * permission = [_manager getFunctionPermissionByKey:REPORT_FUNCTION];
//    if(permission) {
//        res = [permission getPermissionType] != FUNCTION_ACCESS_PERMISSION_NONE;
//    }
    return res;
    
}

- (void) setInfoWithEquipment:(PatrolTaskHistoryEquipment *) equip andLocation:(Position *) location{
    _equip = equip;
    _location = location;
}

- (void) updateList {
    [_tableView reloadData];
}

- (void) markCurrentContentProcessed {
    if(_curIndex >= 0 && _curIndex < [_equip.patrolTaskItemDetails count]) {
        PatrolTaskHistoryContentItem * content = _equip.patrolTaskItemDetails[_curIndex];
        content.processed = YES;
        _equip.patrolTaskItemDetails[_curIndex] = content;
        [self updateList];
    }
}

- (PatrolHistoryEquipSectionType) getSectionType:(NSInteger) section {
    PatrolHistoryEquipSectionType sectionType = EQUIP_SECTION_TYPE_UNKNOW;
    if(_equip) {
        switch(section) {
            case 0:
                if([_equip.eqId isEqualToNumber:[NSNumber numberWithLong:0]]) {   //综合巡检
                    sectionType = EQUIP_SECTION_TYPE_CONTENT;
                } else {                                                        //设备
                    sectionType = EQUIP_SECTION_TYPE_INFO;
                }
                break;
            case 1:
                if([_equip.eqId isEqualToNumber:[NSNumber numberWithLong:0]]) {
                    sectionType = EQUIP_SECTION_TYPE_ORDER;
                } else {
                    sectionType = EQUIP_SECTION_TYPE_CONTENT;
                }
                break;
            case 2:
                sectionType = EQUIP_SECTION_TYPE_ORDER;
                break;
            default:
                sectionType = EQUIP_SECTION_TYPE_UNKNOW;
                break;
        }
    }
    
    return sectionType;
}



- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[PatrolHistoryEquipmentContentItemView class]]) {
        if(subView) {
            PatrolHistoryContentItemEventType type = subView.tag;
            NSInteger position = view.tag;
            _curIndex = position;
            PatrolTaskHistoryContentItem * content = _equip.patrolTaskItemDetails[position];
            switch(type) {
                case PATROL_HISTORY_CONTENT_ITEM_EVENT_SHOW_PHOTO:
                    [self gotoShowPhoto:position];
                    break;
                case PATROL_HISTORY_CONTENT_ITEM_EVENT_PROCESS:
                    if(content.processed) {
                        [self showReportControlMenu];
                    } else {
                        [self showProcessControlMenu];
                    }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
}

- (void) showReportControlMenu {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"patrol_item_operate_report" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler reportHandler = ^(UIAlertAction * action) {
        [weakSelf gotoReportViewController:_curIndex];
    };
    
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:reportHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

- (void) showProcessControlMenu {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"patrol_item_operate_report" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"patrol_item_operate_mark" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler reportHandler = ^(UIAlertAction * action) {
        [weakSelf gotoReportViewController:_curIndex];
    };
    ActionHandler markHandler = ^(UIAlertAction * action) {
        [weakSelf requestMarkItem:_curIndex];
    };
    
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:reportHandler, markHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

#pragma mark - 显示菜单
- (void) showControlWithMenuTexts:(NSMutableArray *) textArray handlers:(NSMutableArray *) handlers{
    _actionHandlerArray = handlers;
    BOOL showCancel = YES;
    CGFloat height = [MenuAlertContentView calculateHeightByCount:[textArray count] showCancel:showCancel];
    [_menuContentView setMenuWithArray:textArray];
    [_menuContentView setShowCancelMenu:showCancel];
    [_alertView setContentHeight:height withKey:@"menu"];
    [_alertView showType:@"menu"];
    [_alertView show];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    if(_equip) {
        if([_equip.eqId isEqualToNumber:[NSNumber numberWithLong:0]]) {
            return 2;           //综合巡检没有设备信息项
        } else {
            return 3;
        }
    }
    return 0;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    if(_equip) {
        switch(sectionType) {
            case EQUIP_SECTION_TYPE_INFO:
                count = 2;
                break;
            case EQUIP_SECTION_TYPE_CONTENT:
                if([_equip.patrolTaskItemDetails count] > 0) {
                    count = [_equip.patrolTaskItemDetails count] + 1;
                }
                break;
            case EQUIP_SECTION_TYPE_ORDER:
                if([_equip.orders count] > 0) {
                    count = [_equip.orders count] + 1;
                }
                break;
                
            default:
                break;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    CGFloat width = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    width = self.view.frame.size.width;
    switch(sectionType) {
        case EQUIP_SECTION_TYPE_INFO:
            
            height = _footerHeight;
            if(position == 0) {
                height = [PatrolHistoryEquipmentBaseInfoView getBaseInfoHeight];
            }
            break;
        case EQUIP_SECTION_TYPE_CONTENT:
            height = _footerHeight;
            if(position < [_equip.patrolTaskItemDetails count]) {
                PatrolTaskHistoryContentItem * item = _equip.patrolTaskItemDetails[position];
                height = [PatrolHistoryEquipmentContentItemView calculateHeightByTitle:item.content andResult:item.result andDesc:item.comment andWidth:width showIgnore:NO showException:[item isException] showReportButton:[item isException]];
            }
            break;
        case EQUIP_SECTION_TYPE_ORDER:
            height = _footerHeight;
            if(position < [_equip.orders count]) {
                height = _orderItemHeight;
            }
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = nil;
    PatrolHistoryEquipmentBaseInfoView * infoItemView = nil;
    PatrolHistoryEquipmentContentItemView * contentItemView = nil;
    PatrolHistoryEquipmentOrderItemView * orderItemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = self.view.frame.size.width;
    BOOL isFooter = NO;
    CGFloat itemHeight = 0;
    CGFloat paddingLeft = _paddingLeft;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    switch(sectionType) {
        case EQUIP_SECTION_TYPE_INFO:           //基本信息
            if(position == 0) {
                cellIdentifier = @"CellCommon";
//                itemHeight = _infoItemHeight;
                itemHeight = [PatrolHistoryEquipmentBaseInfoView getBaseInfoHeight];
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[PatrolHistoryEquipmentBaseInfoView class]]) {
                            infoItemView = (PatrolHistoryEquipmentBaseInfoView *) view;
                        }
                        if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if(cell && !infoItemView) {
                    infoItemView = [[PatrolHistoryEquipmentBaseInfoView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [infoItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    [cell addSubview:infoItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    [cell addSubview:seperator];
                } else {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                }
                if(infoItemView) {
                    infoItemView.tag = position;
                    NSString * strName = _equip.name;
                    [infoItemView setInfoWithDeviceName:strName andSystemName:[_equip getSystemName]];
                    
                    [infoItemView setExceptionStatus:_equip.exceptionStatus.integerValue];
                }
            } else {
                isFooter = YES;
            }
            break;
            
        case EQUIP_SECTION_TYPE_CONTENT:           //工作内容
            if(position < [_equip.patrolTaskItemDetails count]) {
                cellIdentifier = @"CellContent";
                PatrolTaskHistoryContentItem * item = _equip.patrolTaskItemDetails[position];
                NSString * strResult;
                
                strResult = item.result;
                
                itemHeight = [PatrolHistoryEquipmentContentItemView calculateHeightByTitle:item.content andResult:strResult andDesc:item.comment andWidth:width showIgnore:NO showException:[item isException] showReportButton:[item isException]];
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[PatrolHistoryEquipmentContentItemView class]]) {
                            contentItemView = view;
                        } else if ([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if(cell && !contentItemView) {
                    contentItemView = [[PatrolHistoryEquipmentContentItemView alloc] init];
                    [contentItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    [contentItemView setOnItemClickListener:self];
                    [cell addSubview:contentItemView];
                }
                if(cell && !seperator){
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_equip.patrolTaskItemDetails count] - 1) {
                        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
                        [seperator setDotted:YES];
                    } else {
                        [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                        [seperator setDotted:NO];
                    }
                    
                }
                if(contentItemView) {
                    BOOL report = [item isException] && [self canReport];
                    contentItemView.tag = position;
                    [contentItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [contentItemView setInfoWithTitle:item.content andResult:strResult desc:item.comment hasPhoto:[item hasPhoto] hasIgnore:[item isLeak] hasException:[item isException] hasProcessed:item.processed showReport:[item isException]];
                    if([item hasPhoto]) {
                        [contentItemView setImages:item.imageIds];
                    }
                }
            } else {
                isFooter = YES;
            }
            break;
        case EQUIP_SECTION_TYPE_ORDER:      //关联工单
            if(position < [_equip.orders count]) {
                PatrolTaskHistoryOrderItem * order = _equip.orders[position];
                cellIdentifier = @"CellOrder";
                itemHeight = _orderItemHeight;
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[PatrolHistoryEquipmentOrderItemView class]]) {
                            orderItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *) view;
                        }
                    }
                }
                if(cell && !orderItemView) {
                    orderItemView = [[PatrolHistoryEquipmentOrderItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
//                    [orderItemView setPaddingLeft:paddingLeft andPaddingRight:paddingLeft];
                    [cell addSubview:orderItemView];
                    
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_equip.orders count] - 1) {
                        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
                    } else {
                        [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                    }
                }
                if(orderItemView) {
                    orderItemView.tag = position;
                    NSString * status = [WorkOrderServerConfig getOrderStatusDesc:order.status];
                    [orderItemView setInfoWithCode:order.code andLaborder:order.requestor andTime:[order getCreateTimeString] andStatus:status];
                }
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
            UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _footerHeight)];
            footerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            [cell addSubview:footerView];
            
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    CGFloat width = CGRectGetWidth(self.view.frame);
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    NSString* strHeader = nil;
    switch(sectionType) {
        case EQUIP_SECTION_TYPE_INFO:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"patrol_device_info" inTable:nil];
            [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowMark:YES];
            break;
        case EQUIP_SECTION_TYPE_CONTENT:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_content" inTable:nil];
            [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowMark:YES];
            break;
        case EQUIP_SECTION_TYPE_ORDER:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"patrol_order_list" inTable:nil];
            [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
            [headerView setShowMark:YES];
            break;
        
        default:
            break;
    }
    return headerView;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case EQUIP_SECTION_TYPE_INFO:
            height = _headerHeight;
            break;
        case EQUIP_SECTION_TYPE_CONTENT:
            if([_equip.patrolTaskItemDetails count] > 0) {
                height = _headerHeight;
            }
            break;
        case EQUIP_SECTION_TYPE_ORDER:
            if([_equip.orders count] > 0) {
                height = _headerHeight;
            }
            break;
            
        default:
            break;
    }
    return height;
}

#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    PatrolHistoryEquipSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case EQUIP_SECTION_TYPE_INFO:
            break;
        case EQUIP_SECTION_TYPE_CONTENT:
            break;
        case EQUIP_SECTION_TYPE_ORDER:
            [self gotoOrderDetail:position];
            break;
        default:
            break;
    }
}

#pragma mark - 消息处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            [_alertView close];
            NSNumber * tmpNumber = [msg valueForKeyPath:@"menuType"];
            MenuAlertViewType type = [tmpNumber integerValue];
            NSInteger position;
            switch(type) {
                case MENU_ALERT_TYPE_NORMAL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    position = tmpNumber.integerValue;
                    if(position < [_actionHandlerArray count]) {
                        ActionHandler handler = _actionHandlerArray[position];
                        handler(nil);
                    }
                    break;
                case MENU_ALERT_TYPE_CANCEL:
                    break;
            }
        }
    }
}

- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [_alertView close];
    }
}

#pragma mark - 网络请求
- (void) requestMarkItem:(NSInteger) position {
    PatrolTaskHistoryContentItem * content = _equip.patrolTaskItemDetails[position];
    if(content.patrolTaskSpotResultId) {
        [self showLoadingDialog];
        [_business requestMarkExceptionContentItem:content.patrolTaskSpotResultId success:^(NSInteger key, id object) {
            [self hideLoadingDialog];
            [self markCurrentContentProcessed];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_item_operate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"patrol_item_operate_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
   
}

#pragma mark - 页面跳转
- (void) gotoOrderDetail:(NSInteger) position {
    NSInteger count = [_equip.orders count];
    if(position >= 0 && position < count) {
        WorkOrderDetailViewController * orderDetailVC = [[WorkOrderDetailViewController alloc] init];
        PatrolTaskHistoryOrderItem * order = _equip.orders[position];
        [orderDetailVC setWorkOrderWithId:order.woId];
        [orderDetailVC setReadOnly:YES];
        [self gotoViewController:orderDetailVC];
    }
}


/**
 前往快速报障页面

 @param position 异常位置
 */
- (void) gotoReportViewController:(NSInteger) position {
    
    PatrolTaskHistoryContentItem * content = _equip.patrolTaskItemDetails[position];
    NSString * desc = content.comment;
    NSNumber * devId = _equip.eqId;
    NSNumber * contentId = content.patrolTaskSpotResultId;
    NSMutableArray * imgs = content.imageIds;
    
    QuickReportViewController *reportVC = [[QuickReportViewController alloc] init];
    [reportVC setInforWithLocation:_location equipment:devId content:contentId desc:desc imgs:imgs];
    [self gotoViewController:reportVC];
}

- (void) gotoShowPhoto:(NSInteger) position {
    PatrolTaskHistoryContentItem * content = _equip.patrolTaskItemDetails[position];
    if(content.imageIds) {
        NSMutableArray * photos = [[NSMutableArray alloc] init];
        for(NSNumber * imgId in content.imageIds) {
            NSURL * url = [FMUtils getUrlOfImageById:imgId];
            [photos addObject:url];
        }
        if([photos count] > 0) {
            [_photoHelper setPhotos:photos];
            [_photoHelper showPhotoWithIndex:0];
        }
    }
}

@end
