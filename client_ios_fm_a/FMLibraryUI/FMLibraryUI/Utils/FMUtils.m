  //
//  Utils.m
//  hello
//
//  Created by 杨帆 on 15/3/25.
//  Copyright (c) 2015年 flynn. All rights reserved.
//



#import "FMUtils.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CommonCrypto/CommonDigest.h>
#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDImageCache.h"
#import "SystemConfig.h"
#import "BaseBundle.h"


@interface FMUtils ()

+ (id) getObjectInternal: (id) obj;

@end

@implementation FMUtils

+ (NSDictionary*)getObjectData:(id)obj {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    free(props);
    if([obj isKindOfClass:[NSObject class]] && ![obj isMemberOfClass:[NSObject class]]) {
        Class cls = [obj superclass];
        while (cls != [NSObject class]) {
            objc_property_t *props = class_copyPropertyList(cls, &propsCount);
            
            for(int i = 0;i < propsCount; i++) {
                objc_property_t prop = props[i];
                NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
                id value = [obj valueForKey:propName];
                if(value == nil) {
                    value = [NSNull null];
                } else {
                    value = [self getObjectInternal:value];
                }
                [dic setObject:value forKey:propName];
            }
            cls = [cls superclass];
            free(props);
        }
        
    }
    return dic;
}


+ (id) getObjectInternal: (id) obj {
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return dic;
    }
    return [self getObjectData:obj];
}

+ (NSNumber *) stringToNumber:(NSString *)str {
    id result;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    result = [f numberFromString:str];
    return result;
}

+ (BOOL) isStringEmpty:(NSString *) string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (BOOL) isStingEqualIgnoreCaseString1: (NSString*) str1 String2: (NSString*) str2 {
    BOOL res = [str1 compare:str2
                     options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    return res;
}

+ (BOOL) isStringContain: (NSString*) str1 subString: (NSString*) str2 {
    BOOL res = NO;
    NSRange range = [str1 rangeOfString:str2];
    if (range.length >0) {
        res = YES;
    }
    return res;
}

+ (BOOL) isString: (NSString*) str1 startWith: (NSString*) str2 {
    BOOL res = NO;
    NSRange range = [str1 rangeOfString:str2];
    if (range.length > 0 && range.location == 0) {
        res = YES;
    }
    return res;
}


+ (long) currentTimeMills {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    long res = [localeDate timeIntervalSince1970];
    return res;
}

+ (NSString *) getDateTimeStringBy:(long) time
                            format:(NSString *) format {
    NSString * res = nil;
    NSDate *datenow = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    res = [dateFormatter stringFromDate:datenow];
    return res;
}
+ (NSString *) getDateTimeDescriptionBy:(NSNumber*) time
                                 format:(NSString *) format {
    NSString * res = nil;
    long long tmp = time.longLongValue / 1000;
    res = [FMUtils getDateTimeStringBy:tmp format:format];
    return res;
}

//获取时间 的指定格式字符串表示
+ (NSString *) getTimeDescriptionByDate:(NSDate*) date
                                 format:(NSString *) format {
    NSString * res = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    res = [dateFormatter stringFromDate:date];
    return res;
}

+ (NSString *) getDeviceIdString {
    NSString * res = nil;
    //    res = [[UIDevice currentDevice].identifierForVendor UUIDString];
    res = @"12345678";
    return res;
}

+ (NSData*) dictionaryToData: (NSDictionary*) dic {
    NSData* res = nil;
    if(dic) {
        NSError * error = nil;
        res = [NSJSONSerialization dataWithJSONObject:dic
                                              options:NSJSONWritingPrettyPrinted
                                                error:&error];
    }
    return res;
}

+ (NSDictionary*) dataToDictionary: (NSData *) data {
    NSDictionary* res = nil;
    NSError *error = nil;
    if(data) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(jsonObject && error== nil) {
            res = jsonObject;
        }
    }
    return res;
}

+ (BOOL) isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

