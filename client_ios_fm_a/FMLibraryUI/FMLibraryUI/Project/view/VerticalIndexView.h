//
//  VerticalIndexView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/28.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"


typedef NS_ENUM(NSInteger, VerticalIndexLocationType) {
    VERTICAL_INDEX_LOCATION_TOP,    //顶部
    VERTICAL_INDEX_LOCATION_MIDDLE, //居中
};

@interface VerticalIndexView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setType:(VerticalIndexLocationType) type;

- (void) setKeyWithArray:(NSMutableArray *) keys;

- (void) setItemHeight:(CGFloat) itemHeight;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
