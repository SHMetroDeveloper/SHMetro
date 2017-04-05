//
//  WorkOrderDetailStepViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailStepViewController.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "SeperatorView.h"
#import "WorkOrderDetailChargeItemView.h"
#import "WorkOrderDetailEntity.h"
#import "WorkOrderDetailPlannedStepItemView.h"
#import "WriteOrderEditPlanStepViewController.h"
#import "WorkOrderSaveEntity.h"
#import "WorkOrderBusiness.h"
#import "SystemConfig.h"
#import "PhotoShowHelper.h"

#import "BaseTextView.h"

@interface WorkOrderDetailStepViewController () <UITableViewDelegate, UITableViewDataSource, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) UIView * topContainerView;
@property (readwrite, nonatomic, strong) UILabel * finishLbl;

//@property (readwrite, nonatomic, strong) UIButton * selectedBtn;
//@property (readwrite, nonatomic, strong) UIImageView * selectImgView;
@property (readwrite, nonatomic, strong) UISwitch * finishSwitch;
@property (readwrite, nonatomic, strong) SeperatorView * topSeperator;

@property (readwrite, nonatomic, strong) UITableView * stepTableView;

@property (readwrite, nonatomic, strong) NSMutableArray * steps;
@property (readwrite, nonatomic, strong) NSMutableArray * groups;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property(readwrite,nonatomic,assign) CGFloat switchWidth;
@property(readwrite,nonatomic,assign) CGFloat switchHeight;

@property (readwrite, nonatomic, assign) CGFloat btnWidth;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat imgHeight;

@property (readwrite, nonatomic, assign) CGFloat topContainerHeight;
@property (readwrite, nonatomic, assign) CGFloat stepItemHeight;

@property (readwrite, nonatomic, assign) CGFloat paddingTop;

@property (readwrite, nonatomic, assign) NSInteger tag;
@property (readwrite, nonatomic, assign) NSInteger position;

@property (readwrite, nonatomic, assign) BOOL editable;
@property (readwrite, nonatomic, assign) BOOL finishAll;
@property (readwrite, nonatomic, assign) BOOL needUpdate;

@property (readwrite, nonatomic, strong) NSNumber * woId;
@property (readwrite, nonatomic, strong) WorkOrderBusiness * business;
@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailStepViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_order_detail_step" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateSelectImgView];
    if([self needEditStep]) {
        [self requestGroups];
    }
    [self initOrderStatusChangeHandler];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_needUpdate) {
        _needUpdate = YES;
        [self updateList];
    }
}

- (void) initLayout {
    if(!_mainContainerView) {
        _business = [WorkOrderBusiness getInstance];
        _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _topContainerHeight = 0;
        _paddingTop = 0;
        _stepItemHeight = 45;
        _imgWidth = 42;
        _imgHeight = 27;
        _switchWidth = [FMSize getInstance].btnWidth;
        _switchHeight = [FMSize getInstance].btnHeight;

        
        CGFloat paddingLeft = 17;
        CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
        
        _btnWidth = paddingLeft * 2 + _imgWidth;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _topContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, _paddingTop, _realWidth, _topContainerHeight)];
        
        _topContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        _finishLbl = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, _realWidth-_btnWidth-paddingLeft, _topContainerHeight)];
        
        
        _finishSwitch = [[UISwitch alloc] init];
        _finishSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _finishSwitch.onTintColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        _switchWidth = CGRectGetWidth(_finishSwitch.frame);
        _switchHeight = CGRectGetHeight(_finishSwitch.frame);
        [_finishSwitch setFrame:CGRectMake(_realWidth - _switchWidth - paddingLeft, (_topContainerHeight-_switchHeight)/2, _switchWidth, _switchHeight)];
        [_finishSwitch addTarget:self action:@selector(onFinishBtnClicked:) forControlEvents:UIControlEventValueChanged];
        
        
        _topSeperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, _topContainerHeight-seperatorHeight, _realWidth, seperatorHeight)];
        
        _finishLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _finishLbl.font = [FMFont fontWithSize:16];
        _finishLbl.text = [[BaseBundle getInstance] getStringByKey:@"btn_title_finish_all" inTable:nil];
        
        
        [_topContainerView addSubview:_finishLbl];
        [_topContainerView addSubview:_finishSwitch];
        [_topContainerView addSubview:_topSeperator];
        
        
//        _stepTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topContainerHeight + _paddingTop * 2, _realWidth, _realHeight - _paddingTop * 2 - _topContainerHeight)];
        _stepTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _realHeight - _paddingTop * 2-_topContainerHeight)];
        _stepTableView.delegate = self;
        _stepTableView.dataSource = self;
        _stepTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _stepTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
