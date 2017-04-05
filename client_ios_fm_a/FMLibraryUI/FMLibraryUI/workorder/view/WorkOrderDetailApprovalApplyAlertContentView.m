//
//  WorkOrderDetailApprovalApplyAlertContentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/29.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailApprovalApplyAlertContentView.h"
#import "UIButton+Bootstrap.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "CustomAlertView.h"
#import "SeperatorView.h"
#import "BaseListHeaderView.h"
#import "BaseTextView.h"
#import "BaseLabelView.h"

typedef NS_ENUM(NSInteger, ApprovalApplyOperationSectionType) {
    APPROVAL_APPLY_SECTION_TYPE_UNKNOW,            //未知
    APPROVAL_APPLY_SECTION_TYPE_LABORER = 100,     //审批人
    APPROVAL_APPLY_SECTION_TYPE_DESC = 200         //说明
};

@interface WorkOrderDetailApprovalApplyAlertContentView ()

@property (readwrite, nonatomic, strong) UITableView * filterList;
@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) BaseTextView * descView;
@property (readwrite, nonatomic, strong) UIButton * doBtn;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;

@property (readwrite, nonatomic, strong) NSMutableArray * headArray;        //
@property (readwrite, nonatomic, strong) NSMutableArray * laborerArray;      //

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, assign) CGFloat laborerItemHeight;
@property (readwrite, nonatomic, assign) CGFloat defaultDescHeight;


