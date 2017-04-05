//
//  HeaderCollectionReusableView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/22.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setHeaderImage:(UIImage *)headerImage;
@end
