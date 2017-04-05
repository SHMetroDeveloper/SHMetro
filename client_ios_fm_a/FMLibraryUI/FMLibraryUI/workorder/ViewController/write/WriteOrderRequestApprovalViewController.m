//
//  WriteOrderRequestApprovalViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WriteOrderRequestApprovalViewController.h"
#import "BaseTextView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "SystemConfig.h"
#import "BaseTextView.h"
#import "ApproverItemView.h"
#import "SeperatorView.h"
#import "InfoSelectViewController.h"
#import "WorkOrderApproverEntity.h"
#import "ApplyApprovalWorkOrderEntity.h"
#import "WorkOrderBusiness.h"
#import "DXAlertView.h"
#import "MultiSelectViewController.h"

typedef NS_ENUM(NSInteger, ApprovalRequestSectionType) {
    WO_APPROVAL_SECTION_UNKNOW,
    WO_APPROVAL_SECTION_REASON,     //审批事由
    WO_APPROVAL_SECTION_APPROVER,   //审批人
};

@interface WriteOrderRequestApprovalViewController () <UITableViewDelegate, UITableViewDataSource, OnViewResizeListener, OnMessageHandleListener, OnItemClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * approvalTableView;
//@property (readwrite, nonatomic, strong) UIImageView * addImgView;
@property (readwrite, nonatomic, strong) UIButton * addBtn;
@property (readwrite, nonatomic, strong) BaseTextView * reasonTextView;
@property (readwrite, nonatomic, strong) SeperatorView * reasonSeperator;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSNumber * orderId;
@property (readwrite, nonatomic, strong) NSMutableArray * approvers;
@property (readwrite, nonatomic, strong) NSMutableArray * selectArray;
@property (readwrite, nonatomic, strong) NSString * reason;

@property (readwrite, nonatomic, assign) CGFloat minReasonHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat approverHeight;
@property (readwrite, nonatomic, assign) CGFloat approverAddHeight;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, assign) WorkOrderBusinessType requestType; //数据请求类型

@property (readwrite, nonatomic, strong) NodeList * approverList;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WriteOrderRequestApprovalViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_approval_request" inTable:nil]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_submit" inTable:nil],  nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    _approvers = [[NSMutableArray alloc] init];
    _selectArray = [NSMutableArray new];
    
    _minReasonHeight = 160;
    _headerHeight = 45;
    _approverHeight = 50;
    _approverAddHeight = 80;
    _imgWidth = 40;
    
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _approvalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
    _approvalTableView.delegate = self;
    _approvalTableView.dataSource = self;
    _approvalTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _approvalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_mainContainerView addSubview:_approvalTableView];
    
    
    [self.view addSubview:_mainContainerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _business = [WorkOrderBusiness getInstance];
    
    [self requestApprovers];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setInfoWithOrderId:(NSNumber *)orderId {
    _orderId = [orderId copy];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) notifyRequestSuccess {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:@"finish" forKeyPath:@"requestType"];
        [_handler handleMessage:msg];
    }
}

- (void) onMenuItemClicked:(NSInteger)position {
    [self requestApprovalWorkOrder];
}

- (void) updateList {
    [_approvalTableView reloadData];
    [_reasonTextView becomeFirstResponder];
}

- (ApprovalRequestSectionType) getSectionTypeBySection:(NSInteger) section {
    ApprovalRequestSectionType sectionType = WO_APPROVAL_SECTION_UNKNOW;
    switch (section) {
        case 0:
            sectionType = WO_APPROVAL_SECTION_REASON;
            break;
        case 1:
            sectionType = WO_APPROVAL_SECTION_APPROVER;
            break;
            
        default:
            break;
    }
    return sectionType;
}

