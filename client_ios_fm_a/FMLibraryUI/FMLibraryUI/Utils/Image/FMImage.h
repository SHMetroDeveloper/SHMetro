//
//  FMImage.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMImageItem : NSObject

- (instancetype) initWith:(NSString*) name left:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom;

- (UIImage*) getImage;

@end

@interface FMImage : NSObject

@property (readwrite, nonatomic, strong) FMImageItem* textFieldBackgroundImg;


@property (readwrite, nonatomic, strong) FMImageItem* bubbleImgDefault;
@property (readwrite, nonatomic, strong) FMImageItem* bubbleImgDotted;

- (instancetype) init;
+ (instancetype) getInstance;


@end

