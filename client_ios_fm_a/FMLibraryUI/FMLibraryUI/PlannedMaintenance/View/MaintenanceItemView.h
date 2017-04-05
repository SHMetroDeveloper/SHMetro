//
//  MaintenanceItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/5/27.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString*) name
                    time:(NSString*) time
                  status:(NSInteger) status
                hasOrder:(BOOL) hasOrder;

@end
