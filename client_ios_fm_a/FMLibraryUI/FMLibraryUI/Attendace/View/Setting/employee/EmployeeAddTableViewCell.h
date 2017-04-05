//
//  EmployeeAddTableViewCell.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/26/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

@interface EmployeeAddTableViewCell : UITableViewCell
    
- (void) setEmployeeName:(NSString *) name;
- (void) setChecked:(BOOL) checked;
- (void) setPaddingLeft:(CGFloat) paddingLeft;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;
@end
