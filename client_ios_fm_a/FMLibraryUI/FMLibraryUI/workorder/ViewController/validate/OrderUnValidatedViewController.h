//
//  OrderUnValidatedViewController.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/8.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "ResizeableView.h"
#import "OnItemClickListener.h"

@interface OrderUnValidatedViewController : BaseViewController <PullTableViewDelegate>
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
@end

