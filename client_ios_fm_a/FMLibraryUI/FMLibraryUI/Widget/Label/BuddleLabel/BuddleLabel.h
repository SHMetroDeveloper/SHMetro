//
//  BuddleLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

//  气泡效果的标签，包含 title 和 content

#import <UIKit/UIKit.h>

@interface BuddleLabel : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithTitle:(NSString *) title content:(NSString *) content;

+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width;

@end
