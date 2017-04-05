//
//  PlannedMaintenanceHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PlannedMaintenanceHelper.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "MaintenanceItemView.h"
#import "MarkedListHeaderView.h"
#import "MaintenanceEntity.h"
#import "PlannedMaintenanceServerConfig.h"
#import "CurrentMonthTaskView.h"
#import "MaintenanceEventHelper.h"
#import "JTCalendar.h"


typedef NS_ENUM(NSInteger, PlannedMaintenanceSectionType) {
    PM_SECTION_TYPE_UNKNOW,
    PM_SECTION_TYPE_CALENDAR,       //日历
    PM_SECTION_TYPE_INFO,       //概况
    PM_SECTION_TYPE_FINISHED,   //已完成
    PM_SECTION_TYPE_LEAK,       //漏检
    PM_SECTION_TYPE_UNFINISHED, //未完成
    PM_SECTION_TYPE_PROCESS,    //处理中
};

@interface PlannedMaintenanceHelper () <JTCalendarDelegate>
@property (readwrite, nonatomic, strong) UIView *calendarContainerView;
@property (readwrite, nonatomic, strong) JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (readwrite, nonatomic, strong) CurrentMonthTaskView * baseItemView;

@property (readwrite, nonatomic, strong) NSMutableArray * dataArray;

@property (readwrite, nonatomic, strong) NSMutableArray * finishedArray;    //存已完成的数据的索引
@property (readwrite, nonatomic, strong) NSMutableArray * leakArray;        //漏检
@property (readwrite, nonatomic, strong) NSMutableArray * unFinishedArray;  //未完成
@property (readwrite, nonatomic, strong) NSMutableArray * processArray;     //处理中

@property (readwrite, nonatomic, assign) CGFloat headerHeight;
@property (readwrite, nonatomic, assign) CGFloat baseInfoHeight;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat calendarHeight;
@property (readwrite, nonatomic, assign) CGFloat footerHeight;

@property (readwrite, nonatomic, strong) NSDate * todayDate;
@property (readwrite, nonatomic, strong) NSDate * dateSelected;
@property (readwrite, nonatomic, strong) MaintenanceEventHelper * eventHelper; //任务管理


@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation PlannedMaintenanceHelper

- (instancetype) initWithContext:(BaseViewController *) context {
    self = [super init];
    if(self) {
        [self initSetting];
    }
    return self;
}

- (void) initSetting {
    _headerHeight = 50;
    _baseInfoHeight = 70;
    _itemHeight = 80;
    _footerHeight = 10;
    _calendarHeight = 280;
    _todayDate = [NSDate date];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _eventHelper = [[MaintenanceEventHelper alloc] init];
    
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
//
//
//    [_calendarManager setContentView:_calendarContentView];
//
//    [_calendarManager setDate:_todayDate];
}

- (void) initCalendarBackground {
    //添加渐变色背景
    CGFloat width = CGRectGetWidth(_calendarContainerView.frame);
    CGFloat height = CGRectGetHeight(_calendarContainerView.frame);
    CAGradientLayer * gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, width, height);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[[UIColor colorWithRed:0x64/255.0 green:0x5e/255.0 blue:0x60/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                       (id)[[[UIColor colorWithRed:0x24/255.0 green:0x34/255.0 blue:0x43/255.0 alpha:1] colorWithAlphaComponent:1] CGColor],
                       nil];
    //    [gradient setLocations:@[@0.5]];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(0, 1.0);
    
    [_calendarContainerView.layer insertSublayer:gradient atIndex:0];
}


- (void) setDataWithArray:(NSMutableArray *) dataArray {
    _dataArray = dataArray;
    [_eventHelper setInfoWith:_dataArray];
    [self updateIndexArray];
    [_calendarManager reload];
}

- (void) clearAll  {
    _dateSelected = nil;
    if(_dataArray) {
        [_dataArray removeAllObjects];
    }
    if(_unFinishedArray) {
        [_unFinishedArray removeAllObjects];
    }
    if(_finishedArray) {
        [_finishedArray removeAllObjects];
    }
    if(_leakArray) {
        [_leakArray removeAllObjects];
    }
    if(_processArray) {
        [_processArray removeAllObjects];
    }
}

