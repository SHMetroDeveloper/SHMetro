//
//  LoopTypeTwoCell.m
//  Animations
//
//  Created by YouXianMing on 16/5/6.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "LoopViewCell.h"
#import "UIView+SetRect.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "InfiniteLoopModel.h"
#import "UIFont+Fonts.h"
#import "FMUtilsPackages.h"

@interface LoopViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UILabel     *label;

@end

@implementation LoopViewCell

- (void)setupCollectionViewCell {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
}

- (void)buildSubView {
    
    self.imageView                     = [[UIImageView alloc] init];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode         = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    
//    self.label           = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
//    self.label.font      = [UIFont fontWithName:@"GillSans-Italic" size:12.f];
//    self.label.textColor = [UIColor redColor];
//    [self addSubview:self.label];
}

- (void)loadContent {
    
    InfiniteLoopModel *model = (id)self.dataModel;
//    self.label.text          = model.title;
//    [self.label sizeToFit];
//    [self.label setFrame:CGRectMake(0, 10, self.frame.size.width - 20, self.label.frame.size.height)];
    
    CGFloat width        = self.frame.size.width;
    CGFloat height       = self.frame.size.height;
    self.imageView.frame = CGRectMake(0, 0, width, height);
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[model imageUrlString]] placeholderImage:[[FMTheme getInstance] getImageByName:@"ad04"]];
    
//    if (![FMUtils isStringEmpty:[model imageUrlString]]) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model imageUrlString]] placeholderImage:[[FMTheme getInstance] getImageByName:@"ad03"]];
//    } else {
//        self.imageView.alpha = 0.f;
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:[model imageUrlString]]
//                          placeholderImage:[[FMTheme getInstance] getImageByName:@"ad03"]
//                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                     
//                                     [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1.f initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                                         
//                                         self.imageView.alpha = 1.f;
//                                         self.imageView.image = image;
//                                         
//                                     } completion:nil];
//                                 }];
//    }
}

- (void)willDisplay {

//    self.label.alpha = 0.f;
//    [UIView animateWithDuration:1.f delay:0.5f options:0 animations:^{
//        
//        self.label.x     = 10;
//        self.label.alpha = 1;
//        
//    } completion:nil];
}

- (void)didEndDisplay {

//    [self.label.layer removeAllAnimations];
//    self.label.x = 0;
//    self.label.y = 10;
}

@end
