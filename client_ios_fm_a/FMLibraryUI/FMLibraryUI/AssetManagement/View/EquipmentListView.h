//
//  EquipmentListView.h
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/1.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentListView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect) frame;
- (void) setFrame:(CGRect) frame;

- (void) setInfoWithTitle:(NSString *) title
                 category:(NSString *) category
                 location:(NSString *) location
                   status:(NSInteger) status
                   repair:(NSInteger) repair
              maintecance:(NSInteger) maintenance;

+ (CGFloat) calculateHeight;

@end
