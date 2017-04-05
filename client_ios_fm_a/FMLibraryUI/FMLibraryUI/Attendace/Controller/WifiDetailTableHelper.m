//
//  EmployeeDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WifiDetailTableHelper.h"
//#import "BaseTableViewCell.h"
#import "WifiDetailTableViewCell.h"
#import "AttendanceSettingEntity.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface WifiDetailTableHelper ()
@property (readwrite, nonatomic, strong) NSMutableArray * array;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation WifiDetailTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    _itemHeight = 48;
    
    _array = [[NSMutableArray alloc] init];
}

- (void) clearData {
    if(_array) {
        [_array removeAllObjects];
    }
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
}

- (void) setWifi:(NSMutableArray *)array {
    _array = array;
}

- (NSInteger) getWifiCount {
    return [_array count];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = _itemHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    WifiDetailTableViewCell *cell = nil;
    NSInteger position = indexPath.row;
    if (!cell) {
        cell  = [[WifiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        __weak typeof(self) weakSelf = self;
        cell.actionBlock = ^(BOOL enable){
            if (weakSelf.isEditable) {
                AttendanceConfigureWiFi *wifi = weakSelf.array[position];
                wifi.enable = enable;
                [weakSelf.array replaceObjectAtIndex:position withObject:wifi];
                NSMutableDictionary *wifiDic = [NSMutableDictionary new];
                [wifiDic setValue:wifi forKeyPath:@"wifi"];
                [wifiDic setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
                [weakSelf notifyEvent:WIFI_DETAIL_TABLE_EVENT_ENABLE_CHANGE data:wifiDic];
            }
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (cell && [cell isKindOfClass:[WifiDetailTableViewCell class]]) {
        WifiDetailTableViewCell *wifiCell = (WifiDetailTableViewCell *)cell;
        AttendanceConfigureWiFi * wifi = _array[position];
        [wifiCell setIsEnable:wifi.enable];
        if(position == [_array count] -1) {
            [wifiCell setIsLast:YES];
        } else {
            [wifiCell setIsLast:NO];
        }
        [wifiCell setName:wifi.name];
        [wifiCell setDesc:wifi.mac];
        wifiCell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NSInteger position = indexPath.row;
    __block AttendanceConfigureWiFi *wifi = _array[position];
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf notifyDeleteInfo:wifi position:position];
    }];
    
    UITableViewRowAction *enableAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_enable" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        wifi.enable = YES;
        NSMutableDictionary *wifiDic = [NSMutableDictionary new];
        [wifiDic setValue:wifi forKeyPath:@"wifi"];
        [wifiDic setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
        [weakSelf notifyEvent:WIFI_DETAIL_TABLE_EVENT_ENABLE_CHANGE data:wifiDic];
    }];
    enableAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    
    UITableViewRowAction *disableAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_disable" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        wifi.enable = NO;
        NSMutableDictionary *wifiDic = [NSMutableDictionary new];
        [wifiDic setValue:wifi forKeyPath:@"wifi"];
        [wifiDic setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
        [weakSelf notifyEvent:WIFI_DETAIL_TABLE_EVENT_ENABLE_CHANGE data:wifiDic];
    }];
    disableAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    
    
    if (_isEditable) {
        if (wifi.enable) {
            return @[deleteAction,disableAction];
        } else {
            return @[deleteAction,enableAction];
        }
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _isEditable;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}


- (void) notifyDeleteInfo:(AttendanceConfigureWiFi *) wifi position:(NSInteger) position {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:wifi forKeyPath:@"wifi"];
    [dict setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
    [self notifyEvent:WIFI_DETAIL_TABLE_EVENT_DELETE data:dict];
}

- (void) notifyEvent:(WifiDetailTableEventType) type data:(id) data {
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



@end
