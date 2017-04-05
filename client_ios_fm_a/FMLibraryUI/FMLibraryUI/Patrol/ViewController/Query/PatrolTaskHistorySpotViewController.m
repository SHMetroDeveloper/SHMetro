//
//  PatrolTaskHistorySpotViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskHistorySpotViewController.h"
#import "PatrolTaskItemView.h"
#import "PatrolTaskSpotItemView.h"
#import "SpotContentItemView.h"
#import "PatrolCheckViewController.h"
#import "BaseBundle.h"
 
#import "ReportEntity.h"
#import "PatrolHistorySpotContentItemView.h"
#import "PatrolHistorySpotDeviceItemView.h"
#import "PatrolHistorySpotWorkOrderItemView.h"
#import "DXAlertView.h"
#import "PatrolHistoryQuestionAlertContentView.h"
#import "WorkOrderHistoryEntity.h"

typedef enum {
    SECTION_TYPE_UNKNOW = 0,
    SECTION_TYPE_CONTENT = 1000,
    SECTION_TYPE_DEVICE = 2000,
    SECTION_TYPE_WORKORDER = 3000
}SectionType;

@interface PatrolTaskHistorySpotViewController ()
@property (readwrite, nonatomic, assign) CGFloat listItemHeight;
@property (readwrite, nonatomic, assign) CGFloat listHeaderHeight;
@property (readwrite, nonatomic, assign) CGFloat deviceItemHeight;

@property (readwrite, nonatomic, strong) Equipment* mSpotCheckContent;
@property (readwrite, nonatomic, strong) WorkOrderHistory* mOrder;
@property (readwrite, nonatomic, strong) NSMutableArray* mDevices;
@property (readwrite, nonatomic, strong) NSString* spotName;

@property (readwrite, nonatomic, strong) UITableView * pullTableView;

@end


@implementation PatrolTaskHistorySpotViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (void) initRefreshView {
    CGRect frame = [self getContentFrame];
    self.pullTableView = [[UITableView alloc] initWithFrame:frame];
    
    self.pullTableView.dataSource = self;
    self.pullTableView.delegate = self;
    
    
    [self.view addSubview:self.pullTableView];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _listItemHeight = 40;
    _listHeaderHeight = 40;
    _deviceItemHeight = 80;
    [self initRefreshView];
}

