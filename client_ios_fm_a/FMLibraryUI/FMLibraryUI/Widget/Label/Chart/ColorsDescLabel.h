//
//  ColorsDescLabel.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/10/15.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ColorDescLayoutType) {
    COLOR_DESC_LAYOUT_HORIZONTAL,   //横着布局
    COLOR_DESC_LAYOUT_VERTICAL     //竖着布局
};

@interface ColorsDescLabel : UIScrollView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setColors:(NSMutableArray *) colorArray desc:(NSMutableArray *) descArray;
- (void) setPaddingTop:(CGFloat)paddingTop;

//设置布局类型
- (void) setLayoutType:(ColorDescLayoutType)layoutType;
@end