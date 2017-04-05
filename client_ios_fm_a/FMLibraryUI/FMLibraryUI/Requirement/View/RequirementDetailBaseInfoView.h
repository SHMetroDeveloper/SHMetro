//
//  RequirementDetailBaseInfoView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/24.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequirementDetailEntity.h"
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, RequirementEventType) {
    Requirement_EVENT_PHONE,
};

@interface RequirementDetailBaseInfoView : UIView <OnItemClickListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWith:(NSString *)code
              status:(NSInteger)status
                type:(NSString *)type
                desc:(NSString *)desc
              origin:(NSString *)origin
            location:(NSString *)location
           requestor:(RequirementRequestor *) requestor
          createDate:(NSNumber *) createDate;

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) calculateHeightByDesc:(NSString *) desc width:(CGFloat) width;

@end
