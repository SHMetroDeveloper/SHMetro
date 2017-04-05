//
//  QuickReportEquipmentTabBarView.h
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/10.
//  Copyright © 2017年 facility. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuickReportEquipmentTabActionType) {
    QUICK_REPORT_EQUIPMENT_TAB_ACTION_SELECT,      //直接选择
    QUICK_REPORT_EQUIPMENT_TAB_ACTION_QR_SCAN,     //扫码添加
};

typedef void(^QuickReportEquipmentTabActionBlock)(QuickReportEquipmentTabActionType type, id object);

@interface QuickReportEquipmentTabBarView : UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier;

@property (nonatomic, copy) QuickReportEquipmentTabActionBlock actionBlock;

+ (CGFloat)getItemHeight;

@end