+ (BOOL) canUserPickPhotosFromPhotoLibrary {
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (float) heightForStringWith:(UILabel *)label value:(NSString*) value andWidth:(float)width {
    NSString * text = label.text;
    if([FMUtils isStringEmpty:value]) {
        return 0;
    }
    [label setText:value];
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    [label setText:text];
    return sizeToFit.height;
}

+ (float) widthForString:(UILabel *)label value:(NSString*) value {
    NSString * text = label.text;
    [label setText:value];
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [label setText:text];
    return sizeToFit.width;
}

+ (CGSize) getLabelSizeBy:(UILabel *) label andContent:(NSString *) content andMaxLabelWidth:(CGFloat) maxWidth {
    NSString * text = label.text;
    if([FMUtils isStringEmpty:content]) {
        return CGSizeZero;
    }
    [label setText:content];
    CGSize resultSize = [label sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    [label setText:text];
    return resultSize;
}

//通过字体和内容计算所需大小
+ (CGSize) getLabelSizeByFont:(UIFont *)font andContent:(NSString *)content andMaxWidth:(CGFloat) maxWidth {
    if (!font) {
        font = [UIFont fontWithName:@".SFUIText" size:17];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+ (CGFloat) heightForTextViewWith:(UITextView*) view {
    CGRect frame = view.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [view sizeThatFits:constraintSize];
    return size.height;
}

+ (NSString *) phonetic:(NSString *) srcString {
    NSString * res = [srcString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)res, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)res, NULL, kCFStringTransformStripDiacritics, NO);
    return res;
}

// 是否为润年
+ (BOOL) isLeapYear:(NSInteger) year {
    BOOL res = NO;
    if((year%4==0 && year%100!=0) || year%400==0) {
        res = YES;
    }
    return res;
}

+ (NSInteger) getLastDayOfMonthWithYear:(NSInteger) year month:(NSInteger) month {
    NSInteger day = 0;
    switch(month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day = 30;
            break;
        case 2:
            if([FMUtils isLeapYear:year]) {
                day = 29;
            } else {
                day = 28;
            }
            break;
    }
    return day;
}


+ (NSDate *) getFirstSecondOfMonth:(NSDate *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    res = [FMUtils getDateByYear:year month:month day:1 hour:0 minute:0 second:0];
    return res;
}

//获取下个月的第 1s
+ (NSDate *) getFirstSecondOfNextMonth:(NSDate *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    month ++;
    if(month > 12) {
        year++;
    }
    res = [FMUtils getDateByYear:year month:month day:1 hour:0 minute:0 second:0];
    return res;
}

+ (NSDate *) getLastSecondOfMonth:(NSDate *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    day = [FMUtils getLastDayOfMonthWithYear:year month:month];
    res = [FMUtils getDateByYear:year month:month day:day hour:23 minute:59 second:59];
    return res;
}

//获取一天的第一秒
+ (NSDate *) getFirstSecontOfDay:(NSDate *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    day = [components day];
    res = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
    return res;
}

//获取一天的第一秒（以number表示）
+ (NSNumber *) getFirstSecontNumberOfDay:(NSNumber *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:[FMUtils timeLongToDate:date]];
    year = [components year];
    month = [components month];
    day = [components day];
    res = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
    
    return [FMUtils dateToTimeLong:res];
}

//获取前一天或者后一天的第一秒 deviation = -1 表示前一天 deviation = 1表示后一天 targetDate表示当天的日期
+ (NSDate *) getFirstSecontOfDeviation:(NSInteger)deviation targetDay:(NSNumber *) targetDate {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:[FMUtils timeLongToDate:targetDate]];
    year = [components year];
    month = [components month];
    day = [components day] + deviation;
    res = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
    return res;
}

//获取一个月后的时间
+ (NSNumber *) getTimeNextMonthOfDay:(NSNumber *) fromDay {
    NSNumber * res;
    if(fromDay) {
        NSDictionary * dic = [FMUtils timeLongToDictionary:fromDay];
        NSNumber * tmpNumber = [dic valueForKeyPath:@"year"];
        NSInteger year = tmpNumber.integerValue;
        tmpNumber = [dic valueForKeyPath:@"month"];
        NSInteger month = tmpNumber.integerValue;
        NSInteger dayCount = [FMUtils getLastDayOfMonthWithYear:year month:month];
        res = [NSNumber numberWithLongLong:(fromDay.longLongValue + dayCount * 1000 * 60 * 60 * 24)];
        
    }
    return res;
}


//获取从指定日期开始经过指定数量月份后的时间
+ (NSNumber *) getTimeOfSomeMonths:(NSInteger) monthCount fromDate:(NSNumber *) fromDay {
    NSNumber * res;
    if(fromDay) {
        NSDictionary * dic = [FMUtils timeLongToDictionary:fromDay];
        NSNumber * tmpNumber = [dic valueForKeyPath:@"year"];
        NSInteger year = tmpNumber.integerValue;
        tmpNumber = [dic valueForKeyPath:@"month"];
        NSInteger month = tmpNumber.integerValue;
        tmpNumber = [dic valueForKeyPath:@"day"];
        NSInteger day = tmpNumber.integerValue;
        month += monthCount;
        
        NSInteger exyear = month/12;
        year += exyear;
        month = month%12;
        
        //如果起始月份比终止月份大则取终止月份作为 day
        NSInteger maxDay = [FMUtils getLastDayOfMonthWithYear:year month:month];
        if(day > maxDay) {
            day = maxDay;
        }
        
        
        NSDate * date = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
        res = [FMUtils dateToTimeLong:date];
    }
    return res;

}

