//
//  FilterSelectView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSelectView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setTitleInfoWith:(NSString *) name;

- (void) setChecked:(BOOL) checked;

+ (CGFloat) calculateHeightByTitle:(NSString *) titleStr andWidth:(CGFloat) width;

@end
