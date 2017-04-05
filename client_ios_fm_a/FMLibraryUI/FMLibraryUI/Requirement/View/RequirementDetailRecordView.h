//
//  RequirementDetailRecordView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/26.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequirementDetailRecordView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

//设置信息
- (void) setInfoWithTitle:(NSString *) title
                  content:(NSString *) content
                     type:(NSInteger) recordType
                     time:(NSNumber *) time;

//设置是否显示 起始时间线
- (void) setShowTopTimeLine:(BOOL) showTopTimeLine;

//依据内容和宽度计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width;

@end
