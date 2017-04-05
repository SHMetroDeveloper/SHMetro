//
//  ContractProfileCollectionViewCell.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractProfileCollectionViewCell : UICollectionViewCell

- (void)setTitleWith:(NSString *)title;

- (void)setContentWith:(NSString *)content;

+ (CGFloat)getItemHeight;

@end
