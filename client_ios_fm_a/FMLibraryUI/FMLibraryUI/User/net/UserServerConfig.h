//
//  UserServerConfig.h
//  hello
//
//  Created by 杨帆 on 15/4/1.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const USER_INFO_URL;
extern NSString * const USER_Retrieve_PWD_URL;
extern NSString * const USER_EDIT_URL;
extern NSString * const USER_CHANGE_PWD_URL;
extern NSString * const USER_BIND_PHONE_URL;
extern NSString * const USER_FEEDBACK_URL;
extern NSString * const USER_PHOTO_SET_URL;
extern NSString * const USER_LIST_URL;
extern NSString * const USER_ATTENDANCE_RECORD_LIST_URL; /* 签到记录 */
extern NSString * const USER_ATTENDANCE_RECORD_LAST_URL; /* 最后一次签到记录 */

@interface UserServerConfig : NSObject

@end