//获取开始时间
- (NSNumber *) getTimeStart {
    NSNumber * timeStart;
    NSDate * date = [FMUtils getFirstSecondOfMonth:_calendarManager.date];
    timeStart = [FMUtils dateToTimeLong:date];
    
    return timeStart;
}
//获取结束时间
- (NSNumber *) getTimeEnd {
    NSNumber * timeEnd;
    NSDate* date = [FMUtils getLastSecondOfMonth:_calendarManager.date];
    timeEnd = [FMUtils dateToTimeLong:date];
    return timeEnd;
}

//获取选中的时间
- (NSDate *) getDateSelected {
    return _dateSelected;
}

- (NSInteger) getCount {
    return [_dataArray count];
}


//更新索引
- (void) updateIndexArray {
    if(!_finishedArray) {
        _finishedArray = [[NSMutableArray alloc] init];
    } else {
        [_finishedArray removeAllObjects];
    }
    if(!_leakArray) {
        _leakArray = [[NSMutableArray alloc] init];
    } else {
        [_leakArray removeAllObjects];
    }
    if(!_unFinishedArray) {
        _unFinishedArray = [[NSMutableArray alloc] init];
    } else {
        [_unFinishedArray removeAllObjects];
    }
    if(!_processArray) {
        _processArray = [[NSMutableArray alloc] init];
    } else {
        [_processArray removeAllObjects];
    }
    NSInteger index = 0;
    for(MaintenanceEntity * obj in _dataArray) {
        MaintenanceTaskStatus status = obj.status;
        NSDate * date = [FMUtils timeLongToDate:obj.dateTodo];
        if(!_dateSelected || [FMUtils isDate:_dateSelected inTheSameDayOfDate:date]) {   //没有指定日期或者跟指定的日期一样
            switch(status) {
                case PM_TASK_STATUS_UNDO:
                    [_unFinishedArray addObject:[NSNumber numberWithInteger:index]];
                    break;
                case PM_TASK_STATUS_PROCESS:
                    [_processArray addObject:[NSNumber numberWithInteger:index]];
                    break;
                case PM_TASK_STATUS_FINISHED:
                    [_finishedArray addObject:[NSNumber numberWithInteger:index]];
                    break;
                case PM_TASK_STATUS_LEAK:
                    [_leakArray addObject:[NSNumber numberWithInteger:index]];
                    break;
                default:
                    break;
            }
        }
        
        index++;
    }
}

//已完成
- (NSInteger) getFinishedCount {
    NSInteger count = [_finishedArray count];
    
    return count;
}
//漏检
- (NSInteger) getLeakCount {
    NSInteger count = [_leakArray count];
    return count;
}
//未完成
- (NSInteger) getUnFinishedCount {
    NSInteger count = [_unFinishedArray count];
    return count;
}
//处理中
- (NSInteger) getProcessCount {
    NSInteger count = [_processArray count];
    return count;
}

//获取 section 个数
- (NSInteger) getSectionCount {
    NSInteger count = 2;    //日历和概况始终显示
    if([self getFinishedCount] > 0) {
        count++;
    }
    if([self getLeakCount] > 0) {
        count++;
    }
    if([self getUnFinishedCount] > 0) {
        count++;
    }
    if([self getProcessCount] > 0) {
        count++;
    }

    return count;
}

