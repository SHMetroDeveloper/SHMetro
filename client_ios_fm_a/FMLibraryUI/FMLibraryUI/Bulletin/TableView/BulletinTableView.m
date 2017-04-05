//
//  BulletinTableView.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinTableView.h"
#import "BulletinTableViewCell.h"
#import "FMUtilsPackages.h"

@interface BulletinTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BulletinTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _dataArray = [NSMutableArray new];
        _page = [[NetPage alloc] init];
        _dataType = BULLETIN_DATA_TYPE_UNREAD;
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delaysContentTouches = NO;
        
        self.mj_header = [FMRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(RefreshTableView)];
        self.mj_footer = [FMLoadMoreFooterView footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreToTableView)];
        self.mj_footer.automaticallyChangeAlpha = YES;
    }
    return self;
}

#pragma mark setter
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count = _dataArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [BulletinTableViewCell getHeightOfCell];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    BulletinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BulletinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell && [cell isKindOfClass:[BulletinTableViewCell class]]) {
        BulletinTableViewCell *consumerCell = (BulletinTableViewCell *)cell;
        BulletinHistory *historyDetail = _dataArray[indexPath.row];
        if (_dataType == BULLETIN_DATA_TYPE_UNREAD) {
//            [consumerCell setIsShowAnnotion:YES];  
            [consumerCell setIsShowAnnotion:NO];  //此处标记为NO是因为测试说不需要显示小红点提示
        } else {
            [consumerCell setIsShowAnnotion:NO];
        }
        [consumerCell setIsTop:historyDetail.top];
        [consumerCell setType:historyDetail.type];
        [consumerCell setThemeImageId:historyDetail.imageId];
        [consumerCell setTitle:historyDetail.title];
        [consumerCell setTime:historyDetail.time];
        [consumerCell setCreator:historyDetail.creator];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BulletinHistory *historyDetail = _dataArray[indexPath.row];
    _actionBlock(historyDetail);
}

- (void) RefreshTableView {
    _refreshBlock(BULLETIN_HISTORY_REFRESH);
}

- (void) LoadMoreToTableView {
    _refreshBlock(BULLETIN_HISTORY_LOADMORE);
}

@end
