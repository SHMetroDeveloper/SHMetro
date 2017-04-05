//
//  SearchResultDisplayViewController.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/10/21.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OnMessageHandleListener.h"

@interface SearchResultDisplayViewController : BaseViewController

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *searchKeyWord;

- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;
@end
