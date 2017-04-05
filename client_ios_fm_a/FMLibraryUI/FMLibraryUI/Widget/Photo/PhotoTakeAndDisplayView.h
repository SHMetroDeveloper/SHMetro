//
//  PhotoTakeAndDisplayView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/18.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "OnItemClickListener.h"


@protocol OnPhotoItemClickListener;

@interface PhotoTakeAndDisplayView : UIView <iCarouselDataSource, iCarouselDelegate>

- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setEditable:(BOOL) editable;

//////设置需要展示的图片
//- (void) setInfoWithPhotos:(NSMutableArray *) photos;

//设置要展示的图片的路径
- (void) setInfoWithPhotoPathArray:(NSMutableArray *) pathArray;

//获取当前图片
- (NSMutableArray *) getPhotos;

//更新焦点
- (void) update;

//设置对齐方式
- (void) setPaddingLeft:(CGFloat)paddingLeft paddingRight:(CGFloat) paddingRight paddingTop:(CGFloat) paddingTop paddingBottom:(CGFloat) paddingBottom;

- (void) setOnPhotoItemClickListener:(id<OnPhotoItemClickListener>) listener;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end


@protocol OnPhotoItemClickListener <NSObject>

- (void) onPhotoItemClick:(UIView *)view position:(NSInteger)position;

@end
