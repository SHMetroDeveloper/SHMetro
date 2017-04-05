//
//  OrderMyReportTableHelper.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/18.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "OrderMyReportTableHelper.h"
#import "MyReportItemCellView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "NetPage.h"
#import "WorkOrderDetailViewController.h"
#import "BaseDataDbHelper.h"

#import "SeperatorTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"

@interface OrderMyReportTableHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * orders;

@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;

@property (readwrite, nonatomic, weak) BaseViewController * baseVC;
@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation OrderMyReportTableHelper

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

- (MyReportHistory *)getOrderByPosition:(NSInteger)position {
    MyReportHistory * order = _orders[position];
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
    MyReportHistory * job = _orders[position];
    itemHeight = (NSInteger)[MyReportItemCellView calculateHeightByDesc:job.woDescription andwidth:tableView.frame.size.width];
    return itemHeight + _seperatorHeight + _showMoreHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    CGFloat itemHeight = 0;
    
    static NSString *cellIdentifier = @"Cell";
    MyReportItemCellView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    MyReportHistory * job = _orders[position];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat padding = [FMSize getInstance].listePadding;
    itemHeight = [MyReportItemCellView calculateHeightByDesc:job.woDescription andwidth:width];
//    SeperatorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ShowMoreDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ShowMoreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeperatorHeight:_seperatorHeight andShowMoreHeight:_showMoreHeight];
    } else {
        NSArray *subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[MyReportItemCellView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if (cell && !itemView) {
        itemView = [[MyReportItemCellView alloc] init];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, width-padding
                                       *2, seperatorHeight)];
    }
    if (itemView) {
        
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        Priority * priority = [[BaseDataDbHelper getInstance] queryPriorityById:job.priorityId];
        NSString * strPriority;
        if(priority) {
            strPriority = priority.name;
        }
        [itemView setInfoWithCode:job.code time:[job getCreateTimeStr] serviceType:job.serviceTypeName desc:job.woDescription status:job.status priority:strPriority];
        itemView.tag = position;
    }
    return cell;
}

#pragma mark 点击事件发送
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self notifyShowOrderDetail:position];
}

- (void) notifyShowOrderDetail:(NSInteger) position {
    MyReportHistory * workJob = _orders[position];
    [self notifyEvent:WO_MYREPORT_EVENT_ITEM_CLICK data:workJob];
}

- (void) notifyEvent:(OrderMyReportEventType) type data:(id) data {
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
