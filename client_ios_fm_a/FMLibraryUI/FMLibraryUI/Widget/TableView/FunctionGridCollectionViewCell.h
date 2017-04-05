//
//  BaseCollectionViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 2/10/17.
//  Copyright © 2017 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionItemGridView.h"

@interface FunctionGridCollectionViewCell : UICollectionViewCell

@property (readwrite, nonatomic, strong) FunctionItemGridView * functionView;

- (instancetype) init;

@end
