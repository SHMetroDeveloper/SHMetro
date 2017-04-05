//
//  BulletinDetailViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BulletinTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BulletinDetailViewController : BaseViewController

//公告ID
@property (nonatomic, strong) NSNumber *bulletinId;

//公告状态
@property (nonatomic, assign) BulletinDataType dataType;

@end

NS_ASSUME_NONNULL_END
