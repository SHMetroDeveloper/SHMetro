//
//  WorkOrderWriteLaborerItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/5.
//  Copyright (c) 2015年 flynn. All rights reserved.
//


#import "WorkOrderWriteLaborerItemView.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"

@interface WorkOrderWriteLaborerItemView ()

@property (readwrite, nonatomic, strong) NSString * name;           //执行人名字
@property (readwrite, nonatomic, strong) NSString * position;       //岗位
@property (readwrite, nonatomic, strong) NSString * telno;          //联系方式
@property (readwrite, nonatomic, strong) NSString * status;          //执行人状态
@property (readwrite, nonatomic, strong) NSString * arriveTime;     //实际到达时间
@property (readwrite, nonatomic, strong) NSString * finishTime;     //实际完成时间


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * positionLbl;
@property (readwrite, nonatomic, strong) UILabel * telnoLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
@property (readwrite, nonatomic, strong) UILabel * arriveTimeLbl;
@property (readwrite, nonatomic, strong) UILabel * finishTimeLbl;


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat statusWidth;
@end

@implementation WorkOrderWriteLaborerItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _statusWidth = 60;
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _positionLbl = [[UILabel alloc] init];
        _telnoLbl = [[UILabel alloc] init];
        _statusLbl = [[UILabel alloc] init];
        _arriveTimeLbl = [[UILabel alloc] init];
        _finishTimeLbl = [[UILabel alloc] init];
        
        
        [_nameLbl setFont:msgFont];
        [_positionLbl setFont:msgFont];
        [_telnoLbl setFont:msgFont];
        [_statusLbl setFont:msgFont];
        [_arriveTimeLbl setFont:msgFont];
        [_finishTimeLbl setFont:msgFont];
        
        [self initViews];
        
        [self addSubview:_nameLbl];
        [self addSubview:_positionLbl];
        [self addSubview:_telnoLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_arriveTimeLbl];
        [self addSubview:_finishTimeLbl];
    }
    return self;
}

- (void) initViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, 30)];
    
    CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
    sepHeight = (height - msgHeight * 5)/6;
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight - _statusWidth, msgHeight)];
    [_positionLbl setFrame:CGRectMake(_paddingLeft, sepHeight * 2 + msgHeight, width - _paddingLeft - _paddingRight, msgHeight)];
    [_telnoLbl setFrame:CGRectMake(_paddingLeft, sepHeight * 3 + msgHeight*2, width - _paddingLeft - _paddingRight, msgHeight)];
    [_statusLbl setFrame:CGRectMake(width-_paddingRight-_statusWidth, sepHeight , _statusWidth, msgHeight)];
    [_arriveTimeLbl setFrame:CGRectMake(_paddingLeft, sepHeight * 4 + msgHeight*3, width - _paddingLeft - _paddingRight, msgHeight)];
    [_finishTimeLbl setFrame:CGRectMake(_paddingLeft, sepHeight * 5 + msgHeight*4, width - _paddingLeft - _paddingRight, msgHeight)];
    
}



- (void) setInfoWithName:(NSString *) name
                position:(NSString *) position
                   telno:(NSString *) telno
                  status:(NSString*) status
              arriveTime:(NSString*) arriveTime
              finishTime:(NSString*) finishTime {
    
    _name = name;
    _position = position;
    _telno = telno;
    _status = status;
    _arriveTime = arriveTime;
    _finishTime = finishTime;
    
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self initViews];
}

- (void) updateInfo {
    [_nameLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_laborer_name" inTable:nil], _name]];
    [_positionLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_laborer_position" inTable:nil], _position]];
    [_telnoLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_laborer_contact" inTable:nil], _telno]];
    [_arriveTimeLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_laborer_time_arrive" inTable:nil], _arriveTime]];
    [_finishTimeLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_laborer_time_finish" inTable:nil], _finishTime]];
    
    [_statusLbl setText:_status];
}

@end
