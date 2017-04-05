//
//  PatrolTaskQueryFilterViewController.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolTaskQueryFilterViewController.h"
#import "UIButton+Bootstrap.h"
#import "PatrolHistoryFilterItemTimeView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "CheckableButton.h"
#import "PatrolTaskHistoryEntity.h"
#import "CustomAlertView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseTextField.h"
#import "REFrostedViewController.h"
#import "BaseLabelView.h"
#import "FilterSelectView.h"
#import "TaskAlertView.h"
#import "BaseTimePicker.h"
#import "PatrolTaskHistoryViewController.h"


typedef NS_ENUM(NSInteger, PatrolQueryFilterSectionType) {
    PATROL_QUERY_SECTION_TYPE_UNKNOW,
    PATROL_QUERY_SECTION_TYPE_NAME,
    PATROL_QUERY_SECTION_TYPE_TIME_START,
    PATROL_QUERY_SECTION_TYPE_TIME_END,
    PATROL_QUERY_SECTION_TYPE_STATUS,
};

typedef NS_ENUM(NSInteger, BaseLabelType) {
    BASE_LABEL_TYPE_PATROL_TIME_START,  //设备编码
    BASE_LABEL_TYPE_PATROL_TIME_END,  //基本信息
    
};


@interface PatrolTaskQueryFilterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView * mainContainerView;
@property (nonatomic, strong) UIView * controlView;

@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * doneBtn;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITextField * patrolNameField;
@property (nonatomic, strong) BaseLabelView * patrolTaskStartTimeLbl;
@property (nonatomic, strong) BaseLabelView * patrolTaskEndTimeLbl;


@property (readwrite, nonatomic, strong) NSNumber* timeStart;
@property (readwrite, nonatomic, strong) NSNumber* timeEnd;

@property (nonatomic, strong) NSString * patrolName;
@property (nonatomic, strong) NSMutableArray * patrolStatus;

@property (readwrite, nonatomic, strong) BaseTimePicker * datePicker;
@property (readwrite, nonatomic, strong) TaskAlertView * alertView;
@property (readwrite, nonatomic, assign) PatrolTaskTimePickerType timeType;


@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * selectedArray;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation PatrolTaskQueryFilterViewController

