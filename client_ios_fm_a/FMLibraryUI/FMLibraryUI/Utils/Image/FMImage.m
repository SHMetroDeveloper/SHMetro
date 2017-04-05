//
//  FMImage.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "FMImage.h"

static FMImage *  instance = nil;

@interface FMImage ()

@end

@implementation FMImage

- (instancetype) init {
    self = [super init];
    if(self) {
        //
        self.textFieldBackgroundImg = [[FMImageItem alloc] initWith:@"background.png" left:10 top:2 right:10 bottom:8];
    
        
        _bubbleImgDefault = [[FMImageItem alloc] initWith:@"bubble" left:21 top:14 right:64 bottom:49];
//        _bubbleImgDotted = [[FMImageItem alloc] initWith:@"buddle1" left:19 top:44 right:100 bottom:9];
        _bubbleImgDotted = [[FMImageItem alloc] initWith:@"buddle1" left:10 top:22 right:50 bottom:4];

    }
    return self;
}

+ (instancetype) getInstance {
    if(!instance) {
        instance = [[FMImage alloc] init];
    }
    return instance;
}

@end

@interface FMImageItem ()

@property (readwrite, nonatomic, strong) NSString* name;
@property (readwrite, nonatomic, assign) UIEdgeInsets insets;
@property (readwrite, nonatomic, strong) UIImage* image;

@end

@implementation FMImageItem

- (instancetype) initWith:(NSString*) name left:(CGFloat) left top:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom {
    self = [super init];
    if(self) {
        self.name = name;
        self.insets = UIEdgeInsetsMake(top, left, bottom, right);
    }
    return self;
}

- (UIImage*) getImage {
    if(!self.image) {
        self.image = [UIImage imageNamed:self.name];
        self.image = [self.image resizableImageWithCapInsets:self.insets resizingMode:UIImageResizingModeStretch];
    }
    return self.image;
}

@end