//
//  WorkOrderDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailViewController.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "OrderDetailTableHelper.h"
#import "WorkOrderBusiness.h"
#import "WorkOrderDetailEntity.h"
#import "WorkOrderDetailApprovalApplyAlertContentView.h"
#import "TaskAlertView.h"
#import "UndoWorkOrderViewController.h"
#import "DispachTaskAlertContentView.h"
#import "CommonAlertContentView.h"
#import "PhoneListAlertContentView.h"
#import "FMDrawView.h"
#import "DispachLaborerViewController.h"
#import "InfoSelectViewController.h"
#import "WriteOrderAddContentViewController.h"
#import "WriteOrderAddToolViewController.h"
#import "WriteOrderAddChargeViewController.h"
#import "CameraHelper.h"
#import "PhotoShowHelper.h"
#import "WriteOrderLaborerSetTimeViewController.h"
#import "SystemConfig.h"
#import "ApplyApprovalWorkOrderEntity.h"
#import "CustomAlertView.h"
#import "FileUploadService.h"
#import "UploadConfig.h"
#import "WorkOrderValidateContentView.h"
#import "PhotoItem.h"
#import "MenuAlertContentView.h"
#import "WriteOrderRequestApprovalViewController.h"
#import "SignAlertContentView.h"
#import "WorkOrderDetailToolViewController.h"
#import "WorkOrderDetailCostViewController.h"
#import "WorkOrderSignatureViewController.h"
#import "WorkOrderDetailDispachViewController.h"
#import "WorkOrderDetailStepViewController.h"
#import "WorkOrderDetailEquipmentViewController.h"

#import "WorkOrderHistoryRecordViewController.h"
#import "BaseAlertView.h"
#import "AudioPlayAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "MediaViewController.h"
#import "IQKeyboardManager.h"
#import "WorkOrderDetailMaterialViewController.h"
#import "AttachmentViewController.h"
#import "MultiSelectViewController.h"
#import "WorkOrderDetailReservationViewController.h"
#import "DXAlertView.h"
#import "InventoryBusiness.h"
#import "BaseDataDbHelper.h"
#import "WorkOrderDetailSelectFailureReasonViewController.h"
#import "ColorNoticeView.h"

//时间类型
typedef NS_ENUM(NSInteger, TimeType) {
    TIME_TYPE_UNKNOW,
    TIME_TYPE_START,    //开始时间
    TIME_TYPE_FINISH    //完成时间
};

typedef NS_ENUM(NSInteger, OrderActionType) {
    ORDER_ACTION_UNKNOW,
    ORDER_ACTION_RECEIVE,   //接单
    ORDER_ACTION_PROCESS,   //处理
    ORDER_ACTION_CONTINUE,   //继续工作
    ORDER_ACTION_DISPACH,   //派工
    ORDER_ACTION_APPROVAL,  //审核
    ORDER_ACTION_VALIDATE,  //验证
    ORDER_ACTION_CLOSE,     //存档
    ORDER_ACTION_VALIDATE_CLOSE,  //验证加存档
    
    ORDER_ACTION_BACK,     //退单
    ORDER_ACTION_TERMINATE,     //终止
    ORDER_ACTION_PAUSE,     //暂停
};

//文件上传类型
typedef NS_ENUM(NSInteger, OrderUploadFileType) {
    WO_UPLOAD_FILE_UNKNOW,
    WO_UPLOAD_IMAGE_CONTENT,    //工作内容图片
    WO_UPLOAD_IMAGE_CUSTOMER_SIGN,  //客户签名
    WO_UPLOAD_IMAGE_SUPERVISOR_SIGN,//主管签名
};

@interface WorkOrderDetailViewController () <OnItemClickListener, OnMessageHandleListener, OnClickListener>

@property (readwrite, nonatomic, strong) UIView * mainContainView;
@property (readwrite, nonatomic, strong) UITableView * orderTableView;

@property (readwrite, nonatomic, strong) UIButton * editWorkContentBtn;
@property (readwrite, nonatomic, strong) UILabel * titleLbl;
@property (readwrite, nonatomic, strong) UIImageView * imgView;

@property (readwrite, nonatomic, strong) AudioPlayAlertView * audioPlayAlertView; //提醒弹出View (录音播放界面)

@property (nonatomic, strong) AVPlayer * audioPalyer;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) NSURL * playFileURL;

@property (readwrite, nonatomic, strong) CommonAlertContentView * commonContentView;              //通用操作界面
@property (readwrite, nonatomic, strong) PhoneListAlertContentView * phoneContentView;              //手机号操作界面
@property (readwrite, nonatomic, strong) WorkOrderValidateContentView * validateContentView;              //主管验证界面
@property (readwrite, nonatomic, strong) MenuAlertContentView * menuContentView;    //菜单界面
@property (readwrite, nonatomic, strong) NSMutableArray * actionHandlerArray;   //事件处理


@property (readwrite, nonatomic, strong) SignAlertContentView * signContentView;   //客户签名页面

@property (readwrite, nonatomic, strong) TaskAlertView * alertView; //弹出框
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;   //弹出框高度

@property (readwrite, nonatomic, strong) BaseAlertView * centerAlertView; //用于在屏幕中先弹出的提示框
@property (nonatomic, strong) ColorNoticeView *finishNoticeView;    //任务完成时的提示信息框

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, strong) NSNumber * orderId;    //工单ID
@property (readwrite, nonatomic, strong) __block WorkOrderDetail * orderDetail; //工单详情信息
@property (readwrite, nonatomic, strong) __block NSMutableArray * materials; //
@property (readwrite, nonatomic, strong) __block NSMutableArray * reservationArray; //预订单
@property (readwrite, nonatomic, strong) NSMutableArray * groups;   //工作组
@property (readwrite, nonatomic, assign) OrderActionType actionType;
@property (readwrite, nonatomic, assign) BOOL readonly; //是否只允许看

@property (readwrite, nonatomic, strong) OrderDetailTableHelper * helper;   //table 数据源
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;  //工单业务处理
@property (readwrite, nonatomic, strong) InventoryBusiness * inventoryBusiness;
@property (readwrite, nonatomic, strong) CameraHelper * cameraHelper;   //拍照
@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper; //图片展示

@property (readwrite, nonatomic, strong) UIImage * customerSignImg; //客户签字
@property (readwrite, nonatomic, strong) UIImage * supervisorSignImg;   //主管签字

@property (readwrite, nonatomic, strong) NetPage * materialPage;
@property (readwrite, nonatomic, assign) BOOL materialNeedUpdate;
@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, assign) WorkOrderBusinessType requestType; //数据请求类型

@property (readwrite, nonatomic, strong) NSString *strFinishNotice;//任务完成时的提示信息
@end

@implementation WorkOrderDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithVcType:(BaseVcType) vcType param:(NSDictionary *)param {
    self = [super initWithVcType:vcType param:param];
    return self;
}

- (void) initNavigation {
    NSString * strTitle = [[BaseBundle getInstance] getStringByKey:@"order_detail" inTable:nil];
    if(_orderDetail) {
        strTitle = [[NSString alloc] initWithFormat:@"%@", _orderDetail.code];
    }
    [self setTitleWith:strTitle];
    [self setBackAble:YES];
    
    if(!_readonly) {
        NSNumber * laborerId = [SystemConfig getEmployeeId];
        if([_business canOperateOrder:_orderDetail laborer:laborerId] && _actionType != ORDER_ACTION_UNKNOW) {
            NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[FMTheme getInstance] getImageByName:@"menu_more"], nil];
            [self setMenuWithArray:menus];
        }
    }
}


