//
//  BulletinReaderCollectionViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BulletinReaderCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSNumber *imageId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *projectName;

@property (nonatomic, assign) CGFloat paddingLeft;

@property (nonatomic, assign) CGFloat paddingRight;

@end

NS_ASSUME_NONNULL_END
