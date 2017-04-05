//
//  LocationDetailAccuracyTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationDetailAccuracyTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) NSInteger accuracy;

//计算需要的高度
+ (CGFloat) calculateHeight;
@end