- (void) initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    _alertViewHeight = CGRectGetHeight(self.view.frame);
    
    _materialPage = [[NetPage alloc] init];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if (![manager.disabledDistanceHandlingClasses containsObject:[self class]]) {
        [manager.disabledDistanceHandlingClasses addObject:[self class]];
    }
    
    if(!_mainContainView) {
        _mainContainView = [[UIView alloc] initWithFrame:frame];
        _mainContainView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _orderTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _orderTableView.delaysContentTouches = NO;
        
        _editWorkContentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _realHeight-[FMSize getSizeByPixel:150], _realWidth, [FMSize getSizeByPixel:150])];
        _editWorkContentBtn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _editWorkContentBtn.layer.borderWidth = 0.4f;
        _editWorkContentBtn.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        [_editWorkContentBtn addTarget:self action:@selector(gotoEditContent) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"order_work_content_edit" inTable:nil];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _titleLbl.font = [FMFont fontWithSize:15];
        
        
        
        _imgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"edit_work_content"]];

        [_editWorkContentBtn addSubview:_imgView];
        [_editWorkContentBtn addSubview:_titleLbl];
        
        [_mainContainView addSubview:_editWorkContentBtn];
        [_mainContainView addSubview:_orderTableView];
        [self.view addSubview:_mainContainView];
        
        _commonContentView = [[CommonAlertContentView alloc] init];
        [_commonContentView setOnItemClickListener:self];
        
        _phoneContentView = [[PhoneListAlertContentView alloc] init];
        _phoneContentView.clipsToBounds = YES;
        _phoneContentView.layer.cornerRadius = 3;
        [_phoneContentView setOnPhoneDelegate:self];
        
        _validateContentView = [[WorkOrderValidateContentView alloc] init];
        [_validateContentView setOnItemClickListener:self];
        
        _menuContentView = [[MenuAlertContentView alloc] init];
        [_menuContentView setOnMessageHandleListener:self];
        
        _audioPlayAlertView = [[AudioPlayAlertView alloc] init];
        _audioPlayAlertView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        [_audioPlayAlertView setOnItemClickListener:self];
        _audioPlayAlertView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _audioPlayAlertView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        
        _signContentView = [[SignAlertContentView alloc] init];
        [_signContentView setTitleWithText:[[BaseBundle getInstance] getStringByKey:@"order_alert_title_finish" inTable:nil]];
        [_signContentView setDescWithText:[[BaseBundle getInstance] getStringByKey:@"order_sign_customer" inTable:nil]];
        [_signContentView setOnItemClickListener:self];
        
        _finishNoticeView = [[ColorNoticeView alloc] init];
        [_finishNoticeView setLeftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil]];
        [_finishNoticeView setOnItemClickListener:self];
    }
}

- (void) updateLayout {
    if ([_helper editable]) {
        [_orderTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight-[FMSize getSizeByPixel:150])];
        [_editWorkContentBtn setFrame:CGRectMake(0, _realHeight-[FMSize getSizeByPixel:150], _realWidth, [FMSize getSizeByPixel:150])];
        CGSize titleSize = [FMUtils getLabelSizeBy:_titleLbl andContent:[[BaseBundle getInstance] getStringByKey:@"order_work_content_edit" inTable:nil] andMaxLabelWidth:_realWidth];
        CGFloat imgWidth = 16;
        CGFloat originX = (_realWidth - imgWidth - titleSize.width - [FMSize getInstance].padding50)/2;
        CGFloat originY = ([FMSize getSizeByPixel:150] - imgWidth)/2;
        [_imgView setFrame:CGRectMake(originX, originY, imgWidth, imgWidth)];
        originX += imgWidth + [FMSize getInstance].padding50;
        originY = ([FMSize getSizeByPixel:150] - titleSize.height)/2;
        [_titleLbl setFrame:CGRectMake(originX, originY, titleSize.width, titleSize.height)];
        _editWorkContentBtn.hidden = NO;
    } else {
        [_orderTableView setFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _editWorkContentBtn.hidden = YES;
    }
}

- (void) initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat contentHeight = 300;
    CGFloat commonHeight = 250;
    
    [_alertView setContentView:_commonContentView withKey:@"common" andHeight:commonHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_alertView setContentView:_validateContentView withKey:@"validate" andHeight:250 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_alertView setContentView:_signContentView withKey:@"sign" andHeight:commonHeight  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_alertView setContentView:_audioPlayAlertView withKey:@"audioPlay" andHeight:_alertViewHeight*2/5 andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    [_alertView setContentView:_menuContentView withKey:@"menu" andHeight:(contentHeight + 40)  andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
    
    _centerAlertView = [[BaseAlertView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_centerAlertView setOnClickListener:self];
    [_centerAlertView setPadding:[FMSize getInstance].defaultPadding];
//    [_centerAlertView setContentView:_phoneContentView];
    [_centerAlertView setHidden:YES];
    [self.view addSubview:_centerAlertView];
}



- (void) initHelper {
    _helper = [[OrderDetailTableHelper alloc] init];
    [_helper setOnMessageHandleListener:self];
    [_helper setLaborerId:[SystemConfig getEmployeeId]];
    _business = [WorkOrderBusiness getInstance];
    _inventoryBusiness = [InventoryBusiness getInstance];
    
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTableView.dataSource = _helper;
    _orderTableView.delegate = _helper;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initStatusChangeHandler]; //初始化预定单状态监听
    [self initHelper];
    [self requestData];
    [self requestReservationList];
    _actionType = ORDER_ACTION_PROCESS;
    [self initAlertView];
    
    _cameraHelper = [[CameraHelper alloc] initWithContext:self andMultiSelectAble:YES];
    [_cameraHelper setOnMessageHandleListener:self];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_materialNeedUpdate) {
        if(_orderId) {
            _materialNeedUpdate = NO;
            [self requestReservationList];
        }
    }
    [_helper reloadVideos];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self updateLayout];
     [self updateTitle];
}

#pragma mark - 注册消息监听
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
}

- (void) initStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMReservationStatusUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"FMReservationStatusUpdate"
                                               object: nil];
}

- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _materialNeedUpdate = YES;
}

#pragma mark - 更新标题
- (void) updateTitle {
    [self initNavigation];
    [super updateNavigationBar];
}

