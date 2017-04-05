//
//  ContractDetailViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 17/1/4.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractDetailViewController.h"
#import "ContractBusiness.h"
#import "PhotoShowHelper.h"
#import "FMUtilsPackages.h"
#import "ContractDetailTableView.h"
#import "ContractRecordViewController.h"
#import "ContractEquipmentViewController.h"
#import "EquipmentDetailViewController.h"
#import "ContractCheckViewController.h"

#import "AttachmentViewController.h"
#import "PhoneListAlertContentView.h"
#import "MenuAlertContentView.h"
#import "TaskAlertView.h"
#import "BaseAlertView.h"
#import "IQKeyboardManager.h"
#import "ContractOperateContentView.h"
#import "ContractServerConfig.h"


//typedef NS_ENUM(NSInteger, ContractOperationType) {
//    CONTRACT_DETAIL_OPERATION_CLOSE = 0,  //关闭
//    CONTRACT_DETAIL_OPERATION_RECOVERY = 1, //恢复
////    CONTRACT_DETAIL_OPERATION_CHECK_PASSED = 2,  //验收不通过  //这两个操作放到新的页面去操作了
////    CONTRACT_DETAIL_OPERATION_CHECK_UNPASSED = 3,   //验收通过
//    CONTRACT_DETAIL_OPERATION_ARCHIVED = 4  //存档
//};

@interface ContractDetailViewController ()<OnMessageHandleListener,OnClickListener,OnItemClickListener>
@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) ContractDetailTableView *tableView;

@property (nonatomic, strong) NSNumber *contractId;

@property (nonatomic, strong) ContractBusiness *business;  //业务处理
@property (nonatomic, strong) __block ContractDetailEntity *contractDetail;
@property (nonatomic, strong) __block NSMutableArray *equipmentArray;
@property (nonatomic, strong) __block NetPage *netPage;

@property (nonatomic, strong) TaskAlertView *alertView; //弹出框
@property (nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度
@property (nonatomic, strong) MenuAlertContentView *menuContentView;    //菜单界面
@property (nonatomic, strong) NSMutableArray *actionHandlerArray;   //事件处理
@property (nonatomic, strong) ContractOperateContentView *operationContentView;  //操作页面

@property (nonatomic, strong) PhoneListAlertContentView *phoneContentView;    //手机号操作界面
@property (nonatomic, strong) BaseAlertView *centerAlertView;      //用于在屏幕中先弹出的提示框

@property (nonatomic, assign) __block ContractOperationType operateType;
@property (nonatomic, strong) __block NSString *operateDesc;

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) BOOL editable;
@end

@implementation ContractDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestContractDetailData];
    [self requestEquipmentListData];
    [self initAlertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needUpdate) {
        _needUpdate = NO;
        [self requestContractDetailData];
        [self requestEquipmentListData];
    }
}

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_contract_detail" inTable:nil]];
    [self setBackAble:YES];
    
    if (_editable) {
//        [self setMenuWithArray:@[NSLocalizedString(@"contract_detail_operate_title", nil)]];
        NSMutableArray *menus = [[NSMutableArray alloc] initWithObjects:[[FMTheme getInstance] getImageByName:@"menu_more"], nil];
        [self setMenuWithArray:menus];
    } else {
        [self setMenuWithArray:nil];
    }
}

- (void) updateTitle {
    [self initNavigation];
    [self updateNavigationBar];
}

- (void)onMenuItemClicked:(NSInteger)position {
    if (_editable) {
        [self showControlMenue];
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        CGRect frame = [self getContentFrame];
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
        if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
            [manager.disabledDistanceHandlingClasses addObject:[self class]];
        }

        _business = [ContractBusiness getInstance];
        _netPage = [[NetPage alloc] init];
        _equipmentArray = [NSMutableArray new];
        _contractDetail = [[ContractDetailEntity alloc] init];
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _phoneContentView = [[PhoneListAlertContentView alloc] init];
        _phoneContentView.clipsToBounds = YES;
        _phoneContentView.layer.cornerRadius = 3;
        [_phoneContentView setOnPhoneDelegate:self];
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        _operationContentView = [[ContractOperateContentView alloc] init];
        [_operationContentView setOnItemClickListener:self];
        
        [_mainContainerView addSubview:self.tableView];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat itemHeight = 50;
    CGFloat contentHeight = itemHeight * (4 + 1);//附加一个取消按钮
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:contentHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_alertView setContentView:_operationContentView withKey:@"operation" andHeight:250 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    _centerAlertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_centerAlertView setOnClickListener:self];
    [_centerAlertView setPadding:[FMSize getInstance].defaultPadding];
    [_centerAlertView setContentView:_phoneContentView];
    [_centerAlertView setHidden:YES];
    [self.view addSubview:_centerAlertView];
}

#pragma mark - Private Method
- (void)updateDetail {
    [_tableView setContractDetail:_contractDetail];
}

- (void)updateEquipmentList {
    [_tableView setEquipmentDataArray:_equipmentArray];
}

