//
//  PatrolSpotListViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 8/10/16.
//  Copyright © 2016 facilityone. All rights reserved.
//
//  用于在首页扫描时展示同一个点位下的任务列表

#import "BaseViewController.h"

@interface PatrolSpotListViewController : BaseViewController

- (instancetype) init;
- (void) setInfoWithCode:(NSString *) spotCode;


/**
 设置点位 ID

 @param spotId 点位 ID
 */
- (void) setInfoWithSpotId:(NSNumber *)spotId spotName:(NSString *)spotName;


/**
 设置站点 ID

 @param buildingId 站点 ID
 */
- (void) setInfoWithBuildingId:(NSNumber *)buildingId buildingName:(NSString *)buildingName;

@end
