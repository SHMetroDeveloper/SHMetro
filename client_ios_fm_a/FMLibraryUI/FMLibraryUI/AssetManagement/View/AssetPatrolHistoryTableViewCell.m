//
//  AssetPatrolHistoryTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/8.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetPatrolHistoryTableViewCell.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "ColorLabel.h"
#import "SeperatorView.h"
#import "PatrolServerConfig.h"

@interface AssetPatrolHistoryTableViewCell ()

@property (readwrite, nonatomic, strong) AssetPatrolRecordEntity * patrolHistory;

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * startTimeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * endTimeLbl;
@property (readwrite, nonatomic, strong) UILabel * spotCountLbl;

@property (readwrite, nonatomic, strong) ColorLabel * ignoreLbl;   //漏检
@property (readwrite, nonatomic, strong) ColorLabel * exceptionLbl;//异常
@property (readwrite, nonatomic, strong) ColorLabel * reportLbl;   //报修
@property (readwrite, nonatomic, strong) ColorLabel * typeLbl;   //巡检类型

@property (nonatomic, strong) SeperatorView *seperator;

@property (readwrite, nonatomic, assign) CGFloat spotCountWidth;
@property (readwrite, nonatomic, assign) CGFloat ignoreWidth;
@property (readwrite, nonatomic, assign) CGFloat exceptionWidth;
@property (readwrite, nonatomic, assign) CGFloat photoWidth;
@property (readwrite, nonatomic, assign) CGFloat reportWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation AssetPatrolHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _spotCountWidth = 60;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = 0;
        _paddingBottom = 0;
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [FMFont getInstance].font44;
        _nameLbl.textColor = contentColor;
        
        _startTimeLbl = [[BaseLabelView alloc] init];
        [_startTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"time_start_estimate" inTable:nil] andLabelWidth:0];
        [_startTimeLbl setLabelFont:mFont andColor:labelColor];
        [_startTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_startTimeLbl setContentAlignment:NSTextAlignmentLeft];
        [_startTimeLbl setContentFont:mFont];
        [_startTimeLbl setContentColor:contentColor];
        
        _endTimeLbl = [[BaseLabelView alloc] init];
        [_endTimeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"time_end_estimate" inTable:nil] andLabelWidth:0];
        [_endTimeLbl setLabelFont:mFont andColor:labelColor];
        [_endTimeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_endTimeLbl setContentAlignment:NSTextAlignmentLeft];
        [_endTimeLbl setContentFont:mFont];
        [_endTimeLbl setContentColor:contentColor];
        
        _spotCountLbl = [[UILabel alloc] init];
        _spotCountLbl.font = mFont;
        _spotCountLbl.textColor = contentColor;
        _spotCountLbl.textAlignment = NSTextAlignmentRight;
        
        _ignoreLbl = [[ColorLabel alloc] init];
        _exceptionLbl = [[ColorLabel alloc] init];
        _reportLbl = [[ColorLabel alloc] init];
        _typeLbl = [[ColorLabel alloc] init];
        
        [_ignoreLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_ignoreLbl setShowCorner:YES];
        
        [_exceptionLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_exceptionLbl setShowCorner:YES];
        
        [_reportLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_reportLbl setShowCorner:YES];
        
        [_typeLbl setShowCorner:YES];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_startTimeLbl];
        [self.contentView addSubview:_endTimeLbl];
        [self.contentView addSubview:_spotCountLbl];
        [self.contentView addSubview:_ignoreLbl];
        [self.contentView addSubview:_exceptionLbl];
        [self.contentView addSubview:_reportLbl];
        [self.contentView addSubview:_typeLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    
    CGFloat nameHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat sepHeight = 0;
    CGFloat sepWidth = 8;
    CGFloat originY = padding;
    
    BOOL hasIgnore = NO;
    BOOL hasException = NO;
    BOOL hasRepair = NO;
    
    if(_patrolHistory) {
        if(_patrolHistory.leakNumber > 0) {
            hasIgnore = YES;
        }
        if(_patrolHistory.exceptionNumber > 0) {
            hasException = YES;
        }
        if(_patrolHistory.repairNumber) {
            hasRepair = YES;
        }
    }
    
    sepHeight = (height - nameHeight - msgHeight * 2) / 4;
    originY = sepHeight;
    
    CGFloat stateWidth = 0;
    CGSize size;
    CGSize typeSize;
    NSString * strType = [PatrolServerConfig getTaskTypeDescription:_patrolHistory.taskType];
    typeSize = [ColorLabel calculateSizeByInfo:strType];
    
    if(hasRepair) {
        size = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
        stateWidth += size.width;
        [_reportLbl setFrame:CGRectMake(width-_paddingRight-stateWidth, originY + (nameHeight - size.height)/2, size.width, size.height)];
    }
    if(hasException) {
        if(stateWidth > 0) {
            stateWidth += sepWidth;
        }
        size = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
        stateWidth += size.width;
        [_exceptionLbl setFrame:CGRectMake(width-_paddingRight-stateWidth, originY + (nameHeight - size.height)/2, size.width, size.height)];
    }
    if(hasIgnore) {
        if(stateWidth > 0) {
            stateWidth += sepWidth;
        }
        size = [ColorLabel calculateSizeByInfo:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
        stateWidth += size.width;
        [_ignoreLbl setFrame:CGRectMake(width-_paddingRight-stateWidth, originY + (nameHeight - size.height)/2, size.width, size.height)];
    }
    
    if(stateWidth > 0) {
        stateWidth += sepWidth;
    }
    stateWidth += typeSize.width;
    [_typeLbl setFrame:CGRectMake(width-_paddingRight-stateWidth, originY + (nameHeight - typeSize.height)/2, typeSize.width, typeSize.height)];
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_patrolHistory.patrolName];
    if(nameWidth > width-_paddingLeft - _paddingRight-stateWidth) {
        nameWidth = width-_paddingLeft - _paddingRight-stateWidth;
    }
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, nameWidth, nameHeight)];
    originY+= nameHeight + sepHeight;
    
    [_startTimeLbl setFrame:CGRectMake(0, originY, width, msgHeight)];
    originY+= msgHeight + sepHeight;
    
    [_endTimeLbl setFrame:CGRectMake(0, originY, width - _spotCountWidth, msgHeight)];
    
    [_spotCountLbl setFrame:CGRectMake(width-_paddingRight-_spotCountWidth, originY, _spotCountWidth, msgHeight)];
    originY+= msgHeight + sepHeight;
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    
    if(_patrolHistory) {
        [_nameLbl setText:_patrolHistory.patrolName];
        
        [_startTimeLbl setContent:[FMUtils timeLongToDateStringWithOutYear:_patrolHistory.dueStartDateTime]];
        [_endTimeLbl setContent:[FMUtils timeLongToDateStringWithOutYear:_patrolHistory.dueEndDateTime]];
        
        [_spotCountLbl setText:[[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_amount" inTable:nil], _patrolHistory.spotNumber]];
        
        if(_patrolHistory.leakNumber > 0) {
            [_ignoreLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
            [_ignoreLbl setHidden:NO];
        } else {
            [_ignoreLbl setHidden:YES];
        }
        if(_patrolHistory.exceptionNumber > 0) {
            [_exceptionLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
            [_exceptionLbl setHidden:NO];
        } else {
            [_exceptionLbl setHidden:YES];
        }
        if(_patrolHistory.repairNumber) {
            [_reportLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
            [_reportLbl setHidden:NO];
        } else {
            [_reportLbl setHidden:YES];
        }
        
        /* 巡检与巡视颜色区分 */
        UIColor *backgroundColor;
        if (_patrolHistory.taskType == PATROL_TASK_TYPE_INSPECTION) {
            
            backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        }
        else if (_patrolHistory.taskType == PATROL_TASK_TYPE_PATROL) {
            
            backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        }
        [_typeLbl setTextColor:[UIColor whiteColor] andBorderColor:backgroundColor andBackgroundColor:backgroundColor];
        NSString * strType = [PatrolServerConfig getTaskTypeDescription:_patrolHistory.taskType];
        [_typeLbl setContent:strType];
    }
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setPatrolHistory:(AssetPatrolRecordEntity *) patrolHistory {
    
    _patrolHistory = patrolHistory;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat nameHeight = 19;
    CGFloat padding = 15;
    
    height = nameHeight+itemHeight*3 + padding*5;
    
    return height;
}

@end
