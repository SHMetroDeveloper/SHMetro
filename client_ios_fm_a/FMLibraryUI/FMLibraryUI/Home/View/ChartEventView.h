//
//  ChartEventView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/13.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartEventView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithTime:(NSNumber *) time title:(NSString *) title content:(NSString *) content;

- (void) setShowBound:(BOOL) showBound;

//依据内容以及宽度计算当前 view 所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width;
@end