- (PlannedMaintenanceSectionType) getSectionType:(NSInteger) index {
    PlannedMaintenanceSectionType sectionType = PM_SECTION_TYPE_UNKNOW;
    if([self getFinishedCount] == 0 && index >= 2) {
        index++;
    }
    if([self getLeakCount] == 0 && index >= 3) {
        index++;
    }
    if([self getUnFinishedCount] == 0 && index >= 4) {
        index++;
    }
    
    switch (index) {
        case 0:
            sectionType = PM_SECTION_TYPE_CALENDAR;
            break;
        case 1:
            sectionType = PM_SECTION_TYPE_INFO;
            break;
        case 2:
            sectionType = PM_SECTION_TYPE_FINISHED;
            break;
        case 3:
            sectionType = PM_SECTION_TYPE_LEAK;
            break;
        case 4:
            sectionType = PM_SECTION_TYPE_UNFINISHED;
            break;
        case 5:
            sectionType = PM_SECTION_TYPE_PROCESS;
            break;
            
        default:
            sectionType = PM_SECTION_TYPE_UNKNOW;
            break;
    }
    return sectionType;
}

- (MaintenanceEntity *) getDataBySection:(NSInteger) section position:(NSInteger) position {
    MaintenanceEntity * data;
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    NSInteger index = -1;   //此处不能用0
    NSNumber * tmpNumber;
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            break;
        case PM_SECTION_TYPE_INFO:
            break;
        case PM_SECTION_TYPE_FINISHED:
            if(position < [_finishedArray count]) {
                tmpNumber = _finishedArray[position];
                index = tmpNumber.integerValue;
            }
            break;
        case PM_SECTION_TYPE_LEAK:
            if(position < [_leakArray count]) {
                tmpNumber = _leakArray[position];
                index = tmpNumber.integerValue;
            }
            break;
        case PM_SECTION_TYPE_UNFINISHED:
            if(position < [_unFinishedArray count]) {
                tmpNumber = _unFinishedArray[position];
                index = tmpNumber.integerValue;
            }
            break;
        case PM_SECTION_TYPE_PROCESS:
            if(position < [_processArray count]) {
                tmpNumber = _processArray[position];
                index = tmpNumber.integerValue;
            }
            break;
        default:
            break;
            
    }
    if(index >= 0 && index < [_dataArray count]) {
        data = _dataArray[index];
    }
    return data;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [self getSectionCount];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            count = 1;
            break;
        case PM_SECTION_TYPE_INFO:
            count = 1 + 1;
            break;
        case PM_SECTION_TYPE_FINISHED:
            count = [self getFinishedCount] + 1;
            break;
        case PM_SECTION_TYPE_LEAK:
            count = [self getLeakCount] + 1;
            break;
        case PM_SECTION_TYPE_UNFINISHED:
            count = [self getUnFinishedCount] + 1;
            break;
        case PM_SECTION_TYPE_PROCESS:
            count = [self getProcessCount] + 1;
            break;
        default:
            count = 0;
            break;
            
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            if(position == 0) {
                itemHeight = _calendarHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_SECTION_TYPE_INFO:
            if(position == 0) {
                itemHeight = _baseInfoHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_SECTION_TYPE_FINISHED:
            if(position < [self getFinishedCount]) {
                itemHeight = _itemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            
            break;
        case PM_SECTION_TYPE_LEAK:
            if(position < [self getLeakCount]) {
                itemHeight = _itemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_SECTION_TYPE_UNFINISHED:
            if(position < [self getUnFinishedCount]) {
                itemHeight = _itemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        case PM_SECTION_TYPE_PROCESS:
            if(position < [self getProcessCount]) {
                itemHeight = _itemHeight;
            } else {
                itemHeight = _footerHeight;
            }
            break;
        default:
            itemHeight = 0;
            break;
    }
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIdentifier = @"Cell";
    MaintenanceItemView * itemView = nil;
    
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    //    CGFloat paddingLeft = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UITableViewCell * cell;
    BOOL isFooter = NO;
    MaintenanceEntity * obj = [self getDataBySection:section position:position];
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    CGFloat padding = [FMSize getInstance].defaultPadding;
    BOOL hasOrder = NO;
    if(obj && [obj.woIds count] > 0){
        hasOrder = YES;
    }
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            if(position == 0) {
                itemHeight = _calendarHeight;
                cellIdentifier = @"CellCalendar";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if(cell && !_calendarContainerView) {
                    _calendarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
//                    _calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [_calendarContentView setFrame:CGRectMake(0, 0, width, _calendarHeight)];
                    
                    [_calendarContainerView addSubview:_calendarContentView];
                    [self initCalendarBackground];
//                    [_calendarManager setContentView:_calendarContentView];
//                    [_calendarManager setDate:_todayDate];
//                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
//                    [_baseItemView addSubview:seperator];
                    [cell addSubview:_calendarContainerView];
                }
                if(_calendarContentView) {
                    
                }
            } else {
                isFooter = YES;
            }
            break;
        case PM_SECTION_TYPE_INFO:
            if(position == 0) {
                itemHeight = _baseInfoHeight;
                cellIdentifier = @"CellBase";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if(cell && !_baseItemView) {
                    _baseItemView = [[CurrentMonthTaskView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:_baseItemView];
                }
                if(_baseItemView) {
                    [_baseItemView setNumberOfTaskFinished:[self getFinishedCount] missed:[self getLeakCount] undo:[self getUnFinishedCount] processing:[self getProcessCount]];
                }
            } else {
                isFooter = YES;
            }
            break;
        case PM_SECTION_TYPE_FINISHED:
            isFooter = YES;
            if(position < [self getFinishedCount]) {
                isFooter = NO;
                itemHeight = _itemHeight;
                cellIdentifier = @"CellMaintenance";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceItemView class]]) {
                            itemView = (MaintenanceItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !itemView) {
                    itemView = [[MaintenanceItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:itemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [_finishedArray count] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(itemView) {
                    [itemView setInfoWithName:obj.pmName time:[obj getStartDateStr] status:obj.status hasOrder:hasOrder];
                }
            }
            break;
        case PM_SECTION_TYPE_LEAK:
            isFooter = YES;
            if(position < [self getLeakCount]) {
                isFooter = NO;
                itemHeight = _itemHeight;
                cellIdentifier = @"CellMaintenance";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceItemView class]]) {
                            itemView = (MaintenanceItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !itemView) {
                    itemView = [[MaintenanceItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:itemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getLeakCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(itemView) {
                    [itemView setInfoWithName:obj.pmName time:[obj getStartDateStr] status:obj.status hasOrder:hasOrder];
                }
            }
            break;
        case PM_SECTION_TYPE_UNFINISHED:
            isFooter = YES;
            if(position < [self getUnFinishedCount]) {
                isFooter = NO;
                itemHeight = _itemHeight;
                cellIdentifier = @"CellMaintenance";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceItemView class]]) {
                            itemView = (MaintenanceItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !itemView) {
                    itemView = [[MaintenanceItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:itemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getUnFinishedCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(itemView) {
                    [itemView setInfoWithName:obj.pmName time:[obj getStartDateStr] status:obj.status hasOrder:hasOrder];
                }
            }
            break;
        case PM_SECTION_TYPE_PROCESS:
            isFooter = YES;
            if(position < [self getProcessCount]) {
                isFooter = NO;
                itemHeight = _itemHeight;
                
                cellIdentifier = @"CellMaintenance";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if(!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                } else {
                    NSArray * subViews = [cell subviews];
                    for(UIView * view in subViews) {
                        if([view isKindOfClass:[MaintenanceItemView class]]) {
                            itemView = (MaintenanceItemView *)view;
                        } else if([view isKindOfClass:[SeperatorView class]]) {
                            seperator = (SeperatorView *)view;;
                        }
                    }
                }
                if(cell && !itemView) {
                    itemView = [[MaintenanceItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                    [cell addSubview:itemView];
                }
                if(cell && !seperator) {
                    seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                    [seperator setDotted:YES];
                    [cell addSubview:seperator];
                }
                if(seperator) {
                    if(position < [self getProcessCount] - 1) {
                        [seperator setHidden:NO];
                    } else {
                        [seperator setHidden:YES];
                    }
                }
                if(itemView) {
                    [itemView setInfoWithName:obj.pmName time:[obj getStartDateStr] status:obj.status hasOrder:hasOrder];
                }
            }
            
            break;
        default:
            itemHeight = 0;
            break;
    }
    if(isFooter) {
        cellIdentifier = @"CellFooter";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        SeperatorView * footerView;
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            
        } else {
            NSArray * subViews = [cell subviews];
            for(id subView in subViews) {
                if([subView isKindOfClass:[SeperatorView class]]) {
                    footerView = subView;
                }
            }
        }
        if(cell && !footerView) {
            footerView = [[SeperatorView alloc] init];
            [cell addSubview:footerView];
        }
        if(footerView) {
            [footerView setFrame:CGRectMake(0, 0, width, seperatorHeight)];
            [footerView setShowBottomBound:NO];
            [footerView setShowTopBound:YES];
            if(position > 0) {
                [footerView setShowTopBound:YES];
            } else {
                [footerView setShowTopBound:NO];
            }
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    CGFloat width = CGRectGetWidth(tableView.frame);
    UIView * res;
    MarkedListHeaderView * headerView = [[MarkedListHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight)];
    res = headerView;
    NSString* strHeader = nil;
    
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            break;
        case PM_SECTION_TYPE_INFO:
            if(!_dateSelected) {
                strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_current_month" inTable:nil];
            } else {
                strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_current_day" inTable:nil];
            }
            break;
        case PM_SECTION_TYPE_FINISHED:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_finished" inTable:nil];
            break;
        case PM_SECTION_TYPE_LEAK:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_missed" inTable:nil];
            break;
        case PM_SECTION_TYPE_UNFINISHED:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_undo" inTable:nil];
            break;
        case PM_SECTION_TYPE_PROCESS:
            strHeader = [[BaseBundle getInstance] getStringByKey:@"ppm_status_process" inTable:nil];
            break;
        default:
            break;
    }
    [headerView setInfoWithName:strHeader desc:nil andDescStyle:LIST_HEADER_DESC_STYLE_NONE];
    [headerView setShowTopBorder:NO withPaddingLeft:0 paddingRight:0];
    headerView.tag = sectionType;
    return res;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = _headerHeight;
    PlannedMaintenanceSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case PM_SECTION_TYPE_CALENDAR:
            height = 0;
            break;
        default:
            break;
    }
    return height;
}


#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    MaintenanceEntity * entity = [self getDataBySection:section position:position];
    [self notifyShowMaintenanceDetail:entity];
}

- (void) notifyShowMaintenanceDetail:(MaintenanceEntity*) obj {
    if(obj) {
        [self notifyEvent:PM_CALENDAR_EVENT_SHOW_DETAIL data:obj];
    }
}

- (void) notifyEvent:(MaintenanceCalendarEventType) type data:(id) data {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:type] forKeyPath:@"eventType"];
        [result setValue:data forKeyPath:@"eventData"];
        
        [msg setValue:result forKeyPath:@"result"];
        
        [_handler handleMessage:msg];
    }
}
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}
#pragma mark - CalendarManager delegate
// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView {
    // Today
    
    // Other month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_OTHER_MONTH];
        dayView.noteLabel.text = @"";
    } else {
        dayView.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_MONTH];
        dayView.noteLabel.text = [_eventHelper getTaskDescriptionOfDay:dayView.date];
    }
    // Selected date
    if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_SELECT_BG];
    } else {
        dayView.circleView.hidden = YES;
        
        if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
            dayView.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAINTENANCE_CALENDAR_TEXT_TODAY];
        }
    }
    dayView.dotView.hidden = YES;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView {
    _dateSelected = dayView.date;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    [self updateIndexArray];
    [self notifyEvent:PM_CALENDAR_EVENT_SELECT_DATE data:_dateSelected];
}

#pragma mark - CalendarManager delegate - Page mangement
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date {
    return YES;
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar {
    NSDate * date = calendar.date;
    [self clearAll];
    [self notifyEvent:PM_CALENDAR_EVENT_TIME_CHANGE data:date];
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar {
    NSDate * date = calendar.date;
    [self clearAll];
    [self notifyEvent:PM_CALENDAR_EVENT_TIME_CHANGE data:date];
}




@end