//- (void)initNavigation {
//    [self setTitleWith:@"筛选"];
//    [self setBackAble:YES];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initLayout {
    
    _statusArray = [NSMutableArray new];
    
    [_statusArray addObject:[NSNumber numberWithInteger:PATROL_HISTORY_STATUS_NORMAL]];
    [_statusArray addObject:[NSNumber numberWithInteger:PATROL_HISTORY_STATUS_EXCEPTION]];
    [_statusArray addObject:[NSNumber numberWithInteger:PATROL_HISTORY_STATUS_MISS]];
    [_statusArray addObject:[NSNumber numberWithInteger:PATROL_HISTORY_STATUS_REPAIR]];
    
    _selectedArray = [NSMutableArray new];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    [_selectedArray addObject:[NSNumber numberWithBool:NO]];
    
    _timeType = PATROL_TASK_TIME_PICKER_UNKNOW;
    
    CGFloat controlHeight = [FMSize getInstance].bottomControlHeight;
    controlHeight = 60;
    CGRect frame = [self getContentFrame];
    CGFloat originX = 0;
    CGFloat originY = 0;
    frame.size.width -= 80;
    frame.size.height -= [FMSize getInstance].statusbarHeight + [FMSize getInstance].navigationbarHeight;
    
    _realWidth = frame.size.width;
    
    _headerHeight = [FMSize getInstance].selectHeaderHeight;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    
    
    //tableView的初始化
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-controlHeight) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //按钮控制View
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-controlHeight, frame.size.width, controlHeight)];
    _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    CGFloat btnHeight = [FMSize getInstance].selectListItemHeight;;
    CGFloat sepHeight = (controlHeight - btnHeight)/2;
    CGFloat btnWidth = (_controlView.frame.size.width - sepHeight*3)/2;
    originY = sepHeight;
    originX = sepHeight;
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, btnWidth, btnHeight)];
    [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_reset" inTable:nil] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    _cancelBtn.titleLabel.font = [FMFont getInstance].defaultFontLevel2;
    [_cancelBtn grayStyle];
    _cancelBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.masksToBounds = YES;
    
    [_cancelBtn addTarget:self action:@selector(onResetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX + sepHeight + btnWidth, originY, btnWidth, btnHeight)];
    [_doneBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
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


- (PatrolQueryFilterSectionType) getSectionTypeBy:(NSInteger) section {
    PatrolQueryFilterSectionType type = PATROL_QUERY_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            type = PATROL_QUERY_SECTION_TYPE_NAME;
            break;
        case 1:
            type = PATROL_QUERY_SECTION_TYPE_TIME_START;
            break;
        case 2:
            type = PATROL_QUERY_SECTION_TYPE_TIME_END;
            break;
        case 3:
            type = PATROL_QUERY_SECTION_TYPE_STATUS;
            break;
    }
    return type;
}

#pragma mark - UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    PatrolQueryFilterSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case PATROL_QUERY_SECTION_TYPE_NAME:
            count = 1;
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_START:
            count = 1;
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_END:
            count = 1;
            break;
        case PATROL_QUERY_SECTION_TYPE_STATUS:
            count = [_statusArray count];
            break;
        default:
            break;
    }

    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [FMSize getInstance].selectListItemHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    
    CGFloat width = tableView.frame.size.width;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = 0;
    BOOL isExist = NO;
    
    static NSString * cellIdentifier = @"CellIdentifer";
    UITableViewCell * cell = nil;
    SeperatorView * seperator = nil;
    FilterSelectView * statusSelectItemView = nil;
    NSString * title = nil;
    NSNumber * tmpNumber;
    PatrolQueryFilterSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case PATROL_QUERY_SECTION_TYPE_NAME:
            cellIdentifier = @"patrolCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[UITextField class]]) {
                        _patrolNameField = (UITextField *) view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *)view;
                    }
                }
            }
            if (cell && !_patrolNameField) {
                _patrolNameField = [[UITextField alloc] initWithFrame:CGRectMake(padding, 0, width-padding, itemHeight)];
                _patrolNameField.font = [FMFont getInstance].font38;
                _patrolNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _patrolNameField.placeholder = [[BaseBundle getInstance] getStringByKey:@"patrol_filter_name_placeholder" inTable:nil];
                [cell addSubview:_patrolNameField];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            if (_patrolNameField) {
                
            }
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_START:
            cellIdentifier = @"startTimeCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[BaseLabelView class]]) {
                        BaseLabelView * labelView = (BaseLabelView *) view;
                        if (labelView.tag == BASE_LABEL_TYPE_PATROL_TIME_START) {
                            _patrolTaskStartTimeLbl = labelView;
                        }
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !_patrolTaskStartTimeLbl) {
                _patrolTaskStartTimeLbl = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [_patrolTaskStartTimeLbl setContentFont:[FMFont getInstance].font38];
                [_patrolTaskStartTimeLbl setOnClickListener:self];
                _patrolTaskStartTimeLbl.tag = BASE_LABEL_TYPE_PATROL_TIME_START;
                [cell addSubview:_patrolTaskStartTimeLbl];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            if (_patrolTaskStartTimeLbl) {
                if(_timeStart) {
                    NSDate * date = [FMUtils timeLongToDate:_timeStart];
                    [_patrolTaskStartTimeLbl setContent:[FMUtils getDayStr:date]];
                    [_patrolTaskStartTimeLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
                } else {
                    [_patrolTaskStartTimeLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_filter_time_start" inTable:nil]];
                    [_patrolTaskStartTimeLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER]];
                }
                
            }
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_END:
            cellIdentifier = @"endTimeCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[BaseLabelView class]]) {
                        BaseLabelView * labelView = (BaseLabelView *) view;
                        if (labelView.tag == BASE_LABEL_TYPE_PATROL_TIME_END) {
                            _patrolTaskEndTimeLbl = labelView;
                        }
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !_patrolTaskEndTimeLbl) {
                _patrolTaskEndTimeLbl = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [_patrolTaskEndTimeLbl setContentFont:[FMFont getInstance].font38];
                [_patrolTaskEndTimeLbl setOnClickListener:self];
                _patrolTaskEndTimeLbl.tag = BASE_LABEL_TYPE_PATROL_TIME_END;
                [cell addSubview:_patrolTaskEndTimeLbl];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                [seperator setDotted:NO];
                [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
            }
            if (_patrolTaskEndTimeLbl) {
                if(_timeEnd) {
                    NSDate * date = [FMUtils timeLongToDate:_timeEnd];
                    [_patrolTaskEndTimeLbl setContent:[FMUtils getDayStr:date]];
                    [_patrolTaskEndTimeLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
                } else {
                    [_patrolTaskEndTimeLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_filter_time_end" inTable:nil]];
                    [_patrolTaskEndTimeLbl setContentColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_PLACEHOLDER]];
                }
            }
            break;
        case PATROL_QUERY_SECTION_TYPE_STATUS:
            cellIdentifier = @"statusSelect";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            tmpNumber = _statusArray[position];
            title = [PatrolTaskHistoryItem getStatusStringByStatus:tmpNumber.integerValue];
            itemHeight = [FMSize getInstance].selectListItemHeight;
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                NSArray * subViews = [cell subviews];
                for (id view in subViews) {
                    if ([view isKindOfClass:[FilterSelectView class]]) {
                        statusSelectItemView = (FilterSelectView *)view;
                    } else if ([view isKindOfClass:[SeperatorView class]]) {
                        seperator = (SeperatorView *) view;
                    }
                }
            }
            if (cell && !statusSelectItemView) {
                statusSelectItemView = [[FilterSelectView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
                [cell addSubview:statusSelectItemView];
            }
            if (cell && !seperator) {
                seperator = [[SeperatorView alloc] init];
                [cell addSubview:seperator];
            }
            if (seperator) {
                if (position == _statusArray.count) {
                    [seperator setDotted:NO];
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
                } else {
                    [seperator setDotted:YES];
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
                }
            }
            if (statusSelectItemView) {
                [statusSelectItemView setTitleInfoWith:title];
                NSNumber * selected = _selectedArray[position];
                [statusSelectItemView setChecked:selected.boolValue];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    NSNumber * selected;
    PatrolQueryFilterSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case PATROL_QUERY_SECTION_TYPE_NAME:
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_START:
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_END:
            break;
        case PATROL_QUERY_SECTION_TYPE_STATUS:
            selected = _selectedArray[position];
            selected = [NSNumber numberWithBool:!selected.boolValue];
            _selectedArray[position] = selected;
            
            if (position == 0) {
                if(selected.boolValue) {
                    for(NSInteger index = 1; index<[_selectedArray count];index++) {
                        _selectedArray[index] = [NSNumber numberWithBool:NO];
                    }
                }
            } else {
                if(selected.boolValue) {
                    _selectedArray[0] = [NSNumber numberWithBool:NO];
                }
            }
            
            [_tableView reloadData];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _headerHeight)];
    titleView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    CGFloat padding = [FMSize getInstance].padding50;
    
    UILabel * titleLbl = [[UILabel alloc] init];
    titleLbl.font = [FMFont getInstance].font42;
    titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    [titleLbl setFrame:CGRectMake(padding, [FMSize getInstance].padding70, tableView.frame.size.width, 19)];
    
    PatrolQueryFilterSectionType sectionType = [self getSectionTypeBy:section];
    switch(sectionType) {
        case PATROL_QUERY_SECTION_TYPE_NAME:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_filter_name" inTable:nil];
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_START:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_filter_time_start" inTable:nil];
            break;
        case PATROL_QUERY_SECTION_TYPE_TIME_END:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_filter_time_end" inTable:nil];
            break;
        case PATROL_QUERY_SECTION_TYPE_STATUS:
            titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"patrol_filter_spot_status" inTable:nil];
            break;
        default:
            break;
    }
    
    [titleView addSubview:titleLbl];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0.01f;
    return height;
}

#pragma mark - 去掉HeaderView粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= _headerHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= _headerHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-_headerHeight, 0, 0, 0);
    }
}

