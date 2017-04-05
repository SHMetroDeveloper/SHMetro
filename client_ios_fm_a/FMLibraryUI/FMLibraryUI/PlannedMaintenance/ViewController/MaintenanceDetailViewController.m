//
//  MaintenanceDetailViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MaintenanceDetailViewController.h"
#import "PlannedMaintenanceBusiness.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "MaintenanceDetailHelper.h"
#import "TaskAlertView.h"
#import "PhotoItemContentView.h"
#import "PhotoItemModel.h"
#import "WorkOrderDetailViewController.h"
#import "ImageItemView.h"
#import "AttachmentViewController.h"

@interface MaintenanceDetailViewController () <OnClickListener, OnItemClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * tableView;
@property (readwrite, nonatomic, strong) UIButton * moreBtn;

@property (readwrite, nonatomic, strong) TaskAlertView * alertView;
@property (readwrite, nonatomic, strong) PhotoItemContentView * photoContentView;
@property (readwrite, nonatomic, assign) BOOL isWorking;

@property (readwrite, nonatomic, strong) ImageItemView * noticeLbl;   //提示
@property (readwrite, nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (readwrite, nonatomic, strong) NSNumber * pmId;
@property (readwrite, nonatomic, strong) NSNumber * todoId;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, assign) CGFloat alertViewHeight;
@property (readwrite, nonatomic, assign) CGFloat photoContentHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;
@property (readwrite, nonatomic, strong) MaintenanceDetailEntity *detailInfo;
@property (readwrite, nonatomic, strong) PlannedMaintenanceBusiness * business;
@property (readwrite, nonatomic, strong) MaintenanceDetailHelper * helper;
@end

