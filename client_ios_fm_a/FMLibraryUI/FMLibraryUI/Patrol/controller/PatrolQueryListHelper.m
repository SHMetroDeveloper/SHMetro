//
//  PatrolHistoryListHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolQueryListHelper.h"
#import "PatrolTaskHistoryEntity.h"

#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "NetPage.h"
#import "PatrolHistoryItemView.h"
#import "PatrolTaskHistoryEntity.h"


@interface PatrolQueryListHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * tasks;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation PatrolQueryListHelper

- (instancetype) init{
    self = [super init];
    if(self) {
        _tasks = [[NSMutableArray alloc] init];
        _page = [[NetPage alloc] init];
        _itemHeight = 120;
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

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = _itemHeight;
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PatrolHistoryItemView * itemView = nil;
    SeperatorView * seperator;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat itemHeight = _itemHeight;
    CGFloat width = CGRectGetWidth(tableView.frame);
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[PatrolHistoryItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]){
                seperator = (SeperatorView *) view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[PatrolHistoryItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(seperator) {
        if(position < [_tasks count] - 1) {
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding*2, seperatorHeight)];
        } else {
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, width, seperatorHeight)];
        }
        
    }
    if(itemView) {
        PatrolTaskHistoryItem* task = _tasks[position];
        [itemView setInfoWithPatrolTask:task];
        itemView.tag = position;
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
    PatrolTaskHistoryItem * task = _tasks[position];
    [self notifyEvent:PATROL_QUERY_LIST_SHOW_DETAIL data:task];
}

- (void) notifyEvent:(PatrolQueryListEventType) type data:(id) data {
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