- (void) onResetBtnClick {
    for (NSInteger i = 0; i < _selectedArray.count; i ++) {
        [_selectedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    _patrolName = nil;
    _timeStart = nil;
    _timeEnd = nil;
    
    _patrolNameField.text = nil;
    [_patrolTaskStartTimeLbl setContent:nil];
    [_patrolTaskEndTimeLbl setContent:nil];
    [_tableView reloadData];
}

- (void) onOkBtnClick {
    _patrolName = @"";
    if (![FMUtils isStringEmpty:_patrolNameField.text]) {
        _patrolName = _patrolNameField.text;
    }
    if (!_patrolStatus) {
        _patrolStatus = [NSMutableArray new];
    } else {
        [_patrolStatus removeAllObjects];
    }
    for (NSInteger index=0;index<[_selectedArray count];index++) {
        NSNumber * selected = _selectedArray[index];
        if (selected.boolValue) {
            [_patrolStatus addObject:_statusArray[index]];
        }
    }
    
    [self handleResult:PATROL_FILTER_EVENT_TYPE_FILTERDATA];
    
    [self.frostedViewController hideMenuViewController];
}


- (void) handleResult:(PatrolTaskQueryFilterEventType) type {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        switch (type) {
            case PATROL_FILTER_EVENT_TYPE_FILTERDATA:{  //传递筛选信息
                [result setValue:[NSNumber numberWithInteger:PATROL_FILTER_EVENT_TYPE_FILTERDATA] forKeyPath:@"eventType"];
                [result setValue:_patrolName forKeyPath:@"patrolName"];
                [result setValue:_timeStart forKeyPath:@"startTime"];
                [result setValue:_timeEnd forKeyPath:@"endTime"];
                [result setValue:_patrolStatus forKeyPath:@"patrolStatus"];
            }
            break;
        }
        [msg setValue:result forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}


- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        NSNumber * timeNumber;
        if ([strOrigin isEqualToString:NSStringFromClass([PatrolTaskHistoryViewController class])]) {
            NSMutableDictionary * result = [msg valueForKeyPath:@"result"];
            
            timeNumber = [result valueForKeyPath:@"eventData"];
            if(_timeType == PATROL_TASK_TIME_PICKER_END) {
                
                _timeEnd = nil;
                if(![FMUtils isNumberNullOrZero:timeNumber]) {
                    NSDate * date = [FMUtils timeLongToDate:timeNumber];
                    date = [FMUtils getLastSecontOfDay:date];
                    _timeEnd = [FMUtils dateToTimeLong:date];
                }
            } else if(_timeType == PATROL_TASK_TIME_PICKER_START) {
                _timeStart = timeNumber;
            }
        }
        if (_timeStart && _timeEnd && _timeStart.longLongValue > _timeEnd.longLongValue) {
            [self notifyAutoDismissShow];
        } else {
            [_tableView reloadData];
        }
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) hideKeyboard {
    [_patrolNameField resignFirstResponder];
}

//设置开始时间和结束时间
- (void) setTimeStart:(NSNumber *) timeStart timeEnd:(NSNumber *) timeEnd {
    _timeStart = timeStart;
    _timeEnd = timeEnd;
    [_tableView reloadData];
}

- (void)onClick:(UIView *)view {
    [self hideKeyboard];
    if (view == _patrolTaskStartTimeLbl) {
        _timeType = PATROL_TASK_TIME_PICKER_START;
        [self notifyDatePicker];
    } if (view == _patrolTaskEndTimeLbl) {
        _timeType = PATROL_TASK_TIME_PICKER_END;
        [self notifyDatePicker];
    }
}

- (void) notifyDatePicker {
    NSNumber * time;
    if(_timeType == PATROL_TASK_TIME_PICKER_START) {
        time = [_timeStart copy];
    } else if(_timeType == PATROL_TASK_TIME_PICKER_END) {
        time = [_timeEnd copy];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PatrolDatePicker" object:time];
}

- (void) notifyAutoDismissShow {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PatrolAutoDismiss" object:nil];
}



@end

