//
//  BaseBundle.h
//  FMLibraryBase
//
//  Created by 杨帆 on 2/8/17.
//  Copyright © 2017 Facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseBundle : NSObject

+ (instancetype) getInstance;

- (instancetype) initWithName:(NSString *) bundleName;

//获取指定位置的指定字符串
- (NSString *) getStringByKey:(NSString *) key inTable:(NSString *) table;

//静态获取 png 图片资源，用于使用率较高的较小的图片(获取 images 文件夹下的图片)
- (UIImage *) getPngImageByKeyStatic:(NSString *) key;

//静态获取 png 图片资源，用于使用率较低的较大的图片
- (UIImage *) getPngImageByKeyDynamic:(NSString *) key;

@end
