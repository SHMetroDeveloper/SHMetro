//
//  WorkOrderDetailToolViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailToolViewController.h"
#import "WriteOrderAddToolViewController.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "WorkOrderDetailToolItemView.h"
#import "CostSumView.h"
#import "ImageItemView.h"
#import "WorkOrderBusiness.h"
#import "WorkOrderDetailEntity.h"
#import "DXAlertView.h"


@interface WorkOrderDetailToolViewController () <UITableViewDelegate, UITableViewDataSource, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * toolTableView;

@property (readwrite, nonatomic, strong) ImageItemView * noticeView;    //提示

@property (readwrite, nonatomic, strong) NSMutableArray * tools;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat toolItemHeight;
@property (readwrite, nonatomic, assign) CGFloat sumItemHeight;

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;

@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, assign) NSInteger position;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) WorkOrderDetail * orderDetail;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailToolViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_detail_tool" inTable:nil]];
    if(_editable) {
        NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_add" inTable:nil],  nil];
        [self setMenuWithArray:menus];
    }
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self requestData];
}

- (void) initLayout {
    if(!_mainContainerView) {
        _orderDetail = [[WorkOrderDetail alloc] init];
        _business = [WorkOrderBusiness getInstance];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _toolItemHeight = 70;
        _sumItemHeight = 60;
        
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _toolTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        
        _toolTableView.delegate = self;
        _toolTableView.dataSource = self;
        _toolTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _toolTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _noticeView = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight - _noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeView setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"order_tool_no_data" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        [_noticeView setHidden:YES];
        [_noticeView setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeView setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
        
        [_mainContainerView addSubview:_toolTableView];
        [_mainContainerView addSubview:_noticeView];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self gotoAddTool];
}

- (void) updateNotice {
    if([_tools count] > 0) {
        [_noticeView setHidden:YES];
        [_toolTableView setHidden:NO];
    } else {
        [_noticeView setHidden:NO];
        [_toolTableView setHidden:YES];
    }
}

- (void) setInfoWithTools:(NSArray *)tools {
    if(!_tools) {
        _tools = [[NSMutableArray alloc] init];
    } else {
        [_tools removeAllObjects];
    }
    [_tools addObjectsFromArray:tools];
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
    for(WorkOrderTool * tool in _tools) {
        if(tool.cost) {
            tmpNumber = [FMUtils stringToNumber:tool.amount];
            sum += (tool.cost.floatValue * tmpNumber.floatValue);
        }
    }
    NSString * strSum = [[NSString alloc] initWithFormat:@"%.2f", sum];
    return strSum;
}

- (void) updateList {
    [self updateNotice];
    [self notifyToolUpdate];
    [_toolTableView reloadData];
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_tools count] + 1;
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    if(position < [_tools count]) {
        height = _toolItemHeight;
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
    WorkOrderDetailToolItemView * toolItemView;
    SeperatorView * seperator;
    CostSumView * sumItemView;
    
    CGFloat padding = 17;
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    if(position < [_tools count]) {
        cellIdentifer = @"CellTool";
        itemHeight = _toolItemHeight;
        WorkOrderTool * tool = _tools[position];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
            if(!_editable) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[WorkOrderDetailToolItemView class]]) {
                    toolItemView = subView;
                } else if([subView isKindOfClass:[SeperatorView class]]) {
                    seperator = subView;
                }
            }
        }
        if(cell && !toolItemView) {
            toolItemView = [[WorkOrderDetailToolItemView alloc] init];
            [cell addSubview:toolItemView];
        }
        if(cell && !seperator) {
            seperator = [[SeperatorView alloc] init];
            [cell addSubview:seperator];
        }
        if(seperator) {
            if(position < [_tools count] - 1) {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
            } else {
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
        }
        if(toolItemView) {
            [toolItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
            [toolItemView setInfoWithCreateName:tool.name
                                          model:tool.model
                                          brand:nil
                                           unit:tool.unit
                                          count:[tool.amount integerValue]
                                           cost:tool.cost.floatValue
                                           desc:tool.comment];
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
    
    return cell;
}


#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if(_editable) {
        if(position >= 0 && position < [_tools count]) {
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
        if(position >= 0 && position < [_tools count]) {
            DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"notice_tool_delete" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
            alertView.leftBlock = ^(){
                [self deleteToolatIndex:position andTodo:^{
                    [_tools removeObjectAtIndex:position];
                    [self updateList];
                }];
            };
            alertView.rightBlock = ^(){
            };
            [alertView show];
        }
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
        if(position < [_tools count]) {
            [self gotoEditTool:position];
        }
    }
}

#pragma mark - 数据更新
- (void) notifyToolUpdate {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:_tools forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}


#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([WriteOrderAddToolViewController class])]) {
            WorkOrderTool * tool = [msg valueForKeyPath:@"result"];
            if(_tag == ORDER_TOOL_OPERATE_TYPE_ADD) {
                if(!_tools) {
                    _tools = [[NSMutableArray alloc] init];
                }
                [_tools addObject:tool];
            } else if(_tag == ORDER_TOOL_OPERATE_TYPE_EDIT){
                if(_position < [_tools count]) {
                    _tools[_position] = tool;
                }
            }
            [self updateList];
//            [self notifyToolUpdate];
        }
    }
}

