//
//  WorkOrderWriteContentItemVIew.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOrderWriteContentItemView : UIView

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight;

- (void) setInfoWithContent:(NSString *) content
                  andPhotos:(NSMutableArray *) photoArray;

@end
