//
//  EquipmentListTableHelper.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/2.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "EquipmentListTableHelper.h"
#import "FMUtilsPackages.h"
#import "EquipmentListView.h"
#import "SeperatorView.h"
#import "AssetManagementEntity.h"


@interface EquipmentListTableHelper()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;
@property (readwrite, nonatomic, weak) BaseViewController * baseVC;

@property (readwrite, nonatomic, strong) NSMutableArray * dataArray;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end


@implementation EquipmentListTableHelper

- (instancetype)initWithContext:(BaseViewController *)context {
    self = [super init];
    if (self) {
        CGRect frame = [context getContentFrame];
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        _baseVC = context;
        _page = [[NetPage alloc] init];
        _dataArray = [NSMutableArray new];
    }
    return self;
}

- (void) setEquipmentWithArray:(NSMutableArray *) array {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    _dataArray = [array copy];
}

- (void) removeAllOrders {
    if(_dataArray) {
        [_dataArray removeAllObjects];
    }
    [_page reset];
}

- (void) addOrdersWithArray:(NSMutableArray *) orders {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    [_dataArray addObjectsFromArray:orders];
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

- (NSInteger) getOrderCount {
    return [_dataArray count];
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    height = [EquipmentListView calculateHeight];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    UITableViewCell * cell = nil;
    EquipmentListView * equipmentItemView = nil;
    SeperatorView * seperator = nil;
    AssetManagementEquipmentsEntity * itemEntity = [_dataArray objectAtIndex:position];
    
    CGFloat itemHeight = [EquipmentListView calculateHeight];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].padding50;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        NSArray * subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[EquipmentListView class]]) {
                equipmentItemView = view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if (cell && !equipmentItemView) {
        equipmentItemView = [[EquipmentListView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
        [cell addSubview:equipmentItemView];
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if (seperator) {
        if (position == _dataArray.count - 1) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
        } else {
            [seperator setDotted:YES];
            [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
        }
    }
    if (equipmentItemView) {
        [equipmentItemView setInfoWithTitle:[itemEntity getEquipmentNameDesc]
                                   category:itemEntity.equSysName
                                   location:itemEntity.location
                                     status:itemEntity.status.integerValue
                                     repair:itemEntity.repairNumber
                                maintecance:itemEntity.maintainNumber];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self nofityEvent:indexPath.row];
}

- (void) nofityEvent:(NSInteger) position {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        NSString * strOrigin = NSStringFromClass([self class]);
        [msg setValue:strOrigin forKeyPath:@"msgOrigin"];
        AssetManagementEquipmentsEntity * data = [_dataArray objectAtIndex:position];
        NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
        [result setValue:data forKeyPath:@"eventData"];
        [msg setValue:result forKeyPath:@"result"];
        [_handler handleMessage:msg];
    }
}

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler {
    _handler = handler;
}

@end




