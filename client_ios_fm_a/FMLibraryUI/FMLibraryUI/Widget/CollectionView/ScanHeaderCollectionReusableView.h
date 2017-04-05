//
//  ScanHeaderCollectionReusableView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScanHeaderActionBlock)();

@interface ScanHeaderCollectionReusableView : UICollectionReusableView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

@property (nonatomic, copy) ScanHeaderActionBlock actionBlock;

@end
