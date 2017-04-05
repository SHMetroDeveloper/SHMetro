//
//  ReservationListTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 7/15/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ReservationListTableHelper.h"
#import "ReservationItemView.h"
#import "ReservationEntity.h"
#import "ShowMoreDetailTableViewCell.h"

@interface ReservationListTableHelper ()

@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * array;
@property (readwrite, nonatomic, assign) CGFloat defaultItemHeight;
@property (readwrite, nonatomic, assign) CGFloat moreHeight;
@property (readwrite, nonatomic, assign) CGFloat sepHeight;

@property (readwrite, nonatomic, assign) BOOL showMore;
@property (readwrite, nonatomic, assign) BOOL showSeperator;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation ReservationListTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        _array = [NSMutableArray new];
        _defaultItemHeight = [ReservationItemView calculateHeight];
        _moreHeight = 50;
        _sepHeight = 15;
        _page = [[NetPage alloc] init];
    }
    return self;
}

- (void) setDataWithArray:(NSMutableArray *) array {
    _array = array;
}

- (void) removeAllData {
    if(_array) {
        [_array removeAllObjects];
    }
    [_page reset];
}

- (void) addDataWithArray:(NSMutableArray *) orders {
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    [_array addObjectsFromArray:orders];
}

- (id) getDataByPosition:(NSInteger) position {
    id obj;
    if(position >= 0 && position < [_array count]) {
        obj = _array[position];
    }
    return obj;
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

- (NSInteger) getDataCount {
    return [_array count];
}

- (void) setShowMore:(BOOL) showMore showSeperator:(BOOL) showSeperator {
    _showMore = showMore;
    _showSeperator = showSeperator;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [_array count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat seperatorHeight = _sepHeight;
    CGFloat moreHeight = _moreHeight;
    
    if(!_showMore) {
        moreHeight = 0;
    }
    if(!_showSeperator) {
        seperatorHeight = 0;
    }
    CGFloat itemHeight = _defaultItemHeight + moreHeight + seperatorHeight;
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    ReservationItemView * itemView = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    ShowMoreDetailTableViewCell * cell;
    
    CGFloat seperatorHeight = _sepHeight;
    CGFloat moreHeight = _moreHeight;
    
    if(!_showMore) {
        moreHeight = 0;
    }
    if(!_showSeperator) {
        seperatorHeight = 0;
    }
    

    itemHeight = _defaultItemHeight;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ShowMoreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[ReservationItemView class]]) {
                itemView = view;
                break;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[ReservationItemView alloc] init];
        [cell addSubview:itemView];
    }
    if(itemView) {
        if(position == [_array count] - 1) {
            [itemView setIsLast:YES];
        } else {
            [itemView setIsLast:NO];
        }
        
        ReservationEntity * entity = _array[position];
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        itemView.tag = position;
        [itemView setInfoWith:entity];
        
    }
    
    [cell setSeperatorHeight:seperatorHeight andShowMoreHeight:moreHeight];
    return cell;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    if(position >= 0 && position < [_array count]) {
        [self notifyEvent:INVENTORY_RESERVATION_LIST_EVENT_SHOW_DETAIL data:[NSNumber numberWithInteger:position]];
    }
    
}


- (void) notifyEvent:(InventoryReservationListEventType) type data:(id) data {
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
