//
//  BaseGroupView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ResizeableView.h"

typedef NS_ENUM(NSInteger, BaseGroupViewBoundsType) {
    BOUNDS_TYPE_UNKNOW,
    BOUNDS_TYPE_NONE,           //无边框
    BOUNDS_TYPE_RECT,           //直角
    BOUNDS_TYPE_CIRCLE          //圆角
};


@interface BaseGroupView : UIView

- (instancetype) initWithFrame:(CGRect) frame;


- (void) setMembers:(NSMutableArray *) viewsArray;
- (void) addMember:(UIView *) view;
- (void) setBoundsType:(BaseGroupViewBoundsType) boundsType;
- (void) setItemHeight:(CGFloat) itemHeight;

//设置是否显示分割线
- (void) setShowSeperator:(BOOL) show;

@end
