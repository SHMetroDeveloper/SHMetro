//
//  PatrolSpotsListHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "PatrolSpotsListHelper.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMColor.h"
#import "BaseBundle.h"
#import "NetPage.h"
#import "PatrolTaskSpotItemView.h"
#import "DBPatrolSpot+CoreDataClass.h"


@interface PatrolSpotsListHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * spots;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;
@property (readwrite, nonatomic, assign) BOOL showTask;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation PatrolSpotsListHelper

- (instancetype) init{
    self = [super init];
    if(self) {
        _spots = [[NSMutableArray alloc] init];
        _itemHeight = 120;
        _page = [[NetPage alloc] init];
    }
    return self;
}


- (void) setDataWithArray:(NSMutableArray *) spots {
    _spots = spots;
}

- (void) setShowTask:(BOOL)showTask {
    _showTask = showTask;
}


- (void) addDataWithArray:(NSMutableArray *) tasks {
    if(!_spots) {
        _spots = [[NSMutableArray alloc] init];
    }
    [_spots addObjectsFromArray:tasks];
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
    return [_spots count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_spots count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = _itemHeight;
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PatrolTaskSpotItemView * itemView = nil;
    SeperatorView * seperator;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = _itemHeight;
    CGFloat paddingLeft = [FMSize getInstance].listItemPaddingLeft;
    CGFloat width = CGRectGetWidth(tableView.frame);
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id subView in subViews) {
            if([subView isKindOfClass:[PatrolTaskSpotItemView class]]) {
                itemView = subView;
            } else if([subView isKindOfClass:[SeperatorView class]]) {
                seperator = subView;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[PatrolTaskSpotItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] initWithFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width, seperatorHeight)];
        [cell addSubview:seperator];
    } else if(seperator){
        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width, seperatorHeight)];
    }
    if(itemView) {
        DBPatrolSpot* spot = _spots[position];
        NSString * strStatus;
        if(spot.finish) {
            if(spot.finish.boolValue) {
                strStatus = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_complete" inTable:nil];
            } else {
                strStatus = [[BaseBundle getInstance] getStringByKey:@"patrol_task_status_incomplete" inTable:nil];
            }
        }
        
        NSString * strSyn;
        if(spot.edit) {
            if(spot.edit.boolValue) {
                strSyn = [[BaseBundle getInstance] getStringByKey:@"patrol_syned" inTable:nil];
            } else {
                strSyn = [[BaseBundle getInstance] getStringByKey:@"patrol_un_syned" inTable:nil];
            }
        }
        
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        if(_showTask) {
            [itemView setInfoWithName:spot.name
                             taskName:spot.patrolTaskName
                             position:spot.place
                            composite:spot.spotCheckNumber.integerValue
                               device:spot.deviceCheckNumber.integerValue
                                state:strStatus
                               notice:strSyn];
        } else {
            [itemView setInfoWithName:spot.name
                             position:spot.place
                            composite:spot.spotCheckNumber.integerValue
                               device:spot.deviceCheckNumber.integerValue
                                state:strStatus
                               notice:strSyn];
        }
        
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
    DBPatrolSpot * spot = _spots[position];
    [self notifyEvent:PATROL_SPOTS_LIST_SHOW_DETAIL data:spot];
}

- (void) notifyEvent:(PatrolSpotsListEventType) type data:(id) data {
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