#pragma mark - datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 2;
    return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    ApprovalRequestSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case WO_APPROVAL_SECTION_REASON:
            count = 1;
            break;
        case WO_APPROVAL_SECTION_APPROVER:
            count = [_approvers count] + 1;
            break;
            
        default:
            break;
    }
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ApprovalRequestSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case WO_APPROVAL_SECTION_REASON:
            height = CGRectGetHeight(_reasonTextView.frame);
            if(height < _minReasonHeight) {
                height = _minReasonHeight;
            }
            break;
        case WO_APPROVAL_SECTION_APPROVER:
            if(position < [_approvers count]) {
                height = _approverHeight;
            } else if(position == [_approvers count]) {
                height = _approverAddHeight;
            }
            break;
            
        default:
            break;
    }

    return height;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = _headerHeight;
    
    return height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    CGFloat paddingTop = 7;
    CGFloat paddingLeft = 17;
    UILabel * headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, paddingTop, _realWidth-paddingLeft * 2, _headerHeight - paddingTop)];
    headerLbl.font = [FMFont getInstance].defaultFontLevel2;
    headerLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    NSString * strHeader;
    ApprovalRequestSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case WO_APPROVAL_SECTION_REASON:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"order_approval_problem" inTable:nil];
            break;
        case WO_APPROVAL_SECTION_APPROVER:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"order_approval_person" inTable:nil];
            break;
            
        default:
            break;
    }
    [headerLbl setText:strHeader];
    [headerView addSubview:headerLbl];
    return headerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    NSString * cellIdentifier;
    UITableViewCell * cell;
    CGFloat itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = 17;
    CGFloat width = _realWidth;
    ApprovalRequestSectionType sectionType = [self getSectionTypeBySection:section];
    ApproverItemView * approverItemView;
    SeperatorView * seperator;
    switch (sectionType) {
        case WO_APPROVAL_SECTION_REASON:
            cellIdentifier = @"CellReason";
            itemHeight = CGRectGetHeight(_reasonTextView.frame);
            if(itemHeight < _minReasonHeight) {
                itemHeight = _minReasonHeight;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            if(cell && !_reasonTextView) {
                _reasonTextView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [_reasonTextView setOnViewResizeListener:self];
                [_reasonTextView setShowBounds:NO];
                [_reasonTextView setMinHeight:_minReasonHeight];
                [_reasonTextView setMaxTextLength:1000];
                [_reasonTextView setPaddingLeft:padding-5];
                
                [_reasonTextView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"order_approval_reason_placeholder" inTable:nil]];
                
                _reasonSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                
                [cell addSubview:_reasonTextView];
                [cell addSubview:_reasonSeperator];
            }
            else {
                [_reasonSeperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
            }
            break;
        case WO_APPROVAL_SECTION_APPROVER:
            if(position < [_approvers count]) { //审批人
                cellIdentifier = @"CellApprover";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                itemHeight = _approverHeight;
                WorkOrderApprover * approver = _approvers[position];
                NSString * name = approver.name;
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[ApproverItemView class]]) {
                            approverItemView = view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = view;
                        }
                    }
                }
                if(cell && !approverItemView) {
                    approverItemView  = [[ApproverItemView alloc] init];
                    [approverItemView setOnItemClickListener:self];
                    [cell addSubview:approverItemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
                    
                }
                if(approverItemView) {
                    approverItemView.tag = position;
                    [approverItemView setFrame:CGRectMake(0, 0, width, itemHeight)];
                    [approverItemView setInfoWithName:name];
                }
            } else {    //添加按钮
                cellIdentifier = @"CellApproverAdd";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                itemHeight = _approverAddHeight;
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    NSArray * subViews = [cell subviews];
                    for(id view in subViews) {
                        if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = view;
                        }
                    }
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] init];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                }
                if(cell && !_addBtn) {
                    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-_imgWidth-padding, (itemHeight -_imgWidth)/2, _imgWidth, _imgWidth)];
                    [_addBtn setImage:[[FMTheme getInstance] getImageByName:@"add_blue"] forState:UIControlStateNormal];
                    [_addBtn setImage:[[FMTheme getInstance] getImageByName:@"addmore"] forState:UIControlStateHighlighted];
                    [_addBtn addTarget:self action:@selector(onAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell addSubview:_addBtn];
                }
            }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - onItemClick
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[ApproverItemView class]]) {
        NSInteger position = view.tag;
        if(subView) {
            ApproverItemActionType type = subView.tag;
            
            if(type == APPROVER_ACTION_DELETE) {
                DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_notice_delete_approver" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
                
                alertView.leftBlock = ^(){
                    [_approvers removeObjectAtIndex:position];
                    [self updateList];
                };
                alertView.rightBlock = ^(){
                };
                alertView.dismissBlock = ^(){};
                [alertView show];
            }
        }
    }
}

#pragma mark - view resize
- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    if(view == _reasonTextView) {
        CGRect frame = _reasonTextView.frame;
        frame.size = newSize;
        _reasonTextView.frame = frame;
//        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:0];
//        NSArray * rows  = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [_approvalTableView reloadRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
//        [_reasonTextView becomeFirstResponder];
        [self updateList];
    }
}

#pragma mark - 添加审批人
- (void) onAddBtnClicked:(UITapGestureRecognizer *) gesture {
    [self gotoApprovalLaborerSelect];
}

//判断审批人是否存在
- (BOOL) isApprovalLaborerExist:(NSNumber *) approverId {
    BOOL res = NO;
    if(_approvers) {
        for(WorkOrderApprover * approver in _approvers) {
            if([approver.approverId isEqualToNumber:approverId]) {
                res = YES;
                break;
            }
        }
    }
    return res;
}

