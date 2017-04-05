//
//  BulletinConfig.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/7.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinConfig.h"
#import "FMUtilsPackages.h"
#import "BaseBundle.h"

//公告查询URL
NSString * const BULLETIN_HISTORY_QUERY_URL = @"/m/v1/bulletin/query";

//公告详情URL
NSString * const BULLETIN_HISTORY_DETAIL_URL = @"/m/v1/bulletin/detail";

//公告已读未读URL
NSString * const BULLETIN_HISTORY_READ_STATE_URL = @"/m/v1/bulletin/receiver";

@implementation BulletinConfig

+ (NSString *) getNameOfBulletinGradeType:(BulletinGradeType) type {
    NSString *res = @"";
    switch (type) {
        case BULLETIN_GRADE_TYPE_PROJECT:
            res = [[BaseBundle getInstance] getStringByKey:@"bulletin_grade_type_project" inTable:nil];
            break;
            
        case BULLETIN_GRADE_TYPE_COMPANY:
            res = [[BaseBundle getInstance] getStringByKey:@"bulletin_grade_type_project" inTable:nil];
            break;
            
        case BULLETIN_GRADE_TYPE_SYSTEM:
            res = [[BaseBundle getInstance] getStringByKey:@"bulletin_grade_type_system" inTable:nil];
            break;
    }
    return res;
}

+ (UIColor *) getColorOfBulletinGradeType:(BulletinGradeType) type {
    UIColor *resColor = nil;
    switch (type) {
        case BULLETIN_GRADE_TYPE_PROJECT:
            resColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_PROJECT];
            break;
            
        case BULLETIN_GRADE_TYPE_COMPANY:
            resColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_COMPANY];
            break;
            
        case BULLETIN_GRADE_TYPE_SYSTEM:
            resColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_SYSTEM];
            break;
    }
    return resColor;
}

@end
