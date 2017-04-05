//
//  QuestionEditViewController.h
//
//
//  Created by 杨帆 on 28/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//
//  巡检问题记录页面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#import "BaseTextView.h"
#import "OnMessageHandleListener.h"



@protocol OnQuestionEditFinishedListener;

@interface QuestionEditViewController : BaseViewController <UITextViewDelegate, OnViewResizeListener, OnMessageHandleListener>

- (instancetype) init;
- (instancetype) initWithFrame:(CGRect)frame;

- (void) setContent:(NSString *)content withTag:(NSInteger) tag;
- (void) setContent:(NSString *)content exceptions:(NSString *) exceptions withTag:(NSInteger) tag;
- (void) setOnQuestionEditFinishedListener:(id<OnQuestionEditFinishedListener>) listener;
@end

@protocol OnQuestionEditFinishedListener <NSObject>
- (void) onQuestionEditFinishedWithTag:(NSInteger) tag andDesc:(NSString *) desc;
@end