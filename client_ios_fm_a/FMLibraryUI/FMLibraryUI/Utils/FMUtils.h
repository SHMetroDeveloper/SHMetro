//
//  Utils.h
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMUtils : NSObject

//NSObject ——> NSDictionary
//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;

//NSDictionary ——> NSData
+ (NSData*) dictionaryToData: (NSDictionary*) dic;

//NSData ——> NSDictionary
+ (NSDictionary*) dataToDictionary: (NSData *) data;

//NSString ---> NSNumber
+ (NSNumber *) stringToNumber:(NSString *) str;

//判断字符串是否为空
+ (BOOL) isStringEmpty:(NSString *) string;

//判断对象是否为空
+ (BOOL) isObjectNull:(id) object;

//判断 Number 对象是否为空
+ (BOOL) isNumberNullOrZero:(NSNumber*) number;

//判断两个字符串是否相同忽略大小写比较）
+ (BOOL) isStingEqualIgnoreCaseString1: (const NSString*) str1 String2: (const NSString*) str2;

//判断字符串 str1 中是否包含子串 str2
+ (BOOL) isStringContain: (const NSString*) str1 subString: (const NSString*) str2;

//判断字符串是否以指定字符串开头
+ (BOOL) isString: (const NSString*) str1 startWith: (const NSString*) str2;

//获取当前时间的 ms 数
+ (long) currentTimeMills;

//获取时间的指定格式字符串表示
+ (NSString *) getDateTimeStringBy:(long) time
                            format:(NSString *) format;

//获取时间 的指定格式字符串表示，yyyy-MM-dd hh:mm:ss
+ (NSString *) getDateTimeDescriptionBy:(NSNumber*) time
                                 format:(NSString *) format;

//获取时间 的指定格式字符串表示
+ (NSString *) getTimeDescriptionByDate:(NSDate*) date
                                 format:(NSString *) format;

//获取设备 ID
+ (NSString *) getDeviceIdString;

//判断相册是否可用
+ (BOOL) isPhotoLibraryAvailable;

//判断是否支持某种多媒体类型（照片，视频）
+ (BOOL) cameraSupportsMedia:(NSString *) paramMediaType
                  sourceType:(UIImagePickerControllerSourceType) paramSourceType;

//判断是否可以从相册中选取照片
+ (BOOL) canUserPickPhotosFromPhotoLibrary;

//计算 UILabel 所占高度, 使用本接口之前需要设置 label 的 font 以及 numberOfLines属性
+ (float) heightForStringWith:(UILabel *)label value:(NSString*) value andWidth:(float)width;

//计算 UILabel 所占宽度, 使用本接口之前需要设置 label 的字体
+ (float) widthForString:(UILabel *)label value:(NSString*) value;

//计算UIlabel的size，需要提供内容字符串 + label的最大宽度
+ (CGSize) getLabelSizeBy:(UILabel *) label andContent:(NSString *) content andMaxLabelWidth:(CGFloat) maxWidth;

//通过字体和内容计算所需大小
+ (CGSize) getLabelSizeByFont:(UIFont *)font andContent:(NSString *)content andMaxWidth:(CGFloat) maxWidth;

//计算UITextView 所需要的高度
+ (CGFloat) heightForTextViewWith:(UITextView*) view;

// 汉字转拼音
+ (NSString *) phonetic:(NSString *) srcString;

//获取指定月的最后一天
+ (NSInteger) getLastDayOfMonthWithYear:(NSInteger) year month:(NSInteger) month;

//获取一个月中的第一秒所在的时间
+ (NSDate *) getFirstSecondOfMonth:(NSDate *) date;

//获取下个月的第 1s
+ (NSDate *) getFirstSecondOfNextMonth:(NSDate *) date;

//获取一个月中的最后一秒所在的时间
+ (NSDate *) getLastSecondOfMonth:(NSDate *) date;

//获取一天的第一秒
+ (NSDate *) getFirstSecontOfDay:(NSDate *) date;

//获取一天的第一秒（以number表示）
+ (NSNumber *) getFirstSecontNumberOfDay:(NSNumber *) date;

//获取一天的最后一秒
+ (NSDate *) getLastSecontOfDay:(NSDate *) date;