//获取一天的最后一秒
+ (NSDate *) getLastSecontOfDay:(NSDate *) date {
    NSDate * res;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    day = [components day];
    res = [FMUtils getDateByYear:year month:month day:day hour:23 minute:59 second:59];
    return res;
}

//判断系统是否为12小时制
+ (BOOL) is12HourFormat {
    BOOL res = NO;
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    res = containsA.location != NSNotFound;
    return res;
}

//由自1970年1月1日凌晨以来的毫秒数获取 NSDate 对象
+ (NSDate *) timeLongToDate:(NSNumber *) ms {
    long long sec = [ms longLongValue]/1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:sec];
    return date;
}

+ (NSString *) timeLongToDateString:(NSNumber *) ms {
    NSString * str = @"";
    if (![FMUtils isObjectNull:ms] && ![ms isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:ms];
        str = [FMUtils getMinuteStr:date];
    }
    return str;
}

//由自1970年1月1日凌晨以来的毫秒数获取 字符串(不包含年)，MM-DD hh:mm
+ (NSString *) timeLongToDateStringWithOutYear:(NSNumber *) ms {
    NSString * str = @"";
    if (![FMUtils isObjectNull:ms] && ![ms isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:ms];
        str = [FMUtils getMinuteStrWithoutYear:date];
    }
    return str;
}

//由 NSDate 获取自1970年起所经过的 毫秒数
+ (NSNumber *) dateToTimeLong:(NSDate *) date {
    NSNumber * res = [NSNumber numberWithLongLong:[date timeIntervalSince1970] * 1000];
    return res;
}

//获取当前时间的毫秒数
+ (NSNumber *) getTimeLongNow {
    NSDate * date = [NSDate date];
    NSNumber * res = [FMUtils dateToTimeLong:date];
    return res;
}

//获取一整天的毫秒数
+ (NSNumber *) getMilliSecondOfADay {
    NSNumber *res = [NSNumber numberWithLongLong:86400000];
    
    return res;
}

//获取 NSDate 对象的月份表示 YYYY-MM
+ (NSString *) getMonthStr:(NSDate *) date {
    NSString * strMonth = @"";
    NSString * smonth = @"";
    NSInteger month = 0;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    //格式化字符串
    month = [components month];
    if(month < 10) {
        smonth = @"0";
    }
    strMonth = [NSString stringWithFormat:@"%ld-%@%ld", [components year], smonth, month];
    return strMonth;
}

//获取 NSDate 对象的日期表示 YYYY-MM-DD
+ (NSString *) getDayStr:(NSDate *) date {
    NSString * strDay = @"";
    NSString * smonth = @"";
    NSString * sday = @"";
    NSInteger month = 0;
    NSInteger day = 0;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    month = [components month];
    if(month < 10) {
        smonth = @"0";
    }
    day = [components day];
    if(day < 10) {
        sday = @"0";
    }
    //格式化字符串
    strDay = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld", [components year], smonth, month, sday, day];
    return strDay;
}

//获取 NSDate 对象的日期表示 MM/DD
+ (NSString *) getDateStrMMDD:(NSDate *) date {
    NSString * strDay = @"";
    NSString * smonth = @"";
    NSString * sday = @"";
    NSInteger month = 0;
    NSInteger day = 0;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    month = [components month];
    if(month < 10) {
        smonth = @"0";
    }
    day = [components day];
    if(day < 10) {
        sday = @"0";
    }
    //格式化字符串
    strDay = [NSString stringWithFormat:@"%@%ld/%@%ld", smonth, month, sday, day];
    return strDay;
}


//获取 NSDate 对象的时间表示 hh:mm
+ (NSString *) getTimeStr:(NSDate *) date {
    NSString * strMinute = @"";
    
    NSString * shour = @"";
    NSString * sminute = @"";
    
    NSInteger hour = 0;
    NSInteger minute = 0;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    
    hour = [components hour];
    if(hour < 10) {
        shour = @"0";
    }
    minute = [components minute];
    if(minute < 10) {
        sminute = @"0";
    }
    //格式化字符串
    strMinute = [NSString stringWithFormat:@"%@%ld:%@%ld", shour, hour, sminute, minute];
    return strMinute;
}

