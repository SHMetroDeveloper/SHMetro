//
//  QuestionView.h
//  JieMianKuangJia
//
//  Created by 杨帆 on 28/4/14.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "BaseRadioBoxView.h"
#import "OnMessageHandleListener.h"


//值的类型
typedef NS_ENUM(NSInteger, QuestionViewValueType) {
    QUESTION_VIEW_VALUE_TYPE_INPUT,             //输入
    QUESTION_VIEW_VALUE_TYPE_SINGLE_SELECT,     //单选
    QUESTION_VIEW_VALUE_TYPE_COMMENT,           //备注
};


//事件类型
typedef NS_ENUM(NSInteger, QuestionViewEventType) {
    QUESTION_VIEW_EVENT_UNKNOW,
    QUESTION_VIEW_EVENT_VALUE_CHANGE_INPUT,     //输入
    QUESTION_VIEW_EVENT_VALUE_CHANGE_SINGLE_SELECT, //单选
    QUESTION_VIEW_EVENT_VALUE_CHANGE_COMMENT,   //备注
    QUESTION_VIEW_EVENT_TAKE_PHOTO,             //拍照
    QUESTION_VIEW_EVENT_SHOW_PHOTO,             //显示大图
    QUESTION_VIEW_EVENT_DELETE_PHOTO,           //删除图片
    QUESTION_VIEW_EVENT_EDIT,             //填写备注
};


@interface QuestionView : UIView <UITextViewDelegate, OnValueChangedListener>

- (instancetype) init;

- (instancetype) initWithFrame:(CGRect)frame;

- (void) setFrame:(CGRect)frame;

- (void) setInfoWithtitle:(NSString*) title
                valueType:(NSInteger) type
                  content:(NSString*) content
          valuesForSelect:(NSArray *) values
                     desc:(NSString*) desc
                imageUrls:(NSMutableArray *) imagePathArray;

- (void) setShowBound:(BOOL) showBound;

- (void) setOnMessageHandleListener:(id) handler;

//计算高度
+ (CGFloat) getMinHeightByTitle:(NSString *) title andDesc:(NSString *) desc andWidth:(CGFloat) width photoCount:(NSInteger) photoCount andSelectValueCount:(NSInteger) count ;
@end
