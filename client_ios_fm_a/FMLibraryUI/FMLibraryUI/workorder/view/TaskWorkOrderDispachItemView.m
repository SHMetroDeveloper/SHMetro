//
//  TaskWorkOrderDispachItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "TaskWorkOrderDispachItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"



@interface TaskWorkOrderDispachItemView ()
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) NSString * serviceType;
@property (readwrite, nonatomic, strong) NSString * priority;
@property (readwrite, nonatomic, strong) NSString * location;


@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * serviceTypeLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) UILabel * locationLbl;
@property (readwrite, nonatomic, strong) UIButton * diapachBtn;
@end

@implementation TaskWorkOrderDispachItemView
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
        self.locationLbl = [[UILabel alloc] init];
        self.timeLbl = [[UILabel alloc] init];
        self.serviceTypeLbl = [[UILabel alloc] init];
        self.priorityLbl = [[UILabel alloc] init];
        self.diapachBtn = [[UIButton alloc] init];
        
        [self.codeLbl setFont:msgFont];
        [self.locationLbl setFont:msgFont];
        [self.timeLbl setFont:msgFont];
        [self.serviceTypeLbl setFont:msgFont];
        [self.priorityLbl setFont:msgFont];
        
        
        
        [self.priorityLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [self.diapachBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        
        CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
        CGFloat sepHeight = (height - msgHeight * 3)/4;
        
        [self.codeLbl setFrame:CGRectMake(orginX, sepHeight, width - orginX*2 - stateWidth, msgHeight)];
        [self.serviceTypeLbl setFrame:CGRectMake(orginX, sepHeight*2+msgHeight, width - orginX*2, msgHeight)];
        [self.locationLbl setFrame:CGRectMake(orginX, sepHeight*3+msgHeight*2, width - orginX * 2, msgHeight)];
        [self.timeLbl setFrame:CGRectMake(width-orginX-stateWidth, sepHeight, stateWidth, msgHeight)];
        
        [self.priorityLbl setFrame:CGRectMake(width-stateWidth*2 - orginX*2, sepHeight, stateWidth, msgHeight)];
        [self.diapachBtn setFrame:CGRectMake(width-orginX-stateWidth, height - sepHeight - imgWidth, stateWidth, msgHeight+sepHeight)];
        
        [self.diapachBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_dispach" inTable:nil] forState:UIControlStateNormal];
        
        [self addSubview:self.codeLbl];
        [self addSubview:self.locationLbl];
        [self addSubview:self.timeLbl];
        [self addSubview:self.serviceTypeLbl];
        [self addSubview:self.priorityLbl];
        [self addSubview:self.diapachBtn];
        
    }
    return self;
}

- (void) setInfoWithCode:(NSString*) code
                    location:(NSString*) location
                    time:(NSString*) time
               serviceType:(NSString*) serviceType
                priority:(NSString*) priority {
    self.code = code;
    self.time = time;
    self.serviceType = serviceType;
    self.priority = priority;
    self.location = location;
    
    [self updateInfo];
}

- (void) updateInfo {
    [self.codeLbl setText:self.code];
    [self.locationLbl setText:self.location];
    [self.timeLbl setText:self.time];
    NSString* strServiceType = [[NSString alloc] initWithFormat:@"%@:%@", [[BaseBundle getInstance] getStringByKey:@"service_type" inTable:nil], self.serviceType];
    [self.serviceTypeLbl setText:strServiceType];
    [self.priorityLbl setText:self.priority];
}

@end


