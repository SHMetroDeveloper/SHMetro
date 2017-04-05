//
//  BluetoothDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "BluetoothDetailTableHelper.h"
#import "SignSettingTableViewCell.h"
#import "AttendanceSettingEntity.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface BluetoothDetailTableHelper ()
@property (readwrite, nonatomic, strong) NSMutableArray * array;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation BluetoothDetailTableHelper

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

- (void) setBluetooth:(NSMutableArray *)array {
    _array = array;
}

- (void) addBluetooth:(NSMutableArray *)array {
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    [_array addObjectsFromArray:array];
}

- (NSInteger) getBluetoothCount {
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
    SignSettingTableViewCell *cell = nil;
    if (!cell) {
        cell  = [[SignSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    
    if (cell && [cell isKindOfClass:[SignSettingTableViewCell class]]) {
        SignSettingTableViewCell *wifiCell = (SignSettingTableViewCell *)cell;
        AttendanceConfigureBluetooth * bluetooth = _array[position];
        [wifiCell setName:bluetooth.name];
        [wifiCell setDesc:bluetooth.mac];
        if(position == [_array count] -1) {
            [wifiCell setIsLast:YES];
        } else {
            [wifiCell setIsLast:NO];
        }
        wifiCell.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSInteger position = indexPath.row;
        AttendanceConfigureBluetooth * bluetooth = _array[position];
        [_array removeObjectAtIndex:position];
        [self notifyDeleteInfo:bluetooth];
    }];
    
    return @[deleteAction];
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}


- (void) notifyDeleteInfo:(AttendanceConfigureBluetooth *) bluetooth {
    [self notifyEvent:BLUETOOTH_DETAIL_TABLE_EVENT_DELETE data:bluetooth];
}

- (void) notifyEvent:(BluetoothDetailTableEventType) type data:(id) data {
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