- (void)showControlMenue {
    __weak typeof(self) weakSelf = self;
    ActionHandler closeHandler = ^(UIAlertAction * action) {
        weakSelf.operateType = CONTRACT_OPERATION_TYPE_CLOSE;
        [weakSelf onMenuOperateClicked];
    };
    
    ActionHandler recoveryHandler = ^(UIAlertAction * action) {
        weakSelf.operateType = CONTRACT_OPERATION_TYPE_RECOVERY;
        [weakSelf onMenuOperateClicked];
    };
    
    ActionHandler checkHandler = ^(UIAlertAction * action) {
//        weakSelf.operateType = CONTRACT_DETAIL_OPERATION_CHECK_PASSED;
        [weakSelf gotoCheckInContract];
    };
    
    ActionHandler archivedHandler = ^(UIAlertAction * action) {
        weakSelf.operateType = CONTRACT_OPERATION_TYPE_ARCHIVED;
//        [weakSelf onMenuOperateClicked];
        [weakSelf requestContractOperation];
    };
    
    NSMutableArray *menus = [NSMutableArray new];
    NSMutableArray *handlers = [NSMutableArray new];
    switch(_contractDetail.status) {
        case CONTRACT_STATUS_UNDO:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_close" inTable:nil]];
        [handlers addObject:closeHandler];
        break;
        case CONTRACT_STATUS_EXECUTING:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_close" inTable:nil]];
        [handlers addObject:closeHandler];
        break;
        case CONTRACT_STATUS_EXPIRED:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_check" inTable:nil]];
        [handlers addObject:checkHandler];
        break;
        case CONTRACT_STATUS_VERFIED_YES:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_archived" inTable:nil]];
        [handlers addObject:archivedHandler];
        break;
        case CONTRACT_STATUS_VERFIED_NO:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_check" inTable:nil]];
        [handlers addObject:checkHandler];
        break;
        case CONTRACT_STATUS_TERMINATED:
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_archived" inTable:nil]];
        [menus addObject:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_recovery" inTable:nil]];
        [handlers addObject:archivedHandler];
        [handlers addObject:recoveryHandler];
        break;
        case CONTRACT_STATUS_CLOSED:
        break;
        
    }
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//验证
- (void) onMenuOperateClicked {
    [_operationContentView clearInput];
    switch (_operateType) {
        case CONTRACT_OPERATION_TYPE_CLOSE:
            [_operationContentView setTitleOfContentView:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_title_close" inTable:nil]];
            break;
            
        case CONTRACT_OPERATION_TYPE_RECOVERY:
            [_operationContentView setTitleOfContentView:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_title_recovery" inTable:nil]];
            break;
            
//        case CONTRACT_DETAIL_OPERATION_CHECK:
//            [_operationContentView setTitleOfContentView:NSLocalizedString(@"contract_detail_operate_title_check", nil)];
//            break;
            
        case CONTRACT_OPERATION_TYPE_ARCHIVED:
            [_operationContentView setTitleOfContentView:[[BaseBundle getInstance] getStringByKey:@"contract_detail_operate_title_archived" inTable:nil]];
            break;
    }
    [_alertView showType:@"operation"];
    [_alertView show];
}

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

#pragma mark - Lazyload
- (ContractDetailTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ContractDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        __weak typeof(self) weakSelf = self;
        _tableView.actionBlock = ^(ContractDetalActionType type, id object){
            switch (type) {
                case CONTRACT_DETAIL_ACTION_PHONE:{
                    ContractProvider *provider = (ContractProvider *)object;
                    [weakSelf gotoCallConnact:provider];
                }
                    break;
                    
                case CONTRACT_DETAIL_ACTION_ATTACHMENT:{
                    ContractAttachment *attachment = (ContractAttachment *)object;
                    [weakSelf gotoAttachmentDetail:attachment];
                }
                    break;
                    
                case CONTRACT_DETAIL_ACTION_HISTORY_MORE:
                    [weakSelf gotoShowMoreRecord];
                    break;
                    
                case CONTRACT_DETAIL_ACTION_HISTORY_ATTACHMENT:{
                    ContractAttachment *attachment = (ContractAttachment *)object;
                    [weakSelf gotoAttachmentDetail:attachment];
                }
                    break;
                    
                case CONTRACT_DETAIL_ACTION_EQUIPMENT:{
                    ContractEquipment *equipment = (ContractEquipment *)object;
                    [weakSelf gotoEquipmentDetailByID:equipment.equipmentId];
                }
                    break;
                    
                case CONTRACT_DETAIL_ACTION_EQUIPMENT_MORE:
                    [weakSelf gotoShowMoreEquipment];
                    break;
            }
        };
    }
    
    return _tableView;
}

#pragma mark - Setter
- (void)setEditable:(BOOL)editable {
    _editable = editable;
}

- (void) setContractWithId:(NSNumber *) contractId {
    _contractId = contractId;
}

#pragma mark - 网络数据请求
//获取合同详情
- (void)requestContractDetailData {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getDetailInfoOfContract:_contractId success:^(NSInteger key, id object) {
        weakSelf.contractDetail = object;
//        weakSelf.contractDetail = [weakSelf testData];
        [weakSelf updateDetail];
        [weakSelf updateContractAction];
        [weakSelf updateTitle];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"contract_detail_request_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
//        weakSelf.contractDetail = [weakSelf testData];
        [weakSelf updateDetail];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) updateContractAction {
    if(_contractDetail) {
        switch(_contractDetail.status) {
            case CONTRACT_STATUS_CLOSED:
                _editable = NO;
                break;
            default:
                break;
        }
    }
}

//获取关联设备列表
- (void)requestEquipmentListData {
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business getEquipmentListOfContract:_contractId andPage:_netPage success:^(NSInteger key, id object) {
        ContractEquipmentResponseData *data = (ContractEquipmentResponseData *)object;
        weakSelf.netPage = data.page;
        weakSelf.equipmentArray = [NSMutableArray arrayWithArray:data.contents];
        [weakSelf updateEquipmentList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf updateEquipmentList];
        [weakSelf hideLoadingDialog];
    }];
}

//合同操作
- (void)requestContractOperation {
    ContractOperateRequestParam *param = [self getOperationParam];
    __weak typeof(self) weakSelf = self;
    [weakSelf showLoadingDialog];
    [_business operateContractByParam:param Success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf notifyContractStatusChanged];
        [weakSelf finishAfterSeconds:DIALOG_ALIVE_TIME_SHORT];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"tips_operate_failed" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    }];
}

- (ContractOperateRequestParam *)getOperationParam {
    ContractOperateRequestParam *param = [[ContractOperateRequestParam alloc] init];
    param.type = _operateType;
    param.contractId = _contractId;
    param.desc = _operateDesc;
    return param;
}

#pragma mark - 通知合同列表刷新
- (void) notifyContractStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMContractStatusUpdate" object:nil];
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([msgOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
            NSNumber *tmpNumber = [msg valueForKeyPath:@"menuType"];
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
                    [_alertView close];
                    break;
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([ContractCheckViewController class])]) {
            
        }
    }
}

