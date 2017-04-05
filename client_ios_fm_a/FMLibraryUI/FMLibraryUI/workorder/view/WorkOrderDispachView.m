//
//  WorkOrderDispachView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDispachView.h"
#import "DispachWorkOrderEntity.h"
#import "PatrolHistoryFilterItemTimeView.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "CustomAlertView.h"
#import "RadioItemView.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "BaseListHeaderView.h"
#import "InfoSelectViewController.h"



@interface WorkOrderDispachView ()

@property (readwrite, nonatomic, strong) UITableView * filterList;

@property (readwrite, nonatomic, strong) NSMutableArray * headArray;        //
@property (readwrite, nonatomic, strong) NSMutableArray * laborerArray;      //点位状态名字
@property (readwrite, nonatomic, assign) NSInteger leaderIndex;

@property (readwrite, nonatomic, assign) CGFloat realWidth;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, assign) CGFloat laborerItemHeight;
@property (readwrite, nonatomic, assign) CGFloat timeItemHeight;        //时间过滤区项的高度

@property (readwrite, nonatomic, strong) NSNumber * timeStart;  //开始时间
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;    //结束时间

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation WorkOrderDispachView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void )setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _timeItemHeight = 100;
        _headerHeight = 40;
        _laborerItemHeight = 40;
        
        _headArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_laborer_add" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_laborer_estimate" inTable:nil], nil];
        
        _laborerArray = [[NSMutableArray alloc] init];
        _leaderIndex = 0;
        
        _filterList = [[UITableView alloc] init];
        _filterList.dataSource = self;
        _filterList.delegate = self;
        _filterList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_filterList];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGRect tableFrame = CGRectMake(0, 0, width, height);
    [_filterList setFrame:tableFrame];
    
}

- (void) addLaborer:(WorkOrderLaborerDispach *) laborer {
    [_laborerArray addObject:laborer];
    [self updateFilterList];
}




- (DispachOrderOperationSectionType) getSectionType:(NSInteger) section {
    DispachOrderOperationSectionType sectionType = DISPACH_ORDER_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            sectionType = DISPACH_ORDER_SECTION_TYPE_LABORER;
            break;
        case 1:
            sectionType = DISPACH_ORDER_SECTION_TYPE_LABORERTIME;
            break;
        default:
            break;
    }
    return sectionType;
}




- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}


- (NSString *) getTimeUsedString {
    NSString * res = @"";
    if(![FMUtils isObjectNull:_timeStart] && ![FMUtils isObjectNull:_timeEnd]) {
        CGFloat timeCount = (_timeEnd.longLongValue - _timeStart.longLongValue)*1.0f/(1000 * 60 * 60);
        res = [[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"order_time_used" inTable:nil], timeCount];
    }
    return res;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [_headArray count];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            count = [_laborerArray count];
            break;
        case DISPACH_ORDER_SECTION_TYPE_LABORERTIME:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    CGFloat height = 0;
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            height = _laborerItemHeight;
            break;
        case DISPACH_ORDER_SECTION_TYPE_LABORERTIME:
            height = _timeItemHeight;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    NSString *cellIdentifier = nil;
    UITableViewCell* cell = nil;
    PatrolHistoryFilterItemTimeView * itemView = nil;
    RadioItemView *laborerItemView = nil;
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORERTIME:
            cellIdentifier = @"CellTime";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id sub in subViews) {
                    if([sub isKindOfClass:[PatrolHistoryFilterItemTimeView class]]) {
                        itemView = sub;
                        break;
                    }
                }
            }
            if(cell && !itemView) {
                itemView = [[PatrolHistoryFilterItemTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeItemHeight)];
                [itemView setOnClickListener:self];
                [itemView setPaddingLeft:30 andPaddingRight:10];
                SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(10, _timeItemHeight-1, _realWidth-20, 1)];
                [cell addSubview:seperator];
                [cell addSubview:itemView];
            }
            if(itemView) {
                NSString * timeStartStr = [FMUtils timeLongToDateString:_timeStart];
                NSString * timeEndStr = [FMUtils timeLongToDateString:_timeEnd];
                if([FMUtils isStringEmpty:timeStartStr]) {
                    timeStartStr = @"----:--:-- --:--";
                }
                if([FMUtils isStringEmpty:timeEndStr]) {
                    timeEndStr = @"----:--:-- --:--";
                }
                [itemView setInfoWithTimeStart:timeStartStr end:timeEndStr];
            }
            
            break;
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            cellIdentifier = @"CellLaborer";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id sub in subViews) {
                    if([sub isKindOfClass:[RadioItemView class]]) {
                        laborerItemView = sub;
                        break;
                    }
                }
            }
            if(cell && !laborerItemView) {
                laborerItemView = [[RadioItemView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _laborerItemHeight)];
                [laborerItemView setOnListItemButtonClickListener:self];
                [laborerItemView setPaddingLeft:40 right:10];
                if(position > 0) {
                    SeperatorView * seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(10, 0, _realWidth-20, 1)];
                    [cell addSubview:seperator];
                }
                [cell addSubview:laborerItemView];
            }
            if(laborerItemView) {
                WorkOrderLaborerDispach * laborer = _laborerArray[position];
                NSString * laborerName = laborer.name;
                BOOL isChecked = _leaderIndex == position;
                laborerItemView.tag = position;
                [laborerItemView setInfoWithName:laborerName isChecked:isChecked];
            }
            cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    UIView * headerView = nil;
    NSString * header = _headArray[section];
    BaseListHeaderView * laborerHeader = nil;
    UIImage * imageAdd = [[FMTheme getInstance] getImageByName:@"add_gray"];
    UIButton * btn = nil;
    UILabel * topIndicator = nil;
    UILabel * bottomIndicator = nil;
    UILabel * timeLbl;
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            laborerHeader = [[BaseListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
            
            [laborerHeader setInfoWithName:header desc:[[BaseBundle getInstance] getStringByKey:@"order_laborer_responsible_desc" inTable:nil] image:imageAdd];
            [laborerHeader setPaddingLeft:20 right:10];
            [laborerHeader setFont:[UIFont fontWithName:@"Helvetica" size:16]];
            [laborerHeader setOnListSectionHeaderClickListener:self];
            headerView = laborerHeader;
            break;
        case DISPACH_ORDER_SECTION_TYPE_LABORERTIME:
            btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
            [btn setTitle:header forState:UIControlStateNormal];
            [btn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]  forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
            //
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(_realWidth/2, 0, _realWidth/2, _headerHeight)];
            timeLbl.text = [self getTimeUsedString];
            timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            [btn addSubview:timeLbl];
            
            topIndicator = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _realWidth, 1)];
            topIndicator.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            bottomIndicator = [[UILabel alloc] initWithFrame:CGRectMake(10, _headerHeight-1, _realWidth, 1)];
            bottomIndicator.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            
            if([_laborerArray count] > 0) {
                [btn addSubview:topIndicator];
            }
            [btn addSubview:bottomIndicator];
            btn.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
            headerView = btn;
            break;
        default:
            break;
    }
    
    return headerView;
}



- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 滑动删除
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger position = indexPath.row;
        if(_leaderIndex == position) {
            _leaderIndex = -1;
        }
        [self notifyLaborerDelete:position];
        [_laborerArray removeObjectAtIndex:position];
        // Delete the row from the data source.
        [_filterList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateFilterList];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil];
}



#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    DispachOrderOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_ORDER_SECTION_TYPE_LABORER:
            _leaderIndex = position;
            [self updateFilterList];
            [self notifyLaborerLeaderChange:position];
            break;
        case DISPACH_ORDER_SECTION_TYPE_LABORERTIME:
            break;
        default:
            break;
    }
}

- (void) onListSectionHeaderClick:(UIView *)view {
    if([view isKindOfClass:[BaseListHeaderView class]]) {
        [self notifySelectLaborer];
    }
}

#pragma -- 时间选择
- (void) onClick:(UIView *)view {
    FilterItemViewType type = view.tag;
    switch(type) {
        case FILTER_ITEM_VIEW_TAG_START:
            [self notifySelectTimeStart];
            break;
        case FILTER_ITEM_VIEW_TAG_END:
            [self notifySelectTimeEnd];
            break;
        default:
            break;
    }
}

#pragma - 选中
- (void) onButtonClick:(UIView *)parent view:(UIView *)view {
    if([parent isKindOfClass:[RadioItemView class]]) {
        NSInteger tag = parent.tag;
        NSInteger position = tag;
        _leaderIndex = position;
        [self updateFilterList];
    }
}


- (void) updateFilterList {
    [_filterList reloadData];
}

- (void) notifyMessage:(DispachOrderOperationType) operateType message:(id) msg {
    if(_handler) {
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:@"WorkOrderDispachView" forKeyPath:@"resultType"];
        [data setValue:[NSNumber numberWithInteger:operateType] forKeyPath:@"msgType"];
        [data setValue:msg forKeyPath:@"msgData"];
        [_handler handleMessage:data];
    }
}

- (void) notifySelectLaborer {
    DispachOrderOperationType operateType = DISPACH_ORDER_OPERATION_TYPE_LABORER_SELECT;
    [self notifyMessage:operateType message:nil];
}

- (void) notifyLaborerDelete:(NSInteger) position {
    DispachOrderOperationType operateType = DISPACH_ORDER_OPERATION_TYPE_LABORER_DELETE;
    WorkOrderLaborerDispach * laborer = _laborerArray[position];
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:laborer.emId forKeyPath:@"laborerId"];
    [self notifyMessage:operateType message:msg];
}

- (void) notifyLaborerLeaderChange:(NSInteger) position {
    DispachOrderOperationType operateType = DISPACH_ORDER_OPERATION_TYPE_LABORER_LEADER_CHANGE;
    WorkOrderLaborerDispach * laborer = _laborerArray[position];
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:laborer.emId forKeyPath:@"laborerId"];
    [self notifyMessage:operateType message:msg];
}

- (void) notifySelectTimeStart {
    DispachOrderOperationType operateType = DISPACH_ORDER_OPERATION_TYPE_LABORERTIME_START_SELECT;
    [self notifyMessage:operateType message:nil];
}

- (void) notifySelectTimeEnd {
    DispachOrderOperationType operateType = DISPACH_ORDER_OPERATION_TYPE_LABORERTIME_END_SELECT;
    [self notifyMessage:operateType message:nil];
}

@end
