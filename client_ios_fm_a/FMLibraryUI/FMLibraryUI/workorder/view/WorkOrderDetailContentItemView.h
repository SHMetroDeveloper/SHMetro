//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderDetailContentItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithContent:(NSString *) content;

//依据内容计算 view 所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

@end
