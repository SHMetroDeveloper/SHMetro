//
//  BasePhotoCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "PhotoItem.h"

typedef NS_ENUM(NSInteger, BasePhotoCellType) {
    BASE_PHOTO_CELL_TYPE_IMAGE, //单纯的图片
    BASE_PHOTO_CELL_TYPE_BUTTON,    //按钮，主要是可以添加点击效果
};

@interface BasePhotoCell : UICollectionViewCell

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置显示图片，参数为 UIImage
- (void) setPhoto:(UIImage *) photo;

//设置高亮状态的图片
- (void) setPhotoHighlight:(UIImage *) photo;

//设置显示图片，参数为url
- (void) setPhotoUrl:(NSURL *) url;

//设置图片
- (void) setPhotoItem:(PhotoItem *) item;

//显示文字信息
- (void) setText:(NSString *) text;

//设置是否显示上分割线
- (void) setShowTopLine:(BOOL) show;
//设置是否显示下分割线
- (void) setShowBottomLine:(BOOL) show;
//设置是否显示左分割线
- (void) setShowLeftLine:(BOOL) show;
//设置是否显示右分割线
- (void) setShowRightLine:(BOOL) show;

//设置是否可编辑
- (void) setEditable:(BOOL)editable;

//设置类型
- (void) setCelltype:(BasePhotoCellType)celltype;


//设置左右边距
- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight;

//设置点击事件监听
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