- (void) updateActionType {
    WorkOrderStatus orderStatus = _orderDetail.status;
    NSNumber * laborerId = [SystemConfig getEmployeeId];
    _actionType = ORDER_ACTION_UNKNOW;
    if([_business canOperateOrder:_orderDetail laborer:laborerId]) {
        switch (orderStatus) {
            case ORDER_STATUS_CREATE:   //已创建
                if([_business canDispachOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_DISPACH;
                }
                break;
            case ORDER_STATUS_DISPACHED://已发布
                if([_business canReceiveOrder:_orderDetail laborerId:laborerId]) {
                    _actionType = ORDER_ACTION_RECEIVE;
                }
                break;
            case ORDER_STATUS_PROCESS:       //处理中
                if([_business hasLaborerReceived:_orderDetail laborerId:laborerId]) {
                    _actionType = ORDER_ACTION_PROCESS;
                } else {
                    if([_business canReceiveOrder:_orderDetail laborerId:laborerId]) {
                        _actionType = ORDER_ACTION_RECEIVE;
                    }
                }
                break;
            case ORDER_STATUS_STOP:     //暂停---继续工作
                if([_business canContinueOrder:_orderDetail laborerId:laborerId]) {
                    _actionType = ORDER_ACTION_CONTINUE;
                }
                break;
            case ORDER_STATUS_TERMINATE:      //已终止
                if([_business canValidateOrder:_orderDetail]) {
                    if([_business canCloseOrder:_orderDetail]) {
                        _actionType = ORDER_ACTION_VALIDATE_CLOSE;
                    } else {
                        _actionType = ORDER_ACTION_VALIDATE;
                    }
                } else if([_business canCloseOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_CLOSE;
                }
                break;
            case ORDER_STATUS_FINISH:   //已完成
                if([_business canValidateOrder:_orderDetail]) {
                    if([_business canCloseOrder:_orderDetail]) {
                        _actionType = ORDER_ACTION_VALIDATE_CLOSE;
                    } else {
                        _actionType = ORDER_ACTION_VALIDATE;
                    }
                } else if([_business canCloseOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_CLOSE;
                }
                break;
            case ORDER_STATUS_VALIDATATION:   //已验证
                if([_business canCloseOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_CLOSE;
                }
                break;
            case ORDER_STATUS_CLOSE:      //已存档
                break;
            case ORDER_STATUS_APPROVE:  //待审批
                if([_business canApprovalOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_APPROVAL;
                }
                break;
            case ORDER_STATUS_STOP_N:     //暂停---不继续工作
                if([_business canDispachOrder:_orderDetail]) {
                    _actionType = ORDER_ACTION_DISPACH;
                }
                break;
                
            default:
                break;
        }
    }
    if(_actionType == ORDER_ACTION_UNKNOW) {        //只允许看
        _readonly = YES;
        [_helper setEditAble:NO];
    } else {
//        _readonly = NO;
        if(_actionType == ORDER_ACTION_PROCESS && !_readonly) {   //允许修改数据
            [_helper setEditAble:YES];
        } else {                                    //允许点击，不允许改数据
            [_helper setEditAble:NO];
        }
    }
    [_helper setReadOnly:_readonly];
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

//接单
- (void) showControlReceive {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_receive" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_back" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_approval_request" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler approvalRequestHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuApprovalRequestClicked];
    };
    ActionHandler receiveHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuReceiveClicked];
    };
    ActionHandler backHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuBackClicked];
    };
    
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:receiveHandler, backHandler, approvalRequestHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//处理菜单
- (void) showControlProcess {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:
                              [[BaseBundle getInstance] getStringByKey:@"order_operation_finish" inTable:nil],
                              [[BaseBundle getInstance] getStringByKey:@"order_operation_pause" inTable:nil],
                              [[BaseBundle getInstance] getStringByKey:@"order_operation_terminate" inTable:nil],
                              [[BaseBundle getInstance] getStringByKey:@"order_operation_back" inTable:nil],
                              [[BaseBundle getInstance] getStringByKey:@"order_operation_approval_request" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler approvalRequestHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuApprovalRequestClicked];
    };
    ActionHandler backHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuBackClicked];
    };
    ActionHandler pauseHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuPauseClicked];
    };
    ActionHandler terminateHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuTerminateClicked];
    };
//    ActionHandler saveHandler = ^(UIAlertAction * action) {
//        [weakSelf onMenuSaveClicked];
//    };
    ActionHandler finishHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuFinishClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects: finishHandler, pauseHandler, terminateHandler, backHandler, approvalRequestHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//继续工作
- (void) showControlContinue {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_continue" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler continueRequestHandler = ^(UIAlertAction * action) {
        [weakSelf onContinueRequestClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:continueRequestHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//派工
- (void) showControlDispach {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_dispach" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_terminate" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_approval_request" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler approvalRequestHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuApprovalRequestClicked];
    };
    
    ActionHandler terminateHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuTerminateClicked];
    };
    ActionHandler dispachHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuDispachClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:dispachHandler, terminateHandler, approvalRequestHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//审核
- (void) showControlApproval {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_approval" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler approvalHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuApprovalClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:approvalHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//验证存档
- (void) showControlValidateClose {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_validate" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_close" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler validateHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuValidateClicked];
    };
    ActionHandler closeHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuCloseClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:validateHandler, closeHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//只验证
- (void) showControlValidate {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_validate" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler validateHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuValidateClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:validateHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

//存档
- (void) showControlClose {
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_close" inTable:nil], nil];
    
    __weak id weakSelf = self;
    ActionHandler closeHandler = ^(UIAlertAction * action) {
        [weakSelf onMenuCloseClicked];
    };
    NSMutableArray * handlers = [[NSMutableArray alloc] initWithObjects:closeHandler, nil];
    [self showControlWithMenuTexts:menus handlers:handlers];
}

- (void) updateList {
    [_orderTableView reloadData];
}

#pragma mark - 设置参数
- (void) setWorkOrderWithId:(NSNumber *) orderId {
    _orderId = [orderId copy];
}
- (void) setWorkOrderWithId:(NSNumber *) orderId approvalId:(NSNumber *) approvalId {
    _orderId = [orderId copy];
}

- (void) setReadOnly:(BOOL) readonly {
    _readonly = readonly;
}

//判断是否存在预定单，处于待审批状态并且没有主管和预订人等信息
- (BOOL) checkReservationHandlerValid {
    BOOL res = YES;
    for(ReservationEntity * reservation in _reservationArray) {
        if(reservation.status == RESERVATION_STATUS_TYPE_UNCHECK && (!reservation.reservationPersonId || !reservation.administrator || !reservation.supervisor)) {
            res = NO;
            break;
        }
    }
    return res;
}

#pragma mark - 请求数据
//请求工单详情
- (void) requestData {
    [self showLoadingDialog];
    __weak typeof(self) weakSelf = self;
    [_business getDetailInfoOfOrder:_orderId success:^(NSInteger key, id object) {
        weakSelf.orderDetail = object;
        weakSelf.orderDetail.relatedOrder = [[NSMutableArray alloc] init];
        [weakSelf requestFinishNoticeInfo]; //请求完成提示信息
        [weakSelf.helper setInfoWith:weakSelf.orderDetail];
        [weakSelf updateActionType];
        [weakSelf updateTitle];
        [weakSelf updateLayout];
        [weakSelf updateList];
        [weakSelf hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf hideLoadingDialog];
    }];
}

- (void) requestFinishNoticeInfo {
    if(_orderDetail && _orderDetail.flowId) {
        Flow * flow = [[BaseDataDbHelper getInstance] queryFlowById:_orderDetail.flowId];
        _strFinishNotice = flow.notice;
    }
}

//获取工单预订单列表
- (void) requestReservationList {
    __weak typeof(self) weakSelf = self;
    [_inventoryBusiness getReservationListOfWorkOrder:_orderId success:^(NSInteger key, id object) {
        _reservationArray = object;
        [_helper setReservationList:_reservationArray];
        [weakSelf updateList];
    } fail:^(NSInteger key, NSError *error) {
        _reservationArray = nil;
        [_helper setReservationList:nil];
        [weakSelf updateList];
    }];
}


//请求接单
- (void) requestReceive {
    if(_business) {
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_RECEIVE;

        WorkOrderOperateRequestParam *param = [[WorkOrderOperateRequestParam alloc] init];
        param.woId = [_orderId copy];
        param.operateType = WORK_ORDER_OPERATE_TYPE_ACCEPT;
        param.operateDescription = @"";
        __weak typeof(self) weakSelf = self;
        [_business operateOrder:param success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];  //注释掉隐藏loading的方法，让程序跑到requestData中去隐藏
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_receive_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showLoadingDialog];
                [weakSelf requestData];
            });
            [weakSelf notifyOrderStatusChanged];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_receive_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
    [_alertView close];
}

