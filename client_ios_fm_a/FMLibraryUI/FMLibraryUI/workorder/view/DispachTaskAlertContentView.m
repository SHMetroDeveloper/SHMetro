//
//  DispachTaskAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/24.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DispachTaskAlertContentView.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "WorkOrderFilterItemTimeView.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMSize.h"
#import "CustomAlertView.h"
#import "RadioItemView.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "BaseListHeaderView.h"

typedef NS_ENUM(NSInteger, DispachTaskOperationSectionType) {
    DISPACH_TASK_SECTION_TYPE_UNKNOW,            //未知
    DISPACH_TASK_SECTION_TYPE_LABORER = 100,           //执行人
    DISPACH_TASK_SECTION_TYPE_LABORERTIME = 200        //预估完成时间
};

@interface DispachTaskAlertContentView ()

@property (readwrite, nonatomic, strong) UITableView * filterList;
@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) WorkOrderFilterItemTimeView * itemView;
@property (readwrite, nonatomic, strong) UIButton * dispachBtn;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * headArray;        //
@property (readwrite, nonatomic, strong) NSMutableArray * laborerArray;      //点位状态名字
@property (readwrite, nonatomic, assign) NSInteger leaderIndex;

@property (readwrite, nonatomic, assign) CGFloat realWidth;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, assign) CGFloat laborerItemHeight;
@property (readwrite, nonatomic, assign) CGFloat timeItemHeight;        //时间过滤区项的高度

@property (readwrite, nonatomic, strong) NSNumber * timeStart;  //开始时间
@property (readwrite, nonatomic, strong) NSNumber * timeEnd;    //结束时间
@property (readwrite, nonatomic, strong) NSNumber * timeUsed;   //耗时

