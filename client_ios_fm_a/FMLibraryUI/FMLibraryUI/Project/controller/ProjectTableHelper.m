//
//  ProjectTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/29.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "ProjectTableHelper.h"
#import "SystemConfig.h"

#import "ProjectEntity.h"
#import "BaseItemView.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMTheme.h"
#import "FMFont.h"
#import "FMUtils.h"

@interface ProjectTableHelper ()
@property (readwrite, nonatomic, strong) QuickSearchIndexTable * searchHelper;
@property (readwrite, nonatomic, strong) NSMutableArray * projects;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) CGFloat headerHeight;

@property (readwrite, nonatomic, weak) UIViewController * context;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation ProjectTableHelper

- (instancetype) initWithContext:(UIViewController *) context {
    self = [super init];
    if(self) {
        _context = context;
        
        _headerHeight = 30;
        _itemHeight = 45;
    }
    return self;
}

//
- (void) setDataWithArray:(NSMutableArray *) projects {
    _projects = projects;
}

- (void) setSearchHelper:(QuickSearchIndexTable *)searchHelper {
    _searchHelper = searchHelper;
}


- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

- (BOOL) needShowCurrentProject {
    BOOL show = NO;
    if([SystemConfig getCurrentProjectId]) {
        show = YES;
    }
    return show;
}



- (NSString *) getSectionName:(NSInteger) section {
    NSString * res;
    if([self needShowCurrentProject]) {
        if(section == 0) {
            res = [[BaseBundle getInstance] getStringByKey:@"project_current_key_full" inTable:nil];
        } else {
            section -= 1;
            res = [[_searchHelper getGroupNameAtIndex:section] uppercaseString];
        }
    } else {
        res = [[_searchHelper getGroupNameAtIndex:section] uppercaseString];
    }
    return res;
}

- (NSString *) getItemName:(NSInteger) section position:(NSInteger) position {
    NSString * res;
    BOOL isCurrent = NO;
    if([self needShowCurrentProject]) {
        if(section == 0) {
            isCurrent = YES;
        } else {
            section -= 1;
        }
    }
    if(isCurrent) {
        res = [SystemConfig getCurrentProjectName];
    } else {
        NSInteger index = [_searchHelper getIndexByGroup:section andPosition:position];
        Project * project = _projects[index];
        res = project.name;
    }
    
    return res;
}


- (Project *) getCurrentProject {
    Project * res;
    NSNumber * projectId = [SystemConfig getCurrentProjectId];
    if(projectId) {
        if(_projects) { //如果获取到了网络数据的话就用网络数据
            for(Project * pro in _projects) {
                if([pro.projectId isEqualToNumber:projectId]) {
                    res = pro;
                    break;
                }
            }
        } else { //否则就用本地数据
            res = [[Project alloc] init];
            res.projectId = projectId;
            res.name = [SystemConfig getCurrentProjectName];
        }
    }
    return res;
}

- (Project *) getProjectBy:(NSInteger) section position:(NSInteger) position {
    Project * res;
    BOOL isCurrent = NO;
    if([self needShowCurrentProject]) {
        if(section == 0) {
            isCurrent = YES;
        } else {
            section -= 1;
        }
    }
    if(isCurrent) {
        res = [self getCurrentProject];
    } else {
        NSInteger index = [_searchHelper getIndexByGroup:section andPosition:position];
        res = _projects[index];
    }
    
    return res;
}

//获取组的个数
- (NSInteger) getCountOfSection {
    NSInteger count = 0;
    count = [_searchHelper getGroupCount];
    if([self needShowCurrentProject]) {
        count += 1;
    }
    return count;
}

//获取组中元素个数
- (NSInteger) getItemCountOfSection:(NSInteger) section {
    NSInteger count = 0;
    BOOL isCurrent = NO;
    if([self needShowCurrentProject]) {
        if(section == 0) {
            isCurrent = YES;
        } else {
            section -= 1;
        }
    }
    if(isCurrent) {
        count = 1;
    } else {
        NSString * key = [_searchHelper getGroupNameAtIndex:section];
        count = [_searchHelper getItemCountByKey:key];
    }
    return count;
}

//判断是否为当前选中项目
- (BOOL) isProjectCurrentSelected:(NSNumber *) projectId {
    BOOL res = NO;
    NSNumber * currentProjectId = [SystemConfig getCurrentProjectId];
    if(currentProjectId && [currentProjectId isEqualToNumber:projectId]) {
        res = YES;
    }
    return res;
}



#pragma mark - table datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger count = [self getCountOfSection];
    return count;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self getItemCountOfSection:section];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = _itemHeight + 10;
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger position = indexPath.row;
    CGFloat itemHeight = _itemHeight;
    BaseItemView * itemView = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat margin = 10;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UITableViewCell* cell = nil;
    Project * project = [self getProjectBy:section position:position];
    static NSString *cellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSArray * subViews = [cell subviews];
        for(id subView in subViews) {
            if([subView isKindOfClass:[BaseItemView class]]) {
                itemView = subView;
                break;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[BaseItemView alloc] init];
        [itemView setPaddingLeft:padding andPaddingRight:padding];
        [itemView setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE]];
        [itemView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        [itemView setShowLogoImage:NO];
        [itemView setShowBound:YES];
        [itemView setDescType:BASE_ITEM_DESC_TYPE_RED_BG];
        itemView.layer.cornerRadius = [FMSize getInstance].defaultBorderRadius;
        [cell addSubview:itemView];
    }
    
    if(itemView) {
        itemView.tag = position;
        [itemView setFrame:CGRectMake(margin, 0, width - margin, itemHeight)];
        
        NSString * strName = project.name;
        
        if(project.msgCount > 0) {
            NSString * countDesc;
            if(project.msgCount < 100) {
                countDesc = [[NSString alloc] initWithFormat:@"%ld", project.msgCount];
            } else {
                countDesc = @"99+";
            }
            [itemView updateDesc:countDesc];
//            [itemView setShowRedPoint:YES];
        } else {
            [itemView updateDesc:nil];
//            [itemView setShowRedPoint:NO];
        }
        
        if([self isProjectCurrentSelected:project.projectId]) {
            [itemView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
        } else {
            [itemView setNameColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
        }
        [itemView setInfoWithName:strName];
    }
    itemView.userInteractionEnabled = NO;
    [cell setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = _headerHeight;
    return headerHeight;
}

- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}


- (NSString*) tableView: (UITableView*) tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

//- (NSArray *) sectionIndexTitlesForTableView:(UITableView *) tableView {
//    return [_searchHelper getGoupNameArray];
//}
//
//- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return index;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat headerHeight = _headerHeight;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, headerHeight)];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    CGFloat padding = 10;
    
    UILabel * nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, width-padding*2, headerHeight)];
    NSString * strName = [self getSectionName:section];
    [nameLbl setText:strName];
    [nameLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT]];
    nameLbl.font = [FMFont getInstance].defaultFontLevel3;
    [headerView addSubview:nameLbl];
    
    return headerView;
}


#pragma mark - 点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    
    Project * project = [self getProjectBy:section position:position];
    [self notifySelectProject:project];
    
}

#pragma mark - 通知项目选择
- (void) notifySelectProject:(Project *) project {
    if(_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:project forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}


@end
