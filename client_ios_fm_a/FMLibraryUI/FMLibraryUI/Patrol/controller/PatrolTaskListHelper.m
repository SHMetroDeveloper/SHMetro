//
//  PatrolTaskListHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/9/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolTaskListHelper.h"

#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "NetPage.h"
#import "ShowMoreDetailTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"
#import "PatrolTaskItemView.h"
#import "DBPatrolTask+CoreDataClass.h"


@interface PatrolTaskListHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * tasks;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation PatrolTaskListHelper

- (instancetype) init{
    self = [super init];
    if(self) {
        _tasks = [[NSMutableArray alloc] init];
        _seperatorHeight = 15;
        _showMoreHeight = 50;
        _page = [[NetPage alloc] init];
    }
    return self;
}


- (void) setDataWithArray:(NSMutableArray *) tasks {
    _tasks = tasks;
}


- (void) addDataWithArray:(NSMutableArray *) tasks {
    if(!_tasks) {
        _tasks = [[NSMutableArray alloc] init];
    }
    [_tasks addObjectsFromArray:tasks];
}


- (void) setPage:(NetPage *)page {
    _page = page;
}

- (NetPage *) getPage {
    return _page;
}

- (BOOL) isFirstPage {
    return [_page isFirstPage];
}

- (BOOL) hasMorePage {
    return [_page haveMorePage];
}

- (NSInteger) getDataCount {
    return [_tasks count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    itemHeight = [PatrolTaskItemView calculateHeight];
    return itemHeight + _seperatorHeight + _showMoreHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    
    static NSString *cellIdentifier = @"Cell";
    ShowMoreDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PatrolTaskItemView * itemView = nil;
    SeperatorView * seperator = nil;
    
    CGFloat width = tableView.frame.size.width;
    
    CGFloat itemHeight = [PatrolTaskItemView calculateHeight];
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat paddingLeft = [FMSize getInstance].defaultPadding;
    
    if(!cell) {
        cell = [[ShowMoreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeperatorHeight:_seperatorHeight andShowMoreHeight:_showMoreHeight];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[PatrolTaskItemView class]]) {
                itemView = (PatrolTaskItemView *)view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *)view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[PatrolTaskItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft * 2, seperatorHeight)];
        [cell addSubview:seperator];
    }
    if(itemView) {
        itemView.tag = position;
        DBPatrolTask * task = _tasks[position];
        BOOL needSubmit = YES;
        [itemView setInfoWithName: task.patrolTaskName
                        startTime: [FMUtils timeLongToDateString:task.startDate]
                          endTime: [FMUtils timeLongToDateString:task.endDate]
                             spot: task.spotNumber.integerValue
                           device: task.deviceNumber.integerValue
                         taskType: task.taskType.integerValue
                         isFinish: task.finish.boolValue
                              syn: task.edit
                           submit: needSubmit];
    }
    return cell;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self notifyShowTaskDetail:position];
}

- (void) notifyShowTaskDetail:(NSInteger) position {
    DBPatrolTask * task = _tasks[position];
    [self notifyEvent:PATROL_TASK_LIST_SHOW_DETAIL data:task];
}

- (void) notifyEvent:(PatrolTaskListEventType) type data:(id) data {
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


@end