- (void) initNavigation {
    [self setTitleWith:[[NSString alloc] initWithFormat:@"%@:[%@]", [[BaseBundle getInstance] getStringByKey:@"patrol_spot" inTable:nil], _spotName]];
    [self setBackAble:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) setSpotName:(NSString *) spotName
     andEquipment:(Equipment *) equip
        andDevice:(NSMutableArray*) devices
     andWorkOrder:(WorkOrderHistory *) workOrder {
    _spotName = spotName;
    _mSpotCheckContent = equip;
    _mDevices = devices;
    _mOrder = workOrder;
    
}

//获取当前 section 类型
- (SectionType) getSectionType:(NSInteger) section {
    SectionType type = SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            if(_mSpotCheckContent) {
                type = SECTION_TYPE_CONTENT;
            } else if(_mDevices) {
                type = SECTION_TYPE_DEVICE;
            } else if(_mOrder) {
                type = SECTION_TYPE_WORKORDER;
            }
            break;
        case 1:
            if(_mDevices) {
                type = SECTION_TYPE_DEVICE;
            } else if(_mOrder) {
                type = SECTION_TYPE_WORKORDER;
            }
            break;
        case 2:
            if(_mOrder) {
                type = SECTION_TYPE_WORKORDER;
            }
            break;
        default:
            type = SECTION_TYPE_UNKNOW;
            break;
    }
    return type;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger count = 0;
    if(_mSpotCheckContent) {
        count++;
    }
    if(_mDevices) {
        count++;
    }
    if(_mOrder) {
        count++;
    }
    return count;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    SectionType type = [self getSectionType:section];
    switch(type) {
        case SECTION_TYPE_CONTENT:
            count = [_mSpotCheckContent.contents count];
            break;
        case SECTION_TYPE_DEVICE:
            count = [_mDevices count];
            break;
        case SECTION_TYPE_WORKORDER:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    CGFloat height = 0;
    SectionType type = [self getSectionType:section];
    switch(type) {
        case SECTION_TYPE_CONTENT:
            height = _listItemHeight;
            break;
        case SECTION_TYPE_DEVICE:
            height = _deviceItemHeight;
            break;
        case SECTION_TYPE_WORKORDER:
            height = _listItemHeight;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *cellIdentifier = nil;
    UITableViewCell* cell = nil;
    SectionType type = [self getSectionType:section];
    PatrolHistorySpotContentItemView * contentItemView = nil;
    PatrolHistorySpotDeviceItemView * deviceItemView = nil;
    PatrolHistorySpotWorkOrderItemView * orderItemView = nil;
    switch(type) {
        case SECTION_TYPE_CONTENT:      //巡检内容
            cellIdentifier = @"Cell_CONTENT";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[PatrolHistorySpotContentItemView class]]) {
                        contentItemView = view;
                        break;
                    }
                }
            }
            if(cell && !contentItemView) {
                contentItemView = [[PatrolHistorySpotContentItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _listItemHeight)];
                
                [contentItemView setOnListItemButtonClickListener:self];
                [cell addSubview:contentItemView];
            }
            if(contentItemView) {
                PatrolTaskItemDetail *item = _mSpotCheckContent.contents[position];
                NSString* result = nil;
                NSString* normal = nil;
                NSString* report = nil;
                if(item.resultType.integerValue == 1) {
                    result = item.resultInput;
                } else {
                    result = item.resultSelect;
                }
                if([item isException]) {
                    normal = [[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil];
                } else {
                    normal = [[BaseBundle getInstance] getStringByKey:@"patrol_status_normal" inTable:nil];
                }
                if([item isReport]) {
                    report = [[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil];
                } else {
                    report = @"";
                }
                [contentItemView setInfoWithName:item.content result:result normal:normal report:report];
                [contentItemView setPaddingLeft:30 right:10];
                contentItemView.tag = position;
            }
            break;
        case SECTION_TYPE_DEVICE:       //设备信息
            cellIdentifier = @"Cell_DEVICE";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[PatrolHistorySpotDeviceItemView class]]) {
                        deviceItemView = view;
                        break;
                    }
                }
            }
            if(cell && !deviceItemView) {
                deviceItemView = [[PatrolHistorySpotDeviceItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _deviceItemHeight)];
                [deviceItemView setPaddingLeft:30 right:10];
                [cell addSubview:deviceItemView];
            }
            if(deviceItemView) {
                Device * device = _mDevices[position];
                [deviceItemView setInfoWithName:device.name code:device.code system:[device getDeviceType].equSysName];
                deviceItemView.tag = position;
            }
            break;
        case SECTION_TYPE_WORKORDER:
            cellIdentifier = @"Cell_WORKORDER";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id view in subViews) {
                    if([view isKindOfClass:[PatrolHistorySpotWorkOrderItemView class]]) {
                        orderItemView = view;
                        break;
                    }
                }
            }
            if(cell && !orderItemView) {
                orderItemView = [[PatrolHistorySpotWorkOrderItemView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _listItemHeight)];
                [orderItemView setPaddingLeft:30 right:10];
                [cell addSubview:orderItemView];
            }
            if(orderItemView) {
                [orderItemView setInfoWithCode:_mOrder.code time:[_mOrder getFinishTimeStr] state:[_mOrder getStatusStr]];
                orderItemView.tag = position;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    SectionType type = [self getSectionType:section];
    NSString * header = nil;
    switch(type) {
        case SECTION_TYPE_CONTENT:
            header = [[BaseBundle getInstance] getStringByKey:@"patrol_spot_content" inTable:nil];
            break;
        case SECTION_TYPE_DEVICE:
            header = [[BaseBundle getInstance] getStringByKey:@"patrol_device_info" inTable:nil];
            break;
        case SECTION_TYPE_WORKORDER:
            header = [[BaseBundle getInstance] getStringByKey:@"patrol_order_list" inTable:nil];
            break;
        default:
            break;
    }
    return header;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    [self showContentItem:position];
}

- (void) onButtonClick:(UIView *)parent view:(UIView *)view {
    DXAlertView * alert = [[DXAlertView alloc] initWithTitle:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] contentText:[[BaseBundle getInstance] getStringByKey:@"patrol_notice_report" inTable:nil] leftButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_no" inTable:nil] rightButtonTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_yes" inTable:nil] viewController:self];
    alert.leftBlock = ^(){
        
    };
    alert.rightBlock = ^(){
    };
    [alert showIn:self];
}

- (void) showContentItem:(NSInteger) position {
    if(_mSpotCheckContent) {
        PatrolTaskItemDetail * item = _mSpotCheckContent.contents[position];
        if(item) {
            CustomAlertView *alertView = [[CustomAlertView alloc] init];
            PatrolHistoryQuestionAlertContentView * contentView = [[PatrolHistoryQuestionAlertContentView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
            [contentView setInfoWith:item];
            [contentView setPaddingLeft:20 right:20];
            [alertView setContainerView:contentView];
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_i_know" inTable:nil], nil]];
            [alertView setOnButtonTouchUpInside:^(CustomAlertView *alertView, int buttonIndex) {
                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                [alertView close];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];

        }
    }
}

- (void)customDialogButtonTouchUpInside: (CustomAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

@end