//获取前一天或者后一天的第一秒 deviation = -1 表示前一天 deviation = 1表示后一天 targetDate表示当天的日期
+ (NSDate *) getFirstSecontOfDeviation:(NSInteger)deviation targetDay:(NSNumber *) targetDate;

//获取一个月后的时间
+ (NSNumber *) getTimeNextMonthOfDay:(NSNumber *) fromDay;

//获取从指定日期开始经过指定数量月份后的时间
+ (NSNumber *) getTimeOfSomeMonths:(NSInteger) monthCount fromDate:(NSNumber *) fromDay;

//判断是否为闰年
+ (BOOL) isLeapYear:(NSInteger) year;

//判断系统是否为12小时制
+ (BOOL) is12HourFormat;

//由自1970年1月1日凌晨以来的毫秒数获取 NSDate 对象
+ (NSDate *) timeLongToDate:(NSNumber *) ms;

//由自1970年1月1日凌晨以来的毫秒数获取 字符串，YYYY-MM-DD hh:mm
+ (NSString *) timeLongToDateString:(NSNumber *) ms;

//由自1970年1月1日凌晨以来的毫秒数获取 字符串(不包含年)，MM-DD hh:mm
+ (NSString *) timeLongToDateStringWithOutYear:(NSNumber *) ms;

//由 NSDate 获取自1970年起所经过的 毫秒数
+ (NSNumber *) dateToTimeLong:(NSDate *) date;

//获取当前时间的毫秒数
+ (NSNumber *) getTimeLongNow;

//获取一整天的毫秒数
+ (NSNumber *) getMilliSecondOfADay;

//获取 NSDate 对象的月份表示 YYYY-MM
+ (NSString *) getMonthStr:(NSDate *) date;

//获取 NSDate 对象的日期表示 YYYY-MM-DD
+ (NSString *) getDayStr:(NSDate *) date;

//获取 NSDate 对象的日期表示 MM/DD
+ (NSString *) getDateStrMMDD:(NSDate *) date;

//获取 NSDate 对象的时间表示 hh:mm
+ (NSString *) getTimeStr:(NSDate *) date;

//获取 NSDate 对象的分钟表示 YYYY-MM-DD hh:mm
+ (NSString *) getMinuteStr:(NSDate *) date;

//获取 NSDate 对象的分钟表示(不包含年份) MM-DD hh:mm
+ (NSString *) getMinuteStrWithoutYear:(NSDate *) date;

//获取 time 的合适的表示，如果是当天的话 就是"上午hh:mm" ,前一天的话就显示 "昨天",后一天则显示"明天"， 其它时间则显示"MM月DD日"
+ (NSString *) getSuitableDescOfTime:(NSNumber *) time;

//构造 NSDate 对象
+ (NSDate *) getDateByYear:(NSInteger) year
                     month:(NSInteger) month
                       day:(NSInteger) day
                      hour:(NSInteger) hour
                    minute:(NSInteger) minute
                    second:(NSInteger) second;

//按GMT 时区构造 NSDate 对象
+ (NSDate *) getGMTDateByYear:(NSInteger) year
                        month:(NSInteger) month
                          day:(NSInteger) day
                         hour:(NSInteger) hour
                       minute:(NSInteger) minute
                       second:(NSInteger) second;

//获取时间的字典表示
+ (NSDictionary *) timeLongToDictionary:(NSNumber *) time;

//判断两个日期是否为同一天
+ (BOOL) isDate:(NSDate *) dateA inTheSameDayOfDate:(NSDate *) dateB;

//判断是否为同一天
+ (BOOL) isTime:(NSNumber *) timeA inTheSameDayOfTime:(NSNumber *) timeB;

//判断时间的先后 -1(A<B) 0(A=B) 1(A>B)  以天为单位
+ (NSInteger) compareTimeA:(NSNumber *) timeA withTimeB:(NSNumber *) timeB;

//判断是否为同一月
+ (BOOL) isDate:(NSDate *) date1 inTheSameMonthOfDate:(NSDate *) date2;

//判断是否为同一月
+ (BOOL) isTime:(NSNumber *) time1 inTheSameMonthOfTime:(NSNumber *) time2;

//获取时间的字典表示
+ (NSDictionary *) dateToDictionary:(NSDate *) date;

//输出当前的时间
+ (void) printCurrentTime;

