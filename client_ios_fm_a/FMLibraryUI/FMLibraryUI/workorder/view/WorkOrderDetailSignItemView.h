//
//  WorkOrderDetailSignItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/3/13.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderDetailSignItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithType:(NSString *) type image:(UIImage *) signImg ;

- (void) setPaddingLeft:(CGFloat) paddingLeft paddingRight:(CGFloat) paddingRight;
//
- (void) setInfoWithType:(NSString *) type imageUrl:(NSURL *) signImgUrl;
@end