//获取 NSDate 对象的分钟表示 YYYY-MM-DD hh:mm
+ (NSString *) getMinuteStr:(NSDate *) date {
    NSString * strMinute = @"";
    NSString * smonth = @"";
    NSString * sday = @"";
    NSString * shour = @"";
    NSString * sminute = @"";
    NSInteger month = 0;
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger minute = 0;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    month = [components month];
    if(month < 10) {
        smonth = @"0";
    }
    day = [components day];
    if(day < 10) {
        sday = @"0";
    }
    hour = [components hour];
    if(hour < 10) {
        shour = @"0";
    }
    minute = [components minute];
    if(minute < 10) {
        sminute = @"0";
    }
    //格式化字符串
    strMinute = [NSString stringWithFormat:@"%ld-%@%ld-%@%ld %@%ld:%@%ld", [components year], smonth, month, sday, day, shour, hour, sminute, minute];
    return strMinute;
    
}

//获取 NSDate 对象的分钟表示(不包含年份) MM-DD hh:mm
+ (NSString *) getMinuteStrWithoutYear:(NSDate *) date {
    NSString * strMinute = @"";
    NSString * smonth = @"";
    NSString * sday = @"";
    NSString * shour = @"";
    NSString * sminute = @"";
    NSInteger month = 0;
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger minute = 0;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    month = [components month];
    if(month < 10) {
        smonth = @"0";
    }
    day = [components day];
    if(day < 10) {
        sday = @"0";
    }
    hour = [components hour];
    if(hour < 10) {
        shour = @"0";
    }
    minute = [components minute];
    if(minute < 10) {
        sminute = @"0";
    }
    //格式化字符串
    strMinute = [NSString stringWithFormat:@"%@%ld-%@%ld %@%ld:%@%ld", smonth, month, sday, day, shour, hour, sminute, minute];
    return strMinute;
    
}

+ (NSNumber *) getStartTimeLongToday {
    NSDate * date = [NSDate date];
    NSInteger year = 0;
    NSInteger month = 0;
    NSInteger day = 0;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [components year];
    month = [components month];
    day = [components day];
    NSDate * todayDate = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
    NSNumber * res = [FMUtils dateToTimeLong:todayDate];
    return res;
}

//获取 time 的合适的表示，如果是当天的话 就是"上午hh:mm" ,前一天的话就显示 "昨天",后一天则显示"明天"， 其它时间则显示"MM月DD日"
+ (NSString *) getSuitableDescOfTime:(NSNumber *) time {
    NSString * strTime;
    NSDate * date = [FMUtils timeLongToDate:time];

    NSInteger month = 0;
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSNumber * todayStart = [FMUtils getStartTimeLongToday];
    NSNumber * msOfADay = [NSNumber numberWithLongLong:1000 * 60 * 60 * 24];
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    month = [components month];
    day = [components day];
    hour = [components hour];
    minute = [components minute];

    if(time.longLongValue >= todayStart.longLongValue && time.longLongValue < todayStart.longLongValue + msOfADay.longLongValue) {  //今天
        NSString * sepHour = @"";
        NSString * sepMinute = @"";

        if(minute < 10) {
            sepMinute = @"0";
        }
        if([FMUtils is12HourFormat]) {
            if(hour > 12) {
                strTime = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"message_time_format_afternoon" inTable:nil], sepHour, hour-12, sepMinute, minute];
            } else {
                strTime = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"message_time_format_morning" inTable:nil], sepHour, hour, sepMinute, minute];
            }
        } else {
            if(hour < 10) {
                sepHour = @"0";
            }
            strTime = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"message_time_format_24" inTable:nil], sepHour, hour, sepMinute, minute];
        }
        
    } else if(time.longLongValue >= todayStart.longLongValue + msOfADay.longLongValue && time.longLongValue < todayStart.longLongValue + msOfADay.longLongValue*2) {//明天
        strTime = [[BaseBundle getInstance] getStringByKey:@"message_tomorrow" inTable:nil];
    } else if(time.longLongValue >= todayStart.longLongValue - msOfADay.longLongValue && time.longLongValue < todayStart.longLongValue) {//昨天
        strTime = [[BaseBundle getInstance] getStringByKey:@"message_yestarday" inTable:nil];
    } else {
        strTime = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"message_date_format" inTable:nil], month, day];
    }
    
    return strTime;
}

