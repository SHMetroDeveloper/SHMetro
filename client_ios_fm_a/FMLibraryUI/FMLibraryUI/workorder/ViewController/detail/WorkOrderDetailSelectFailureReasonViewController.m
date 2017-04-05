//
//  WorkOrderDetailSelectFailureReasonViewController.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/16.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "WorkOrderDetailSelectFailureReasonViewController.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "BaseTextField.h"
#import "NodeItemView.h"
#import "SystemConfig.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SeperatorView.h"
#import "BaseDataDbHelper.h"
#import "FMSize.h"
#import "FMFont.h"
#import "WorkOrderBusiness.h"


@interface WorkOrderDetailSelectFailureReasonViewController ()
@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * pullTableView;
@property (readwrite, nonatomic, strong) BaseTextField * searchTf;

@property (readwrite, nonatomic, strong) UILabel * noticeLbl;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat searchHeight;

@property (readwrite, nonatomic, strong) NSMutableArray* nodesArray;

@property (readwrite, nonatomic, strong) NodeList * nodes;
@property (readwrite, nonatomic, assign) BOOL hintVisiable;
@property (readwrite, nonatomic, strong) NSString * defaultHintText;

@property (readwrite, nonatomic, assign) NSInteger curNodeParentId;
@property (readwrite, nonatomic, assign) NSInteger curNodeLevel;

@property (readwrite, nonatomic, strong) NSString* strTitle;

@property (readwrite, nonatomic, strong) NSMutableArray* reasonList;       //

@property (readwrite, nonatomic, strong) NSMutableArray *selectDataArray;  //已选数据

@property (readwrite, nonatomic, strong) NetPage * mPage;

@property (nonatomic, strong) NSNumber *woId;//工单ID
@property (nonatomic, strong) FailureReason *reason;//所选的故障原因

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation WorkOrderDetailSelectFailureReasonViewController

- (instancetype) init {
    self = [super init];
    if(self) {
    }
    return self;
}


- (void) initNavigation {
    if(!_strTitle) {
        _strTitle = [[BaseBundle getInstance] getStringByKey:@"function_info_select" inTable:nil];
    }
    [self setTitleWith:[[NSString alloc] initWithFormat:@"%@", _strTitle]];
    NSMutableArray * menus = [[NSMutableArray alloc] initWithObjects:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil], nil];
    [self setMenuWithArray:menus];
    [self setBackAble:YES];
}

- (void) onMenuItemClicked:(NSInteger)position {
//    [self selectCurrentNode];
//    [self finish];
}

- (void) initData {
    _searchHeight = 40;
    _itemHeight = 50;
    _curNodeParentId = [NodeItem getParentIdOfRoot];
    _curNodeLevel = [NodeItem getParentLevelOfRoot];
    
    _nodesArray = [[NSMutableArray alloc] init];
    
    if (!_selectDataArray) {
        _selectDataArray = [NSMutableArray new];
    }
    
    _nodes = [[NodeList alloc] init];
    _mPage = [[NetPage alloc] init];
}

- (void) initViews {
    CGFloat originX = 10;
    CGFloat searchPaddingTop = 6;
    CGFloat originY = searchPaddingTop;
    
    CGRect frame = [self getContentFrame];
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    CGFloat noticeHeight = [FMSize getInstance].defaultNoticeHeight;
    
    _mainContainerView = [[UIView alloc] initWithFrame:frame];
    _mainContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    _searchTf = [[BaseTextField alloc] initWithFrame:CGRectMake(originX, searchPaddingTop, width-originX*2, _searchHeight)];
    _searchTf.font = [FMFont getInstance].defaultFontLevel2;
    [_searchTf setLabelWithImage:[[FMTheme getInstance] getImageByName:@"search_gray"]];
    _searchTf.borderStyle = UITextBorderStyleNone;
    _searchTf.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
    _searchTf.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
    _searchTf.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
    _searchTf.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
    
    [_searchTf setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"filter_placeholder_common" inTable:nil]];
    
    _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, (height - noticeHeight)/2, (width-originX*2), noticeHeight)];
    _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
    _noticeLbl.textAlignment = NSTextAlignmentCenter;
    _noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"select_no_data" inTable:nil];
    [_noticeLbl setFont:[FMFont fontWithSize:14]];
    
    CGRect listFrame = CGRectMake(0, originY * 2  + _searchHeight, width, height - originY*2-_searchHeight);
    
    _pullTableView = [[UITableView alloc] initWithFrame:listFrame];
    
    _pullTableView.dataSource = self;
    _pullTableView.delegate = self;
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pullTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    
    
    [_mainContainerView addSubview:_searchTf];
    [_mainContainerView addSubview:_pullTableView];
    [_mainContainerView addSubview:_noticeLbl];
    
    [self.view addSubview:_mainContainerView];
}

