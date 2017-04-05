//
//  ImageScrollView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setImages:(NSMutableArray *) images;
- (void) addImage:(UIImage *) image;
- (void) clearAllImage;

//开始滚动
- (void) start;
//停止滚动
- (void) stop;

@end