//构造 NSDate 对象
+ (NSDate *) getDateByYear:(NSInteger) year
                     month:(NSInteger) month
                       day:(NSInteger) day
                      hour:(NSInteger) hour
                    minute:(NSInteger) minute
                    second:(NSInteger) second {
    NSDate * date = nil;
    NSString * dateStr = [[NSString alloc] initWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", year, month, day, hour, minute, second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* localzone = [NSTimeZone localTimeZone];     //按本地时区构造
    [dateFormatter setTimeZone:localzone];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    date = [dateFormatter dateFromString:dateStr];
    return date;
}

//构造 NSDate 对象
+ (NSDate *) getGMTDateByYear:(NSInteger) year
                        month:(NSInteger) month
                          day:(NSInteger) day
                         hour:(NSInteger) hour
                       minute:(NSInteger) minute
                       second:(NSInteger) second {
    NSDate * date = nil;
    NSString * dateStr = [[NSString alloc] initWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld", year, month, day, hour, minute, second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone* localzone = [NSTimeZone localTimeZone];     //按本地时区构造
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0]; //按GMT标准时区构造
    [dateFormatter setTimeZone:GTMzone];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    date = [dateFormatter dateFromString:dateStr];
    return date;
}


//获取时间的字典表示
+ (NSDictionary *) timeLongToDictionary:(NSNumber *) time {
    NSMutableDictionary * res;
    NSDate * date = [FMUtils timeLongToDate:time];
    NSNumber* year ;
    NSNumber* month ;
    NSNumber* day ;
    NSNumber* hour ;
    NSNumber* minute ;
    NSNumber* second ;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [NSNumber numberWithInteger:[components year]];
    month = [NSNumber numberWithInteger:[components month]];
    day = [NSNumber numberWithInteger:[components day]];
    hour = [NSNumber numberWithInteger:[components hour]];
    minute = [NSNumber numberWithInteger:[components minute]];
    second = [NSNumber numberWithInteger:[components second]];
    res = [[NSMutableDictionary alloc] initWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", hour, @"hour", minute, @"minute", second, @"second", nil];
    return res;
}

//获取时间的字典表示
+ (NSDictionary *) dateToDictionary:(NSDate *) date {
    NSMutableDictionary * res;
    NSNumber* year ;
    NSNumber* month ;
    NSNumber* day ;
    NSNumber* hour ;
    NSNumber* minute ;
    NSNumber* second ;
    //    NSCalendar *calender = [NSCalendar currentCalendar];     //本地时间
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //通过日历对象获得日期组件对象NSDateComponents
    NSUInteger units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calender components:units fromDate:date];
    year = [NSNumber numberWithInteger:[components year]];
    month = [NSNumber numberWithInteger:[components month]];
    day = [NSNumber numberWithInteger:[components day]];
    hour = [NSNumber numberWithInteger:[components hour]];
    minute = [NSNumber numberWithInteger:[components minute]];
    second = [NSNumber numberWithInteger:[components second]];
    res = [[NSMutableDictionary alloc] initWithObjectsAndKeys:year, @"year", month, @"month", day, @"day", hour, @"hour", minute, @"minute", second, @"second", nil];
    return res;
}



//判断是否为同一天
+ (BOOL) isTime:(NSNumber *) timeA inTheSameDayOfTime:(NSNumber *) timeB {
    BOOL res = NO;
    NSDate * dateA = [FMUtils timeLongToDate:timeA];
    NSDate * dateB = [FMUtils timeLongToDate:timeB];
    res = [FMUtils isDate:dateA inTheSameDayOfDate:dateB];
    return res;
}

//判断时间的先后 -1(A<B) 0(A=B) 1(A>B)  以天为单位
+ (NSInteger) compareTimeA:(NSNumber *) timeA withTimeB:(NSNumber *) timeB {
    NSInteger result = -1;
    NSNumber * dateA = [FMUtils getFirstSecontNumberOfDay:timeA];
    NSNumber * dateB = [FMUtils getFirstSecontNumberOfDay:timeB];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    NSString *timeStringA = [numFormatter stringFromNumber:dateA];
    NSString *timeStringB = [numFormatter stringFromNumber:dateB];
    
    if ((timeStringA.doubleValue - timeStringB.doubleValue) == 0) {
        result = 0;
    } else if ((timeStringA.doubleValue - timeStringB.doubleValue) < 0) {
        result = -1;
    } else if ((timeStringA.doubleValue - timeStringB.doubleValue) > 0) {
        result = 1;
    }
    
    return result;
}

//判断是否为同一天
+ (BOOL) isDate:(NSDate *) dateA inTheSameDayOfDate:(NSDate *) dateB {
    BOOL res = NO;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsA = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *componentsB = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    
    res = componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
    return res;
}


//判断是否为同一月
+ (BOOL) isTime:(NSNumber *) timeA inTheSameMonthOfTime:(NSNumber *) timeB {
    BOOL res = NO;
    NSDate * dateA = [FMUtils timeLongToDate:timeA];
    NSDate * dateB = [FMUtils timeLongToDate:timeB];
    res = [FMUtils isDate:dateA inTheSameMonthOfDate:dateB];
    return res;
}


//判断是否为同一月
+ (BOOL) isDate:(NSDate *) dateA inTheSameMonthOfDate:(NSDate *) dateB {
    BOOL res = NO;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsA = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    res = componentsA.year == componentsB.year && componentsA.month == componentsB.month;
    return res;
}

//输出当前的时间
+ (void) printCurrentTime {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
}

+ (BOOL) isObjectNull:(id) object {
    BOOL res = NO;
    if(!object || [object isKindOfClass:[NSNull class]]) {
        res = YES;
    }
    return res;
}

//判断 Number 对象是否为空
+ (BOOL) isNumberNullOrZero:(NSNumber*) number {
    BOOL res = NO;
    if(!number || [number isKindOfClass:[NSNull class]] || [number isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        res = YES;
    }
    return res;
}

//过滤 NSString 中的 html 标签
+ (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner * theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@"\n"];
    } // while //
    return html;
}

