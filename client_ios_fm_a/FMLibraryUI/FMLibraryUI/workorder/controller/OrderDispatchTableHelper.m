//
//  OrderDispatchTableHelper.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/4.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "OrderDispatchTableHelper.h"
#import "WorkOrderDispachItemView.h"
#import "WorkOrderDispachEntity.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"

#import "SeperatorTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"

@interface OrderDispatchTableHelper ()

@property (readwrite, nonatomic, strong) NetPage  * page;
@property (readwrite, nonatomic, strong) NSMutableArray * orders;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;
@property (readwrite, nonatomic, strong) BaseViewController * baseVC;

@property (readwrite, nonatomic, strong) id<OnMessageHandleListener> handler;

@end

@implementation OrderDispatchTableHelper
- (instancetype)initWithContext:(BaseViewController *)context {
    self = [super init];
    if (self) {
        _orders = [[NSMutableArray alloc] init];
        _seperatorHeight = 15;
        _showMoreHeight = 50;
        _baseVC = context;
        _page = [[NetPage alloc] init];
    }
    return self;
}

- (WorkOrderDispach *)getOrderByPosition:(NSInteger)position {
    WorkOrderDispach * order = _orders[position];
    return order;
}

- (void)setDataWithArray:(NSMutableArray *)orders {
    _orders = orders;
}

- (void) removeAllOrders {
    if (_orders) {
        [_orders removeAllObjects];
    }
    [_page reset];
}

- (void) addOrdersWithArray:(NSMutableArray *) orders {
    if(!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    [_orders addObjectsFromArray:orders];
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
    return [_orders count];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_orders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    NSInteger position = indexPath.row;
    CGFloat width = CGRectGetWidth(tableView.frame);
    WorkOrderDispach * job = _orders[position];
    itemHeight = (NSInteger)[WorkOrderDispachItemView calculateHeightByContent:job.woDescription andLocation:job.location pfmCode:job.pfmCode andWidth:width];
        
    return itemHeight + _seperatorHeight + _showMoreHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
//    SeperatorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ShowMoreDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    WorkOrderDispachItemView * itemView = nil;
    SeperatorView * seperator = nil;
    WorkOrderDispach * job = _orders[position];
//    CGFloat paddingLeft = 0;
    CGFloat paddingLeft = [FMSize getInstance].listePadding;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = [WorkOrderDispachItemView calculateHeightByContent:job.woDescription andLocation:job.location pfmCode:job.pfmCode andWidth:width];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    if (!cell) {
        cell = [[ShowMoreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeperatorHeight:_seperatorHeight andShowMoreHeight:_showMoreHeight];
    } else {
        NSArray * subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[WorkOrderDispachItemView class]]) {
                itemView = view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if (cell && !itemView) {
        itemView = [[WorkOrderDispachItemView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if (seperator) {
        [seperator setFrame:CGRectMake(paddingLeft, itemHeight - seperatorHeight, width - paddingLeft*2, seperatorHeight)];
    }
    if (itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        [itemView setInfoWithWorkJobDetail:job];
    }
    
    return cell;
}

#pragma mark - 点击事件发送
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self notifyShowOrderDetail:position];
}

- (void) notifyShowOrderDetail:(NSInteger) position {
    WorkOrderDispach * workJob = _orders[position];
    [self notifyEvent:WO_DISPATCH_EVENT_ITEM_CLICK data:workJob];
}

- (void) notifyEvent:(OrderDispatchEventType) type data:(id) data {

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

