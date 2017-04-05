//
//  WorkOrderFilterViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/31.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderHistoryFilterViewController.h"
#import "WorkOrderServerConfig.h"
#import "BaseDataDBHelper.h"
#import "FMColor.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"
#import "FMUtils.h"

#import "WorkOrderHistoryEntity.h"
#import "BaseDataEntity.h"
#import "FilterSelectView.h"
#import "SeperatorView.h"
#import "REFrostedViewController.h"
#import "UIButton+Bootstrap.h"

@interface WorkOrderHistoryFilterViewController ()

@property (nonatomic, strong) UIView * mainContainerView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * controlView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;

@property (nonatomic, strong) NSMutableArray * priorityArray;
@property (nonatomic, strong) NSMutableArray * statusArray;

@property (nonatomic, strong) NSMutableArray * selectedArray;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WorkOrderHistoryFilterViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _priorityArray = [[NSMutableArray alloc] init];
    _statusArray = [[NSMutableArray alloc] init];
    _selectedArray = [[NSMutableArray alloc] init];
    
    //获取优先级信息
    _priorityArray = [[BaseDataDbHelper getInstance] queryAllPrioritysOfCurrentProject];
    
    //获取状态信息
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_CREATE]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_DISPACHED]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_PROCESS]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_STOP]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_TERMINATE]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_FINISH]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_VALIDATATION]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_CLOSE]];
    [_statusArray addObject:[NSNumber numberWithInteger:ORDER_STATUS_APPROVE]];
    
}

