//
//  BulletinReadStateViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BulletinReadStateViewController : BaseViewController


@property (nonatomic, strong) NSNumber *bulletinId;

@property (nonatomic, assign) NSInteger readCount;

@property (nonatomic, assign) NSInteger unreadCount;

@end

NS_ASSUME_NONNULL_END
