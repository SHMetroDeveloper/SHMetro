//
//  MyReportItemCellView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 15/11/10.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface MyReportItemCellView : UIView

-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)setFrame:(CGRect)frame;

- (void) setInfoWithCode:(NSString *)code
                    time:(NSString *)time
             serviceType:(NSString *)serviceType
                    desc:(NSString *)desc
                  status:(NSInteger)status
                priority:(NSString *) priority;

- (void) setOnItemClickListener:(id<OnItemClickListener>)listener;
//计算所需高度
+ (CGFloat) calculateHeightByDesc:(NSString *) desc andwidth:(CGFloat) width;

@end
