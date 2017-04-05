//
//  PatrolHistorySpotDeviceItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/30.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolHistorySpotDeviceItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                    code:(NSString*) code
                  system:(NSString*) system;
- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right;
- (void) setFont:(UIFont*) font;
@end
