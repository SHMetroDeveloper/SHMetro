//
//  FMGridImageView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/3/25.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMGridImageViewDelegate <NSObject>

@optional

- (void) onClick:(NSUInteger) index;
- (void) onLongPress:(NSUInteger) index;
- (void) onDeleteClikc:(NSUInteger) index;

@end

@interface FMGridImageView : UIView

@property (nonatomic, weak) id<FMGridImageViewDelegate> delegate;

//更新图片展示
- (void) updateWithImages:(NSMutableArray *)images;

+ (CGFloat) getHeightBymaxWidth:(CGFloat) maxWidth;

@end

