//
//  WorkOrderWriteToolItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderWriteToolItemView.h"
#import "FMColor.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface WorkOrderWriteToolItemView ()

@property (readwrite, nonatomic, strong) NSString * name; //名字
@property (readwrite, nonatomic, strong) NSString * unit; //单位
@property (readwrite, nonatomic, assign) NSInteger count; //个数
@property (readwrite, nonatomic, strong) NSString * cost;//费用
@property (readwrite, nonatomic, strong) NSString * desc;//备注



@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * unitLbl;
@property (readwrite, nonatomic, strong) UILabel * countLbl;
@property (readwrite, nonatomic, strong) UILabel * costLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat unitWidth;
@property (readwrite, nonatomic, assign) CGFloat countWidth;

@end

@implementation WorkOrderWriteToolItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _unitWidth = 60;
        _countWidth = 80;
        
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        _nameLbl = [[UILabel alloc] init];
        _unitLbl = [[UILabel alloc] init];
        _countLbl = [[UILabel alloc] init];
        _costLbl = [[UILabel alloc] init];
        _descLbl = [[UILabel alloc] init];
        
        
        
        [_nameLbl setFont:msgFont];
        [_unitLbl setFont:msgFont];
        [_countLbl setFont:msgFont];
        [_costLbl setFont:msgFont];
        [_descLbl setFont:msgFont];
        [self updateSubViews];
        
        [self addSubview:_nameLbl];
        [self addSubview:_unitLbl];
        [self addSubview:_countLbl];
        [self addSubview:_costLbl];
        [self addSubview:_descLbl];
        
    }
    return self;
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, 30)];
    
    
    CGFloat msgHeight = [FMSize getInstance].listItemInfoHeight;
    
    
    sepHeight = (height - msgHeight * 3)/4;
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, msgHeight)];
    [_unitLbl setFrame:CGRectMake(_paddingLeft, sepHeight*2+msgHeight, _unitWidth, msgHeight)];
    [_countLbl setFrame:CGRectMake(_paddingLeft+_unitWidth, sepHeight*2+msgHeight, _countWidth, msgHeight)];
    
    [_costLbl setFrame:CGRectMake(_paddingLeft+_unitWidth+_countWidth, sepHeight*2+msgHeight, width - _paddingLeft - _paddingRight - _countWidth -_unitWidth, msgHeight)];
    [_descLbl setFrame:CGRectMake(_paddingLeft, sepHeight*3+msgHeight*2, width - _paddingLeft - _paddingRight, msgHeight)];
    
    
    [self updateInfo];
}



- (void) setInfoWithCreateName:(NSString*) name
                          unit:(NSString*) unit
                         count:(NSInteger) count
                          cost:(NSString*) cost
                          desc:(NSString *) desc {
    _name = name;
    _unit = unit;
    _count = count;
    _cost = cost;
    _desc = desc;
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}

- (void) updateInfo {
    [_nameLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_tool_name" inTable:nil], _name]];
    [_unitLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_tool_unit" inTable:nil], _unit]];
    [_countLbl setText:[[NSString alloc] initWithFormat:@"%@: %ld", [[BaseBundle getInstance] getStringByKey:@"order_tool_amount" inTable:nil], _count]];
    [_costLbl setText:[[NSString alloc] initWithFormat:@"%@: %@", [[BaseBundle getInstance] getStringByKey:@"order_tool_cost" inTable:nil], _cost]];
    [_descLbl setText:[[NSString alloc] initWithFormat:@"%@: %@",[[BaseBundle getInstance] getStringByKey:@"label_note" inTable:nil], _desc]];
}

@end



