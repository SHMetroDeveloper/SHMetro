//
//  WorkOrderWriteEquipmentItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderWriteEquipmentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "BaseBundle.h"
#import "FMFont.h"

@interface WorkOrderWriteEquipmentItemView ()

@property (readwrite, nonatomic, strong) NSString * code; //设备编码
@property (readwrite, nonatomic, strong) NSString * name; //设备名称
@property (readwrite, nonatomic, strong) NSString * location; //安装位置
@property (readwrite, nonatomic, strong) NSString * system; //所属分类
@property (readwrite, nonatomic, strong) NSString * desc; //故障说明
@property (readwrite, nonatomic, strong) NSString * repair;//维修方式



@property (readwrite, nonatomic, strong) BaseLabelView * codeLbl;
@property (readwrite, nonatomic, strong) UIImageView * editImgView;
@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * locationLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * systemLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * repairLbl;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;
@property (readwrite, nonatomic, assign) CGFloat imageWidth;

@property (readwrite, nonatomic, assign) BOOL editable;

@end

@implementation WorkOrderWriteEquipmentItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _imageWidth = 32;
        
        _codeLbl = [[BaseLabelView alloc] init];
        [_editImgView setImage:[[FMTheme getInstance] getImageByName:@"edit"]];
        _editImgView = [[UIImageView alloc] init];
        _nameLbl = [[BaseLabelView alloc] init];
        _locationLbl = [[BaseLabelView alloc] init];
        _systemLbl = [[BaseLabelView alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _repairLbl = [[BaseLabelView alloc] init];
        
        CGFloat labelWidth = 80;
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_code" inTable:nil] andLabelWidth:labelWidth];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_name" inTable:nil] andLabelWidth:labelWidth];
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_location" inTable:nil] andLabelWidth:labelWidth];
        [_systemLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_system" inTable:nil] andLabelWidth:labelWidth];
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil] andLabelWidth:labelWidth];
        [_repairLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil] andLabelWidth:labelWidth];
        
        [self updateSubViews];
        
        [self addSubview:_codeLbl];
        [self addSubview:_editImgView];
        [self addSubview:_nameLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_systemLbl];
        [self addSubview:_descLbl];
        [self addSubview:_repairLbl];
        
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) updateSubViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    
    [_codeLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, 30)];
    
    
    //    CGFloat msgHeight = [FMUtils heightForStringWith:_codeLbl value:@"测试" andWidth:width - 100] * 2;
    
    CGFloat msgHeight = 40;
    
    if(!_editable) {
        sepHeight = (height - msgHeight * 4)/5;
    }
    else {
        sepHeight = (height - msgHeight * 6)/7;
    }
    
    [_codeLbl setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, msgHeight)];
    [_editImgView setFrame:CGRectMake(width-_paddingRight-_imageWidth, sepHeight, _imageWidth, _imageWidth)];
    [_nameLbl setFrame:CGRectMake(_paddingLeft, sepHeight*2+msgHeight, width - _paddingLeft - _paddingRight, msgHeight)];
    [_locationLbl setFrame:CGRectMake(_paddingLeft, sepHeight*3+msgHeight*2, width - _paddingLeft - _paddingRight, msgHeight)];
    [_systemLbl setFrame:CGRectMake(_paddingLeft, sepHeight*4+msgHeight*3, width - _paddingLeft - _paddingRight, msgHeight)];
    if(_editable) {
        [_descLbl setFrame:CGRectMake(_paddingLeft, sepHeight*5+msgHeight*4, width - _paddingLeft - _paddingRight, msgHeight)];
        [_descLbl setHidden:NO];
        [_repairLbl setFrame:CGRectMake(_paddingLeft, sepHeight*6+msgHeight*5, width - _paddingLeft - _paddingRight, msgHeight)];
        [_repairLbl setHidden:NO];
        [_editImgView setHidden:NO];
    } else {
        [_descLbl setHidden:YES];
        [_repairLbl setHidden:YES];
        [_editImgView setHidden:YES];
    }
    
    
    
    [self updateInfo];
}

- (void) updateInfo {
    
    [_codeLbl setContent:_code];
    [_nameLbl setContent:_name];
    [_locationLbl setContent:_location];
    [_systemLbl setContent:_system];
    [_descLbl setContent:_desc];
    [_repairLbl setContent:_repair];
}

- (void) setInfoWithCreateCode:(NSString*) code
                          name:(NSString*) name
                      location:(NSString*) location
                        system:(NSString*) system
                          desc:(NSString*) desc
                        repair:(NSString*) repair {
    
    _code = code;
    _name = name;
    _location = location;
    _system = system;
    _desc = desc;
    _repair = repair;
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}

- (void) setShowBounds:(BOOL) show {
    if(show) {
        self.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
    } else {
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        self.layer.borderWidth = 0;
    }
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
    [self updateSubViews];
}

@end


