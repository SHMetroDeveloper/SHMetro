//
//  AssetWorkOrderTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetWorkOrderTableViewCell : UITableViewCell

- (void)setSeperatorGapped:(BOOL)isGapped;

- (void)setInfoWithCode:(NSString *)code
                   time:(NSNumber *)time
                   desc:(NSString *)desc
                 status:(NSInteger)status;

+ (CGFloat)getItemHeight;

@end
