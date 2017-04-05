//
//  ChartsViewController.m
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "ProjectsViewController.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "ProjectEntity.h"
#import "BaseDataNetRequest.h"
#import "BaseItemView.h"
#import "SeperatorView.h"
#import "SystemConfig.h"
#import "FMUtils.h"
#import "SeperatorTableViewCell.h"
#import "MainViewController.h"
#import "BaseDataDownloader.h"
#import "FMFont.h"
#import "NotificationDbHelper.h"
#import "BaseTextField.h"
#import "QuickSearchIndexTable.h"
#import "VerticalIndexView.h"
#import "ProjectTableHelper.h"
#import "ProjectBusiness.h"

@interface ProjectsViewController () <OnItemClickListener, OnMessageHandleListener>

@property (readwrite, nonatomic, strong) BaseTextField * searchTf;  //搜索框
@property (readwrite, nonatomic, strong) UIView * searchContainerView;

@property (readwrite, nonatomic, strong) UIView * mainContainerView;
@property (readwrite, nonatomic, strong) UITableView * projectTableView;
@property (readwrite, nonatomic, strong) UILabel * noticeLbl;
@property (readwrite, nonatomic, strong) VerticalIndexView * indexView;

@property (readwrite, nonatomic, strong) NSMutableArray * projects;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) CGFloat indexWidth;    //索引宽度

@property (readwrite, nonatomic, assign) CGFloat indexItemheight;    //索引项高度

@property (readwrite, nonatomic, strong) QuickSearchIndexTable * searchHelper;  //快速搜索的索引表
@property (readwrite, nonatomic, strong) ProjectTableHelper * tableHelper;
@property (readwrite, nonatomic, strong) ProjectBusiness * business;
@property (readwrite, nonatomic, assign) CGFloat searchHeight;  //搜索框高度

@property (readwrite, nonatomic, assign) CGFloat noticeHeight;
@property (readwrite, nonatomic, assign) ProjectBackType backType;

@end

@implementation ProjectsViewController

- (instancetype) initWithType:(ProjectBackType) type {
    self = [super init];
    if(self) {
        _backType = type;
    }
    return self;
}

- (void) initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_select_project" inTable:nil]];
    [self setBackAble:YES];
}

- (void) initLayout {
    if(!_mainContainerView) {
        
        CGRect frame = [self getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        _tableHelper = [[ProjectTableHelper alloc] initWithContext:self];
        
        _noticeHeight = 40;
        _searchHeight = 40;
        _indexWidth = 40;
        _indexItemheight = 24;
        
        CGFloat originY = 0;
        CGFloat padding = 10;
        CGFloat searchPaddingTop = 6;
        
        _mainContainerView = [[UIView alloc] initWithFrame:frame];
        
        _searchContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, _realWidth, _searchHeight + searchPaddingTop * 2)];
        
        _searchContainerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _searchContainerView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _searchContainerView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        _searchTf = [[BaseTextField alloc] initWithFrame:CGRectMake(padding, searchPaddingTop, _realWidth-padding*2, _searchHeight)];
        _searchTf.font = [FMFont getInstance].defaultFontLevel2;
        [_searchTf setLabelWithImage:[[FMTheme getInstance] getImageByName:@"search_gray"]];
        [_searchTf addTarget:self action:@selector(onSearchFilterChanged) forControlEvents:UIControlEventEditingChanged];
        _searchTf.delegate = self;
        _searchTf.borderStyle = UITextBorderStyleNone;
        _searchTf.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        _searchTf.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _searchTf.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        _searchTf.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [_searchTf setPlaceholder:[[BaseBundle getInstance] getStringByKey:@"project_exchange_search_notice" inTable:nil]];
        
        [_searchContainerView addSubview:_searchTf];
        originY += _searchHeight + searchPaddingTop * 2;
        
        _projectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, _realWidth-_indexWidth, _realHeight-originY)];
        _projectTableView.dataSource = _tableHelper;
        _projectTableView.delegate = _tableHelper;
        _projectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _projectTableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        _projectTableView.sectionIndexColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        _projectTableView.showsVerticalScrollIndicator = NO;
        
        _indexView = [[VerticalIndexView alloc] initWithFrame:CGRectMake(_realWidth-_indexWidth, originY, _indexWidth, _realHeight-originY)];
        [_indexView setItemHeight:_indexItemheight];
        [_indexView setOnItemClickListener:self];
        
        
        _noticeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setText:[[BaseBundle getInstance] getStringByKey:@"select_no_project" inTable:nil]];
        _noticeLbl.textAlignment = NSTextAlignmentCenter;
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        [_noticeLbl setHidden:YES];
        
        [_mainContainerView addSubview:_searchContainerView];
        [_mainContainerView addSubview:_projectTableView];
        [_mainContainerView addSubview:_indexView];
        [_mainContainerView addSubview:_noticeLbl];
        
        [self.view addSubview:_mainContainerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];

    _searchHelper = [[QuickSearchIndexTable alloc] init];
    [_tableHelper setSearchHelper:_searchHelper];
    [_tableHelper setOnMessageHandleListener:self];
    _business = [ProjectBusiness getInstance];
    [self requestData];
    [self notifyNotificationNeedUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didNotificationUpdated {
    [self updateList];
}

- (void) updateNotice {
    if([self needShowCurrentProject] || [_projects count] > 0) {
        [_noticeLbl setHidden:YES];
    } else {
        [_noticeLbl setHidden:NO];
    }
}

- (void) updateNotificationCount {
    NotificationDbHelper * helper = [NotificationDbHelper getInstance];
    NSNumber * userId = [SystemConfig getUserId];
    userId = @3687;
    
//    NSMutableArray * array = [helper queryAllNotificationOfCompanyBy:userId];   //项目级公告
//    for(ProjectGroup * group in _groups) {
        for(Project * project in _projects) {
            NSNumber * projectId = project.projectId;
            if(![FMUtils isNumberNullOrZero:projectId]) {
                NSInteger count = [helper queryAllNotificationUnReadBy:userId project:projectId];
                project.msgCount = count;
            }
        }
//    }
}

- (void) updateQuickSearchTable {
    NSMutableArray * nameArray = [self getProjectNameArray];
    [_searchHelper setDataWithArray:nameArray];
}

//
- (void) updateIndexViews {
    NSMutableArray * keys = [[NSMutableArray alloc] init];
    if([self needShowCurrentProject]) {
        [keys addObject:[[BaseBundle getInstance] getStringByKey:@"project_current_key" inTable:nil]];
    }
    [keys addObjectsFromArray:[_searchHelper getGoupNameArray]];
    
    [_indexView setKeyWithArray:keys];
}

- (void) updateList {
    [self updateNotificationCount];
    [_tableHelper setDataWithArray:_projects];
    [self updateQuickSearchTable];
    [self updateIndexViews];
    [self updateNotice];
    [_projectTableView reloadData];
}

//获取项目名称数组
- (NSMutableArray *) getProjectNameArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    if(_projects) {
        for(Project * project in _projects) {
            NSString * name = [project.name copy];
            [array addObject:name];
        }
    }
    return array;
}

