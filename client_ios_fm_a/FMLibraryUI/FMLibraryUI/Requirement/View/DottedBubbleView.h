//
//  DottedBubbleView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/1/21.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DottedBubbleView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置标题和内容
- (void) setInfoWithTitle:(NSString *) title content:(NSString *) content;

//获取基准点的高度
- (CGFloat) getControlPointHeight;

//通过内容以及宽度计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content width:(CGFloat) width;
@end