//判断字符串是否是手机号
+ (BOOL) isMobile:(NSString *) phone {
    BOOL res = NO;
    NSString * MOBILE = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(17[6-8])|(18[0-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    res = [regextestmobile evaluateWithObject:phone];
    return res;
}

//判断是否为小数
+ (BOOL) isFloatNumber:(NSString *) text {
    BOOL res = NO;
    NSString * MOBILE = @"(-?\\d*)(\\d+\\.\\d*)?";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    res = [regextestmobile evaluateWithObject:text];
    return res;
}

//根据文件名获取 mime 类型
+ (NSString *) getMimeTypeByFileName:(NSString *) fileName {
    NSString * mimeType;
    NSString * extName = [[fileName pathExtension] lowercaseString];
    if([extName isEqualToString:@"jpg"] || [extName isEqualToString:@"jpeg"] || [extName isEqualToString:@"png"] || [extName isEqualToString:@"bmp"] || [extName isEqualToString:@"gif"]) {
        mimeType = @"image/png";
    } else if([extName isEqualToString:@"txt"]) {
        mimeType = @"text/plain";
    } else if([extName isEqualToString:@"pdf"]) {
        mimeType = @"application/pdf";
    } else if([extName isEqualToString:@"doc"] || [extName isEqualToString:@"docx"] ) {
        mimeType = @"application/msword";
    } else if([extName isEqualToString:@"xls"] || [extName isEqualToString:@"xlsx"] ) {
        mimeType = @"application/vnd.ms-excel";
    } else if([extName isEqualToString:@"ppt"] || [extName isEqualToString:@"pps"] ) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if([extName isEqualToString:@"mp3"] || [extName isEqualToString:@"aac"] ) {
        mimeType = @"audio/mpeg";
    }
    
    return mimeType;
}

//获取格式化的手机号码 比如 “151 XXXX XXXX”
+ (NSString *) getFormatMobile:(NSString *) phone {
    NSString * res = @"";
    if(phone && [FMUtils isMobile:phone]) {
        NSMutableString * str = [[NSMutableString alloc] initWithString:phone];
        [str insertString:@" " atIndex:3];
        [str insertString:@" " atIndex:8];
        res = str;
    }
    return res;
}

//获取格式化的手机号码 比如 “151*****XXX”
+ (NSString *) getSecretFormatMobile:(NSString *) phone {
    NSString * res = @"";
    if(phone && [FMUtils isMobile:phone]) {
        NSMutableString * str = [[NSMutableString alloc] initWithString:phone];
        NSRange range = NSMakeRange(3,5);
        [str replaceCharactersInRange:range withString:@"*****"];
        res = [str copy];
    }
    return res;
}

+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

//删除指定路径下的指定图片
+ (void) deleteFileWithPath:(NSString *) path andName:(NSString *) name {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:path] stringByAppendingPathComponent:name];
    
    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (!exist) {
        NSLog(@"没有该图片。");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:fullPath error:nil];
        if (blDele) {
            NSLog(@"删除成功---%@", fullPath);
        }else {
            NSLog(@"删除失败---%@", fullPath);
        }
        
    }
}

//删除 Documents 目录下的指定图片
+ (void) deleteDocumentsWithName:(NSString *) name {
    NSString * path = @"Documents";
    [FMUtils deleteFileWithPath:path andName:name];
}

//获取图片
+ (UIImage *) getImageWithName:(NSString *) name {
    UIImage * image;
    UIImage * tmpImage;
    NSString * path = @"Documents";
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:path] stringByAppendingPathComponent:name];
    if(![FMUtils isStringEmpty:name]) {
        tmpImage = [UIImage imageWithContentsOfFile:fullPath];
        tmpImage = [FMUtils fixOrientation:tmpImage];
    }
    image = tmpImage;
    return image;
}

//修正图片的方向，防止上传之后图片的显示方向为横着的
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取缩略图
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

//保持原来的长宽比，获取一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

