//
//  WorkOrderDetailEquipmentView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderDetailEquipmentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "FMSize.h"
#import "BaseLabelView.h"
#import "BaseBundle.h"
#import "UIButton+Bootstrap.h"


@interface WorkOrderDetailEquipmentItemView ()

@property (readwrite, nonatomic, strong) NSString * code; //设备编码
@property (readwrite, nonatomic, strong) NSString * name; //设备名称
@property (readwrite, nonatomic, strong) NSString * desc; //故障说明
@property (readwrite, nonatomic, strong) NSString * repair;//维修方式
@property (readwrite, nonatomic, assign) BOOL finished;//是否已完成
@property (readwrite, nonatomic, assign) BOOL needScan;//是否开启扫描二维码功能

@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * descLbl;
@property (readwrite, nonatomic, strong) BaseLabelView * repairLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
//@property (readwrite, nonatomic, strong) UIButton * doBtn;


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) CGFloat labelWidth;
//
//@property (readwrite, nonatomic, assign) CGFloat btnWidth;
//@property (readwrite, nonatomic, assign) CGFloat btnHeight;

@property (readwrite, nonatomic, strong) UIFont * font;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, weak) id<OnListItemButtonClickListener> btnClickListener;
@property (readwrite, nonatomic, weak) id<OnClickListener> clickListener;

@end

@implementation WorkOrderDetailEquipmentItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        _labelWidth = 0;
        _editable = YES;
        
        _font = [FMFont fontWithSize:13];
        
        _nameLbl = [[UILabel alloc] init];
        _descLbl = [[BaseLabelView alloc] init];
        _repairLbl = [[BaseLabelView alloc] init];
        _statusLbl = [[UILabel alloc] init];
        
        _nameLbl.font = [FMFont fontWithSize:15];
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        
        _statusLbl.font = [FMFont fontWithSize:13];
        
        [_descLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil] andLabelWidth:_labelWidth];
        [_repairLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil] andLabelWidth:_labelWidth];
        
        [_descLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        [_repairLbl setLabelFont:[FMFont getInstance].defaultLabelFont andColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_DESC]];
        
        
        [self addSubview:_nameLbl];
        [self addSubview:_descLbl];
        [self addSubview:_repairLbl];
        [self addSubview:_statusLbl];
        
        [self updateSubViews];
        
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
    if(width == 0) {
        return;
    }
    CGFloat sepHeight = 8;
    CGFloat originY = sepHeight;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat itemHeight = 0;
    CGFloat btnWidth = 0;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    CGFloat statusWidth = [FMUtils widthForString:_statusLbl value:[self getEquipmentStatusDesc]];
    
    itemHeight = defaultItemHeight;
    [_nameLbl setFrame:CGRectMake(padding, originY, width-padding*2-statusWidth, itemHeight)];
    [_statusLbl setFrame:CGRectMake(width-padding-statusWidth, originY, statusWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    if(![FMUtils isStringEmpty:_desc]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_desc font:_font desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width-_paddingRight];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_descLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    if(![FMUtils isStringEmpty:_repair]) {
        itemHeight = [BaseLabelView calculateHeightByInfo:_repair font:_font desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil] labelFont:_font andLabelWidth:_labelWidth andWidth:width-_paddingRight];
    }
    if(itemHeight < defaultItemHeight) {
        itemHeight = defaultItemHeight;
    }
    [_repairLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight-btnWidth, itemHeight)];

    
    [self updateInfo];
}


- (void) setInfoWithCreateCode:(NSString*) code
                          name:(NSString*) name
                          desc:(NSString*) desc
                        repair:(NSString*) repair
                      finished:(BOOL) finished
                      needScan:(BOOL) needScan {
    
    if(![FMUtils isStringEmpty:code]) {
        _code = code;
    } else {
        _code = @"";
    }
    if(![FMUtils isStringEmpty:name]) {
        _name = name;
    } else {
        _name = @"";
    }
    if(![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    } else {
        _desc = @"";
    }
    if(![FMUtils isStringEmpty:repair]) {
        _repair = repair;
    } else {
        _repair = @"";
    }
    _finished = finished;
    _needScan = needScan;
    [self updateSubViews];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self updateSubViews];
}

- (NSString *) getEquipmentNameDesc {
    NSString * res = @"";
    BOOL isNameNull = [FMUtils isStringEmpty:_name];
    BOOL isCodeNull = [FMUtils isStringEmpty:_code];
    if(!isNameNull && !isCodeNull) {
        res = [[NSString alloc] initWithFormat:@"%@(%@)", _name, _code];
    } else if(!isNameNull) {
        res = _name;
    } else if(!isCodeNull) {
        res = [[NSString alloc] initWithFormat:@"(%@)", _code];
    }
    return res;
}

- (NSString *) getEquipmentStatusDesc {
    NSString * res = @"";
    if(_finished) {
        res = [[BaseBundle getInstance] getStringByKey:@"order_equipment_status_finished" inTable:nil];
    } else {
        res = [[BaseBundle getInstance] getStringByKey:@"order_equipment_status_unfinished" inTable:nil];
    }
    return res;
}

- (void) updateInfo {
    [_nameLbl setText:[self getEquipmentNameDesc]];
    [_descLbl setContent:_desc];
    [_repairLbl setContent:_repair];
    [_statusLbl setText:[self getEquipmentStatusDesc]];
    if(_finished) {
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN]];
    } else {
        [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED]];
    }
    _statusLbl.hidden = !_needScan;
}


- (void) setEditable:(BOOL) editable {
    _editable = editable;
    [self updateSubViews];
}

- (void) setOnListItemButtonClickListener:(id<OnListItemButtonClickListener>) listener {
    _btnClickListener = listener;
}

//设置 view 的点击事件代理
- (void) setOnClickListener:(id<OnClickListener>) listener {
    if(!_clickListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClick:)];
        [self addGestureRecognizer:tapGesture];
    }
    _clickListener = listener;
}

- (void) actionClick:(UIView *) v {
    [self notifyViewClicked];
}

- (void) notifyViewClicked {
    if(_editable && _clickListener) {
        [_clickListener onClick:self];
    }
}

+ (CGFloat) calculateHeightByInfo:(WorkOrderEquipment *) equip  andWidth:(CGFloat)width andPaddingLeft:(CGFloat) paddingLeft andPaddingRight:(CGFloat) paddingRight{
    CGFloat height = 0;
    CGFloat sepHeight = 8;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat labelWidth = 0;
    CGFloat failDescHeight = 0;
    CGFloat repairDescHeight = 0;
    UIFont * font = [FMFont fontWithSize:13];
    
    if(![FMUtils isStringEmpty:equip.failureDesc]) {
        failDescHeight = [BaseLabelView calculateHeightByInfo:equip.failureDesc font:font desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_desc" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:(width-paddingRight)];
    }
    if(failDescHeight < defaultItemHeight) {
        failDescHeight = defaultItemHeight;
    }
    
    if(![FMUtils isStringEmpty:equip.repairDesc]) {
        repairDescHeight = [BaseLabelView calculateHeightByInfo:equip.repairDesc font:font desc:[[BaseBundle getInstance] getStringByKey:@"order_equipment_repair" inTable:nil] labelFont:font andLabelWidth:labelWidth andWidth:(width-paddingRight)];
    }
    if(repairDescHeight < defaultItemHeight) {
        repairDescHeight = defaultItemHeight;
    }
    
    height = defaultItemHeight + failDescHeight + repairDescHeight + sepHeight * 4;
    
    
    return height;
}

@end


