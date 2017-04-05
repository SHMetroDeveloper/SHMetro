//
//  MessageTableViewHelper.m
//  FMLibraryUI
//
//  Created by flynn.yang on 2017/3/19.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "MessageTableViewHelper.h"
#import "FMUtilsPackages.h"
#import "FMMessageTableViewCell.h"
#import "NotificationEntity.h"


@interface MessageTableViewHelper()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, assign) CGFloat logoWidth;
@property (nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation MessageTableViewHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _msgArray = [NSMutableArray new];
        _logoWidth = [FMSize getInstance].msgPaddingLeft;
    }
    return self;
}


- (void) setMsgArray:(NSMutableArray *) msgArray {
    _msgArray = msgArray;
}


#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count = _msgArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = 0;
    NSInteger position = indexPath.row;
    if(position >= 0 && position < [_msgArray count]) {
        NotificationEntity *entity = _msgArray[indexPath.row];
        itemHeight = entity.itemHeight;
    }
    return itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSString *cellIdentifier = @"Cell";
    FMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[FMMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        [cell setShowType:YES paddingLeft:_logoWidth];
    }
    cell.tag = position;
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NotificationEntity *entity;
    FMMessageTableViewCell * msgCell = (FMMessageTableViewCell *) cell;
    if (msgCell) {
        if(position >= 0 && position < [_msgArray count]) {
            entity = _msgArray[position];
        }
        msgCell.rightUtilityButtons = [self rightButtonsWeatherIsRead:entity.read];
        if (position == _msgArray.count-1) {
            [msgCell setSeperatorBroad:YES];
        } else {
            [msgCell setSeperatorBroad:NO];
        }
        [msgCell setInfoWithTitle:entity.title
                          content:entity.content
                             time:entity.time
                             type:entity.type
                           status:entity.woStatus
                             read:entity.read];
    }
}

#pragma mark - UITableViewDelegate
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationEntity * msg = _msgArray[indexPath.row];
    NotificationItemType type = msg.type;
    
    _actionBlock(msg,type);  //Action回调
}

#pragma mark - SWTableViewCellDelegate
- (NSArray *) rightButtonsWeatherIsRead:(BOOL) isRead {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (!isRead) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]
                                                    title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_mark_readed" inTable:nil]];
    }
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK]
                                                title:[[BaseBundle getInstance] getStringByKey:@"tableviewcell_delete" inTable:nil]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]
                                                 icon:[[FMTheme getInstance] getImageByName:@"menu_more_slimer"]];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    cell = (FMMessageTableViewCell *) cell;
    NSInteger position = cell.tag;
    NotificationEntity * msg = _msgArray[position];
    if (msg.read) {
        index += 1;
    }
    NotificationEditType editType = index;
    _editBlock(editType, position, msg);  //edit回调
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - 刷新
- (void) pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [self notifyEvent:NOTIFICATION_EDIT_TYPE_REFRESH data:nil];
}

- (void) pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    [self notifyEvent:NOTIFICATION_EDIT_TYPE_LOAD_MORE data:nil];
}

#pragma mark - 发送消息
- (void) notifyEvent:(NotificationEditType) type data:(id) data {
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