//检测当前项目是否存在
- (void) checkCurrentProjectExist {
    BOOL exist = NO;
    NSNumber * currentProjectId = [SystemConfig getCurrentProjectId];
    if(currentProjectId && _projects) {
        for(Project * project in _projects) {
            if(project && [project.projectId isEqualToNumber:currentProjectId]) {
                exist = YES;
                break;
            }
        }
        if(!exist) {
            [SystemConfig setCurrentProjectId:nil];
        }
    }
}

- (BOOL) needShowCurrentProject {
    BOOL show = NO;
    if([SystemConfig getCurrentProjectId]) {
        show = YES;
    }
    return show;
}

#pragma mark - 请求数据
- (void) requestData {
    [self showLoadingDialog];
    NSNumber * userId = [SystemConfig getUserId];
    [_business getProjectsWith:userId Success:^(NSInteger key, id object) {
        if(!_projects) {
            _projects = [[NSMutableArray alloc] init];
        } else {
            [_projects removeAllObjects];
        }
        NSArray * groups = object;
        for(ProjectGroup * group in groups) {
            if(group.projects && [group.projects count] > 0) {
                for(Project * project in group.projects) {
                    [_projects addObject:project];
                }
            }
        }
        [self checkCurrentProjectExist];
        
        [self hideLoadingDialog];
        [self updateList];
    } fail:^(NSInteger key, NSError *error) {
        [self hideLoadingDialog];
        [self updateList];
    }];
}


//查看单项目概况
- (void) gotoProjectDetail:(NSNumber*) projectId {
    [self gotoMain];
}

- (void) gotoMain {
    MainViewController * mainVC;
    [self notifyProjectChanged];
    switch (_backType) {
        case PROJECT_BACK_TYPE_NEW:
            mainVC = [[MainViewController alloc] init];
            [self gotoViewController:mainVC];
            break;
        default:
            [self finish];
            break;
    }
}

- (void) notifyProjectChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentProjectChanged" object:self];
//    [BaseViewController updateAppBageIcon];
}

#pragma mark - 搜索条件变化
- (void) onSearchFilterChanged {
    NSLog(@"搜索条件发生了变化");
    UITextRange * selectedRange = [_searchTf markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
//        [self updateList];
        NSString * strFilter = _searchTf.text;
        [_searchHelper setFilter:strFilter];
        [self updateList];
    }
}

//右侧索引栏的点击事件
- (void) onItemClick:(UIView *)view subView:(UIView *)subView {
    if([view isKindOfClass:[_indexView class]]) {
        if(subView) {
            NSInteger position = subView.tag;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:position];
            [_projectTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

- (void) handleMessage:(id)msg {
    if(msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_tableHelper class])]) {
            Project * project = [msg valueForKeyPath:@"result"];
            NSNumber * projectId;
            projectId = project.projectId;
            NSNumber * currentProjectId = [SystemConfig getCurrentProjectId];
            if(!currentProjectId || (projectId && ![projectId isEqualToNumber:currentProjectId])) {
                [SystemConfig setCurrentProjectId:projectId];       //保存当前项目信息
            }
            [SystemConfig setCurrentProjectName:project.name];  //可能出现 ID 一样名字不一样的情况
            [self gotoProjectDetail:projectId];
        }
    }
}

@end
