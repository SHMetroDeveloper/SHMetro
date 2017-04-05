//
//  PatrolHistoryQuestionAlertContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatrolTaskEntity.h"

@interface PatrolHistoryQuestionAlertContentView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWith:(PatrolTaskItemDetail*) item;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;
- (void) setFont:(UIFont*) font;
@end
