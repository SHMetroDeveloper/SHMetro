//
//  ProjectExchangeView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectExchangeView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString *) name;

+ (CGFloat) calculateWidthBy:(NSString *) name;
@end
