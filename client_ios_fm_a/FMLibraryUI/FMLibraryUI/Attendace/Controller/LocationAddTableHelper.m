//
//  LocationAddTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "LocationAddTableHelper.h"
#import "LocationAddTableViewCell.h"
#import "AttendanceSettingEntity.h"
#import "OnMessageHandleListener.h"
#import "CheckItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "OnItemClickListener.h"
#import "FMFont.h"

@interface LocationAddTableHelper () <OnItemClickListener>

@property (readwrite, nonatomic, strong) NSMutableArray * array;

@property (readwrite, nonatomic, strong) NSMutableArray * selectArray;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation LocationAddTableHelper
- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    
    _itemHeight = 70;
    
    _array = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
}

- (void) clearData {
    if(_array) {
        [_array removeAllObjects];
    }
    if(_selectArray) {
        [_selectArray removeAllObjects];
    }
}

- (void) setLocation:(NSMutableArray *) array {
    _array = array;
    
    if(!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    } else {
        [_selectArray removeAllObjects];
    }
}

//获取所选择的 位置 数组
- (NSMutableArray *) getSelectedLocationArray {
    NSMutableArray *res = [[NSMutableArray alloc] init];
    if (_selectArray.count > 0) {
        NSIndexPath *selectedIndex = _selectArray[0];
        AttendanceLocation *location = _array[selectedIndex.row];
        [res addObject:location];
    }
    return res;
}


#pragma mark - 数据源
- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_array count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LocationAddTableViewCell calculateHeight];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    LocationAddTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[LocationAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    BOOL isChecked = NO;
    if (_selectArray.count > 0) {
        NSIndexPath *selectedIndex = _selectArray[0];
        if (indexPath.row == selectedIndex.row) {
            isChecked = YES;
        }
    }
    if (cell && [cell isKindOfClass:[LocationAddTableViewCell class]]) {
        LocationAddTableViewCell *locationCell = (LocationAddTableViewCell *)cell;
        cell.tag = position;
        AttendanceLocation *location = _array[position];

        [locationCell setName:location.name];
        [locationCell setDesc:location.desc];
        [locationCell setChecked:isChecked];
        if(position == [_array count] - 1) {
            [locationCell setIsLast:YES];
        } else {
            [locationCell setIsLast:NO];
        }
    }
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    } else {
        [_selectArray removeAllObjects];
    }
    [_selectArray addObject:indexPath];
    [self notifyNeedUpdate];
}

- (void) notifyNeedUpdate {
    [self notifyEvent:LOCATION_ADD_TABLE_EVENT_CHECK_UPDATE data:nil];
}

- (void) notifyEvent:(LocationAddTableEventType) type data:(id) data {
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

