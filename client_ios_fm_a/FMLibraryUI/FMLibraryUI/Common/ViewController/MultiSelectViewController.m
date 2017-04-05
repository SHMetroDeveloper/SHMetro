//
//  MultiSelectViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/5/20.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "MultiSelectViewController.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseTextField.h"
#import "NodeItemView.h"
#import "WorkOrderNetRequest.h"
#import "WorkOrderLaborerDispachEntity.h"
#import "SystemConfig.h"
#import "BaseDataEntity.h"
#import "BaseDataNetRequest.h"
#import "SeperatorView.h"
#import "BaseDataDbHelper.h"
#import "FMSize.h"
#import "FMFont.h"
#import "ReportServerConfig.h"
#import "WorkOrderApproverEntity.h"

#import "BaseBundle.h"


@interface MultiSelectViewController ()
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, strong) UITableView * pullTableView;
@property (readwrite, nonatomic, strong) BaseTextField * searchTf;


@property (readwrite, nonatomic, strong) UILabel * noticeLbl;

@property (readwrite, nonatomic, strong) NSMutableArray* nodesArray;


@property (readwrite, nonatomic, assign) CGFloat searchHeight;
@property (readwrite, nonatomic, strong) UIView * mainContainerView;

@property (readwrite, nonatomic, strong) NodeList * nodes;
@property (readwrite, nonatomic, assign) BOOL hintVisiable;
@property (readwrite, nonatomic, strong) NSString * defaultHintText;

@property (readwrite, nonatomic, assign) NSInteger curNodeParentId;
@property (readwrite, nonatomic, assign) NSInteger curNodeLevel;

@property (readwrite, nonatomic, strong) NSString* strTitle;
@property (readwrite, nonatomic, assign) MultiInfoSelectResultType resultType;   //结果类型

@property (readwrite, nonatomic, strong) NSMutableArray * selectDataArray;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation MultiSelectViewController

- (instancetype) init {
    self = [super init];
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
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
    [self selectCurrentNode];
    [self finish];
}

- (void) initData {
    _resultType = RESULT_TYPE_CANCEL_MULTI_INFO_SELECT;
    _searchHeight = 40;
    _itemHeight = 50;
    _curNodeParentId = [NodeItem getParentIdOfRoot];
    _curNodeLevel = [NodeItem getParentLevelOfRoot];
    
    _nodesArray = [[NSMutableArray alloc] init];
    _selectDataArray = [[NSMutableArray alloc] init];
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
    
    //    _searchTf = [[BaseTextField alloc] initWithFrame:CGRectMake(originX, originY, width - originX*2, _searchHeight)];
    //
    //
    //    [_searchTf setLabelWithImage:[[FMTheme getInstance] getImageByName:@"search_gray"]];
    //    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
    //    _searchTf.delegate = self;
    
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
    
    //    [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
    
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
    _curNodeParentId = key;
    _curNodeLevel = [_nodes getChildrenLevel:_curNodeLevel];
    if(_curNodeLevel == LEVEL_LEAF || [[_nodes getChildren:_curNodeParentId level:_curNodeLevel] count] == 0) {
        _resultType = RESULT_TYPE_OK_MULTI_INFO_SELECT;
        [self selectCurrentNode];
        [self finish];
    } else {
        [self updateList];
    }
    
}

- (void) selectCurrentNode {
    NSInteger parentLevel = [_nodes getParentLevel:_curNodeLevel];
    NodeItem * node = [_nodes getNodeByKey:_curNodeParentId andLevel:parentLevel];
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [result setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
    [result setValue:[NSNumber numberWithInteger:_resultType] forKeyPath:@"resultType"];
    [result setValue:node forKeyPath:@"result"];
    //    [self setResult:result];
    
    
    [result setValue:_selectDataArray forKeyPath:@"result"];
    [self handleResult:result];
}




- (void) viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initViews];
    [self showRoot];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (void) onBackButtonPressed {
    if(_curNodeParentId == [NodeItem getParentIdOfRoot]) {
        NodeItem * node = nil;
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:[NSNumber numberWithInteger:RESULT_TYPE_CANCEL_MULTI_INFO_SELECT] forKeyPath:@"resultType"];
        
        [result setValue:node forKeyPath:@"result"];
        //        [self setResult:result];
        
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

- (void) setInfoWith:(NodeList *) nodes {
    _nodes = nodes;
    [self showRoot];
}

- (void) setSelectDataByArray:(nullable NSMutableArray *) dataArray {
    if (!_selectDataArray) {
        _selectDataArray = [NSMutableArray new];
    }
    _selectDataArray = [NSMutableArray arrayWithArray:dataArray];
}


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (void) handleResult:(id) result {
    if(_handler) {
        [_handler handleMessage:result];
    }
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
        

        
        BOOL isChecked = NO;
        for (NodeItem * tmpNode in _selectDataArray) {
            if ([node getKey] == [tmpNode getKey]) {
                isChecked = YES;
                break;
            }
        }
        [itemView setChecked:[NSNumber numberWithBool:isChecked]];
        
        
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
    
    BOOL needAdded = YES;
    NSInteger index = 0;
    for (NodeItem *tmpNode in _selectDataArray) {
        if ([tmpNode getKey] == [node getKey]) {
            needAdded = NO;
            index = [_selectDataArray indexOfObject:tmpNode];
        }
    }
    if (needAdded) {
        [_selectDataArray addObject:node];
    } else {
        [_selectDataArray removeObjectAtIndex:index];
    }
    [_pullTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma - 文本框搜索过滤
- (void) onSearchFilterChanged {
    UITextRange * selectedRange = [_searchTf markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        [self updateList];
    }
}
@end
