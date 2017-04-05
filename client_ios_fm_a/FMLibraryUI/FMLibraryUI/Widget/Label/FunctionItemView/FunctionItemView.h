//
//  ProjectItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionItemView : UIButton

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithLogo:(UIImage*)logo name:(NSString*) name status:(NSInteger) status;

- (void) updateStatus:(NSInteger) status;

@end
