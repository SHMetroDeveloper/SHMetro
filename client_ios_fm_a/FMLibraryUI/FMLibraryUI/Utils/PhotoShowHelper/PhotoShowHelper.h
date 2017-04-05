//
//  PhotoShowHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/9.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PhotoShowHelper : NSObject

- (instancetype) initWithContext:(BaseViewController *) context;

//设置图片数据
- (void) setPhotos:(NSMutableArray *) photos;

//从 index 位置的图片开始展示
- (void) showPhotoWithIndex:(NSInteger) index;
@end
