//
//  LaborerSelectItemView.h
//  client_ios_shangan
//
//  Created by 杨帆 on 15/11/4.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaborerSelectItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(NSString *) name
               score:(NSInteger) score
          grabStatus:(NSInteger) grabStatus
  estimateArriveTime:(NSNumber *) time
              status:(NSNumber *) status;

- (void) setChecked:(BOOL) checked;
- (void) setShowGrab:(BOOL)showGrab;    //是否显示抢单状态

//根据是否抢单计算所需高度
+ (CGFloat) calculateHeightByInfo:(NSInteger) grabType;

@end
