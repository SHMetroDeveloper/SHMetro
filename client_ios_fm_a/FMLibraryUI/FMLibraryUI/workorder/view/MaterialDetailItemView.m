//
//  MaterialDetailItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/9/22.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "MaterialDetailItemView.h"
#import "BaseTextField.h"
#import "BaseLabelView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMUtils.h"
#import "FMTheme.h"
#import "OnClickListener.h"
#import "BaseBundle.h"

@interface MaterialDetailItemView () 

@property (readwrite, nonatomic, strong) BaseLabelView * nameLbl;       //物料名称
@property (readwrite, nonatomic, strong) BaseLabelView * brandLbl;      //规格
@property (readwrite, nonatomic, strong) BaseLabelView * modelLbl;      //型号
@property (readwrite, nonatomic, strong) BaseLabelView * unitLbl;       //单位
@property (readwrite, nonatomic, strong) BaseLabelView * countLbl;       //库存量
@property (readwrite, nonatomic, strong) BaseLabelView * dueDateLbl;     //过期时间
@property (readwrite, nonatomic, strong) BaseLabelView * batchCountLbl;  //批次数量
@property (readwrite, nonatomic, strong) BaseLabelView * usedCountLbl;   //预定数量

@property (readwrite, nonatomic, strong) UIButton * deleteBtn;
@property (readwrite, nonatomic, strong) UIImageView * deleteImgView;

@property (readwrite, nonatomic, strong) NSString * name;
@property (readwrite, nonatomic, strong) NSString * brand;
@property (readwrite, nonatomic, strong) NSString * model;
@property (readwrite, nonatomic, strong) NSString * unit;
@property (readwrite, nonatomic, assign) NSInteger count;
@property (readwrite, nonatomic, strong) NSNumber * dueDate;
@property (readwrite, nonatomic, assign) NSInteger batchCount;
@property (readwrite, nonatomic, assign) NSInteger usedCount;

@property (readwrite, nonatomic, assign) CGFloat labelWidth2;           //2个字的 标签宽度
@property (readwrite, nonatomic, assign) CGFloat labelWidth3;           //3个字的 标签宽度
@property (readwrite, nonatomic, assign) CGFloat labelWidth4;           //4个字的标签宽度

@property (readwrite, nonatomic, assign) CGFloat itemHeight;            //子项的高度

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> itemListener;

@end