@property (readwrite, nonatomic, assign) BOOL isInited;
@property (readwrite, nonatomic, weak) id<OnItemClickListener> clickListener;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailApprovalApplyAlertContentView

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
        
        _headerHeight = 40;
        _laborerItemHeight = 40;
        _defaultDescHeight = 160;
        
        _headArray = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"order_approver_add" inTable:nil], [[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil], nil];
        
        _laborerArray = [[NSMutableArray alloc] init];
        
        _filterList = [[UITableView alloc] init];
        
        _filterList.dataSource = self;
        _filterList.delegate = self;
        _filterList.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _controlView = [[UIView alloc] init];
        _doBtn = [[UIButton alloc] init];
        
        _doBtn.tag = APPROVAL_APPLY_ALERT_TYPE_DONE;
        
        [_doBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        [_doBtn addTarget:self action:@selector(onDoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _controlView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _filterList.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        [_controlView addSubview:_doBtn];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
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
    CGFloat padding = [FMSize getInstance].defaultPadding;
    [_controlView setFrame:CGRectMake(0, height-_controlHeight, width, _controlHeight)];
    [_doBtn setFrame:CGRectMake(padding, padding/2, width-padding*2, _controlHeight - padding)];
    [_doBtn primaryStyle];
    
    [_filterList setFrame:CGRectMake(0, 0, width, height-_controlHeight)];
    
}

- (void) addApprover:(WorkOrderApprover *) approver {
    if(!_laborerArray) {
        _laborerArray = [[NSMutableArray alloc] init];
    }
    [_laborerArray addObject:approver];
    [self updateFilterList];
}

- (void) clearInput {
    if(!_laborerArray) {
        _laborerArray = [[NSMutableArray alloc] init];
    } else {
        [_laborerArray removeAllObjects];
    }
    [_descView setContentWith:@""];
    [self updateFilterList];
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _clickListener = listener;
}

- (ApprovalApplyOperationSectionType) getSectionType:(NSInteger) section {
    ApprovalApplyOperationSectionType sectionType = APPROVAL_APPLY_SECTION_TYPE_UNKNOW;
    switch(section) {
        case 0:
            sectionType = APPROVAL_APPLY_SECTION_TYPE_LABORER;
            break;
        case 1:
            sectionType = APPROVAL_APPLY_SECTION_TYPE_DESC;
            break;
        default:
            break;
    }
    return sectionType;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (NSString *) getApprovalApplyDesc {
    NSString * res = [_descView getContent];
    return res;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return [_headArray count];
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
            count = [_laborerArray count];
            break;
        case APPROVAL_APPLY_SECTION_TYPE_DESC:
            count = 1;
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    CGFloat height = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
            height = _laborerItemHeight;
            break;
        case APPROVAL_APPLY_SECTION_TYPE_DESC:
            height = _defaultDescHeight + padding * 2;
            break;
        default:
            break;
    }
    return height;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    NSString *cellIdentifier = nil;
    UITableViewCell* cell = nil;
    
    BaseLabelView *laborerItemView = nil;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    SeperatorView * seperator;
    CGFloat itemHeight;
    
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_DESC:
            cellIdentifier = @"CellDesc";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = _defaultDescHeight;
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            if(cell && !_descView) {
                _descView = [[BaseTextView alloc] initWithFrame:CGRectMake(padding, padding, _realWidth-padding * 2, itemHeight)];
                [_descView setShowBounds:YES];
                [_descView setTopDesc:[[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil]];
                [_descView setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
                [cell addSubview:_descView];
            }
            
            cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
            cellIdentifier = @"CellLaborer";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            itemHeight = _laborerItemHeight;
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            } else {
                NSArray * subViews = [cell subviews];
                for(id sub in subViews) {
                    if([sub isKindOfClass:[BaseLabelView class]]) {
                        laborerItemView = sub;
                    } else if([sub isKindOfClass:[SeperatorView class]]) {
                        seperator = sub;
                    }
                }
            }
            if(cell && !seperator) {
                seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding * 2, seperatorHeight)];
                [cell addSubview:seperator];
            }
            if(cell && !laborerItemView) {
                laborerItemView = [[BaseLabelView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
                [cell addSubview:laborerItemView];
            }
            
            if(seperator) {
                if(position == [_laborerArray count] -1) {
                    [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
                } else {
                    [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding * 2, seperatorHeight)];
                }
                
            }
            if(laborerItemView) {
                WorkOrderApprover * approver = _laborerArray[position];
                NSString * laborerName = approver.name;
                laborerItemView.tag = position;
                [laborerItemView setContent:laborerName];
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
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    CGFloat height = 0;
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
            height = _headerHeight;
            break;
        case APPROVAL_APPLY_SECTION_TYPE_DESC:
            height = 0;
            break;
        default:
            break;
    }
    return height;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    UIView * headerView = nil;
    NSString * header = _headArray[section];
    BaseListHeaderView * laborerHeader = nil;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    UIImage * imageAdd = [[FMTheme getInstance] getImageByName:@"add_gray"];
    SeperatorView * topIndicator = nil;
    SeperatorView * bottomIndicator = nil;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UIFont * mFont = [FMFont getInstance].listFontHeaderLevel1; 
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
            laborerHeader = [[BaseListHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, _headerHeight)];
            
            topIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, 0, _realWidth-padding, seperatorHeight)];
            [topIndicator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
            if([_laborerArray count] > 0) {
                bottomIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, _headerHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
            } else {
                bottomIndicator = [[SeperatorView alloc] initWithFrame:CGRectMake(0, _headerHeight-seperatorHeight, _realWidth, seperatorHeight)];
            }
            
            [bottomIndicator setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND]];
            [laborerHeader addSubview:topIndicator];
            [laborerHeader addSubview:bottomIndicator];
            
            [laborerHeader setInfoWithName:header desc:nil image:imageAdd];
            [laborerHeader setPaddingLeft:padding * 2 right:padding];
            [laborerHeader setFont:mFont];
            [laborerHeader setOnListSectionHeaderClickListener:self];
            headerView = laborerHeader;
            break;
        case APPROVAL_APPLY_SECTION_TYPE_DESC:
            headerView = nil;
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
    ApprovalApplyOperationSectionType sectionType = [self getSectionType:section];
    switch(sectionType) {
        case APPROVAL_APPLY_SECTION_TYPE_LABORER:
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
}

- (void) onListSectionHeaderClick:(UIView *)view {
    if([view isKindOfClass:[BaseListHeaderView class]]) {
        [self notifySelectLaborer];
    }
}


- (void) updateFilterList {
    [_filterList reloadData];
}

- (void) notifyMessage:(ApprovalApplyOperateType) operateType message:(id) msg {
    if(_handler) {
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [data setValue:[NSNumber numberWithInteger:operateType] forKeyPath:@"msgType"];
        [data setValue:msg forKeyPath:@"msgData"];
        [_handler handleMessage:data];
    }
}

- (void) notifySelectLaborer {
    ApprovalApplyOperateType operateType = APPROVAL_APPLY_ALERT_TYPE_SELECT_LABORER;
    [self notifyMessage:operateType message:nil];
}

- (void) notifyLaborerDelete:(NSInteger) position {
    ApprovalApplyOperateType operateType = APPROVAL_APPLY_ALERT_TYPE_DELETE_LABORER;
    WorkOrderApprover * approver = _laborerArray[position];
    NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
    [msg setValue:approver.approverId forKeyPath:@"approverId"];
    [self notifyMessage:operateType message:msg];
}



- (void) onDoButtonClicked {
    if(_clickListener) {
        [_clickListener onItemClick:self subView:_doBtn];
    }
}

@end