@implementation MaintenanceDetailViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBusiness];
    [self requestData];
    [self initAlertView];
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"maintenance_detail" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        _btnWidth = 60;
        _photoContentHeight = [PhotoItemContentView getContentHeightByModelCount:2];
        _noticeHeight = [FMSize getInstance].noticeHeight;
        
        _helper = [[MaintenanceDetailHelper alloc] init];
        [_helper setOnMessageHandleListener:self];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _alertViewHeight = CGRectGetHeight(self.view.frame);
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = _helper;
        _tableView.delegate = _helper;
        _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"maintenance_notice_no_order" inTable:nil] andLogo:[[FMTheme getInstance] getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance] getImageByName:@"no_data"]];
        
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    
        
        CGFloat padding = [FMSize getInstance].defaultPadding;
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(_realWidth-padding-_btnWidth, _realHeight-padding-_btnWidth, _btnWidth, _btnWidth)];
        [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_more_normal"] forState:UIControlStateNormal];
        [_moreBtn setImage:[[FMTheme getInstance] getImageByName:@"btn_more_highlight"] forState:UIControlStateHighlighted];
        [_moreBtn addTarget:self action:@selector(onMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.layer.cornerRadius = _btnWidth/2;
        
        
        _photoContentView = [[PhotoItemContentView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _photoContentHeight)];
        [_photoContentView setOnItemClickListener:self];
        
        [_mainContainerView addSubview:_tableView];
        [_mainContainerView addSubview:_noticeLbl];
        [_mainContainerView addSubview:_moreBtn];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void) updateLayout {
    
}

- (void) initBusiness {
    _detailInfo = [[MaintenanceDetailEntity alloc] init];
    _business = [PlannedMaintenanceBusiness getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initAlertView {
    _alertView = [[TaskAlertView alloc] init];
    [_alertView setFrame:CGRectMake(0, 0, _realWidth, _alertViewHeight)];
    [_alertView setHidden:YES];
    [_alertView setOnClickListener:self];
    [self.view addSubview:_alertView];
    
    CGFloat contentHeight = _photoContentHeight;
    
    contentHeight = _photoContentHeight;
    [_alertView setContentView:_photoContentView withKey:@"type" andHeight:contentHeight andPosition:ALERT_CONTENT_POSITION_BOTTOM];
    
}


//设置 ID
- (void) setInfoWithPmId:(NSNumber *) pmId todoId:(NSNumber *) todoId {
    _pmId = [pmId copy];
    _todoId = [todoId copy];
}

- (void) updateList {
    [self updateNoticeView];
    [_tableView reloadData];
}

- (void) updateNoticeView {
    if([_helper hasData]) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

#pragma mark --- 类型切换
- (void) onMoreBtnClicked:(id) btn {
    MaintenanceDetailShowType type = [_helper getShowType];
    [self updateMoreAlertView:type];
    [self showAlertView];
    
}

- (void) updateMoreAlertView:(MaintenanceDetailShowType) type {
    NSMutableArray * models = [[NSMutableArray alloc] init];
    PhotoItemModel * modelLeft = [[PhotoItemModel alloc] init];
    PhotoItemModel * modelRight = [[PhotoItemModel alloc] init];
    switch(type) {
        case PM_DETAIL_SHOW_BASE:
            modelLeft.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_target" inTable:nil];
            modelLeft.img = [[FMTheme getInstance] getImageByName:@"maintenance_target"];
            modelLeft.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_target_focus"];
            modelLeft.key = PM_DETAIL_SHOW_TARGET;
            
            modelRight.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_order" inTable:nil];
            modelRight.img = [[FMTheme getInstance] getImageByName:@"maintenance_order"];
            modelRight.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_order_focus"];
            modelRight.key = PM_DETAIL_SHOW_ORDER;
            break;
        case PM_DETAIL_SHOW_TARGET:
            modelLeft.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_content" inTable:nil];
            modelLeft.img = [[FMTheme getInstance] getImageByName:@"maintenance_base"];
            modelLeft.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_base_focus"];
            modelLeft.key = PM_DETAIL_SHOW_BASE;
            
            modelRight.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_order" inTable:nil];
            modelRight.img = [[FMTheme getInstance] getImageByName:@"maintenance_order"];
            modelRight.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_order_focus"];
            modelRight.key = PM_DETAIL_SHOW_ORDER;
            break;
        case PM_DETAIL_SHOW_ORDER:
            modelLeft.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_content" inTable:nil];
            modelLeft.img = [[FMTheme getInstance] getImageByName:@"maintenance_base"];
            modelLeft.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_base_focus"];
            modelLeft.key = PM_DETAIL_SHOW_BASE;
            
            modelRight.name = [[BaseBundle getInstance] getStringByKey:@"maintenance_target" inTable:nil];
            modelRight.img = [[FMTheme getInstance] getImageByName:@"maintenance_target"];
            modelRight.imgHighlight = [[FMTheme getInstance] getImageByName:@"maintenance_target_focus"];
            modelRight.key = PM_DETAIL_SHOW_TARGET;
            break;
        default:
            break;
    }
    [models addObject:modelLeft];
    [models addObject:modelRight];
    [_photoContentView setInfoWith:models];
}

- (void) showAlertView {
    _isWorking = YES;
    [_alertView showType:@"type"];
    [_alertView show];
}

- (void) resetWorking {
    if(_isWorking) {
        _isWorking = NO;
        [_alertView close];
    }
}

#pragma mark - 点击
- (void) onClick:(UIView *)view {
    if(_isWorking) {
        [self resetWorking];
    }
}

- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if(view == _photoContentView) {
        [self resetWorking];
        if(subView) {
            NSInteger tag = subView.tag;
            PhotoItemModel * model = [_photoContentView getModelByTag:tag];
            switch(model.key) {
                case PM_DETAIL_SHOW_BASE:
                    [_helper setShowType:PM_DETAIL_SHOW_BASE];
                    break;
                case PM_DETAIL_SHOW_TARGET:
                    [_helper setShowType:PM_DETAIL_SHOW_TARGET];
                    break;
                case PM_DETAIL_SHOW_ORDER:
                    [_helper setShowType:PM_DETAIL_SHOW_ORDER];
                    break;
            }
            [self updateList];
        }
    }
}

#pragma mark --- 事件处理
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_helper class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            MaintenanceDetailEventType type = [tmpNumber integerValue];
            id result = [msg valueForKeyPath:@"result"];
            MaintenanceDetailOrderEntity * order;
            NSNumber  *position;
            switch(type) {
                case PM_DETAIL_EVENT_SHOW_ORDER_DETAIL:
                    order = (MaintenanceDetailOrderEntity *) result;
                    [self gotoOrderDetail:order.woId];
                    break;
                case PM_DETAIL_EVENT_SHOW_ATTACHMENT_DETAIL:
                    position = (NSNumber *) result;
                    [self gotoAttachmentDetail:position.integerValue];
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - 请求数据
- (void) requestData {
    [self showLoadingDialog];
    [_business getMaintenanceDetailWithPmId:_pmId todoId:_todoId success:^(NSInteger key, id object) {
        MaintenanceDetailEntity * entity = object;
        _detailInfo = entity;
        [_helper setInfoWith:entity];
        [self updateList];
        [self hideLoadingDialog];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
    }];
}

#pragma mark - 页面跳转
- (void) gotoOrderDetail:(NSNumber *) orderId {
    WorkOrderDetailViewController * orderVC = [[WorkOrderDetailViewController alloc] init];
    [orderVC setWorkOrderWithId:orderId];
    [orderVC setReadOnly:YES];
    [self gotoViewController:orderVC];
}

- (void) gotoAttachmentDetail:(NSInteger) position {
    MaintenanceDetailAttachmentEntity *attachment = _detailInfo.pictures[position];
    NSURL *attachmentURL = [FMUtils getUrlOfAttachmentById:attachment.fileId];
    AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentURL];
    [attachmentVC setTitleByFileName:attachment.fileName];
    [self gotoViewController:attachmentVC];
}

@end