#pragma mark - 操作工具
//添加工具
- (void) gotoAddTool {
    WriteOrderAddToolViewController * addVC = [[WriteOrderAddToolViewController alloc] initWithOperateType:ORDER_TOOL_OPERATE_TYPE_ADD];
    _tag = ORDER_TOOL_OPERATE_TYPE_ADD;
    [addVC setWorkOrderId:_woId];
    [addVC setOnMessageHandleListener:self];
    [self gotoViewController:addVC];
}
//编辑工具
- (void) gotoEditTool:(NSInteger) position {
    WorkOrderTool * tool = _tools[position];
    WriteOrderAddToolViewController * editVC = [[WriteOrderAddToolViewController alloc] initWithOperateType:ORDER_TOOL_OPERATE_TYPE_EDIT];
    _tag = ORDER_TOOL_OPERATE_TYPE_EDIT;
    _position = position;
    [editVC setInfoWith:tool];
    [editVC setWorkOrderId:_woId];
    [editVC setOnMessageHandleListener:self];
    [self gotoViewController:editVC];
}


#pragma mark 删除工具
- (void) deleteToolatIndex:(NSInteger)position andTodo:(void(^)(void)) finishBlock {
    [self showLoadingDialog];
    WorkOrderTool * tool = _tools[position];
    WorkOrderToolSaveRequestParam * param = [[WorkOrderToolSaveRequestParam alloc] init];
    param.woId = _woId;
    param.operateType = WORK_ORDER_TOOL_EDIT_TYPE_DELETE;
    param.toolId = tool.toolId;
    param.name = tool.name;
    param.model = tool.model;
    param.unit = tool.unit;
    param.amount = [tool.amount floatValue];
    param.cost = tool.cost.doubleValue;
    param.comment = tool.comment;

    [_business saveWorkOrderTools:param  success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_tools_delete_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        finishBlock();
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"tips_title" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_tools_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

//#pragma mark - 网络请求
//- (void) requestData {
//    [self showLoadingDialog];
//    if (!_tools) {
//        _tools = [[NSMutableArray alloc] init];
//    }
//    [_business getDetailInfoOfOrder:_woId success:^(NSInteger key, id object) {
//        [self hideLoadingDialog];
//        _orderDetail = object;
//        _tools = _orderDetail.workOrderTools;
//        [self updateList];
//    } fail:^(NSInteger key, NSError *error) {
//        [self hideLoadingDialog];
//        _tools = _orderDetail.workOrderTools;
//        [self updateList];
//    }];
//}

@end


