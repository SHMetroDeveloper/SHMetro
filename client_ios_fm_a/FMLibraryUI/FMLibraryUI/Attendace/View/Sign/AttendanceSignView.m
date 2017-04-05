//
//  AttendanceSignView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/19.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSignView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "AttendanceSignHeaderView.h"
#import "AttendanceSignPoetryTableViewCell.h"
#import "AttendanceSignInTableViewCell.h"
#import "AttendanceSignButtonTableViewCell.h"
#import "AttendanceSignHistoryEntity.h"


@interface AttendanceSignView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) AttendanceSignHeaderView *headerView;

@property (nonatomic, assign) CGFloat realHeight;
@property (nonatomic, assign) CGFloat realWidth;

@property (nonatomic, strong) NSNumber *queryTime;
@property (nonatomic, assign) NSInteger employeeType;

@property (nonatomic, strong) NSMutableArray *poetryArray;
@property (nonatomic, strong) NSString *poetry;

@end

@implementation AttendanceSignView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _realWidth = CGRectGetWidth(frame);
        _realHeight = CGRectGetHeight(frame);
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.allowsSelection = NO;
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        self.tableHeaderView = self.headerView;
        self.delaysContentTouches = NO;
        
        //鸡汤
        _poetryArray = [NSMutableArray arrayWithObjects:@"现在我所度过的每一天都是余生当中最年轻的一天。", @"一个人也能扛下来的事情就别声张，大家都挺忙的，你说你很累，可谁又过得顺风顺水。", @"你不能把这个世界，让给你所鄙视的人。", @"扼住生命的咽喉，做主宰自己命运的超人。", @"当你只有一个目标的时候，全世界都会给你让路。", @"愿有来路可期 此后如竟没有炬火 我便是唯一的光。", @"一生负气成今日、四海无人对夕阳。", @"命运啊，你若扼住我的咽喉，我就踢你裤裆。", @"总有人要赢，那为什么不能是我呢。", @"成长的速度要快于父母老去的速度", @"如果觉得你的过去很辉煌，那说明你现在做得不够好。", @"最大的痛苦，不是失败，是我本可以。", @"成功是用心做好每一件事之后的水到渠成",  nil];
        NSInteger position = arc4random() % _poetryArray.count; //随机数 [0 , _poetryArray.count)
        _poetry = _poetryArray[position];
        
        _queryTime = [FMUtils getTimeLongNow];  //初始化的时候默认为现在时间
    }
    return self;
}

#pragma mark - Setter
- (void)setQueryTime:(NSNumber *)queryTime {
    _queryTime = queryTime;
    [self.headerView setDateTime:_queryTime];
}

- (void)setEmployeeType:(NSInteger) employeeType {
    _employeeType = employeeType;
}

- (void)setDateArray:(NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray new];
    } else {
        [_dateArray removeAllObjects];
    }
    _dateArray = dateArray;
    [self reloadData];
}

- (void)setSignReachable:(NSMutableDictionary *)signReachable {
    _signReachable = signReachable;
    [self reloadData];
}

#pragma mark - Lazyload
- (AttendanceSignHeaderView *)headerView {
    if (!_headerView) {
        CGFloat headerHeight = [AttendanceSignHeaderView calculateHeight];
        _headerView = [[AttendanceSignHeaderView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, headerHeight)];
        __weak typeof(self) weakSelf = self;
        _headerView.actionBlock = ^() {
            weakSelf.actionBlock(ATTENDANCE_SIGN_ACTION_EVENT_DATE_CHANGE);
        };
    }
    return _headerView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dateArray.count + 1 + 1;  //一个诗歌cell，一个签入签出cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    CGFloat height = 0;
    
    if (position == 0) {
        height = [AttendanceSignPoetryTableViewCell calculateHeightBy:_poetry];
    } else if (position > 0 && position < _dateArray.count + 2 - 1) {
        height = [AttendanceSignInTableViewCell calculateHeight];
    } else if (position == _dateArray.count + 2 - 1) {
        height = [AttendanceSignButtonTableViewCell calculateHeight];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = nil;
    
    if (position == 0) {
        cellIdentifier = @"CellPoetry";  //第一行诗歌
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            AttendanceSignPoetryTableViewCell *consumerCell = [[AttendanceSignPoetryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell = consumerCell;
        }
    } else if (position > 0 && position < _dateArray.count + 2 - 1) {
        cellIdentifier = @"CellSignIn";   //签到record
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            AttendanceSignInTableViewCell *consumerCell = [[AttendanceSignInTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell = consumerCell;
        }
    } else if (position == _dateArray.count + 2 - 1) {
        cellIdentifier = @"CellSignInButton";   //签入、签出按钮
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            AttendanceSignButtonTableViewCell *consumerCell = [[AttendanceSignButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            consumerCell.actionBlock = ^(SignInButtonEventType type){
                if (type == SIGN_BUTTON_EVENT_TYPE_IN) {
                    _actionBlock(ATTENDANCE_SIGN_ACTION_EVENT_SIGN_IN);
                } else if (type == SIGN_BUTTON_EVENT_TYPE_OUT) {
                    _actionBlock(ATTENDANCE_SIGN_ACTION_EVENT_SIGN_OUT);
                }
            };
            cell = consumerCell;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    if (position == 0) {
        AttendanceSignPoetryTableViewCell *consumerCell = (AttendanceSignPoetryTableViewCell *)cell;
        consumerCell.poetry = _poetry;
    } else if (position > 0 && position < _dateArray.count + 2 - 1) {
        AttendanceSignInTableViewCell *consumerCell = (AttendanceSignInTableViewCell *)cell;
        AttendanceSignHistoryDetailEntity *entity = _dateArray[position - 1];
        if (position == 1) {  //如果是记录的第一条则不需要显示上时间线
            consumerCell.isTopTimeLineShow = NO;
        } else {
            consumerCell.isTopTimeLineShow = YES;
        }
        [consumerCell setSignInfoWithTime:entity.time signType:entity.type isSignIn:entity.signin signDesc:entity.name];
    } else if (position == _dateArray.count + 2 - 1) {
        AttendanceSignButtonTableViewCell *consumerCell = (AttendanceSignButtonTableViewCell *)cell;
        AttendanceSignHistoryDetailEntity *entity = [_dateArray lastObject];
        if (_dateArray.count > 0) {
            consumerCell.isTopTimeLineShow = YES;
            if (entity.signin) {
                consumerCell.isSignIn = NO;
            } else {
                consumerCell.isSignIn = YES;
            }
        } else {
            consumerCell.isTopTimeLineShow = NO;
            consumerCell.isSignIn = YES;
        }
        
        NSNumber *reablity = [_signReachable valueForKeyPath:@"reachable"];
        NSString *statusDesc = [_signReachable valueForKeyPath:@"statusDesc"];
        consumerCell.queryTime = _queryTime;
        consumerCell.employeeType = _employeeType;
        consumerCell.editable = reablity.boolValue;   //判断能否签到
        consumerCell.signStatusDesc = statusDesc;
    }
}

@end