#pragma mark - handle message 
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([MultiSelectViewController class])]) {
            NSMutableArray *nodeArray = [msg valueForKeyPath:@"result"];
            if (!_approvers) {
                _approvers = [NSMutableArray new];
            } else {
                [_approvers removeAllObjects];
            }
            if (!_selectArray) {
                _selectArray = [NSMutableArray new];
            } else {
                [_selectArray removeAllObjects];
            }
            
            if(nodeArray.count > 0) {
                WorkOrderApprover * approver;
                for (NodeItem * node in nodeArray) {
                    approver = [[WorkOrderApprover alloc] init];
                    approver.approverId = [NSNumber numberWithInteger:[node getKey]];
                    approver.name = [[node getVal] copy];
                    [_approvers addObject:approver];
                    [_selectArray addObject:node];
                }
            }
        }
    }
}

#pragma mark - 页面跳转
//选择审批人
- (void) gotoApprovalLaborerSelect {
//    InfoSelectViewController * viewController = [[InfoSelectViewController alloc] initWithRequestType:REQUEST_TYPE_APPROVAL_LABORER_INFO_SELECT];
//    [viewController setSelectDataByArray:_selectArray];
//    [viewController setOnMessageHandleListener:self];
//    [self gotoViewController:viewController];
    
    MultiSelectViewController * vc = [[MultiSelectViewController alloc] init];
    [vc setInfoWith:_approverList];
    [vc setOnMessageHandleListener:self];
    [vc setSelectDataByArray:[self getSelectApproverArray]];
    [self gotoViewController:vc];
}

#pragma mark - 网络请求
- (void) requestApprovers {
    if(_business) {
        NSNumber* userId = [SystemConfig getEmployeeId];
        [_business getApproversByUserId:userId success:^(NSInteger key, id object) {
            NSMutableArray * approvers = object;
            if([approvers count] > 0) {
                _approverList = [self getApprovalLaborerList:approvers];
            }
            NSLog(@"获取审批人信息成功");
        } fail:^(NSInteger key, NSError *error) {
            NSLog(@"获取审批人信息失败");
        }];
    }
}

- (NodeList *) getApprovalLaborerList:(NSMutableArray *) approvers {
    NodeList * nodes = [[NodeList alloc] init];
    for(WorkOrderApprover * approver in approvers) {
        NodeItem * item = [[NodeItem alloc] initWith:0 key:[approver.approverId integerValue] value:approver.name level:1];
        [nodes addNode:item];
        
    }
    [nodes setDesc:[[BaseBundle getInstance] getStringByKey:@"function_info_select_approver" inTable:nil]];
    [nodes addNodeLevel:1];
    return nodes;
}


- (NSMutableArray *) getSelectApproverArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for(WorkOrderApprover * approver in _approvers) {
        NodeItem * node = [[NodeItem alloc] initWith:approver.approverId.longLongValue value:approver.name];
        
        [array addObject:node];
    }
    return array;
}


- (void) requestApprovalWorkOrder {
    NSMutableArray * approvers = [[NSMutableArray alloc] init];
    ApplyApprovalContent * content = [[ApplyApprovalContent alloc] init];
    NSString * strDesc = [_reasonTextView getContent];
    
    for(WorkOrderApprover * approver in _approvers) {
        [approvers addObject:approver.approverId];
    }
    if([approvers count] == 0) {
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_designate_approver" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        return;
    }
    ApplyApprovalParamItem * item = [[ApplyApprovalParamItem alloc] init];
    item.name = [[BaseBundle getInstance] getStringByKey:@"order_approval_desc" inTable:nil];
    item.value = strDesc;
    [content.parameters addObject:item];
    _requestType = BUSINESS_WO_OPERATE_REQUEST_APPROVAL;
    if(_business) {
        [self showLoadingDialog];
        [_business requestApprovalWithApprovers:approvers approvalContent:content orderId:_orderId success:^(NSInteger key, id object) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_request_approval_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self hideLoadingDialog];
//            [self notifyRequestSuccess];
            [self notifyOrderStatusChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //回退两级
                [self backToParentWithLevel:2];
            });
        } fail:^(NSInteger key, NSError *error) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_request_approval_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [self hideLoadingDialog];
        }];
    }

}

#pragma mark - 键盘显示
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        [_approvalTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight-keyboardSize.height)];
        [_reasonTextView becomeFirstResponder];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [_approvalTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
}

#pragma mark - 通知工单列表刷新
- (void) notifyOrderStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMOrderStatusUpdate" object:nil];
}

@end
