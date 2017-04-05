//
//  PhotoItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoItem.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, PhotoItemViewType) {
    PHOTO_ITEM_VIEW_TYPE_UNKNOW, //
    PHOTO_ITEM_VIEW_TYPE_CLICK, //点击
    PHOTO_ITEM_VIEW_TYPE_DELETE //删除
};

@interface PhotoItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setEditable:(BOOL)editable;

- (void) setInfoWithImage:(UIImage *) img;
- (void) setInfoWithPhotoItem:(PhotoItem *) item;
- (void) setInfoWithUrl:(NSURL *) url;
- (void) setInfoWithText:(NSString *) text;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
