//
//  OnItemClickListener.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/6/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnItemClickListener <NSObject>

- (void) onItemClick:(UIView *) view subView:(UIView *) subView;

@end
