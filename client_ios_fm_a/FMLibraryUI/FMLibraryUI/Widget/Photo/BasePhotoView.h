//
//  BasePhotoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnMessageHandleListener.h"

typedef NS_ENUM(NSInteger, PhotoActionType) {
    PHOTO_ACTION_SHOW_DETAIL,   //显示大图
    PHOTO_ACTION_DELETE,   //删除
    PHOTO_ACTION_TAKE_PHOTO,   //拍照
};

typedef NS_ENUM(NSInteger, PhotoShowType) {
    PHOTO_SHOW_TYPE_ALL_LINES,   //显示所有的图片，多行显示
    PHOTO_SHOW_TYPE_ALL_ONE_LINE,   //显示所有的图片，单行显示，允许滚动
    PHOTO_SHOW_TYPE_SOME_ONE_LINE,   //只显示一行图片（如果允许拍照，包括拍照按钮在内）
};


@interface BasePhotoView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置图片数组
- (void) setPhotosWithArray:(NSMutableArray *) array;

//添加图片
- (void) addPhoto:(UIImage *) img;

//设置是否可编辑
- (void) setEditable:(BOOL) editable;

//设置是否允许拍照
- (void) setEnableAdd:(BOOL)enableAdd;

////设置是否显示全部
//- (void) setShowAll:(BOOL) showAll;

//设置展示方式
- (void) setShowType:(PhotoShowType) type;

//设置是否显示边框
- (void) setShowBound:(BOOL) show;

//设置上下边距
- (void) setPaddingTop:(CGFloat) paddingTop paddingBottom:(CGFloat) paddingBottom;

//
- (void) setOnMessageHandleListener:(id<OnMessageHandleListener>) handler;

//计算图片展示所需要的高度
+ (CGFloat) calculateHeightByCount:(NSInteger) count width:(CGFloat) width addAble:(BOOL)enableAdd showType:(PhotoShowType) type;

@end