@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation DispachTaskAlertContentView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _controlHeight = [FMSize getInstance].topControlHeight;
        
        _timeItemHeight = 130;
        _headerHeight = 40;
        _laborerItemHeight = 40;
        
        _headArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_laborer_add" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"order_laborer_estimate" inTable:nil], nil];
        
        _laborerArray = [[NSMutableArray alloc] init];
        _leaderIndex = 0;
        
        _filterList = [[UITableView alloc] init];
        
        _filterList.dataSource = self;
        _filterList.delegate = self;
        _filterList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _controlView = [[UIView alloc] init];
        _dispachBtn = [[UIButton alloc] init];
        
        
        [_dispachBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_assign" inTable:nil] forState:UIControlStateNormal];
        [_dispachBtn addTarget:self action:@selector(onDispachButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_controlView addSubview:_dispachBtn];
        
        [self addSubview:_filterList];
        [self addSubview:_controlView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    _realWidth = width;
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    CGFloat paddingRight = paddingLeft;
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    [_dispachBtn setFrame:CGRectMake(paddingLeft, 0, width-paddingLeft-paddingRight, _controlHeight - 10)];
    [_dispachBtn primaryStyle];
    
    [_filterList setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    
}

//- (NSNumber *) getSelectLaborerId {
//    NSNumber * res;
//    return res;
//}
//- (NSNumber *) getStartTime {
//    NSNumber * res;
//    return res;
//}
//- (NSNumber *) getEndTime {
//    NSNumber * res;
//    return res;
//}


- (void) addLaborer:(WorkOrderLaborerDispach *) laborer {
    if(!_laborerArray) {
        _laborerArray = [[NSMutableArray alloc] init];
    }
    [_laborerArray addObject:laborer];
    [self updateFilterList];
}

- (void) setStartTime:(NSNumber *) timeStart {
    _timeStart = [timeStart copy];
    [self updateFilterList];
}
- (void) setEndTime:(NSNumber *) timeEnd {
    _timeEnd = [timeEnd copy];
    [self updateFilterList];
}

- (void) setUsedTime:(NSNumber *) timeUsed {
    _timeUsed = [timeUsed copy];
    [self updateFilterList];
}

- (void) clearInput {
    _timeStart = nil;
    _timeEnd = nil;
    _timeUsed = nil;
    if(!_laborerArray) {
        _laborerArray = [[NSMutableArray alloc] init];
    } else {
        [_laborerArray removeAllObjects];
    }
    [self updateFilterList];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}


- (DispachTaskOperationSectionType) getSectionType:(NSInteger) section {
    DispachTaskOperationSectionType sectionType = DISPACH_TASK_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            sectionType = DISPACH_TASK_SECTION_TYPE_LABORER;
            break;
        case 1:
            sectionType = DISPACH_TASK_SECTION_TYPE_LABORERTIME;
            break;
        default:
            break;
    }
    return sectionType;
}




- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}


- (NSNumber *) getTimeUsed {
    NSNumber * res = [_itemView getTimeUsed];
    return res;
}

- (NSInteger) getLeaderIndex {
    NSInteger index = _leaderIndex;
    return index;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [_headArray count];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORER:
            count = [_laborerArray count];
            break;
        case DISPACH_TASK_SECTION_TYPE_LABORERTIME:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    CGFloat height = 0;
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORER:
            height = _laborerItemHeight;
            break;
        case DISPACH_TASK_SECTION_TYPE_LABORERTIME:
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
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    NSString *cellIdentifier = nil;
    UITableViewCell* cell = nil;
    
    RadioItemView *laborerItemView = nil;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    SeperatorView * seperator;
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORERTIME:
            cellIdentifier = @"CellTime";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if(cell && !_itemView) {
                _itemView = [[WorkOrderFilterItemTimeView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _timeItemHeight)];
                [_itemView setOnClickListener:self];
                [_itemView setPaddingLeft:padding * 4 andPaddingRight:padding];
                [cell addSubview:_itemView];
            }
            if(cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, _timeItemHeight-seperatorHeight, _realWidth-padding * 2, seperatorHeight)];
                [seperator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
                [cell addSubview:seperator];
            }
            if(seperator) {
                [seperator setFrame:CGRectMake(padding, _timeItemHeight-seperatorHeight, _realWidth-padding, seperatorHeight)];
            }
            if(_itemView) {
                NSString * timeStartStr = [FMUtils timeLongToDateString:_timeStart];
                NSString * timeEndStr = [FMUtils timeLongToDateString:_timeEnd];
                NSString * timeUsedStr = @"";
                if(_timeUsed && ![_timeUsed isEqualToNumber:[NSNumber numberWithFloat:0]]) {
                    timeUsedStr = [[NSString alloc] initWithFormat:@"%.1f", _timeUsed.floatValue];
                }
                
                BOOL flag = YES;
                if([FMUtils isStringEmpty:timeStartStr]) {
                    timeStartStr = @"----:--:-- --:--";
                    flag = NO;
                }
                if([FMUtils isStringEmpty:timeEndStr]) {
                    timeEndStr = @"----:--:-- --:--";
                    flag = NO;
                }
//                if(flag) {
//                    timeUsedStr = [[NSString alloc] initWithFormat:@"%lld", (_timeEnd.longLongValue - _timeStart.longLongValue)/(1000*60*60)];
//                }
                [_itemView setInfoWithTimeStart:timeStartStr end:timeEndStr used:timeUsedStr];
            }
            
            break;
        case DISPACH_TASK_SECTION_TYPE_LABORER:
            cellIdentifier = @"CellLaborer";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id sub in subViews) {
                    if([sub isKindOfClass:[RadioItemView class]]) {
                        laborerItemView = sub;
                    } else if([sub isKindOfClass:[SeperatorView class]]) {
                        seperator = sub;
                    }
                }
            }
            if(cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, 0, _realWidth-padding * 2, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if(cell && !laborerItemView) {
                laborerItemView = [[RadioItemView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _laborerItemHeight)];
                [laborerItemView setOnListItemButtonClickListener:self];
                [laborerItemView setPaddingLeft:padding * 4 right:padding];
                [cell addSubview:laborerItemView];
            }
            if(seperator) {
                [seperator setFrame:CGRectMake(padding, 0, _realWidth-padding * 2, seperatorHeight)];
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
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    UIView * headerView = nil;
    NSString * header = _headArray[section];
    BaseListHeaderView * laborerHeader = nil;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UIImage * imageAdd = [[FMTheme getInstance] getImageByName:@"add_gray"];
    UIButton * btn = nil;
    SeperatorView * topIndicator = nil;
    SeperatorView * bottomIndicator = nil;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UIFont * mFont = [FMFont getInstance].listFontHeaderLevel1;
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORER:
            laborerHeader = [[BaseListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
            
            
            topIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, 0, _realWidth-padding, seperatorHeight)];
            [topIndicator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
            [laborerHeader addSubview:topIndicator];
            
            
            [laborerHeader setInfoWithName:header desc:[[BaseBundle getInstance] getStringByKey:@"order_laborer_responsible_desc" inTable:nil] image:imageAdd];
            [laborerHeader setPaddingLeft:padding * 2 right:padding];
            [laborerHeader setFont:mFont];
            [laborerHeader setOnListSectionHeaderClickListener:self];
            headerView = laborerHeader;
            break;
        case DISPACH_TASK_SECTION_TYPE_LABORERTIME:
            btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
            [btn setTitle:header forState:UIControlStateNormal];
            [btn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]  forState:UIControlStateNormal];
            btn.titleLabel.font = mFont;
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,padding * 2, 0, 0);
            //
           
            
            topIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, 0, _realWidth, seperatorHeight)];
            topIndicator.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND];
            bottomIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, (_headerHeight-seperatorHeight), _realWidth-padding*2, seperatorHeight)];
            
            [btn addSubview:topIndicator];
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
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORER:
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
    DispachTaskOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case DISPACH_TASK_SECTION_TYPE_LABORER:
            _leaderIndex = position;
            [self updateFilterList];
            [self notifyLaborerLeaderChange:position];
            break;
        case DISPACH_TASK_SECTION_TYPE_LABORERTIME:
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
    WorkOrderFilterItemViewType type = view.tag;
    switch(type) {
        case ORDER_FILTER_ITEM_VIEW_TAG_START:
            [self notifySelectTimeStart];
            break;
        case ORDER_FILTER_ITEM_VIEW_TAG_END:
            [self notifySelectTimeEnd];
            break;
        case ORDER_FILTER_ITEM_VIEW_TAG_USED:
            _timeUsed = [_itemView getTimeUsed];
            [self notifySetTimeUsed];
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

- (void) notifyMessage:(DispachTaskOperateType) operateType message:(id) msg {
    if(_handler) {
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:@"DispachTaskAlertContentView" forKeyPath:@"msgOrigin"];
        [data setValue:[NSNumber numberWithInteger:operateType] forKeyPath:@"msgType"];
        [data setValue:msg forKeyPath:@"msgData"];
        [_handler handleMessage:data];
    }
}

- (void) notifySelectLaborer {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_SELECT_LABORER;
    [self notifyMessage:operateType message:nil];
}

- (void) notifyLaborerDelete:(NSInteger) position {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_DELETE_LABORER;
    WorkOrderLaborerDispach * laborer = _laborerArray[position];
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:laborer.emId forKeyPath:@"laborerId"];
    [self notifyMessage:operateType message:msg];
}

- (void) notifyLaborerLeaderChange:(NSInteger) position {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_LEADER_CHANGE;
    WorkOrderLaborerDispach * laborer = _laborerArray[position];
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:laborer.emId forKeyPath:@"laborerId"];
    [self notifyMessage:operateType message:msg];
}

- (void) notifySelectTimeStart {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_SET_TIME_START;
    [self notifyMessage:operateType message:nil];
}

- (void) notifySelectTimeEnd {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_SET_TIME_END;
    [self notifyMessage:operateType message:nil];
}

- (void) notifySetTimeUsed {
    DispachTaskOperateType operateType = DISPACH_TASK_ALERT_TYPE_SET_TIME_USED;
    
    [self notifyMessage:operateType message:_timeUsed];
}

- (void) onDispachButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_dispachBtn];
    }
}

@end
