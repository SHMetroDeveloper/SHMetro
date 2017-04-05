//
//  PatrolHistoryDetailSpotItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/13.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolHistoryDetailSpotItemView : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithSpotName:(NSString *) spotName
               andShowIgnore:(BOOL) showIgnore
            andShowException:(BOOL) showException
               andShowReport:(BOOL) showReport;

- (void) setExpandState:(BOOL) isExpand;

@end
