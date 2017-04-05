//
//  RequirementEvaluateView.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/29.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"
#import "BaseDataEntity.h"

typedef NS_ENUM(NSInteger, RequirementEvaluateType) {
    REQUIREMENT_EVALUATE_TYPE_CANCEL, //取消
    REQUIREMENT_EVALUATE_TYPE_OK,     //确定
};

@interface RequirementEvaluateView : UIView
- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;
- (void) setFrame:(CGRect)frame;

- (void) setInfoWithSatisfactionArray:(NSMutableArray *) array;
- (SatisfactionType *) getSelectedSatisfaction;
- (NSString *) getCommentOfSelectedSatisfaction;


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener;

+ (CGFloat) calculateHeightBySatisfactionArrayCount:(NSInteger )count;

@end
