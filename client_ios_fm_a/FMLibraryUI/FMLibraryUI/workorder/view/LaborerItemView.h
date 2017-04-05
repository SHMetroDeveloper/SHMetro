//
//  LaborerItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//
//  用于派工， 执行人项

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, LaborerItemActionType) {
    LABORER_ACTION_CLICK,
    LABORER_ACTION_DELETE,
};

@interface LaborerItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString *) name;
- (void) setSelected:(BOOL)selected;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