//过滤 NSString 中得 html 标签
+ (NSString *)flattenHTML:(NSString *)html;

//判断字符串是否是手机号
+ (BOOL) isMobile:(NSString *) phone;

//判断是否为小数
+ (BOOL) isFloatNumber:(NSString *) text;

//根据文件名获取 mime 类型
+ (NSString *) getMimeTypeByFileName:(NSString *) fileName;

//获取格式化的手机号码 比如 “151 XXXX XXXX”
+ (NSString *) getFormatMobile:(NSString *) phone;
//获取格式化的手机号码 比如 “151*****XXX”
+ (NSString *) getSecretFormatMobile:(NSString *) phone;

//+ (NSString *) encodeByMD5:(NSString *)str;

//保存图片
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

//删除指定路径下的指定图片
+ (void) deleteFileWithPath:(NSString *) path andName:(NSString *) name;

//删除 @“Documents” 路径下面的指定图片
+ (void) deleteDocumentsWithName:(NSString *) name;

//获取图片
+ (UIImage *) getImageWithName:(NSString *) name;
//获取缩略图
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
//保持原来的长宽比，获取一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

//获取缩略图
+ (UIImage *) thumbnailWithAssetUrl:(NSURL *) url time:(CGFloat) second;

//给图片添加水印
+ (UIImage *)addWaterMarkInImage:(UIImage *)img withText:(NSString *) desc;

//视频文件压缩，异步操作
+ (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler;

//拨打指定电话
+ (void) makeCallWith:(NSString *) phoneNum container:(UIViewController *) container;

//获取指定颜色的 图片,给按钮用
+ (UIImage *) buttonImageFromColor:(UIColor *)color width:(CGFloat) width height:(CGFloat) height;

//获取当前正在显示的 viewController
+ (UIViewController *) getRootViewController;

//依据实际最大值来计算所需要的纵坐标的最大值
+ (NSInteger) getYMaxByMaxValue:(NSInteger) maxValue count:(NSInteger) count;

//判断用户是否允许接收推送通知
+ (BOOL) isAllowedNotification;

//计算单个文件大小，单位为 KB
+ (float) fileSizeAtPath:(NSString *) path;

//计算目录大小，单位为 KB
+ (float) folderSizeAtPath:(NSString *) path;

//计算目录下指定类型的文件的大小，单位为 KB
+ (float) folderSizeAtPath:(NSString *)path withPredicate:(NSPredicate *) predicate;

//依据过滤条件清除指定目录下的缓存文件
+ (void) clearFile:(NSString *) path withPredicate:(NSPredicate *) predicate;

//如果存在文件，则将其删除
+ (void) deleteFileByPath:(NSString *) fullpath;

//获取中文首字母
+ (NSString *) getFirstCharactorOf:(NSString *) str;

//获取中文首字母字符串
+ (NSString *) getFirstCharactorSpellOf:(NSString *) str;

//获取汉字的拼音，以空格分隔
+ (NSString *) getPinYinOf:(NSString *) str;

//获取图片URL
+ (NSURL *) getUrlOfImageById:(NSNumber *) imgId;

//获取音频URL
+ (NSURL *) getUrlOfAudioById:(NSNumber *) audioId;

//获取视频URL
+ (NSURL *) getUrlOfVideoById:(NSNumber *) videoId;

//获取附件URL
+ (NSURL *) getUrlOfAttachmentById:(NSNumber *) attachmentId;

//获取当前的语言环境
+ (NSString*)getPreferredLanguage;

//将view转化为Image
+ (UIImage *)getImageFromView:(UIView *)view;

//根据URL获取未知文件的文件名字
+ (NSString *) getFileNameByURL:(NSURL *) url;

//判断是否为竖屏
+ (BOOL) isVerticalScreen;

//比较两个浮点数的大小 -1--小于  0--等于  1--大于
+ (NSInteger) compareFloatA:(CGFloat)floatA andFloadB:(CGFloat)floadB;

//比较两个浮点数的大小 -1--小于  0--等于  1--大于
+ (NSInteger) compareDoubleA:(double) valueA andDoubleB:(double) valueB;

//获取当前连接的 wifi 的信息
+ (NSDictionary *) getCurrentWiFiInfo;

@end

