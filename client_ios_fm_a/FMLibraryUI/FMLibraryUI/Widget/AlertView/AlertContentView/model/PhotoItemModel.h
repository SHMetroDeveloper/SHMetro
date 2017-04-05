//
//  PhotoItemContentEntity.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoItemModel : NSObject
@property (readwrite, nonatomic, strong) UIImage * img;
@property (readwrite, nonatomic, strong) UIImage * imgHighlight;
@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, assign) NSInteger key;
@end
