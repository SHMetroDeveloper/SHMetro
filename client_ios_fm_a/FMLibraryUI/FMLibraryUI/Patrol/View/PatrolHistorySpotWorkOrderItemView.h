//
//  PatrolHistorySpotWorkOrderItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolHistorySpotWorkOrderItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithCode:(NSString*) code
                    time:(NSString*) time
                   state:(NSString*) state;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;
- (void) setFont:(UIFont*) font;
@end
