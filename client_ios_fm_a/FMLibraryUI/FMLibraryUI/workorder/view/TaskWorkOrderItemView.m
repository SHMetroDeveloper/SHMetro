//
//  TaskWorkOrderItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/21.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "TaskWorkOrderItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"

NSInteger const TASK_WORK_ORDER_STATUS_RECEIVE = 100;       //接单
NSInteger const TASK_WORK_ORDER_STATUS_HANDLE = 200;       //处理工单


@interface TaskWorkOrderItemView ()
@property (readwrite, nonatomic, strong) NSString * code;
@property (readwrite, nonatomic, strong) NSString * time;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, assign) NSInteger opration;
@property (readwrite, nonatomic, strong) NSString * priority;
@property (readwrite, nonatomic, strong) NSString * desc;


@property (readwrite, nonatomic, strong) UILabel * codeLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * locationLbl;
@property (readwrite, nonatomic, strong) UILabel * priorityLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIImageView * moreImgView;
@property (readwrite, nonatomic, strong) UIButton * receiveBtn;
@end

@implementation TaskWorkOrderItemView
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
        self.locationLbl = [[UILabel alloc] init];
        self.moreImgView = [[UIImageView alloc] init];
        self.priorityLbl = [[UILabel alloc] init];
        self.receiveBtn = [[UIButton alloc] init];
        
        [self.codeLbl setFont:msgFont];
        [self.descLbl setFont:msgFont];
        [self.timeLbl setFont:msgFont];
        [self.locationLbl setFont:msgFont];
        [self.priorityLbl setFont:msgFont];
        
        
        
        
        [self.priorityLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE]];
        [self.receiveBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] forState:UIControlStateNormal];
        [self.receiveBtn setBackgroundColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE]];
        
        CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
        CGFloat sepHeight = (height - msgHeight * 3)/4;
        
        [self.codeLbl setFrame:CGRectMake(orginX, sepHeight, width - orginX*2 - stateWidth, msgHeight)];
        [self.descLbl setFrame:CGRectMake(orginX, sepHeight*2+msgHeight, width - orginX*2, msgHeight)];
        [self.locationLbl setFrame:CGRectMake(orginX, sepHeight*3+msgHeight*2, width - orginX * 2, msgHeight)];
        [self.timeLbl setFrame:CGRectMake(width-orginX-stateWidth, sepHeight, stateWidth, msgHeight)];
        
        [self.priorityLbl setFrame:CGRectMake(width-stateWidth*2 - orginX*2, sepHeight, stateWidth, msgHeight)];
        [self.moreImgView setFrame:CGRectMake(width-orginX-imgWidth, height - sepHeight - imgWidth, imgWidth, imgWidth)];
        [self.receiveBtn setFrame:CGRectMake(width-orginX-stateWidth, height - sepHeight - imgWidth, stateWidth, msgHeight+sepHeight)];
        
        [self.moreImgView setImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        [self.receiveBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"order_operation_receive" inTable:nil] forState:UIControlStateNormal];
        
        [self addSubview:self.codeLbl];
        [self addSubview:self.descLbl];
        [self addSubview:self.timeLbl];
        [self addSubview:self.locationLbl];
        [self addSubview:self.priorityLbl];
        [self addSubview:self.moreImgView];
        [self addSubview:self.receiveBtn];
        
    }
    return self;
}

- (void) setInfoWithCode:(NSString*) code
                    desc:(NSString*) desc
                    time:(NSString*) time
                location:(NSString*) location
                priority:(NSString*) priority
                opration:(NSInteger) opration{
    self.code = code;
    self.time = time;
    self.location = location;
    self.opration = opration;
    self.priority = priority;
    self.desc = desc;
    
    [self updateInfo];
}

- (void) updateInfo {
    [self.codeLbl setText:self.code];
    [self.descLbl setText:self.desc];
    [self.timeLbl setText:self.time];
    [self.locationLbl setText:self.location];
    [self.priorityLbl setText:self.priority];
    switch(self.opration) {
        case TASK_WORK_ORDER_STATUS_RECEIVE:
            
            [self.receiveBtn setHidden:NO];
            [self.moreImgView setHidden:YES];
            break;
        case TASK_WORK_ORDER_STATUS_HANDLE:
            [self.receiveBtn setHidden:YES];
            [self.moreImgView setHidden:NO];
            break;
    }
    
    
}

@end
