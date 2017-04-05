//
//  HorizontalDisplayView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface HorizontalDisplayView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithImageArray:(NSMutableArray *) imgs;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
