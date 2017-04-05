//
//  AttendanceSettingShowMoreTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/9/22.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "AttendanceSettingShowMoreTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "FMTheme.h"
#import "BaseBundle.h"

@interface AttendanceSettingShowMoreTableViewCell ()

@end

@implementation AttendanceSettingShowMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.text = [[BaseBundle getInstance] getStringByKey:@"cell_show_all_detail" inTable:nil];
        self.textLabel.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        self.textLabel.font = [FMFont setFontByPX:42];
    }
    return self;
}

+ (CGFloat)calculateHeight {
    CGFloat height = 50;
    
    return height;
}
@end

