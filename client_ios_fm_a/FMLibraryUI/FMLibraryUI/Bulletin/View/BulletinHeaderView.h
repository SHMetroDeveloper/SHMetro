//
//  BulletinHeaderView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BulletinHeaderType) {
    BULLETIN_HEADER_TYPE_READ_YES,
    BULLETIN_HEADER_TYPE_READ_NO
};

typedef void(^BulletinHeaderActionBlock)(BulletinHeaderType headerType);

@interface BulletinHeaderView : UIView

@property (nonatomic, copy) BulletinHeaderActionBlock __nullable actionBlock;

@property (nonatomic, strong) NSString * __nonnull leftButtonTitle;

@property (nonatomic, strong) NSString * __nonnull rightButtonTitle;

+ (CGFloat) getHeaderHeight;

@end
