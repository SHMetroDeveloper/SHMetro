//
//  WorkOrderHistoryRecordViewController.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderHistoryRecordViewController.h"
#import "WorkOrderDetailHistoryRecordView.h"
#import "OnMessageHandleListener.h"
#import "SeperatorView.h"
#import "WorkOrderDetailEntity.h"
#import "PhotoShowHelper.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"

@interface WorkOrderHistoryRecordViewController () <UITableViewDelegate,UITableViewDataSource,OnMessageHandleListener>

@property (readwrite, nonatomic, strong) UITableView * tableView;

@property (readwrite, nonatomic, strong) PhotoShowHelper * photoHelper;
@property (readwrite, nonatomic, strong) NSMutableArray * historyArray;

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@end

@implementation WorkOrderHistoryRecordViewController

- (void)initNavigation {
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"order_step" inTable:nil]];
    [self setBackAble:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initLayout {
    CGRect frame = [self getContentFrame];
    _realWidth = CGRectGetWidth(frame);
    _realHeight = CGRectGetHeight(frame);
    
    _photoHelper = [[PhotoShowHelper alloc] initWithContext:self];
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
}

- (void) setHistoryData:(NSMutableArray *) histories {
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    _historyArray = histories;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_historyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSInteger position = indexPath.row;
    WorkOrderHistoryItem * hitem = _historyArray[position];
    height = [WorkOrderDetailHistoryRecordView calculateHeightByInfo:hitem.content photoCount:[hitem.pictures count] andWidth:tableView.frame.size.width];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    static NSString * cellIdentifier = @"Cell";
    
    WorkOrderDetailHistoryRecordView * itemView = nil;
    SeperatorView * seperator = nil;
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    WorkOrderHistoryItem * hitem = _historyArray[position];
    CGFloat itemHeight = itemHeight = [WorkOrderDetailHistoryRecordView calculateHeightByInfo:hitem.content photoCount:[hitem.pictures count] andWidth:tableView.frame.size.width];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSArray * subViews = [cell subviews];
        for (id view in subViews) {
            if ([view isKindOfClass:[WorkOrderDetailHistoryRecordView class]]) {
                itemView = view;
            } else if ([view isKindOfClass:[SeperatorView class]]) {
                seperator = (SeperatorView *) view;
            }
        }
    }
    if (cell && !itemView) {
        itemView = [[WorkOrderDetailHistoryRecordView alloc] initWithFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
        [itemView setOnMessageHandleListener:self];
        [cell addSubview:itemView];
    }
    if (cell && !seperator) {
        seperator = [[SeperatorView alloc] init];
        [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
        if (position == [_historyArray count]-1) {
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
        }
        [cell addSubview:seperator];
    }
    if (seperator) {
        [seperator setDotted:YES];
        [seperator setFrame:CGRectMake(padding, itemHeight-seperatorHeight, _realWidth-padding*2, seperatorHeight)];
        if (position == [_historyArray count]-1) {
            [seperator setDotted:NO];
            [seperator setFrame:CGRectMake(0, itemHeight-seperatorHeight, _realWidth, seperatorHeight)];
        }
    }
    if (itemView) {
        [itemView setFrame:CGRectMake(0, 0, _realWidth, itemHeight)];
        
        [itemView setInfoWithIndex:(position + 1) time:hitem.operationDate operater:hitem.handler step:hitem.step content:hitem.content andPhotos:hitem.pictures];
        [itemView setPortraitImageID:hitem.handlerImgId];
//        [itemView setPortraitImage:[UIImage imageNamed:@"camera2.0_on"]];   //设置头像
        itemView.tag = position;
    }

    return cell;
}


-(void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if ([strOrigin isEqualToString:NSStringFromClass([WorkOrderDetailHistoryRecordView class])]) {
            NSNumber * position = [msg valueForKeyPath:@"position"];
            NSMutableArray * photosArray = [msg valueForKeyPath:@"photosArray"];
            [_photoHelper setPhotos:photosArray];
            [_photoHelper showPhotoWithIndex:position.integerValue];
        }
    }
}

@end


