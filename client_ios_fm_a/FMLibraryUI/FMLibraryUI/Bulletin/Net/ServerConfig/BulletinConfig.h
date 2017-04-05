//
//  BulletinConfig.h
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BulletinGradeType) {
    BULLETIN_GRADE_TYPE_PROJECT = 0,  //项目级公告
    BULLETIN_GRADE_TYPE_COMPANY = 1,  //公司级公告
    BULLETIN_GRADE_TYPE_SYSTEM = 2    //系统级公告
};

@interface BulletinConfig : NSObject

//获取公告级别名称
+ (NSString *) getNameOfBulletinGradeType:(BulletinGradeType) type;

//获取公告级别颜色
+ (UIColor *) getColorOfBulletinGradeType:(BulletinGradeType) type;

@end

//公告查询URL
extern NSString * const BULLETIN_HISTORY_QUERY_URL;

//公告详情URL
extern NSString * const BULLETIN_HISTORY_DETAIL_URL;

//公告已读未读URL
extern NSString * const BULLETIN_HISTORY_READ_STATE_URL;