//请求退单
- (void) requestBack {
    NSString * desc = [_commonContentView getDesc];
    if(_business) {
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_BACK;
        __weak typeof(self) weakSelf = self;
        [_business chargeBackOrder:_orderId desc:desc success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_back_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_back_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
    [_alertView close];
}

//请求暂停
- (void) requestPause:(SaveWorkOrderOperateType) type {
    NSString * desc = [_commonContentView getDesc];
    if(_business) {
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_PAUSE;
        WorkOrderOperateRequestParam * param = [[WorkOrderOperateRequestParam alloc] init];
        param.woId = [_orderId copy];
        if (type == ORDER_OPERATE_SAVE_TYPE_PAUSE_CONTINUE) {
            param.operateType = WORK_ORDER_OPERATE_TYPE_STOP_Y;
        } else {
            param.operateType = WORK_ORDER_OPERATE_TYPE_STOP_N;
        }
        param.operateDescription = desc;
        __weak typeof(self) weakSelf = self;
        [_business operateOrder:param success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_pause_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_pause_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
    [_alertView close];
}

//请求继续工作
- (void) requestContinue {
    if(_business) {
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_CONTINUE;
        __weak typeof(self) weakSelf = self;
        [_business continueOrder:_orderId success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_continue_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf requestData];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_continue_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
    [_alertView close];
}

//请求验证
- (void) requestValidate:(BOOL) pass desc:(NSString *) operationDesc {
    if(_business) {
        NSString * desc = operationDesc;
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_VALIDATE;
        WorkOrderOperateRequestParam * param = [[WorkOrderOperateRequestParam alloc] init];
        param.woId = [_orderId copy];
        if (pass) {
            param.operateType = WORK_ORDER_OPERATE_TYPE_VALIDATE_PASS;
        } else {
            param.operateType = WORK_ORDER_OPERATE_TYPE_VALIDATE_OUT;
        }
        param.operateDescription = desc;
        __weak typeof(self) weakSelf = self;
        [_business operateOrder:param success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_validate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_validate_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
    [_alertView close];
}



//请求审批工单
- (void) approvalOrder:(ApprovalWorkOrderOperateType) type{
    NSString * desc = [_commonContentView getDesc];
    ApprovalWorkOrderRequestParam * param = [[ApprovalWorkOrderRequestParam alloc] initWithOrderId:_orderId content:desc operateType:type approvalId:_orderDetail.approvalId];
    if(_business && _orderDetail.approvalId) {
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_APPROVAL;
        __weak typeof(self) weakSelf = self;
        [_business approvalOrder:param success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_approval_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
            
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_approval_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
    [_alertView close];
}

//终止工单
- (void) terminateWorkOrder {
    NSString * desc = [_commonContentView getDesc];
    if(_business) {
        
        [self showLoadingDialog];
        _requestType = BUSINESS_WO_OPERATE_TERMINATE;
        WorkOrderOperateRequestParam * param = [[WorkOrderOperateRequestParam alloc] init];
        param.woId = [_orderId copy];
        param.operateType = WORK_ORDER_OPERATE_TYPE_TERMINATE;
        param.operateDescription = desc;
        __weak typeof(self) weakSelf = self;
        [_business operateOrder:param success:^(NSInteger key, id object) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_terminate_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_terminate_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf hideLoadingDialog];
        }];
    }
    [_alertView close];
}
//完成工单
- (void) finishOrder {
    if([_orderDetail hasSomeoneUnAccept]) { //如果有人未接单
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_someone_unreceive" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        if(![FMUtils isStringEmpty:_strFinishNotice]) {  //如果附带提示
            [self showFinishNotice];
        } else {
            [self requestFinishOrder];
        }
    }
    [_alertView close];
}

- (void) requestFinishOrder {
    [self showLoadingDialog];
    _requestType = BUSINESS_WO_OPERATE_FINISH;
    WorkOrderOperateRequestParam * param = [[WorkOrderOperateRequestParam alloc] init];
    param.woId = [_orderId copy];
    param.operateType = WORK_ORDER_OPERATE_TYPE_FINISH;
    param.operateDescription = @"";
    __weak typeof(self) weakSelf = self;
    [_business operateOrder:param success:^(NSInteger key, id object) {
        [weakSelf hideLoadingDialog];
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_finish_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf notifyOrderStatusChanged];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DIALOG_ALIVE_TIME_SHORT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf finish];
        });
    } fail:^(NSInteger key, NSError *error) {
        [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_finish_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        [weakSelf hideLoadingDialog];
    }];
}


#pragma mark - 菜单点击响应
- (void) onMenuItemClicked:(NSInteger)position {
    switch(_actionType) {
        case ORDER_ACTION_RECEIVE:
            [self showControlReceive];
            break;
        case ORDER_ACTION_PROCESS:
            [self showControlProcess];
            break;
        case ORDER_ACTION_CONTINUE:
            [self showControlContinue];
            break;
        case ORDER_ACTION_DISPACH:
            [self showControlDispach];
            break;
        case ORDER_ACTION_APPROVAL:
            [self showControlApproval];
            break;
        case ORDER_ACTION_VALIDATE:
            [self showControlValidate];
            break;
        case ORDER_ACTION_CLOSE:
            [self showControlClose];
            break;
        case ORDER_ACTION_VALIDATE_CLOSE:
            [self showControlValidateClose];
            break;
        default:
            break;
    }
}

#pragma mark - 弹出框隐藏
- (void) resetWorking {
    [self updateList];
    [_alertView close];
}

- (void) showCommonAlertDialogWithTitle:(NSString *) title
                                  label:(NSString *) labelText
                            buttonTitle:(NSString *) btnTitle
                                    tag:(NSInteger) tag {
    _commonContentView.tag = tag;
    [_commonContentView setTitleWithText:title];
    [_commonContentView setEditLabelWithText:labelText];
    [_commonContentView setOperationButtonText:btnTitle];
    
    [_alertView showType:@"common"];
    [_alertView show];
}

- (void) showCommonAlertDialogWithTitle:(NSString *) title
                                  label:(NSString *) labelText
                           buttonTitles:(NSMutableArray *) btnTitleArray
                                    tag:(NSInteger) tag {
    _commonContentView.tag = tag;
    [_commonContentView setTitleWithText:title];
    [_commonContentView setEditLabelWithText:labelText];
    [_commonContentView setOperationButtonTextArray:btnTitleArray];
    
    [_alertView showType:@"common"];
    [_alertView show];
}

#pragma mark - 点击菜单
//点击审批申请按钮
- (void) onMenuApprovalRequestClicked {
    [_alertView close];
    WriteOrderRequestApprovalViewController * approvalVC = [[WriteOrderRequestApprovalViewController alloc] init];
    [approvalVC setInfoWithOrderId:_orderId];
    [approvalVC setOnMessageHandleListener:self];
    [self gotoViewController:approvalVC];
}

//退单
- (void) onMenuBackClicked {
    [self showCommonAlertDialogWithTitle:[[BaseBundle getInstance] getStringByKey:@"order_alert_title_back" inTable:nil] label:[[BaseBundle getInstance] getStringByKey:@"order_back_reason" inTable:nil] buttonTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_back" inTable:nil] tag:ORDER_ACTION_BACK];
}

//接单
- (void) onMenuReceiveClicked {
    [self requestReceive];
}

//暂停
- (void) onMenuPauseClicked {
    NSMutableArray * titleArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_un_continue" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_continue" inTable:nil], nil];
    [self showCommonAlertDialogWithTitle:[[BaseBundle getInstance] getStringByKey:@"order_alert_title_pause" inTable:nil] label:[[BaseBundle getInstance] getStringByKey:@"order_pause_reason" inTable:nil] buttonTitles:titleArray tag:ORDER_ACTION_PAUSE];
}

//继续工作
- (void) onContinueRequestClicked {
    [self requestContinue];
}

//终止
- (void) onMenuTerminateClicked {
    if([_orderDetail hasSomeoneUnAccept]) { //如果有人未接单的话，不允许终止工单
        [_alertView close];
        [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_someone_unreceive" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
    } else {
        [self showCommonAlertDialogWithTitle:[[BaseBundle getInstance] getStringByKey:@"order_alert_title_terminate" inTable:nil] label:[[BaseBundle getInstance] getStringByKey:@"order_terminate_reason" inTable:nil] buttonTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_terminate" inTable:nil] tag:ORDER_ACTION_TERMINATE];
    }
}

//完成
- (void) onMenuFinishClicked {
    NSInteger count = [_orderDetail getEquipmentUnCompletedCount];
    if(count > 0) {
        [_alertView close];
        NSString * msg = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"order_notice_equipment_process_format" inTable:nil], count];
        DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:msg leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        alertView.leftBlock = ^(){
            [self finishOrder];
        };
        alertView.rightBlock = ^() {
        };
        [alertView show];
    } else {
        [self finishOrder];
    }
}

//派工
- (void) onMenuDispachClicked {
    [_alertView close];
    __weak id weakSelf = self;
    if ([self checkReservationHandlerValid]) {
        WorkOrderDetailDispachViewController * laborerVC = [[WorkOrderDetailDispachViewController alloc] init];
        [laborerVC setInfoWithOrderId:_orderId code:_orderDetail.code];
        [laborerVC setEstimateTimeStart:_orderDetail.estimateStartTime timeEnd:_orderDetail.estimateEndTime];
        [weakSelf gotoViewController:laborerVC];
    } else {
        DXAlertView * alertView = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"order_notice_reservation_handler_empty" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] viewController:self];
        alertView.leftBlock = ^() {
            WorkOrderDetailDispachViewController * laborerVC = [[WorkOrderDetailDispachViewController alloc] init];
            [laborerVC setInfoWithOrderId:_orderId code:_orderDetail.code];
            [laborerVC setEstimateTimeStart:_orderDetail.estimateStartTime timeEnd:_orderDetail.estimateEndTime];
            [weakSelf gotoViewController:laborerVC];
        };
        alertView.rightBlock = ^() {
        };
        [alertView show];
    }
    
}

