//
//  CameraHelper.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/9.
//  Copyright © 2016年 flynn. All rights reserved.
//
//


#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"
#import "PhotoItem.h"

@interface CameraHelper : NSObject

//  用于拍照，需要在 viewdidload 中初始化，原因在于view 的添加顺序影响展示效果
- (instancetype) initWithContext:(UIViewController *) context andMultiSelectAble:(BOOL ) isMultiSelectAble;

//只有在单选模式下才能裁剪 isMultiSelectAble = No;
- (void) setAllowCrop:(BOOL)allowCrop;

//选择图片或者拍照,添加水印， mark 可以为 UIImage 或者 NSString
- (void) getPhotoWithWaterMark:(id) mark;

//拍照,添加水印， mark 可以为 UIImage 或者 NSString
- (void) takePhotoWithWaterMark:(id) mark;

//选择图片,添加水印， mark 可以为 UIImage 或者 NSString
- (void) pickImageWithWaterMark:(id) mark;

//用于照片名字回传
- (void) setOnMessageHandleListener:(id) handler;

@end