//获取缩略图
+ (UIImage *) thumbnailWithAssetUrl:(NSURL *) url time:(CGFloat) second {
    UIImage * image;
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    NSError *error = nil;
    CMTime time = CMTimeMake(second,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    image = [UIImage imageWithCGImage:cgImage];
    UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
    CGImageRelease(cgImage);
    NSLog(@"视频截取成功");
    return image;
}

+ (UIImage *)addWaterMarkInImage:(UIImage *)img withText:(NSString *) desc {
    //get image width and height

    CGFloat width = img.size.width;
    CGFloat height = img.size.height;
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, width, height)];
    
    
    //四个参数为水印图片的位置
    CGFloat paddingLeft = 60;
    CGFloat mheight = 100;
    CGFloat paddingBottom = 100;
    CGRect mframe = CGRectMake(paddingLeft, height-mheight-paddingBottom, width-paddingLeft*2, mheight);
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:60];
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor redColor],
                                 NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    [desc drawInRect:mframe withAttributes:attributes];
//    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//视频文件压缩，异步操作
+ (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusUnknown:
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted:{
                handler(exportSession);
                break;
            }
            case AVAssetExportSessionStatusFailed:
                break;
            default:
                break;
        }
    }];
}


+ (void) makeCallWith:(NSString *) phoneNum container:(UIViewController *) container {
    if(![FMUtils isStringEmpty:phoneNum] && [FMUtils isMobile:phoneNum]) {

        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
        //显示弹框
//        UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
//        [container.view addSubview:phoneCallWebView];
    } else {
        if([container isKindOfClass:[BaseViewController class]]) {
            BaseViewController * baseVC = (BaseViewController *)container;
            [baseVC showAutoDismissMessageWith:[[BaseBundle getInstance] getStringByKey:@"notice_title_info" inTable:nil] andMessage:[[BaseBundle getInstance] getStringByKey:@"order_notice_call_fail_telno" inTable:nil] time:DIALOG_ALIVE_TIME_SHORT];
        }
    }
}


+ (UIImage *) buttonImageFromColor:(UIColor *)color width:(CGFloat) width height:(CGFloat) height{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIViewController *) getRootViewController
{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    return topVC;
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//依据实际最大值来计算所需要的纵坐标的最大值，count 表示坐标系纵坐标展示的数量
+ (NSInteger) getYMaxByMaxValue:(NSInteger) maxValue count:(NSInteger) count {
    NSInteger yMax = maxValue;
    if(count > 0) {
        NSInteger ystep = maxValue / count;
        NSInteger tmp = ystep;
        NSInteger k = 1;
        while (tmp > 10) {
            k *= 10;
            tmp /= 10;
        }
        if(maxValue > tmp * k || tmp == 0) {
            tmp++;
        }
        yMax = tmp * k * count;
    } else {
        yMax = 10;
    }
    return yMax;
}

+ (BOOL)isSystemVersioniOS8 {
    //check systemVerson of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}

+ (BOOL) isAllowedNotification {//iOS8 check if user allow notification
    if ([FMUtils isSystemVersioniOS8]) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

+ (float) fileSizeAtPath:(NSString *) path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0;
    }
    return 0;
}

+ (float) folderSizeAtPath:(NSString *) path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [FMUtils fileSizeAtPath:absolutePath];
        }
    }
    return folderSize;
}

//计算目录下指定类型的文件的大小
+ (float) folderSizeAtPath:(NSString *)path withPredicate:(NSPredicate *) predicate {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles= [[fileManager subpathsAtPath:path] filteredArrayUsingPredicate:predicate];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            float tmpSize = [FMUtils fileSizeAtPath:absolutePath];
            if(tmpSize > 0) {
                folderSize += tmpSize;
            }
        }
    }
    return folderSize;
}


//清除缓存文件
+ (void) clearFile:(NSString *) path withPredicate:(NSPredicate *) predicate {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[[fileManager subpathsAtPath:path] filteredArrayUsingPredicate:predicate];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
//    [[SDImageCache sharedImageCache] cleanDisk];
}

//如果存在文件，则将其删除
+ (void) deleteFileByPath:(NSString *) fullpath {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullpath]) {
        [fileManager removeItemAtPath:fullpath error:nil];
    }
}

//获取中文首字母
+ (NSString *) getFirstCharactorOf:(NSString *) str {
    NSString * ch;
    //先获取拼音
    NSString * pinyin = [FMUtils getPinYinOf:str];
    ch = [pinyin substringToIndex:1];
    return ch;
}

//获取中文首字母（大写形式）
+ (NSString *) getFirstCharactorSpellOf:(NSString *) str {
    NSString * ch;
    //先获取拼音
    NSString * pinyin = [FMUtils getPinYinOf:str];
    //分隔
    NSArray * array = [pinyin componentsSeparatedByString:@" "];
    //组装
    NSInteger count = [array count];
    if(count > 0) {
        ch = @"";
        for(NSInteger index = 0; index < count; index++) {
            NSString * tmpStr = array[index];
            ch = [ch stringByAppendingString:[tmpStr substringToIndex:1]];
        }
    }
    return ch;
}

