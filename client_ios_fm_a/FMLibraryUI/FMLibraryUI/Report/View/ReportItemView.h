//
//  ReportItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportItemView : UIView
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setInfoWithServiceType:(NSString*) serviceType
                        content:(NSString*) content
                       location:(NSString*) location
                         status:(NSInteger) status;
@end