- (void) updateNotice {
    NSInteger count = [_nodes getCount];
    if(count > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

- (void) updateList {
    if([self isSearchAble]) {
        NSString * strFilter = _searchTf.text;
        if([FMUtils isStringEmpty:strFilter]) {
            _nodesArray = [_nodes getChildren:_curNodeParentId level:_curNodeLevel];
            [_pullTableView reloadData];
        } else {
            _nodesArray = [_nodes getChildrenByFilter:_curNodeParentId filterType:FILTER_TYPE_NAME_OR_DESC_FIRST_LETTER filter:strFilter level:_curNodeLevel];
            [_pullTableView reloadData];
        }
        
    } else {
        _nodesArray = [_nodes getChildren:_curNodeParentId level:_curNodeLevel];
        [_pullTableView reloadData];
    }
    
    //title
    NSString * strTitle = nil;
    if(_curNodeParentId == [NodeItem getParentIdOfRoot]) {
        if(![FMUtils isStringEmpty:_nodes.desc]) {
            strTitle = _nodes.desc;
        } else {
            strTitle = _strTitle;
        }
        
    } else {
        NSInteger parentLevel = [_nodes getParentLevel:_curNodeLevel];
        strTitle = [[_nodes getNodeByKey:_curNodeParentId andLevel:parentLevel] getVal];
    }
    [self updateTitle:strTitle];
    [self updateNotice];
}

- (void) updateTitle:(NSString *) title {
    [self setTitleWith:title];
    [self updateNavigationBar];
}

- (void) showRoot {
    _curNodeParentId = [NodeItem getParentIdOfRoot];
    _curNodeLevel = [_nodes getRootLevel];
    [self updateList];
}

- (void) showParent {
    if(_curNodeParentId != [NodeItem getParentIdOfRoot]) {
        _curNodeLevel = [_nodes getParentLevel:_curNodeLevel];
        NodeItem * node = [_nodes getNodeByKey:_curNodeParentId andLevel:_curNodeLevel];
        if(node) {
            _curNodeParentId = [node getParentKey];
            [self updateList];
        }
    }
}

- (void) showChildren:(NSInteger) key {
    NSInteger childrenLevel = [_nodes getChildrenLevel:_curNodeLevel];
    if((childrenLevel == LEVEL_LEAF || [[_nodes getChildren:key level:childrenLevel] count] == 0)) {
        if([_nodes getRootLevel] != _curNodeLevel) {
            _curNodeParentId = key;
            _curNodeLevel = childrenLevel;
            [self selectCurrentNode];
            [self requestSaveFailureReason];//往服务器发送信息保存请求
            //        [self finish];
        }
    } else {
        _curNodeParentId = key;
        _curNodeLevel = childrenLevel;
        [self updateList];
    }
}

- (void) selectCurrentNode {
    NSInteger parentLevel = [_nodes getParentLevel:_curNodeLevel];
    NodeItem * node = [_nodes getNodeByKey:_curNodeParentId andLevel:parentLevel];
    _reason = [self getFailureReasonOfNode:node];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
    [self work];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) onBackButtonPressed {
    if(_curNodeParentId == [NodeItem getParentIdOfRoot]) {
        [self finish];
    } else {
        _searchTf.text = @"";
        [self showParent];
    }
}

//是否支持快速搜索
- (BOOL) isSearchAble {
    return YES;
}


- (void) work {
    [self showLoadingDialog];
    [self requestCommonInfo];
    [self hideLoadingDialog];
}
//
//- (void) setSelectDataByArray:(nullable NSMutableArray *) dataArray {
//    if (!_selectDataArray) {
//        _selectDataArray = [NSMutableArray new];
//    }
//    _selectDataArray = [NSMutableArray arrayWithArray:dataArray];
//}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) setInfoWithWorkOrderId:(NSNumber *) woId {
    _woId = woId;
}

- (void) handleResult {
    if(_handler && _reason) {
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [result setValue:_reason forKeyPath:@"result"];
        [_handler handleMessage:result];
    }
}

- (void) requestCommonInfo {
    _reasonList = [[BaseDataDbHelper getInstance] queryAllFailureReason];
    NodeList * nodes = [[NodeList alloc] init];
    NSString * strTitle = [[BaseBundle getInstance] getStringByKey:@"info_select_failurereason" inTable:nil];
    nodes.desc = [strTitle copy];
    NSInteger maxLevel = 1;
    for(FailureReason *reason in _reasonList) {
        NSInteger level = 1;
        NodeItem * item;
        if(reason.parentId) {
            level = 2;
            item = [[NodeItem alloc] initWith:reason.parentId.integerValue key:reason.reasonId.integerValue value:reason.name level:level];
            [nodes addNode:item];
        } else {
            item = [[NodeItem alloc] initWith:PARENT_ID_ROOT key:reason.reasonId.integerValue value:reason.name level:level];
            [nodes addNode:item];
        }
        if(maxLevel < level) {
            maxLevel = level;
        }
        if(item) {
            [nodes addNode:item];
        }
    }
    for(NSInteger level = 1;level<=maxLevel;level++) {
        if(level == 1) {
            [nodes addNodeLevel:level];
        } else {
            [nodes addNodeLevel:level parent:level-1];
        }
    }
    _nodes = nodes;
    [self showRoot];
    [self hideLoadingDialog];
}

- (FailureReason *) getFailureReasonOfNode:(NodeItem *) item {
    FailureReason * res;
    if(item) {
        NSInteger key = [item getKey];
        for(FailureReason *reason in _reasonList) {
            if(reason.reasonId.integerValue == key) {
                res = reason;
                break;
            }
        }
    }
    return res;
}

- (void) requestSaveFailureReason {
    [self showLoadingDialog];
    WorkOrderSaveFailureReasonParam *param = [[WorkOrderSaveFailureReasonParam alloc] init];
    param.woId = _woId;
    param.reasonId = _reason.reasonId;
    [[WorkOrderBusiness getInstance] saveFailureReason:param success:^(NSInteger key, id object) {
        [self hideLoadingDialog];
        [self handleResult];
        [self finish];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_nodesArray count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    ////    //解决cell重用带来的问题
    static NSString *cellIdentifier = @"Cell";
    NodeItemView * itemView = nil;
    SeperatorView * seperator;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = _itemHeight;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat padding = [FMSize getInstance].defaultPadding;
    NSInteger count = [_nodesArray count];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subviews = [cell subviews];
        for(id view in subviews) {
            if([view isKindOfClass:[NodeItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = view;
            }
        }
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(seperator) {
        if(position == count - 1) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }else {
            [seperator setDotted:YES];
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width - padding * 2, seperatorHeight)];
        }
        
    }
    if(cell && !itemView) {
        itemView = [[NodeItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        
        [cell addSubview:itemView];
    }
    if(itemView) {
        NodeItem * node = _nodesArray[position];
        NSInteger key = [node getKey];
        NSInteger level = [node getLevel];
        NSInteger childrenLevel = [_nodes getChildrenLevel:level];
        
        if(level == LEVEL_LEAF || [[_nodes getChildren:key level:childrenLevel] count] == 0) {
            [itemView setShowMore:NO];
        } else {
            [itemView setShowMore:YES];
        }
        [itemView setInfoWith:node];
        itemView.tag = position;
        
    }
    return cell;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - 点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    NodeItem * node = _nodesArray[position];
    if(node) {
        NSInteger key = [node getKey];
        _searchTf.text = @"";
        
        [self showChildren:key];
    }
}

#pragma - 文本框搜索过滤
- (void) onSearchFilterChanged {
    UITextRange * selectedRange = [_searchTf markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        [self updateList];
    }
}
@end
