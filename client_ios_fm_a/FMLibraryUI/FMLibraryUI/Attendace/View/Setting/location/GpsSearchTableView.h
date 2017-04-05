//
//  GpsSearchTableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "FMLoadMoreFooterView.h"
#import "AttendanceSettingEntity.h"

typedef void(^LoadMoreBlock)();
typedef void(^LocationSelectBlock)(AttendanceLocation *location);

@interface GpsSearchTableView : UITableView

- (void) setDataArray:(NSMutableArray *)dataArray;

- (void) addDataArray:(NSMutableArray *)dataArray;

@property (nonatomic, copy) LoadMoreBlock loadMoreBlock;
@property (nonatomic, copy) LocationSelectBlock locationSelectBlock;

@end