- (void) initLayout {
    CGFloat controlHeight = [FMSize getInstance].bottomControlHeight;
    controlHeight = 60;
    CGRect frame = [self getContentFrame];
    CGFloat originX = 0;
    CGFloat originY = 0;
    frame.size.width -= 80;
    frame.size.height -= [FMSize getInstance].statusbarHeight + [FMSize getInstance].navigationbarHeight;
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    //tableView的初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-controlHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //按钮控制View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-controlHeight, frame.size.width, controlHeight)];
    _controlView.backgroundColor = [FMColor getInstance].mainBackground;
    
    
    CGFloat btnHeight = [FMSize getInstance].selectListItemHeight;;
    CGFloat sepHeight = (controlHeight - btnHeight)/2;
    CGFloat btnWidth = (_controlView.frame.size.width - sepHeight*3)/2;
    originY = sepHeight;
    originX = sepHeight;
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
    [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_reset" inTable:nil] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[FMColor getInstance].mainWhite forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    [_cancelBtn grayStyle];
    _cancelBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.masksToBounds = YES;
    
    [_cancelBtn addTarget:self action:@selector(onResetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX + sepHeight + btnWidth, originY, btnWidth, btnHeight)];
    [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[FMColor getInstance].mainWhite forState:UIControlStateNormal];
    [_doneBtn setBackgroundColor:[UIColor colorWithRed:97/255.0 green:184/255.0 blue:41/255.0 alpha:1]];
    [_doneBtn successStyle];
    _doneBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    _doneBtn.layer.cornerRadius = 3;
    _doneBtn.layer.masksToBounds = YES;
    [_doneBtn addTarget:self action:@selector(onOkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_controlView addSubview:_cancelBtn];
    [_controlView addSubview:_doneBtn];
    
    
    [_mainContainerView addSubview:_tableView];
    [_mainContainerView addSubview:_controlView];
    
    [self.view addSubview:_mainContainerView];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = [_priorityArray count] + 1;  //多了一个"不限"
            break;
        case 1:
            count = [_statusArray count] + 1;    //多了一个"不限"
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    switch (section) {
        case 0:
            //获取优先级的名称
            if (position == 0) {
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                Priority * pri = _priorityArray[position - 1];
                NSString * priorityStr = pri.name;
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
            
        case 1:
            //获取状态的名称
            if (position == 0) {
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                NSNumber * nstatus = _statusArray[position - 1];
                WorkOrderStatus woStatus = (WorkOrderStatus)nstatus.integerValue;
                NSString * statusStr = [WorkOrderServerConfig getOrderStatusDesc:woStatus];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
    }
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    BOOL isExist = NO;
    FilterSelectView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat padding = [FMSize getInstance].listePadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = 0;
    NSString * title = nil;
    switch (section) {
        case 0: {
            //获取优先级的名称
            if (position == 0) {
                title = [[BaseBundle getInstance] getStringByKey:@"filter_no_limits" inTable:nil];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                Priority * pri = _priorityArray[position-1];
                title = pri.name;
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
        }
        case 1: {
            //获取状态的名称
            if (position == 0) {
                title = [[BaseBundle getInstance] getStringByKey:@"filter_no_limits" inTable:nil];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            } else {
                NSNumber * nstatus = _statusArray[position-1];
                WorkOrderStatus woStatus = (WorkOrderStatus)nstatus.integerValue;
                title = [WorkOrderServerConfig getOrderStatusDesc:woStatus];
                itemHeight = [FMSize getInstance].selectListItemHeight;
            }
            break;
        }
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[FilterSelectView class]]) {
                itemView = view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if (cell && !itemView) {
        itemView = [[FilterSelectView alloc] init];
        [cell addSubview:itemView];
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if (seperator) {
        if ((section == 0 && position == _priorityArray.count) || (section == 1 && position == _statusArray.count)) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        } else {
            [seperator setDotted:YES];
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
        }  //最后一条分割线设为全长
    }
    if (itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        [itemView setTitleInfoWith:title];
        for (NSIndexPath * index in _selectedArray) {
            if ([index isEqual:indexPath]) {
                isExist = YES;
            }
        }
        [itemView setChecked:isExist];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [FMSize getInstance].selectHeaderHeight;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 52)];
    titleView.backgroundColor = [FMColor getInstance].mainBackground;
    
    UILabel * titleLbl = [[UILabel alloc] init];
    CGFloat padding = [FMSize getInstance].padding50;
    
    titleLbl.font = [FMFont getInstance].font42;
    titleLbl.textColor = [FMColor getInstance].grayLevel4;
    [titleLbl setFrame:CGRectMake(padding, [FMSize getInstance].padding70, 80, 19)];
    switch (section) {
        case 0:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"filter_header_title_priority" inTable:nil];
            break;
        case 1:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"filter_header_title_status" inTable:nil];
            break;
    }
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01f;
    return height;
}

#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    BOOL isExist = NO;
    
    for (int i = 0; i<_selectedArray.count; i++) {
        NSIndexPath * index = _selectedArray[i];
        if ([index isEqual:indexPath]) {
            isExist = YES;
            [_selectedArray removeObject:index];
            break;
        }
    }
    
    if (position == 0) {
        for (int i = _selectedArray.count-1; i >= 0; i--) {
            NSIndexPath * index = _selectedArray[i];
            if (index.section == section) {
                [_selectedArray removeObject:index];
            }
        }
        [_selectedArray addObject:indexPath];
    } else {
        for (int i = _selectedArray.count-1; i >= 0; i--) {
            NSIndexPath * index = _selectedArray[i];
            if (index.row == 0) {
                [_selectedArray removeObject:index];
            }
        }
        if (!isExist) {
            [_selectedArray addObject:indexPath];
        }
    }
    
    [_tableView reloadData];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult {
    if(_handler) {
        WorkOrderHistorySearchCondition * filter = [[WorkOrderHistorySearchCondition alloc] init];
        for (NSIndexPath * result in _selectedArray) {
            NSInteger section = result.section;
            NSInteger position = result.row;
            switch (section) {
                case 0:{
                    if (position != 0) {
                        Priority * pri = _priorityArray[position - 1];
                        [filter.priority addObject:pri.priorityId];
                    }
                    break;
                }
                case 1:{
                    if (position != 0) {
                        NSNumber * status = _statusArray[position - 1];
                        WorkOrderStatus woStatus = (WorkOrderStatus)status.integerValue;
                        if(woStatus == ORDER_STATUS_STOP) { //暂停包括暂停不继续
                            [filter.status addObject:[NSNumber numberWithInteger:ORDER_STATUS_STOP_N]];
                        }
                        [filter.status addObject:[NSNumber numberWithInteger:woStatus]];
                    }
                    break;
                }
            }
        }
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:filter forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}


- (void) onResetBtnClick {
    [_selectedArray removeAllObjects];
    [_tableView reloadData];
}

- (void) onOkBtnClick {
    [self handleResult];
    [self.frostedViewController hideMenuViewController];
}

@end
