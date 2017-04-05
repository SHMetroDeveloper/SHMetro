//
//  TaskWorkOrderCheckItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "TaskWorkOrderCheckItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseBundle.h"
#import "FMSize.h"
#import "FMFont.h"



@interface TaskWorkOrderCheckItemView ()
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) NSString * checkType;
@property (readwrite, nonatomic, strong) NSString * priority;
@property (readwrite, nonatomic, strong) NSString * desc;


@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * checkTypeLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIButton * checkBtn;
@end

@implementation TaskWorkOrderCheckItemView
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat orginX = 10;
        CGFloat imgWidth = 32;
        CGFloat stateWidth = 80;
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        
        
        self.codeLbl = [[UILabel alloc] initWithFrame:CGRectMake(orginX, 10, width -stateWidth - orginX, 30)];
        self.descLbl = [[UILabel alloc] init];
        self.timeLbl = [[UILabel alloc] init];
        self.checkTypeLbl = [[UILabel alloc] init];
        self.priorityLbl = [[UILabel alloc] init];
        self.checkBtn = [[UIButton alloc] init];
        
        [self.codeLbl setFont:msgFont];
        [self.descLbl setFont:msgFont];
        [self.timeLbl setFont:msgFont];
        [self.checkTypeLbl setFont:msgFont];
        [self.priorityLbl setFont:msgFont];
        
        
        
        [self.priorityLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [self.checkBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        
        CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
        CGFloat sepHeight = (height - msgHeight * 3)/4;
        
        [self.codeLbl setFrame:CGRectMake(orginX, sepHeight, width - orginX*2 - stateWidth, msgHeight)];
        [self.descLbl setFrame:CGRectMake(orginX, sepHeight*2+msgHeight, width - orginX*2, msgHeight)];
        [self.checkTypeLbl setFrame:CGRectMake(orginX, sepHeight*3+msgHeight*2, width - orginX * 2, msgHeight)];
        [self.timeLbl setFrame:CGRectMake(width-orginX-stateWidth, sepHeight, stateWidth, msgHeight)];
        
        [self.priorityLbl setFrame:CGRectMake(width-stateWidth*2 - orginX*2, sepHeight, stateWidth, msgHeight)];
        [self.checkBtn setFrame:CGRectMake(width-orginX-stateWidth, height - sepHeight - imgWidth, stateWidth, msgHeight+sepHeight)];
        
        [self.checkBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_approval" inTable:nil] forState:UIControlStateNormal];
        
        [self addSubview:self.codeLbl];
        [self addSubview:self.descLbl];
        [self addSubview:self.timeLbl];
        [self addSubview:self.checkTypeLbl];
        [self addSubview:self.priorityLbl];
        [self addSubview:self.checkBtn];
        
    }
    return self;
}

- (void) setInfoWithCode:(NSString*) code
                    desc:(NSString*) desc
                    time:(NSString*) time
                checkType:(NSString*) checkType
                priority:(NSString*) priority {
    self.code = code;
    self.time = time;
    self.checkType = checkType;
    self.priority = priority;
    self.desc = desc;
    
    [self updateInfo];
}

- (void) updateInfo {
    [self.codeLbl setText:self.code];
    [self.descLbl setText:self.desc];
    [self.timeLbl setText:self.time];
    NSString* strCheck = [[NSString alloc] initWithFormat:@"%@:%@", [[BaseBundle getInstance] getStringByKey:@"order_approval_type" inTable:nil], self.checkType];
    [self.checkTypeLbl setText:strCheck];
    [self.priorityLbl setText:self.priority];
}

@end