#pragma mark - OnClickListener
- (void)onClick:(UIView *)view {
    if([view isKindOfClass:[TaskAlertView class]]) {
        [_alertView close];
    } else if([view isKindOfClass:[BaseAlertView class]]) {
        [_centerAlertView close];
    }
}

#pragma mark - OnItemClickListener
- (void)onItemClick:(UIView *)view subView:(UIView *)subView {
    if ([view isKindOfClass:[ContractOperateContentView class]]) {
        ContractOperateContentActionType type = subView.tag;
        switch(type) {
            case CONTRACT_OPERATE_CONTENT_ACTION_REFUSE:
                break;
                
            case CONTRACT_OPERATE_CONTENT_ACTION_PASS:{
                _operateDesc = [_operationContentView getDesc];
                [self requestContractOperation];
            }
                break;
            
                
            default:
                break;
        }
        [_alertView close];
    }
}

#pragma mark - 处理推送过来的数据
- (void) handleNotification {
    if(self.baseVcParam) {
        _contractId = [self.baseVcParam valueForKeyPath:@"contractId"];
        [self requestContractDetailData];
    }
}

#pragma mark - 键盘的显示与隐藏
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    if(keyboardSize.height > 0) {
        CGFloat statusBarHeight = 20;
        [_alertView moveToTopWithHeight:keyboardSize.height andPadding:statusBarHeight];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if(![_alertView isHidden]) {
        [_alertView reset];
    }
}


#pragma mark - 跳转逻辑
- (void)gotoShowMoreRecord {
    ContractRecordViewController *recordVC = [[ContractRecordViewController alloc] init];
    [recordVC setRecordDataArray:_contractDetail.history];
    [self gotoViewController:recordVC];
}

- (void)gotoShowMoreEquipment {
    ContractEquipmentViewController *equipmentVC = [[ContractEquipmentViewController alloc] init];
    [equipmentVC setContractId:_contractId equipmentDataArray:_equipmentArray andNetPage:_netPage];
    [self gotoViewController:equipmentVC];
}

- (void)gotoEquipmentDetailByID:(NSNumber *)equipmentId {
    EquipmentDetailViewController *equipmentDetailVC = [[EquipmentDetailViewController alloc] initWithEquipmentID:equipmentId];
    [self gotoViewController:equipmentDetailVC];
}

- (void)gotoAttachmentDetail:(ContractAttachment *)attachment {
    NSURL *attachmentURL = [FMUtils getUrlOfAttachmentById:attachment.fileId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentURL];
    [attachmentVC setTitleByFileName:attachment.fileName];
    [self gotoViewController:attachmentVC];
}

- (void)gotoCallConnact:(ContractProvider *)party {
    NSArray *phones = @[party.telno];
    [_phoneContentView setPhones:phones];
    [_centerAlertView setContentHeight:[_phoneContentView getSuitableHeight]];
    [_centerAlertView show];
}

- (void)gotoCheckInContract {
    [_alertView close];
    ContractCheckViewController *checkVC = [[ContractCheckViewController alloc] init];
    [checkVC setContractId:_contractId];
    [checkVC setOnMessageHandleListener:self];
    [self gotoViewController:checkVC];
}

@end