@implementation MaterialDetailItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _itemHeight = 40;
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingRight = _paddingLeft;
        
        _labelWidth2 = 0;
        _labelWidth3 = 0;
        _labelWidth4 = 0;
        
        _nameLbl = [[BaseLabelView alloc] init];
        _brandLbl = [[BaseLabelView alloc] init];
        _modelLbl = [[BaseLabelView alloc] init];
        _unitLbl = [[BaseLabelView alloc] init];
        _countLbl = [[BaseLabelView alloc] init];
        _dueDateLbl = [[BaseLabelView alloc] init];
        _batchCountLbl = [[BaseLabelView alloc] init];
        _usedCountLbl = [[BaseLabelView alloc] init];
        _deleteBtn = [[UIButton alloc] init];
        
        _nameLbl.tag = MATERIAL_DETAIL_ITEM_OPERATE_TYPE_NAME;
        _dueDateLbl.tag = MATERIAL_DETAIL_ITEM_OPERATE_TYPE_DATE;
        _deleteBtn.tag = MATERIAL_DETAIL_ITEM_OPERATE_TYPE_DELETE;
        
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_name" inTable:nil] andLabelWidth:_labelWidth4];
        [_brandLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_brand" inTable:nil] andLabelWidth:_labelWidth2];
        [_modelLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_model" inTable:nil] andLabelWidth:_labelWidth2];
        [_countLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_inventory_amount" inTable:nil] andLabelWidth:_labelWidth4];
        [_unitLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_unit" inTable:nil] andLabelWidth:_labelWidth2];
        [_dueDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_over_due" inTable:nil] andLabelWidth:_labelWidth4];
        [_batchCountLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_amount" inTable:nil] andLabelWidth:_labelWidth2];
        [_usedCountLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"order_material_reserve_amount" inTable:nil] andLabelWidth:_labelWidth4];
        
        [_nameLbl setOnClickListener:self];
        [_dueDateLbl setOnClickListener:self];
        [_usedCountLbl setOnClickListener:self];
        
        UIImage* deleteImg = [[FMTheme getInstance] getImageByName:@"icon_delete_gray"];
        _deleteImgView = [[UIImageView alloc] init];
        [_deleteImgView setImage:deleteImg];
        
        [_deleteBtn addSubview:_deleteImgView];
        [_deleteBtn addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_nameLbl];
        [self addSubview:_brandLbl];
        [self addSubview:_modelLbl];
        [self addSubview:_unitLbl];
        [self addSubview:_countLbl];
        [self addSubview:_dueDateLbl];
        [self addSubview:_batchCountLbl];
        [self addSubview:_usedCountLbl];
        [self addSubview:_deleteBtn];
    }
}


- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height =CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = (height - _itemHeight * 6) / 7;
    CGFloat originY = sepHeight;
    CGFloat itemHeight = _itemHeight;
    CGFloat btnWidth = 48;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_brandLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_modelLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_countLbl setFrame:CGRectMake(_paddingLeft, originY, (width-_paddingLeft-_paddingRight)*2/3, itemHeight)];
    [_unitLbl setFrame:CGRectMake(_paddingLeft + (width-_paddingLeft-_paddingRight)*2/3, originY, (width-_paddingLeft-_paddingRight)/3, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_dueDateLbl setFrame:CGRectMake(_paddingLeft, originY, (width-_paddingLeft-_paddingRight)*2/3, itemHeight)];
    [_batchCountLbl setFrame:CGRectMake(_paddingLeft+(width-_paddingLeft-_paddingRight)*2/3, originY, (width-_paddingLeft-_paddingRight)/3, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_usedCountLbl setFrame:CGRectMake(_paddingLeft, originY, width-_paddingLeft-_paddingRight-btnWidth, itemHeight)];
    
    CGFloat imgPadding = (btnWidth - _imgWidth) / 2;
    [_deleteImgView setFrame:CGRectMake(imgPadding, imgPadding, _imgWidth, _imgWidth)];
    [_deleteBtn setFrame:CGRectMake(width-_paddingRight-btnWidth, height-padding-btnWidth, btnWidth, btnWidth)];
    originY += itemHeight + sepHeight;
    
    [self updateInfo];
}

- (void) updateInfo {
    [_nameLbl setContent:_name];
    [_brandLbl setContent:_brand];
    [_modelLbl setContent:_model];
    if(_count > 0) {
        [_countLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _count]];
    } else {
        [_countLbl setContent:@"0"];
    }
    [_unitLbl setContent:_unit];
    if(_dueDate && ![_dueDate isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        NSDate * date = [FMUtils timeLongToDate:_dueDate];
        [_dueDateLbl setContent:[FMUtils getDayStr:date]];
    } else {
        [_dueDateLbl setContent:@""];
    }
    if(_batchCount > 0) {
        [_batchCountLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _batchCount]];
    } else {
        if(_dueDate) {
            [_batchCountLbl setContent:@""];
        }else{
            [_batchCountLbl setContent:@""];
        }
    }
    if(_usedCount > 0) {
        [_usedCountLbl setContent:[[NSString alloc] initWithFormat:@"%ld", _usedCount]];
    } else {
        [_usedCountLbl setContent:@""];
    }
    
}

//设置基本信息
- (void) setInfoWithName:(NSString *) name brand:(NSString *) brand model:(NSString *) model amount:(NSInteger) amount unit:(NSString *) unit {
    _name = name;
    _brand = brand;
    _model = model;
    _count = amount;
    _unit = unit;
    [self updateInfo];
}
//设置批次时间和批次数量
- (void) setDueDate:(NSNumber *) dueDate andBatchAmount:(NSInteger) batchAmount {
    _dueDate = dueDate;
    _batchCount = batchAmount;
    [self updateInfo];
}

//设置预定数量
- (void) setReserveAmount:(NSInteger) reserveAmount {
    _usedCount = reserveAmount;
    [self updateInfo];
}


//获取预定的数量
- (NSInteger) getReserveAmount {
    NSInteger count = _usedCount;
    return count;
}

//清除所有输入的信息
- (void) clearInfo {
    _name = @"";
    _brand = @"";
    _model = @"";
    _count = 0;
    _unit = @"";
    
    _dueDate = nil;
    _batchCount = 0;
    _usedCount = 0;
    
    [self updateInfo];
}


//设置点击事件监听器
- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_itemListener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    _itemListener = listener;
}

#pragma - onclick 事件
- (void) actiondo:(UIView *) v {
    [self notifyViewClicked];
    
}

- (void) notifyViewClicked {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:nil];
    }
}

- (void) onClick:(UIView *)view {
    if(view == _nameLbl) {
        [self notifySelectMaterial];
    } else if (view == _dueDateLbl ||view == _usedCountLbl) {
        [self notifySelectBatchDate];
    }
}

- (void) notifySelectMaterial {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:_nameLbl];
    }
}

- (void) notifySelectBatchDate {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:_dueDateLbl];
    }
}

- (void) onDeleteButtonClicked:(UIView *) v {
    if(_itemListener) {
        [_itemListener onItemClick:self subView:_deleteBtn];
    }
}

//计算所需的高度
+ (CGFloat) calculateHeightByInfo {
    CGFloat height = 280;
    return height;
}

@end