//获取汉字的拼音，以空格分隔
+ (NSString *) getPinYinOf:(NSString *) str {
    NSString * pinyin;
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    pinyin = [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return pinyin;
}

//获取图片URL
+ (NSURL *) getUrlOfImageById:(NSNumber *) imgId {
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * path = [[NSString alloc] initWithFormat:@"/common/files/id/%lld/img", [imgId longLongValue]];
    NSString* strUrl = [[NSString alloc] initWithFormat:@"%@%@?access_token=%@", [SystemConfig getServerAddress], path, token];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

//获取音频URL
+ (NSURL *) getUrlOfAudioById:(NSNumber *) audioId {
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSString * path = [[NSString alloc] initWithFormat:@"/common/media/%lld", [audioId longLongValue]];
    NSString* strUrl = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], path, devId, token];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

//获取视频URL
+ (NSURL *) getUrlOfVideoById:(NSNumber *) videoId {
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSString * path = [[NSString alloc] initWithFormat:@"/common/media/%lld", [videoId longLongValue]];
    NSString* strUrl = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], path, devId, token];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

//获取附件URL
+ (NSURL *) getUrlOfAttachmentById:(NSNumber *) attachmentId {
    NSString * token = [[SystemConfig getOauthFM] getToken].mAccessToken;
    NSString * devId = [FMUtils getDeviceIdString];
    NSString * path = [[NSString alloc] initWithFormat:@"/common/files/id/%lld", [attachmentId longLongValue]];
    NSString* strUrl = [[NSString alloc] initWithFormat:@"%@%@?device_id=%@&access_token=%@", [SystemConfig getServerAddress], path, devId, token];
    NSURL * url = [NSURL URLWithString:strUrl];
    return url;
}

//获取当前的语言环境
+ (NSString*)getPreferredLanguage {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    NSString * res = @"en_US";
    if([FMUtils isString:preferredLang startWith:@"zh"]) {
        res = @"zh_CN";
    }
    return res;
}

+ (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//根据URL获取未知文件的文件名字
+ (NSString *) getFileNameByURL:(NSURL *) url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    NSArray *nameArray = [response.suggestedFilename componentsSeparatedByString:@"."];
    NSString* strAfterDecodeByUTF8AndURI = [nameArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    strAfterDecodeByUTF8AndURI = [strAfterDecodeByUTF8AndURI stringByAppendingString:[NSString stringWithFormat:@".%@",nameArray[1]]];
    strAfterDecodeByUTF8AndURI = [strAfterDecodeByUTF8AndURI stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    NSLog(@"UTF8文件名是：%@",response.suggestedFilename);
    NSLog(@"实际文件名是：%@",strAfterDecodeByUTF8AndURI);
    
    return strAfterDecodeByUTF8AndURI;
}

//判断是否为竖屏
+ (BOOL) isVerticalScreen {
    BOOL res = YES;
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    if(size.width > size.height) {
        res = NO;
    }
    return res;
}

//比较两个浮点数的大小 -1--小于  0--等于  1--大于
+ (NSInteger) compareFloatA:(CGFloat)floatA andFloadB:(CGFloat)floadB {
    NSInteger res = 0;
    if (floatA > floadB) {
        res = 1;
    }
    if (floatA < floadB) {
        res = -1;
    }
    
    CGFloat absoluteValue = fabs(floatA - floadB);
    if (absoluteValue <= 1e-6) {
        res = 0;
    }
    
    return res;
}

//比较两个浮点数的大小 -1--小于  0--等于  1--大于
+ (NSInteger) compareDoubleA:(double) valueA andDoubleB:(double) valueB {
    NSInteger res = 0;
    if (valueA > valueB) {
        res = 1;
    }
    if (valueA < valueB) {
        res = -1;
    }
    
    CGFloat absoluteValue = fabs(valueA - valueB);
    if (absoluteValue <= 1e-6) {
        res = 0;
    }
    
    return res;
}

//获取当前连接的 wifi 的信息
+ (NSDictionary *) getCurrentWiFiInfo {
    NSMutableDictionary *wifiDic = [[NSMutableDictionary alloc] init];
    NSString *Name = @"";
    NSString *MAC = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            Name = [dict valueForKey:@"SSID"];           //WiFi名称
            MAC = [dict valueForKey:@"BSSID"];     //Mac地址
            [wifiDic setValue:Name forKeyPath:@"name"];
            [wifiDic setValue:MAC forKeyPath:@"mac"];
        }
    }
    CFRelease(myArray);
    
    return wifiDic;
}

@end
