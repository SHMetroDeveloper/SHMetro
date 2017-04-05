//
//  AssetManageHelper.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, AssetManageEventType){
    ASSET_MANAGE_SHOW_DETAIL,   //显示设备详情
    ASSET_MANAGE_SHOW_MORE,     //显示更多设备列表
    ASSET_MANAGE_DID_SCROLL,    //拖动滑动
};


@interface AssetManageTableHelper : NSObject <UITableViewDelegate,UITableViewDataSource>

- (instancetype) initWithContext:(BaseViewController *) context;

- (void) addEquipmentWithArray:(NSMutableArray *) array;

//设置资产概况
- (void) setInfoWithAmount:(NSInteger) amount system:(NSInteger) systemCount maintain:(NSInteger) maintainCount;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

@end
