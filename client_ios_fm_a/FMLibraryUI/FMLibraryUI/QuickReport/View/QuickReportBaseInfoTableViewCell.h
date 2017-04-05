//
//  QuickReportBaseInfoTableViewCell.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/9.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnItemClickListener.h"

typedef NS_ENUM(NSInteger, QuickReportBaseItemType) {
    QUICK_REPORT_BASE_ITEM_TYPE_APPLICANT,         //部门
    QUICK_REPORT_BASE_ITEM_TYPE_PHONE,
    QUICK_REPORT_BASE_ITEM_TYPE_SERVICE,    //服务类型
    QUICK_REPORT_BASE_ITEM_TYPE_LOCATION,     //站点
};

@interface QuickReportBaseInfoTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setApplicant:(NSString *)applicant
         phoneNumber:(NSString *)phoneNumber
         serviceType:(NSString *)serviceType
            location:(NSString *)location;

- (NSString *)phoneNumber;

- (void) setOnItemLickListener:(id<OnItemClickListener>) listener;

+ (CGFloat)getItemHeight;

@end
