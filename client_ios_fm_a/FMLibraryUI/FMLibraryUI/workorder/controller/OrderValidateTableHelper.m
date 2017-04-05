//
//  OrderValidateTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "OrderValidateTableHelper.h"
#import "WorkJobItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "WorkOrderDetailViewController.h"
#import "NetPage.h"

#import "SeperatorTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"

@interface OrderValidateTableHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * orders;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;
@property (readwrite, nonatomic, weak) BaseViewController * baseVC;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation OrderValidateTableHelper

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

- (WorkOrderUnValidatedEntity *) getOrderByPosition:(NSInteger) position {
    WorkOrderUnValidatedEntity * order = _orders[position];
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
    WorkOrderUnValidatedEntity* job = _orders[position];
    itemHeight = (NSInteger)[WorkJobItemView calculateHeightByDesc:job.woDescription location:job.location pfmCode:job.pfmCode andWidth:width];
    return itemHeight + _seperatorHeight + _showMoreHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    WorkJobItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
//    CGFloat paddingLeft = 0;
    CGFloat paddingLeft = [FMSize getInstance].listePadding;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    WorkOrderUnValidatedEntity* job = _orders[position];
    itemHeight = [WorkJobItemView calculateHeightByDesc:job.woDescription location:job.location pfmCode:job.pfmCode andWidth:width];
//    SeperatorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ShowMoreDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ShowMoreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeperatorHeight:_seperatorHeight andShowMoreHeight:_showMoreHeight];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[WorkJobItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[WorkJobItemView alloc] initWithFrame:CGRectMake(paddingLeft, 0, width, itemHeight)];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [cell addSubview:seperator];
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        
        [itemView setInfoWithCode:job.code pfmCode:job.pfmCode time:[job getCreateDateStr] location:job.location desc:job.woDescription status:job.status laborerStatus:job.currentLaborerStatus priority:job.priorityId];
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
    WorkOrderUnValidatedEntity * workJob = _orders[position];
    [self notifyEvent:WO_VALIDATE_EVENT_ITEM_CLICK data:workJob];
    
}

- (void) notifyEvent:(OrderValidateEventType) type data:(id) data {
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

