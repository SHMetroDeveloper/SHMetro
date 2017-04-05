//
//  AttendanceSignInView.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/18.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceSignInTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isTopTimeLineShow;  //是否显示上时间线

- (void) setSignInfoWithTime:(NSNumber *) time
                    signType:(NSInteger ) type
                      isSignIn:(BOOL ) isSignIn
                    signDesc:(NSString *) desc;

+ (CGFloat) calculateHeight;

@end
