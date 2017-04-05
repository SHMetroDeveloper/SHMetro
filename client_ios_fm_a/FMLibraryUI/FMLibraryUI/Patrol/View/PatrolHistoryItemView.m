//
//  PatrolHistoryItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/29.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "PatrolHistoryItemView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "FMUtils.h"
#import "ColorLabel.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseLabelView.h"

@interface PatrolHistoryItemView ()

@property (readwrite, nonatomic, strong) PatrolTaskHistoryItem * task;


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
//@property (readwrite, nonatomic, strong) UILabel * contactLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * startTimeLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * endTimeLbl;
@property (readwrite, nonatomic, strong) UILabel * spotCountLbl;

@property (readwrite, nonatomic, strong) ColorLabel * ignoreLbl;   //漏检
@property (readwrite, nonatomic, strong) ColorLabel * exceptionLbl;//异常
@property (readwrite, nonatomic, strong) ColorLabel * reportLbl;   //报修
@property (readwrite, nonatomic, strong) ColorLabel * typeLbl;   //巡检类型

@property (readwrite, nonatomic, assign) CGFloat spotCountWidth;
//@property (readwrite, nonatomic, assign) CGFloat contactWidth;  //联系人所占宽度

@property (readwrite, nonatomic, assign) CGFloat ignoreWidth;
@property (readwrite, nonatomic, assign) CGFloat exceptionWidth;
@property (readwrite, nonatomic, assign) CGFloat photoWidth;
@property (readwrite, nonatomic, assign) CGFloat reportWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat paddingTop;
@property (readwrite, nonatomic, assign) CGFloat paddingBottom;
@end

@implementation PatrolHistoryItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _spotCountWidth = 60;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        _paddingTop = 0;
        _paddingBottom = 0;
//        _contactWidth = 0;
        
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
        
//        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _startTimeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _endTimeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
//        _spotCountLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
//        [_contactLbl setTextAlignment:NSTextAlignmentCenter];
//        [_spotCountLbl setTextAlignment:NSTextAlignmentRight];

        
        [_ignoreLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [_ignoreLbl setShowCorner:YES];
        
        [_exceptionLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
        [_exceptionLbl setShowCorner:YES];
        
        [_reportLbl setTextColor:[UIColor whiteColor] andBorderColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] andBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        [_reportLbl setShowCorner:YES];
        
        [_typeLbl setShowCorner:YES];
        
        [self addSubview:_nameLbl];
        [self addSubview:_startTimeLbl];
        [self addSubview:_endTimeLbl];
        [self addSubview:_spotCountLbl];
        
        [self addSubview:_ignoreLbl];
        [self addSubview:_exceptionLbl];
        [self addSubview:_reportLbl];
        [self addSubview:_typeLbl];
    }
    return self;
}

- (void) updateViews {
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
    BOOL hasPhoto = NO;
    BOOL hasRepair = NO;
    
    if(_task) {
        if([_task getIgnoreCount] > 0) {
            hasIgnore = YES;
        }
        if([_task getExceptionCount] > 0) {
            hasException = YES;
        }
        if([_task hasPhoto]) {
            hasPhoto = YES;
        }
        if([_task getRepairCount]) {
            hasRepair = YES;
        }
    }
    
    sepHeight = (height - nameHeight - msgHeight * 2) / 4;
    originY = sepHeight;
    
    CGFloat stateWidth = 0;
    CGSize size;
    CGSize typeSize;
    NSString * strType = [PatrolServerConfig getTaskTypeDescription:_task.taskType];
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
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_task.patrolName];
    if(nameWidth > width-_paddingLeft - _paddingRight-stateWidth) {
        nameWidth = width-_paddingLeft - _paddingRight-stateWidth;
    }
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, nameWidth, nameHeight)];
    
//    [_contactLbl setFrame:CGRectMake(_paddingLeft + nameWidth + sepWidth, originY, _contactWidth, nameHeight)];
    originY+= nameHeight + sepHeight;
    
    
    
    [_startTimeLbl setFrame:CGRectMake(0, originY, width, msgHeight)];
    originY+= msgHeight + sepHeight;
    
    [_endTimeLbl setFrame:CGRectMake(0, originY, width - _spotCountWidth, msgHeight)];
    
    [_spotCountLbl setFrame:CGRectMake(width-_paddingRight-_spotCountWidth, originY, _spotCountWidth, msgHeight)];
    originY+= msgHeight + sepHeight;
    
    [self updateInfo];
}

- (void) setInfoWithPatrolTask:(PatrolTaskHistoryItem *) task {
    _task = task;
    [self updateViews];
}

- (void) updateInfo {
    
    if(_task) {
        [_nameLbl setText:_task.patrolName];

        [_startTimeLbl setContent:[_task getStartTimeString]];
        [_endTimeLbl setContent:[_task getEndTimeString]];
        
        [_spotCountLbl setText:[[NSString alloc] initWithFormat:[[BaseBundle getInstance] getStringByKey:@"patrol_spot_amount" inTable:nil], [_task getSpotCount]]];
        
        if([_task getIgnoreCount] > 0) {
            [_ignoreLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_leak" inTable:nil]];
            [_ignoreLbl setHidden:NO];
        } else {
            [_ignoreLbl setHidden:YES];
        }
        if([_task getExceptionCount] > 0) {
            [_exceptionLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_exception" inTable:nil]];
            [_exceptionLbl setHidden:NO];
        } else {
            [_exceptionLbl setHidden:YES];
        }
        if([_task getRepairCount]) {
            [_reportLbl setContent:[[BaseBundle getInstance] getStringByKey:@"patrol_status_report" inTable:nil]];
            [_reportLbl setHidden:NO];
        } else {
            [_reportLbl setHidden:YES];
        }
        
        /* 巡检与巡视颜色区分 */
        UIColor *backgroundColor;
        if (_task.taskType == PATROL_TASK_TYPE_INSPECTION) {
            
            backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
        }
        else if (_task.taskType == PATROL_TASK_TYPE_PATROL) {
            
            backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
        }
        [_typeLbl setTextColor:[UIColor whiteColor] andBorderColor:backgroundColor andBackgroundColor:backgroundColor];
        NSString * strType = [PatrolServerConfig getTaskTypeDescription:_task.taskType];
        [_typeLbl setContent:strType];
    }
}

- (void) onViewSizeChanged:(UIView *)view newSize:(CGSize)newSize {
    CGRect frame;
    if(view == _ignoreLbl) {
        frame = _ignoreLbl.frame;
        frame.size = newSize;
        _ignoreLbl.frame = frame;
        _ignoreWidth = newSize.width;
    } 
    if(view == _exceptionLbl) {
        frame = _exceptionLbl.frame;
        frame.size = newSize;
        _exceptionLbl.frame = frame;
        _exceptionWidth = newSize.width;
    }
    if(view == _reportLbl) {
        frame = _reportLbl.frame;
        frame.size = newSize;
        _reportLbl.frame = frame;
        _reportWidth = newSize.width;
    }
    [self updateViews];
    
}

@end
