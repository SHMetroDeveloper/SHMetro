//
//  UITabBar+badge.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/19.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "UITabBar+badge.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"

#define TabbarItemNums 3.0    //tabbar的数量 如果是5个设置为5.0

#define BADGE_VIEW_TAG_BASE 888

@implementation UITabBar (badge)

//显示badge
- (void)showBadgeOnItemIndex:(NSInteger)index desc:(NSString *)desc{
    //移除之前的badge
    [self removeBadgeOnItemIndex:index];
    
    //
    if(![FMUtils isStringEmpty:desc]) {
        UILabel *badgeView = [[UILabel alloc]init];
        badgeView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        badgeView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_DARK];
        badgeView.clipsToBounds = YES;
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.tag = BADGE_VIEW_TAG_BASE +index;
        badgeView.font = [FMFont fontWithSize:10];
        
        CGFloat itemHeight = 18;
        CGFloat itemWidth = [FMUtils widthForString:badgeView value:desc] + 8;
        if(itemWidth < itemHeight) {
            itemWidth = itemHeight;
        }
        CGRect tabFrame = self.frame;
        
        //确定 位置
        CGFloat offset = 4; //badge 相对中心点的位置偏移
        float percentX = (index +0.5) / TabbarItemNums;
        CGFloat x = ceilf(percentX * tabFrame.size.width) + offset;
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, itemWidth, itemHeight);//
        
        badgeView.layer.cornerRadius = itemHeight/2;
        
        [badgeView setText:desc];
        [self addSubview:badgeView];
    }
}

//隐藏badge
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除badge
    [self removeBadgeOnItemIndex:index];
}

//移除badge
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == BADGE_VIEW_TAG_BASE+index) {
            [subView removeFromSuperview];
        }
    }
}
@end
