//
//  InsetsLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/11.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;


- (void) setPaddingTop:(CGFloat) paddingTop paddingLeft:(CGFloat) paddingLeft;
@end