//
//  BaseCountView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/12.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCountView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithName:(NSString *) name count1:(NSInteger) count1 count2:(NSInteger) count2;
- (void) setDescForCountFirst:(NSString *) fistCountName second:(NSString *) secondCountName;
- (void) setNameColor:(UIColor *) color;
- (void) showBorder:(BOOL) show;
@end
