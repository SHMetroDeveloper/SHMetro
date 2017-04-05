//
//  OrderHistoryTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "OrderHistoryTableHelper.h"
#import "WorkJobHistoryItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "WorkOrderDetailViewController.h"
#import "NetPage.h"

#import "SeperatorTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"

@interface OrderHistoryTableHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * orders;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;
@property (readwrite, nonatomic, weak) BaseViewController * baseVC;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation OrderHistoryTableHelper

- (instancetype) initWithContext:(BaseViewController *) context {
    self = [super init];
    if(self) {
        _orders = [[NSMutableArray alloc] init];
        _seperatorHeight = 15;
        _showMoreHeight = 50;
        _baseVC = context;
        _page = [[NetPage alloc] init];
    }
    return self;
}

- (WorkOrderHistory *) getOrderByPosition:(NSInteger) position {
    WorkOrderHistory * order = _orders[position];
    return order;
}

- (void) setDataWithArray:(NSMutableArray *) orders {
    _orders = orders;
    
}

- (void) removeAllOrders {
    if(_orders) {
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

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_orders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight;
    NSInteger position = indexPath.row;
    CGFloat width = CGRectGetWidth(tableView.frame);
    WorkOrderHistory* job = _orders[position];
    itemHeight = (NSInteger)[WorkJobHistoryItemView calculateHeightByDescription:job.woDescription pfmCode:job.pfmCode andWidth:width];
//    return itemHeight + _seperatorHeight + _showMoreHeight;
    
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    WorkJobHistoryItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    CGFloat paddingLeft = [FMSize getInstance].listePadding;
//    CGFloat paddingLeft = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    WorkOrderHistory * job;
    if(position >= 0 && position < [_orders count]) {
        job = _orders[position];
        itemHeight = [WorkJobHistoryItemView calculateHeightByDescription:job.woDescription pfmCode:job.pfmCode andWidth:width];
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[WorkJobHistoryItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[WorkJobHistoryItemView alloc] init];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        if (!(position == [_orders count])) {
            [cell addSubview:seperator];
        }
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        [itemView setInfoWithOrder:job];
        itemView.tag = position;
    }
    return cell;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self notifyShowOrderDetail:position];
}

- (void) notifyShowOrderDetail:(NSInteger) position {
    WorkOrderHistory * workJob = _orders[position];
    [self notifyEvent:WO_HISTORY_EVENT_ITEM_CLICK data:workJob];
    
}

- (void) notifyEvent:(OrderHistoryEventType) type data:(id) data {
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

