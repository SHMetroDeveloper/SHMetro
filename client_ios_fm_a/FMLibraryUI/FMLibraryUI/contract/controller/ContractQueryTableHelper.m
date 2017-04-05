//
//  ContractQueryTableHelper.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 11/8/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "ContractQueryTableHelper.h"
#import "ContractQueryItemView.h"
#import "SeperatorView.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "NetPage.h"

#import "SeperatorTableViewCell.h"
#import "ShowMoreDetailTableViewCell.h"

@interface ContractQueryTableHelper ()
@property (readwrite, nonatomic, strong) NetPage * page;
@property (readwrite, nonatomic, strong) NSMutableArray * array;
@property (readwrite, nonatomic, assign) CGFloat seperatorHeight;
@property (readwrite, nonatomic, assign) CGFloat showMoreHeight;
@property (readwrite, nonatomic, assign) CGFloat itemHeight;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation ContractQueryTableHelper

- (instancetype) init {
    self = [super init];
    if(self) {
        _array = [[NSMutableArray alloc] init];
        _seperatorHeight = 15;
        _showMoreHeight = 50;
        _itemHeight = [ContractQueryItemView getItemHeight];
        _page = [[NetPage alloc] init];
    }
    return self;
}

- (ContractEntity *) getContractByPosition:(NSInteger) position {
    ContractEntity * entity = _array[position];
    return entity;
}

- (void) setDataWithArray:(NSMutableArray *) array {
    _array = array;
}

- (void) removeAllContracts {
    if(_array) {
        [_array removeAllObjects];
    }
    [_page reset];
}

- (void) addContractsWithArray:(NSMutableArray *) array {
    if(!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    [_array addObjectsFromArray:array];
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

- (NSInteger) getContractCount {
    return [_array count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = _itemHeight;
    return itemHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"Cell";
    ContractQueryItemView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat width = CGRectGetWidth(tableView.frame);
    CGFloat itemHeight = 0;
    CGFloat paddingLeft = [FMSize getInstance].listePadding;
    //    CGFloat paddingLeft = 0;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    ContractEntity * entity;
    if(position >= 0 && position < [_array count]) {
        entity = _array[position];
        itemHeight = _itemHeight;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        NSArray * subViews = [cell subviews];
        for(id view in subViews) {
            if([view isKindOfClass:[ContractQueryItemView class]]) {
                itemView = view;
            } else if([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if(cell && !itemView) {
        itemView = [[ContractQueryItemView alloc] init];
        [cell addSubview:itemView];
    }
    if(cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        if (!(position == [_array count])) {
            [cell addSubview:seperator];
        }
    }
    if(seperator) {
        [seperator setFrame:CGRectMake(paddingLeft, itemHeight-seperatorHeight, width-paddingLeft*2, seperatorHeight)];
    }
    if(itemView) {
        [itemView setFrame:CGRectMake(0, 0, width, itemHeight)];
        [itemView setInfoWithContract:entity];
        itemView.tag = position;
    }
    return cell;
}

#pragma mark 点击事件发送
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger position = indexPath.row;
    [self notifyShowContractDetail:position];
}

- (void) notifyShowContractDetail:(NSInteger) position {
    ContractEntity * contract = _array[position];
    [self notifyEvent:CONTRACT_QUERY_EVENT_ITEM_CLICK data:contract];
    
}

- (void) notifyEvent:(ContractQueryEventType) type data:(id) data {
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
