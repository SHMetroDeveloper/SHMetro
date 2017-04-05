//
//  ApproverItemView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/7.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, ApproverItemActionType) {
    APPROVER_ACTION_CLICK,
    APPROVER_ACTION_DELETE,
};

@interface ApproverItemView : UIView

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithName:(NSString *) name;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

@end
