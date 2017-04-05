//
//  WifiAddTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WifiAddTableHelper.h"
#import "WifiAddTableViewCell.h"
#import "AttendanceSettingEntity.h"
#import "OnMessageHandleListener.h"
#import "CheckItemView.h"
#import "BaseBundle.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMTheme.h"
#import "OnItemClickListener.h"
#import "FMFont.h"

@interface WifiAddTableHelper () <OnItemClickListener>

@property (readwrite, nonatomic, strong) NSMutableArray * array;

@property (readwrite, nonatomic, strong) NSMutableArray * selectArray;

@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WifiAddTableHelper
- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    
    _itemHeight = 90;
    
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

- (void) setWifi:(NSMutableArray *) array {
    _array = array;
    
    if(!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    } else {
        [_selectArray removeAllObjects];
    }

    for(id obj in _array) {
        [_selectArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void) setWifiInfo:(NSMutableDictionary *) wifiDictionary {
    _array = [wifiDictionary valueForKeyPath:@"wifi"];
    _selectArray = [wifiDictionary valueForKeyPath:@"wifiStatus"];
}


- (NSInteger) getWifiCount {
    NSInteger count = [_array count];
    return count;
}

//获取所选择的 wifi 数组
- (NSMutableArray *) getSelectedWifiArray {
    NSMutableArray * res = [[NSMutableArray alloc] init];
    NSInteger count = [_array count];
    for(NSInteger index = 0; index<count; index++) {
        NSNumber * tmp = _selectArray[index];
        if(tmp.boolValue) {
            [res addObject:_array[index]];
        }
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
    return [WifiAddTableViewCell calculateHeight];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    WifiAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[WifiAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[WifiAddTableViewCell class]]) {
        WifiAddTableViewCell *wifiCell = (WifiAddTableViewCell *)cell;
        
        AttendanceConfigureWiFi *wifi = _array[position];
        NSNumber * tmp = _selectArray[position];
        
        cell.tag = position;
        [wifiCell setName:wifi.name];
        [wifiCell setDesc:wifi.mac];
        [wifiCell setChecked:tmp.boolValue];
        
        if(position == [_array count] - 1) {
            [wifiCell setIsLast:YES];
        } else {
            [wifiCell setIsLast:NO];
        }
    }
    cell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat headerHeight = 0;
    if([_array count] > 0) {
        headerHeight = 40;
    }
    return headerHeight;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headerView = [[UIView alloc] init];
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat headerHeight = 40;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, width-padding*2, headerHeight)];
    lbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
    lbl.font = [FMFont fontWithSize:13];
    lbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_notice_wifi_add_header" inTable:nil];
    [headerView addSubview:lbl];
    headerView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    return headerView;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    NSNumber * tmp = _selectArray[position];
    _selectArray[position] = [NSNumber numberWithBool:!tmp.boolValue];
    [self notifyNeedUpdate];
}

- (void) notifyNeedUpdate {
    [self notifyEvent:WIFI_ADD_TABLE_EVENT_CHECK_UPDATE data:nil];
}

- (void) notifyEvent:(WifiAddTableEventType) type data:(id) data {
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