//审核
- (void) onMenuApprovalClicked {
    NSMutableArray * titleArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_operation_refuse" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_operation_pass" inTable:nil], nil];
    [self showCommonAlertDialogWithTitle:[[BaseBundle getInstance] getStringByKey:@"order_alert_title_approval" inTable:nil] label:[[BaseBundle getInstance] getStringByKey:@"order_approval_reason" inTable:nil] buttonTitles:titleArray tag:ORDER_ACTION_APPROVAL];
}

//验证
- (void) onMenuValidateClicked {
    if(_orderDetail.supervisorSignImgId) {
        NSURL * url = [_helper getPhotoUrl:_orderDetail.supervisorSignImgId];
        [_signContentView setSignImgWithUrl:url];
    }
    [_alertView showType:@"validate"];
    [_alertView show];
}

//存档
- (void) onMenuCloseClicked {
    if(_business) {
        [self showLoadingDialog];
        WorkOrderOperateRequestParam * param = [[WorkOrderOperateRequestParam alloc] init];
        param.woId = [_orderId copy];
        param.operateType = WORK_ORDER_OPERATE_TYPE_CLOSE;
        param.operateDescription = @"";
        __weak typeof(self) weakSelf = self;
        [_business operateOrder:param success:^(NSInteger key, id object) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_close_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
            [weakSelf notifyOrderStatusChanged];
            [weakSelf finish];
        } fail:^(NSInteger key, NSError *error) {
            [weakSelf hideLoadingDialog];
            [weakSelf showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_close_success" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }];
    }
}

//打电话
- (void) tryToTakeCall {
    NSArray * phones = [_helper getPhoneArray];
    [_phoneContentView setPhones:phones];
    [_centerAlertView setContentView:_phoneContentView];
    [_centerAlertView setContentHeight:[_phoneContentView getSuitableHeight]];
    [_centerAlertView show];
}

- (void) showFinishNotice {
    [_finishNoticeView setInfoWithStyle:COLOR_NOTICE_STYLE_WARNING content:_strFinishNotice];
    [_centerAlertView setContentView:_finishNoticeView];
    [_centerAlertView setContentHeight:[_phoneContentView getSuitableHeight]];
    [_centerAlertView show];
}

#pragma mark - 点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
//    if(view == _approvalApplyContentView) {
//        [self requestApproval];
//    } else
    if(view == _commonContentView) {
        OrderActionType type = _commonContentView.tag;
        CommonAlertContentOperateType btnType = subView.tag;
        ApprovalWorkOrderOperateType approvalType;
        SaveWorkOrderOperateType pauseType = ORDER_OPERATE_SAVE_TYPE_UNKNOW;
        switch(type) {
            case ORDER_ACTION_BACK:
                [self requestBack];
                break;
            case ORDER_ACTION_PAUSE:
                if(btnType == COMMON_ALERT_OPERATE_TYPE_LEFT) {
                    pauseType = ORDER_OPERATE_SAVE_TYPE_PAUSE_NOT_CONTINUE;
                } else if(btnType == COMMON_ALERT_OPERATE_TYPE_RIGHT) {
                    pauseType = ORDER_OPERATE_SAVE_TYPE_PAUSE_CONTINUE;
                }
                [self requestPause:pauseType];
                break;
            case ORDER_ACTION_TERMINATE:
                [self terminateWorkOrder];
                break;
            case ORDER_ACTION_APPROVAL:
                if(btnType == COMMON_ALERT_OPERATE_TYPE_LEFT) {
                    approvalType = ORDER_OPERATE_APPROVAL_TYPE_REFUSE;
                } else if(btnType == COMMON_ALERT_OPERATE_TYPE_RIGHT) {
                    approvalType = ORDER_OPERATE_APPROVAL_TYPE_ACCESS;
                }
                [self approvalOrder:approvalType];
                break;
            default:
                break;
        }
    }
//    else if(view == _dispachContentView) {
//        [self requestDispach];
//    }
    else if (view == _signContentView) {
        SignAlertContentOperateType type = subView.tag;
        switch (type) {
            case SIGN_ALERT_OPERATE_TYPE_SIGN:
                [_alertView close];
                [self gotoMakeSign:WO_UPLOAD_IMAGE_CUSTOMER_SIGN];
                break;
            case SIGN_ALERT_OPERATE_TYPE_OK:
                [self finishOrder];
                break;
            default:
                break;
        }
    } else if(view == _validateContentView) {
        if(subView) {
            WorkOrderValidateContentActionType type = subView.tag;
            BOOL pass = NO;
            NSString * desc = [_validateContentView getDesc];
//            _supervisorSignImg = [_validateContentView getSignImage];
            switch(type) {
                case WO_VALIDATE_CONTENT_ACTION_SIGN:
                    [_alertView close];
                    [self gotoMakeSign:WO_UPLOAD_IMAGE_SUPERVISOR_SIGN];
                    break;
                case WO_VALIDATE_CONTENT_ACTION_PASS:
                    pass = YES;
                    [self requestValidate:pass desc:desc];
                    break;
                case WO_VALIDATE_CONTENT_ACTION_REFUSE:
                    pass = NO;
                    [self requestValidate:pass desc:desc];
                    break;
                default:
                    break;
            }
            [_alertView close];
        }
    } else if ([view isKindOfClass:[AudioPlayAlertView class]]) {
        NSInteger tag = subView.tag;
        PlayBtnType type = tag;
        switch (type) {
            case PLAY_BUTTON_TYPE_PLAY: {
                [self showLoadingDialog];
                AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:_playFileURL options:nil];
                CMTime audioDuration = audioAsset.duration;
                float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
                [self hideLoadingDialog];
                
                [self playAudioWith:audioDurationSeconds];
            }
                break;
            case PLAY_BUTTON_TYPE_STOP:
                [self pauseRecord];
                break;
            default:
                break;
        }
    } else if([view isKindOfClass:[ColorNoticeView class]]) {
        ColorNoticeEventType type = subView.tag;
        switch(type) {
            case COLOR_NOTICE_EVENT_TYPE_LEFT_CLICK:
                break;
            case COLOR_NOTICE_EVENT_TYPE_RIGHT_CLICK:
                
                break;
            default:
                break;
        }
        [_centerAlertView close];
    }
}



