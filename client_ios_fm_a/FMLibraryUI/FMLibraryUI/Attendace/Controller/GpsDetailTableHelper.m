//
//  GpsDetailTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/27/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "GpsDetailTableHelper.h"
#import "AttendanceSettingLocationTableViewCell.h"
#import "LocationDetailAccuracyTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "BaseBundle.h"

#import "AttendanceSettingEntity.h"

typedef NS_ENUM(NSInteger, GpsDetailTableSectionType) {
    GPS_DETAIL_TABLE_SECTION_LOCATION,  //位置
    GPS_DETAIL_TABLE_SECTION_ACCURACY,   //范围
    GPS_DETAIL_TABLE_SECTION_UNKNOW
};

@interface GpsDetailTableHelper ()
@property (readwrite, nonatomic, strong) __block NSMutableArray * gpsArray;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, assign) NSInteger accuracy;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation GpsDetailTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void) initData {
    _itemHeight = 70;
    
    _gpsArray = [[NSMutableArray alloc] init];
}

- (void) setGpsWithArray:(NSMutableArray *) array {
    _gpsArray = array;
}

- (NSInteger) getGpsCount {
    return [_gpsArray count];
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
}

- (void) setAccuracy:(NSInteger)accuracy {
    _accuracy = accuracy;
}

- (GpsDetailTableSectionType) getSectionTypeBySection:(NSInteger) section {
    GpsDetailTableSectionType sectionType = GPS_DETAIL_TABLE_SECTION_UNKNOW;
    switch(section) {
        case 0:
            sectionType = GPS_DETAIL_TABLE_SECTION_LOCATION;
            break;
        case 1:
            sectionType = GPS_DETAIL_TABLE_SECTION_ACCURACY;
            break;
        default:
            break;
    }
    return sectionType;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if([_gpsArray count] > 0) {
        count = 2;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION:
            count = [_gpsArray count];
            break;
        case GPS_DETAIL_TABLE_SECTION_ACCURACY:
            count = 1;
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger section = indexPath.section;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION:
            height = [AttendanceSettingLocationTableViewCell calculateHeight];
            break;
        case GPS_DETAIL_TABLE_SECTION_ACCURACY:
            height = [LocationDetailAccuracyTableViewCell calculateHeight];
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    if (!cell) {
        switch(sectionType) {
            case GPS_DETAIL_TABLE_SECTION_LOCATION:
                cellIdentifier = @"CellLocation";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                cell = [[AttendanceSettingLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                break;
            case GPS_DETAIL_TABLE_SECTION_ACCURACY:
                cellIdentifier = @"CellAccuracy";
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                cell = [[LocationDetailAccuracyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    NSInteger section = indexPath.section;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch (sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION: {
            AttendanceSettingLocationTableViewCell *gpscell = (AttendanceSettingLocationTableViewCell *)cell;
            AttendanceLocation *location = _gpsArray[position];
            
            if (position == _gpsArray.count - 1) {
                [gpscell setIsSeperatorDotted:NO];
                [gpscell setIsGapped:NO];
            } else {
                [gpscell setIsSeperatorDotted:YES];
                [gpscell setIsGapped:YES];
            }
            
            [gpscell setIsShowState:YES];
            [gpscell setEnable:location.enable];
            [gpscell setLocationName:location.name];
            [gpscell setLocationDesc:location.desc];
        }
            break;
            
        case GPS_DETAIL_TABLE_SECTION_ACCURACY: {
            LocationDetailAccuracyTableViewCell *accuracyCell = (LocationDetailAccuracyTableViewCell*) cell;
            [accuracyCell setIsEditable:_isEditable];
            [accuracyCell setAccuracy:_accuracy];
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION:
            break;
        case GPS_DETAIL_TABLE_SECTION_ACCURACY:
            if (_isEditable) {
                [self notifyEvent:GPS_DETAIL_TABLE_EVENT_SELECT_ACCURACY data:nil];
            }
            break;
        default:
            break;
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL res = NO;
    NSInteger section = indexPath.section;
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    switch(sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION:
            res = _isEditable;
            break;
        case GPS_DETAIL_TABLE_SECTION_ACCURACY:
            break;
        default:
            break;
    }
    return res;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger section = indexPath.section;
    NSInteger index = indexPath.row;
    AttendanceLocation *location = _gpsArray[index];
    GpsDetailTableSectionType sectionType = [self getSectionTypeBySection:section];
    __weak typeof(self) weakSelf = self;
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_delete" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf.gpsArray removeObjectAtIndex:index];
        [weakSelf notifyDeleteInfo:location position:index];
    }];
    
    
    UITableViewRowAction *enableAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_enable" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        location.enable = YES;
        [weakSelf notifyChangeLocationState:location];
    }];
    enableAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    
    
    UITableViewRowAction *disableAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[[BaseBundle getInstance] getStringByKey:@"btn_title_disable" inTable:nil] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        location.enable = NO;
        [weakSelf notifyChangeLocationState:location];
    }];
    disableAction.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
    
    
    switch(sectionType) {
        case GPS_DETAIL_TABLE_SECTION_LOCATION:
            if (_isEditable) {
                [array addObject:deleteAction];
            } else {
                array = nil;
            }
            if (location.enable) {
                [array addObject:disableAction];
            } else {
                [array addObject:enableAction];
            }
            break;
        case GPS_DETAIL_TABLE_SECTION_ACCURACY:
            break;
        default:
            break;
    }
    return array;
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>)handler {
    _handler = handler;
}

- (void) notifyDeleteInfo:(AttendanceLocation *) location position:(NSInteger) position {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:location forKeyPath:@"location"];
    [dict setValue:[NSNumber numberWithInteger:position] forKeyPath:@"position"];
    [self notifyEvent:GPS_DETAIL_TABLE_EVENT_DELETE data:dict];
}

- (void) notifyChangeLocationState:(AttendanceLocation *) location {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:location forKeyPath:@"location"];
    [self notifyEvent:GPS_DETAIL_TABLE_EVENT_STATE_CHANGE data:dict];
}

- (void) notifyEvent:(GpsDetailTableEventType) type data:(id) data {
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

