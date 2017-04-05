//
//  Header.h
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/7/6.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "DBHelper.h"
#import "DBReport+CoreDataClass.h"
#import "DBReportDevice+CoreDataClass.h"
#import "DBReportImage+CoreDataClass.h"
#import "ReportEntity.h"

@interface ReportDbHelper : DBHelper

+ (instancetype) getInstance;

//报障设备
- (BOOL) isReportDeviceExist:(NSNumber*) rdevId;
- (BOOL) addReportDevice:(ReportDevice*) dev withReport:(NSNumber *) reportId;
- (BOOL) addReportDevices:(NSArray *) devs withReport:(NSNumber *) reportId;
//根据ID删除指定报障设备
- (BOOL) deleteReportDeviceById:(NSNumber*) rdevId;
//删除跟指定报障相关报障设备
- (BOOL) deleteReportDeviceByReport:(NSNumber *)reportId;
//查询报障中的所有报障设备
- (NSMutableArray*) queryAllDeviceByReport:(NSNumber *) reportId;


//报障图片
- (BOOL) isReportImageExist:(NSNumber*) rimgId;
- (BOOL) addReportImage:(NSString*) path withReport:(NSNumber *) reportId;
- (BOOL) addReportImages:(NSArray *) paths withReport:(NSNumber *) reportId;
//根据ID删除指定报障图片
- (BOOL) deleteReportImageById:(NSNumber*) rimgId;
//删除跟指定报障相关报障图片
- (BOOL) deleteReportImageByReport:(NSNumber *)reportId;
//查询报障中的所有报障图片
- (NSMutableArray*) queryAllImageByReport:(NSNumber *) reportId;
//查询报障中的所有报障图片
- (NSMutableArray*) queryAllImagePathByReport:(NSNumber *) reportId;

//Report
- (BOOL) isReportExist:(NSNumber *) reportId;
- (BOOL) addReport:(Report*) report andImages:(NSMutableArray *) imgs;
- (BOOL) deleteReportById:(NSNumber*) reportId;
- (BOOL) updateReportById:(NSNumber*) reportId report:(Report*) report withImages:(NSArray *) pathArray;
//通过 ID 来查询指定的 Report 对象
- (Report*) queryReportById:(NSNumber*) reportId;
//查询得到所有的 DBReport 对象
- (NSMutableArray *) queryAllDBReportsByUser:(NSNumber *) userId;
//查询得到所有的 Report 对象
- (NSMutableArray*) queryAllReportsByUser:(NSNumber *) userId;

@end


