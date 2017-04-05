//
//  QuickReportDescTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickReportDescTableViewCell : UITableViewCell

- (void)setTextPlaceHolder:(NSString *)placeHolder;

//设置最大字数限制
- (void)setMaxTextLength:(NSInteger) maxlength;

- (void)setContent:(NSString *)content;

- (NSString *)getContent;

+ (CGFloat) getItemHeight;

@end
