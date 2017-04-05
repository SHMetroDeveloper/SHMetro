//
//  UITabBar+badge.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/19.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(NSInteger)index desc:(NSString *) desc;   //

- (void)hideBadgeOnItemIndex:(NSInteger)index; //隐藏

@end