//        [_mainContainerView addSubview:_topContainerView];
        [_mainContainerView addSubview:_stepTableView];
        
        [self.view addSubview:_mainContainerView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updateSelectImgView {
    if(_finishAll) {
//        [_selectImgView setImage:[UIImage imageNamed:@"switch_on"]];
    } else {
//        [_selectImgView setImage:[UIImage imageNamed:@"switch_off"]];
    }
}

- (void) updateList {
    [self updateSelectImgView];
    [_stepTableView reloadData];
}

- (void) setInfoWith:(NSMutableArray *) array {
    _steps = array;
    [self updateList];
}

- (void) setMaterialCharge:(NSNumber *)materialCharge {
    _finishLbl = [materialCharge copy];
    [self updateList];
}

- (void) setWorkOrderId:(NSNumber *) woId {
    _woId = [woId copy];
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}



#pragma mark - 全部完成switch
- (void) onFinishBtnClicked:(id) sender {
    if (_finishSwitch.on == YES) {
        NSLog(@"全部完成了,上传数据");
        /**
         *  写一些网络请求，声明全部完成
         */
    } else {
        NSLog(@"还没有全部完成");
        /**
         *  什么都不用做
         */
    }
}

- (NSInteger) getStepCount {
    NSInteger count = [_steps count];
    return count;
}

- (WorkOrderStep *) getStepByPosition:(NSInteger) position {
    WorkOrderStep * step;
    if(position < [_steps count]) {
        step = _steps[position];
    }
    return step;
}

//判断是否可以编辑指定步骤
- (BOOL) canEditStep:(NSInteger) position {
    BOOL res = NO;
    WorkOrderStep * step = [self getStepByPosition:position];
    if(step && !step.finished) {
        for(WorkOrderLaborerWorkTeam * team in _groups) {
            if([team.wtId isEqualToNumber:step.workTeamId]) {
                res = YES;
                break;
            }
        }
    }
    return res;
}

//判断是否需要编辑步骤
- (BOOL) needEditStep {
    BOOL res = NO;
    if(_editable) {
        for(WorkOrderStep * step in _steps) {
            if(!step.finished) {
                res = YES;
                break;
            }
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
    NSInteger count = [self getStepCount];
    return count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    CGFloat padding = 17;
    CGFloat width = CGRectGetWidth(tableView.frame);
    WorkOrderStep * step = [self getStepByPosition:position];
    height = [WorkOrderDetailPlannedStepItemView calculateHeightByInfo:step andWidth:width andPaddingLeft:padding andPaddingRight:padding];
    
    return height;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    UITableViewCell * cell;
    NSString * cellIdentifer;
    
    CGFloat itemHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    SeperatorView * seperator;
    WorkOrderDetailPlannedStepItemView * itemView;
    
    CGFloat padding = 17;
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    if(position < [self getStepCount]) {
        cellIdentifer = @"CellStep";
        WorkOrderStep * step = [self getStepByPosition:position];
        itemHeight = [WorkOrderDetailPlannedStepItemView calculateHeightByInfo:step andWidth:width andPaddingLeft:padding andPaddingRight:padding];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[WorkOrderDetailPlannedStepItemView class]]) {
                    itemView = subView;
                } else if([subView isKindOfClass:[SeperatorView class]]) {
                    seperator = subView;
                }
            }
        }
        if(cell && !itemView) {
            itemView = [[WorkOrderDetailPlannedStepItemView alloc] init];
            [itemView setOnMessageHandleListener:self];
            [cell addSubview:itemView];
        }
        if(cell && !seperator) {
            seperator = [[SeperatorView alloc] init];
            [cell addSubview:seperator];
        }
        if(seperator) {
            if(position < [_steps count] - 1) {
                [seperator setDotted:YES];
                [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding * 2, seperatorHeight)];
            } else {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
        }
        if(itemView) {
            [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
            [itemView setInfoWithStep:step];
            itemView.tag = position;
//            [itemView setEditaViewShow:NO];
        }
    }
    
    return cell;
}


#pragma mark - delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_editable) {
        NSInteger position = indexPath.row;
        if([self canEditStep:position]) {
            [self gotoEditStep:position];
        }
    }
}

- (void) initOrderStatusChangeHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WorkOrderStepUpdate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(markNeepUpdate:)
                                                 name: @"WorkOrderStepUpdate"
                                               object: nil];
}


- (void) markNeepUpdate:(NSNotification *)notification {
    NSLog(@"收到通知 --- %@", NSStringFromClass([self class]));
    _needUpdate = YES;
    WorkOrderStep * step = notification.object;
    if(step) {
        for(NSInteger index = 0; index < [_steps count]; index++) {
            WorkOrderStep * tmpStep = _steps[index];
            if([tmpStep.stepId isEqualToNumber:step.stepId]) {
                _steps[index] = step;
                break;
            }
        }
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FMOrderStatusUpdate" object:nil];
}




#pragma mark - 数据更新
- (void) notifyChargeUpdate {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:_steps forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

#pragma mark - handleMessage
- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([WorkOrderDetailPlannedStepItemView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            NSMutableDictionary * dict;
            NSMutableArray * array;
            WorkOrderPlannedStepEventType eventType = tmpNumber.integerValue;
            switch(eventType) {
                case WO_PLANNED_STEP_EVENT_SHOW_PHOTO:
                    dict = [msg valueForKeyPath:@"result"];
                    tmpNumber = [dict valueForKeyPath:@"position"];
                    array = [dict valueForKeyPath:@"photosArray"];
                    [_photoHelper setPhotos:array];
                    [_photoHelper showPhotoWithIndex:tmpNumber.integerValue];
                    break;
                default:
                    break;
            }
        }
    }
}

//  获取工作组信息
- (void) requestGroups {
    [self showLoadingDialog];
    if(_business) {
        NSNumber * emID = [SystemConfig getEmployeeId];
        [_business getWorkGroups:emID success:^(NSInteger key, id object) {
            _groups = object;
            [self hideLoadingDialog];
        } fail:^(NSInteger key, NSError *error) {
            [self hideLoadingDialog];
        }];
    }
}

#pragma mark - 编辑步骤
- (void) gotoEditStep:(NSInteger) position {
    WorkOrderStep * step = _steps[position];
    WriteOrderEditPlanStepViewController * editVC = [[WriteOrderEditPlanStepViewController alloc] init];
    [editVC setInfoWithStep:step];
    [editVC setWorkOrderId:_woId];
//    [editVCset]
    [self gotoViewController:editVC];
}


@end
