//
//  GpsAddTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/20.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "FMLoadMoreFooterView.h"

typedef void(^LoadMoreBlock)();

@interface GpsAddTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

- (void) setDataArray:(NSMutableArray *)dataArray;

- (void) addDataArray:(NSMutableArray *)dataArray;

- (NSMutableArray *) getSelectedLocation;

@property (nonatomic, copy) LoadMoreBlock loadMoreBlock;

@end