- (void) onClick:(UIView *)view {
    if(view == _alertView) {
        [self pauseRecord];
        [self resetWorking];
    } else if(view == _centerAlertView) {
        [_centerAlertView close];
    }
}


#pragma mark - handle message
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * msgOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if(msgOrigin && [msgOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            OrderDetailEventType eventType = [[result valueForKeyPath:@"eventType"] integerValue];
            NSNumber * tmpNumber;
            NSMutableArray * tmpArray;
            NSDictionary * tmpDictionary;
            WorkOrderTool * tool;
            WorkOrderChargeItem * charge;
            switch(eventType) {
                case WO_DETAIL_EVENT_CONTENT_ADD:
                case WO_DETAIL_EVENT_CONTENT_EDIT:
                    [self gotoEditContent];
                    break;
                case WO_DETAIL_EVENT_TAKE_CALL:
                    [self tryToTakeCall];
                    break;
                case WO_DETAIL_EVENT_TAKE_PHOTO:
                    [_cameraHelper getPhotoWithWaterMark:_orderDetail.location];
                    break;
                case WO_DETAIL_EVENT_SHOW_PHOTO_ORDER:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoShowOrderPhoto:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_SHOW_PHOTO_REQUIREMENT:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoShowRequirementPhoto:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_SHOW_AUDIO_REQUIREMENT:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoShowRequirementAudio:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_SHOW_VIDEO_REQUIREMENT:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoShowRequirementVideo:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_SHOW_ATTACHMENT_REQUIREMENT:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [self gotoShowAttachmentDetail:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_LABORER_TIME:
                    [self gotoSetLaborerTime];
                    break;
                case WO_DETAIL_EVENT_EQUIPMENT_SHOW:
                    [self gotoEquipmentDetail];
                    break;
                case WO_DETAIL_EVENT_EQUIPMENT_ADD:
                    break;
                case WO_DETAIL_EVENT_EQUIPMENT_EDIT:
                    break;
                case WO_DETAIL_EVENT_EQUIPMENT_DELETE:
                    break;
                case WO_DETAIL_EVENT_TOOL_SHOW:
                    [self gotoToolDetail];
                    break;
                case WO_DETAIL_EVENT_TOOL_ADD:       //工具添加
                    [self gotoAddTool];
                    break;
                case WO_DETAIL_EVENT_TOOL_EDIT:      //工具编辑
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    tool = [_helper getToolAtIndex:tmpNumber.integerValue];
                    [self gotoEditTool:tool];
                    break;
                case WO_DETAIL_EVENT_TOOL_DELETE:    //工具删除
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [_helper deleteToolAtIndex:tmpNumber.integerValue];
                    [self updateList];
                    break;
                case WO_DETAIL_EVENT_MATERIAL_SHOW:
                    [self gotoMaterialDetail];
                    break;
                case WO_DETAIL_EVENT_MATERIAL_ADD:       //物料添加
                    break;
                case WO_DETAIL_EVENT_MATERIAL_EDIT:      //物料编辑
                    break;
                case WO_DETAIL_EVENT_MATERIAL_DELETE:    //物料删除
                    break;
                case WO_DETAIL_EVENT_HISTORY_RECORD_SHOW:
                    tmpArray = [result valueForKeyPath:@"eventData"];
                    [self gotoHistoryRecord:tmpArray];
                    break;
                case WO_DETAIL_EVENT_HISTORY_RECORD_PHOTO_SHOW:
                    tmpDictionary = [result valueForKeyPath:@"eventData"];
                    tmpNumber = [tmpDictionary valueForKeyPath:@"position"];
                    tmpArray = [tmpDictionary valueForKeyPath:@"photosArray"];
                    [_photoHelper setPhotos:tmpArray];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                case WO_DETAIL_EVENT_STEP_SHOW:
                    [self gotoStepDetail];
                    break;
                case WO_DETAIL_EVENT_STEP_EDIT:      //计划性维护步骤编辑:
                    break;
                case WO_DETAIL_EVENT_CHARGE_SHOW:
                    [self gotoChargeDetail];
                    break;
                case WO_DETAIL_EVENT_CHARGE_ADD:    //添加收费项
                    _tag = -1;
                    [self gotoEditCharge:nil];
                    break;
                case WO_DETAIL_EVENT_CHARGE_EDIT:   //修改收费项
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    _tag = tmpNumber.integerValue;
                    charge = [_helper getChargeAtIndex:_tag];
                    [self gotoEditCharge:charge];
                    break;
                case WO_DETAIL_EVENT_CHARGE_DELETE:
                    tmpNumber = [result valueForKeyPath:@"eventData"];
                    [_helper deleteChargeAtIndex:tmpNumber.integerValue];
                    [self updateList];
                    break;
                case WO_DETAIL_EVENT_SIGN_SHOW_CUSTOMER:
                    [self gotoShowSignDetail:WO_DETAIL_EVENT_SIGN_SHOW_CUSTOMER];
                    break;
                case WO_DETAIL_EVENT_SIGN_EDIT_CUSTOMER:
                    [self gotoEditSignDetail:WO_DETAIL_EVENT_SIGN_EDIT_CUSTOMER];
                    break;
                case WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR:
                    [self gotoShowSignDetail:WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR];
                    break;
                case WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR:
                    [self gotoEditSignDetail:WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR];
                    break;
                case WO_DETAIL_EVENT_EDIT_FAILURE_REASON:
                    [self gotoSelectFailureReason];
                    break;
                case WO_DETAIL_EVENT_SHOW_RELATED_ORDER:
                    break;
                default:
                    break;
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([WriteOrderAddContentViewController class])]) {
            NSMutableDictionary * result =  [msg valueForKeyPath:@"result"];
            NSString * str = [result valueForKeyPath:@"eventType"];
            if ([str isEqualToString:@"refresh"]) {
                [self requestData];
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([_cameraHelper class])]) {
//            NSString * imgPath = [msg valueForKeyPath:@"result"];
            NSMutableArray *imgPaths = [msg valueForKeyPath:@"result"];
            [_helper addPhoto:imgPaths];
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WriteOrderLaborerSetTimeViewController class]) ]) {
            NSDictionary * result = [msg valueForKeyPath:@"result"];
            NSNumber * arriveTime = [result valueForKeyPath:@"arriveTime"];
            NSNumber * finishTime = [result valueForKeyPath:@"finishTime"];
            [_helper setActualArrivalTime:arriveTime];
            [_helper setActualFinishTime:finishTime];
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WriteOrderAddToolViewController class])]) {
            WorkOrderTool * tool = [msg valueForKeyPath:@"result"];
            if(_tag == ORDER_TOOL_OPERATE_TYPE_ADD) {
                [_helper addTool:tool];
            } else if(_tag == ORDER_TOOL_OPERATE_TYPE_EDIT){
                [_helper updateTool:tool];
            }
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WriteOrderAddChargeViewController class])]) {
            WorkOrderChargeItem * charge = [msg valueForKeyPath:@"result"];
            if(_tag < 0) {
                [_helper addCharge:charge];
            } else {
                [_helper updateCharge:charge atIndex:_tag];
            }
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([MenuAlertContentView class])]) {
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
                    [_alertView close];
                    break;
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([WorkOrderDetailToolViewController class])]) {
            NSMutableArray * tools = [msg valueForKeyPath:@"result"];
            [_helper setTools:tools];
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WorkOrderDetailCostViewController class])]) {
            NSMutableArray * charges = [msg valueForKeyPath:@"result"];
            [_helper setCharges:charges];
            [self updateList];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WorkOrderSignatureViewController class])]) {
            switch (_tag) {
                case WO_DETAIL_EVENT_SIGN_EDIT_CUSTOMER:
                    [self requestData];
                    break;
                case WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR:
                    [self requestData];
                    break;
                default:
                    break;
            }
        } else if([msgOrigin isEqualToString:NSStringFromClass([WriteOrderRequestApprovalViewController class])]) {
            [self finish];
        } else if([msgOrigin isEqualToString:NSStringFromClass([WorkOrderDetailMaterialViewController class])]) {
            _materialNeedUpdate = YES;
        } else if([msgOrigin isEqualToString:NSStringFromClass([InfoSelectViewController class])]) {
            _materialNeedUpdate = YES;
        } else if([msgOrigin isEqualToString:NSStringFromClass([WorkOrderDetailSelectFailureReasonViewController class])]) {
            FailureReason *reason = [msg valueForKeyPath:@"result"];
            [_helper setFailureReason:reason];
            [self updateList];
        }
    }
}

