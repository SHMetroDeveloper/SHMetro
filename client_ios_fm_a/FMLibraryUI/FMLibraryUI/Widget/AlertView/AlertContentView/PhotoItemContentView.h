//
//  PhotoItemContentView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//
// 展示多个带图片和文字的按钮

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "PhotoItemModel.h"

@interface PhotoItemContentView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (PhotoItemModel *) getModelByTag:(NSInteger) tag;

- (void) setInfoWith:(NSMutableArray *) array;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) getContentHeightByModelCount:(NSInteger)count;

@end