#pragma mark - 音频播放
//用于录音界面展示中的播放暂停
- (void) playAudioWith:(float) seconds {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if(seconds == 0) {
            [self showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"load_fail" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        } else {
            [_audioPlayAlertView setDurationTime:seconds];
            if(_playerItem) {
                [_playerItem removeObserver:self forKeyPath:@"status"];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
                _playerItem = nil;
            }
            
            
            _playerItem = [AVPlayerItem playerItemWithURL:_playFileURL];
            [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
            
            _audioPalyer = [AVPlayer playerWithPlayerItem:_playerItem];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
            
            [_audioPalyer play];
        }
    });
}

- (void) audioDidEnd:(id) obj {
    NSLog(@"音频播放完成");
}

- (void) playDidEnd {
    NSLog(@"完成");
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if ([_playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
//            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = _playerItem.duration.value / _playerItem.duration.timescale;// 转换成秒
//            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
        } else if ([_playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
    }
}


- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void) pauseRecord{
    [self stopPlaying];
}

//停止播放，释放资源，取消监听
- (void) stopPlaying {
    if(_playerItem) {
        if(_playerItem) {
            [_playerItem removeObserver:self forKeyPath:@"status"];
        }
        _playerItem = nil;
    }
    [_audioPalyer replaceCurrentItemWithPlayerItem:nil];
}


#pragma mark - 页面跳转
- (void) gotoEditContent {  //编辑工作内容
    WriteOrderAddContentViewController * contentVC = [[WriteOrderAddContentViewController alloc] init];
    [contentVC setContent:[_helper getContent]];
    [contentVC setWorkOrderDetail:_orderDetail andWorkOrderId:_orderId];
    [contentVC setOnMessageHandleListener:self];
    [self gotoViewController:contentVC];
}


//播放音视频
- (void) gotoPlayVideo:(NSURL *) videoUrl {
    MediaViewController * mediaVC = [[MediaViewController alloc] init];
    [mediaVC setUrl:videoUrl];
    [self gotoViewController:mediaVC];
}

//播放音频
- (void) gotoPlayAudio:(NSURL *) url {
    _playFileURL = url;
    
    [_alertView showType:@"audioPlay"];
    [_audioPlayAlertView clearAll];
    [_alertView show];
}


//展示需求相关图片
- (void) gotoShowOrderPhoto:(NSInteger) photoIndex {
    NSMutableArray * array = [_helper getOrderPhotosArray];
    [_photoHelper setPhotos:array];
    [_photoHelper showPhotoWithIndex:photoIndex];
}

//展示需求相关图片
- (void) gotoShowRequirementPhoto:(NSInteger) photoIndex {
    NSMutableArray * array = [_helper getRequirementPhoto];
    [_photoHelper setPhotos:array];
    [_photoHelper showPhotoWithIndex:photoIndex];
}

//展示需求相关音频
- (void) gotoShowRequirementAudio:(NSInteger) index {
    NSURL * url = [_helper getRequirementAudioAtIndex:index];
    [self gotoPlayAudio:url];
}

//展示需求相关视频
- (void) gotoShowRequirementVideo:(NSInteger) index {
    NSURL * url = [_helper getRequirementVideoAtIndex:index];
    [self gotoPlayVideo:url];
}

//展示相关附件
- (void) gotoShowAttachmentDetail:(NSInteger) index {
    WorkOrderAttachmentItem *attachment = [_helper getRequirementAttachmentAtIndex:index];
    NSURL *url = [FMUtils getUrlOfAttachmentById:attachment.fileId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:url];
    [attachmentVC setTitleByFileName:attachment.fileName];
    [self gotoViewController:attachmentVC];
}

//设置实际到达时间和完成时间
- (void) gotoSetLaborerTime {
    NSString * laborerName = [_helper getCurrentLaborerInfo].laborer;
    WriteOrderLaborerSetTimeViewController * laborerTimeVC = [[WriteOrderLaborerSetTimeViewController alloc] initWithLaborerName:laborerName];
    NSNumber * arrivalTime = [_helper getActualArrivalTime];
    NSNumber * finishTime = [_helper getActualFinishTime];
    [laborerTimeVC setWorkOrderId:_orderId andLaborerId:[_helper getCurrentLaborerInfo].laborerId];
    [laborerTimeVC setArriveTime:arrivalTime andFinishTime:finishTime];
    [laborerTimeVC setOnMessageHandleListener:self];
    [self gotoViewController:laborerTimeVC];
}

//查看计划性维护步骤详细
- (void) gotoStepDetail {
    WorkOrderDetailStepViewController * stepVC = [[WorkOrderDetailStepViewController alloc] init];
    [stepVC setInfoWith:[_helper getSteps]];
    [stepVC setEditable:[_helper editable]];
    [stepVC setWorkOrderId:_orderId];
    [self gotoViewController:stepVC];
}

//查看收费明细
- (void) gotoChargeDetail {
    NSNumber * materialCharge = [_helper getMaterialCharge];
    WorkOrderDetailCostViewController * chargeVC = [[WorkOrderDetailCostViewController alloc] init];
    NSMutableArray * charges = [_helper getCharges];
    [chargeVC setInfoWith:charges];
    [chargeVC setMaterialCharge:materialCharge];
    [chargeVC setOnMessageHandleListener:self];
    [chargeVC setWorkOrderId:_orderId];
    [chargeVC setEditable:[_helper editable]];
    [self gotoViewController:chargeVC];
}

//编辑工单收费项
- (void) gotoEditCharge:(WorkOrderChargeItem *) charge {
    WriteOrderAddChargeViewController * chargeVC = [[WriteOrderAddChargeViewController alloc] init];
    if(charge) {
        [chargeVC setChargeInfoWithEntity:charge];
    }
    [chargeVC setOnMessageHandleListener:self];
    [self gotoViewController:chargeVC];
}

//查看工具
- (void) gotoToolDetail {
    WorkOrderDetailToolViewController * toolVC = [[WorkOrderDetailToolViewController alloc] init];
    NSArray * tools = [_helper getTools];
    [toolVC setInfoWithTools:tools];
    [toolVC setWorkOrderId:_orderId];
    [toolVC setOnMessageHandleListener:self];
    [toolVC setEditable:[_helper editable]];
    [self gotoViewController:toolVC];
}

//添加工具
- (void) gotoAddTool{
    WriteOrderAddToolViewController * toolVC = [[WriteOrderAddToolViewController alloc] initWithOperateType:ORDER_TOOL_OPERATE_TYPE_ADD];
    _tag = ORDER_TOOL_OPERATE_TYPE_ADD;
    [toolVC setOnMessageHandleListener:self];
    [self gotoViewController:toolVC];
}

//编辑工具
- (void) gotoEditTool:(WorkOrderTool *) tool {
    WriteOrderAddToolViewController * toolVC = [[WriteOrderAddToolViewController alloc] initWithOperateType:ORDER_TOOL_OPERATE_TYPE_EDIT];
    _tag = ORDER_TOOL_OPERATE_TYPE_EDIT;
    [toolVC setInfoWith:tool];
    [toolVC setOnMessageHandleListener:self];
    [self gotoViewController:toolVC];
}

//查看物料
- (void) gotoMaterialDetail {
//    WorkOrderDetailMaterialViewController * vc = [[WorkOrderDetailMaterialViewController alloc] init];
//    [vc setEditable:[_helper editable]];
//    [vc setWorkOrderId:_orderId];
//    [vc setInfoWithMaterials:_materials];
//    [vc setOnMessageHandleListener:self];
//    [self gotoViewController:vc];
    
    WorkOrderDetailReservationViewController * vc = [[WorkOrderDetailReservationViewController alloc] init];
    [vc setInfoWithOrderId:_orderDetail.woId code:_orderDetail.code];
    [vc setOrderStatus:_orderDetail.status];
    [vc setReadOnly:_readonly];
    [vc setReserveAble:[_helper editable]];
    [self gotoViewController:vc];
}

//故障设备
- (void) gotoEquipmentDetail {
    WorkOrderDetailEquipmentViewController * equipmentVC = [[WorkOrderDetailEquipmentViewController alloc] init];
    [equipmentVC setWoId:_orderId];
    [equipmentVC setEquipments:_orderDetail.workOrderEquipments];
    [equipmentVC setEditable:[_helper editable]];
    [self gotoViewController:equipmentVC];
}

//选择执行人
- (void) goToLaborerSelect {
    DispachLaborerViewController * laborerSelectVC = [[DispachLaborerViewController alloc] init];
    [laborerSelectVC setWorkOrderWithId:_orderId];
    [laborerSelectVC setOnMessageHandleListener:self];
    [self gotoViewController:laborerSelectVC];
}

//签字
- (void) gotoMakeSign:(NSInteger) key {
    WorkOrderSignatureViewController * viewController = [[WorkOrderSignatureViewController alloc] init];
    [viewController setOnMessageHandleListener:self];
    [self presentViewController:viewController animated:YES completion:nil];  //此处因为是横屏所以必须用present方法 不能用push方法
}

//历史记录
- (void) gotoHistoryRecord:(NSMutableArray *) histories {
    WorkOrderHistoryRecordViewController * viewController = [[WorkOrderHistoryRecordViewController alloc] init];
    [viewController setHistoryData:histories];
    [self gotoViewController:viewController];
}

- (void) gotoShowSignDetail:(NSInteger) signType {
    //
    WorkOrderSignatureType type = WO_SIGNATURE_TYPE_CUSTOMER;
    NSURL * url;
    
    if(signType == WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR || signType == WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR) {
        type = WO_SIGNATURE_TYPE_SUPERVISOR;
        if(_orderDetail.supervisorSignImgId) {
            url = [_helper getPhotoUrl:_orderDetail.supervisorSignImgId];
        }
    } else  {
        if(_orderDetail.customerSignImgId) {
            url = [_helper getPhotoUrl:_orderDetail.customerSignImgId];
        }
    }
    WorkOrderSignatureViewController * viewController = [[WorkOrderSignatureViewController alloc] initWithSignType:type andOrderId:_orderId];
    _tag = signType;
    [viewController setEditable:NO];
    [viewController setInfoWithUrl:url];
    [self presentViewController:viewController animated:YES completion:nil];  //此处因为是横屏所以必须用present方法 不能用push方法
}

- (void) gotoEditSignDetail:(NSInteger) signType {
    WorkOrderSignatureType type = WO_SIGNATURE_TYPE_CUSTOMER;
    if(signType == WO_DETAIL_EVENT_SIGN_SHOW_SUPERVISOR || signType == WO_DETAIL_EVENT_SIGN_EDIT_SUPERVISOR) {
        type = WO_SIGNATURE_TYPE_SUPERVISOR;
    }
    WorkOrderSignatureViewController * viewController = [[WorkOrderSignatureViewController alloc] initWithSignType:type andOrderId:_orderId];
    [viewController setOnMessageHandleListener:self];
    _tag = signType;
    if(_readonly) {
        [viewController setEditable:NO];
    }
    [self presentViewController:viewController animated:YES completion:nil];  //此处因为是横屏所以必须用present方法 不能用push方法
}

- (void) gotoSelectFailureReason {
    WorkOrderDetailSelectFailureReasonViewController * vc = [[WorkOrderDetailSelectFailureReasonViewController alloc] init];
    [vc setOnMessageHandleListener:self];
    [self gotoViewController:vc];
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

#pragma mark - 处理推送过来的数据
- (void) handleNotification {
    if(self.baseVcParam) {
        _orderId = [self.baseVcParam valueForKeyPath:@"woId"];
        [self requestData];
    }
}

#pragma mark - 通知工单列表刷新
- (void) notifyOrderStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMOrderStatusUpdate" object:nil];
}


#pragma mark - 强制横屏
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
