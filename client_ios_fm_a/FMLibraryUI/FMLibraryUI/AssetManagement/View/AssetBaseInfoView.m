//
//  AssetBaseInfoView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/6/6.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "AssetBaseInfoView.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "FMTheme.h"
#import "BaseBundle.h"
#import "BasePhotoView.h"

@interface AssetBaseInfoView ()<OnMessageHandleListener>
@property (nonatomic, strong) BaseLabelView *numberLbl;  //设备编号
@property (nonatomic, strong) BaseLabelView *nameLbl;       //设备名称
@property (nonatomic, strong) BaseLabelView *classificationLbl; //系统分类
@property (nonatomic, strong) BaseLabelView *statusLbl;    //设备状态
@property (nonatomic, strong) BaseLabelView *locationLbl;    //安装位置
@property (nonatomic, strong) BaseLabelView *brandLbl;    //品牌
@property (nonatomic, strong) BaseLabelView *modelLbl;   //型号
//@property (nonatomic, strong) BaseLabelView *serialnumberLbl;   //序列号
@property (nonatomic, strong) BaseLabelView *countLbl;  //数量
@property (nonatomic, strong) BaseLabelView *unitLbl;  //单位
@property (nonatomic, strong) BaseLabelView *brandLocationLbl;  //铭牌位置
@property (nonatomic, strong) BaseLabelView *productLocationLbl;  //设备产地
@property (nonatomic, strong) BaseLabelView *exfactoryDateLbl;   //出厂日期
@property (nonatomic, strong) BaseLabelView *installDateLbl;   //安装日期
@property (nonatomic, strong) BaseLabelView *introductionDateLbl;  //启用日期
//@property (nonatomic, strong) BaseLabelView *startDateLbl;  //启用日期
@property (nonatomic, strong) BaseLabelView *transferDateLbl;  //移交日期
@property (nonatomic, strong) BaseLabelView *deathDateLbl;  //报废时间
@property (nonatomic, strong) BaseLabelView *designLifeLbl;  //设计年限
@property (nonatomic, strong) BaseLabelView *expectLifeLbl;  //预期年限
@property (nonatomic, strong) BaseLabelView *weightLbl;    //重量
@property (nonatomic, strong) BaseLabelView *lifespanLbl;  //寿命
@property (nonatomic, strong) BaseLabelView *listLbl;  //清单
@property (nonatomic, strong) BaseLabelView *descriptionLbl;  //描述
@property (nonatomic, strong) BasePhotoView *photoView;

@property (nonatomic, strong) NSString *number;  //设备编号
@property (nonatomic, strong) NSString *name;       //设备名称
@property (nonatomic, strong) NSString *classification; //系统分类
@property (nonatomic, strong) NSString *status;    //设备状态
@property (nonatomic, strong) NSString *location;    //安装位置
@property (nonatomic, strong) NSString *brand;    //品牌
@property (nonatomic, strong) NSString *model;   //型号
@property (nonatomic, strong) NSString *count;   //数量
@property (nonatomic, strong) NSString *unit;    //单位
@property (nonatomic, strong) NSString *brandLocation;  //铭牌位置
@property (nonatomic, strong) NSString *productLocation;   //设备产地
//@property (nonatomic, strong) NSString *serialnumber;   //序列号
@property (nonatomic, strong) NSNumber *exfactoryDate;   //出厂日期
@property (nonatomic, strong) NSNumber *installDate;   //安装日期
@property (nonatomic, strong) NSNumber *introductionDate;  //启用日期
@property (nonatomic, strong) NSNumber *transferDate;  //移交日期
@property (nonatomic, strong) NSNumber *deathDate;   //报废时间
@property (nonatomic, strong) NSString *designLife;  //设计年限
@property (nonatomic, strong) NSString *expectLife;  //预期年限
@property (nonatomic, strong) NSString *weight;    //重量
@property (nonatomic, strong) NSString *lifespan;  //寿命
@property (nonatomic, strong) NSString *list;  //清单
@property (nonatomic, strong) NSString *desc;  //描述
@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, assign) BOOL flexible;
@property (nonatomic, assign) BOOL isInited;

@property (nonatomic, weak) id<OnMessageHandleListener> handler;

@end

@implementation AssetBaseInfoView

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
    if (!_isInited) {
        _isInited = YES;
        _flexible = NO;
        
        UIFont * mFont = [FMFont getInstance].font38;
        UIColor * labelColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _numberLbl = [[BaseLabelView alloc] init];  //设备编号
        [_numberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_number" inTable:nil] andLabelWidth:0];
        [_numberLbl setLabelFont:mFont andColor:labelColor];
        [_numberLbl setLabelAlignment:NSTextAlignmentLeft];
        [_numberLbl setContentFont:mFont];
        [_numberLbl setContentColor:contentColor];
        [_numberLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _nameLbl = [[BaseLabelView alloc] init];       //设备名称
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setLabelFont:mFont andColor:labelColor];
        [_nameLbl setLabelAlignment:NSTextAlignmentLeft];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:contentColor];
        [_nameLbl setContentAlignment:NSTextAlignmentLeft];
        [_nameLbl setShowOneLine:NO];
        
        
        _classificationLbl = [[BaseLabelView alloc] init]; //系统分类
        [_classificationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_classification" inTable:nil] andLabelWidth:0];
        [_classificationLbl setLabelFont:mFont andColor:labelColor];
        [_classificationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_classificationLbl setContentFont:mFont];
        [_classificationLbl setContentColor:contentColor];
        [_classificationLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _statusLbl = [[BaseLabelView alloc] init];    //设备状态
        [_statusLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_status" inTable:nil] andLabelWidth:0];
        [_statusLbl setLabelFont:mFont andColor:labelColor];
        [_statusLbl setLabelAlignment:NSTextAlignmentLeft];
        [_statusLbl setContentFont:mFont];
        [_statusLbl setContentColor:contentColor];
        [_statusLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _locationLbl = [[BaseLabelView alloc] init];    //安装位置
        [_locationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_location" inTable:nil] andLabelWidth:0];
        [_locationLbl setLabelFont:mFont andColor:labelColor];
        [_locationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_locationLbl setContentFont:mFont];
        [_locationLbl setContentColor:contentColor];
        [_locationLbl setContentAlignment:NSTextAlignmentLeft];
        [_locationLbl setShowOneLine:NO];
        
        
        _brandLbl = [[BaseLabelView alloc] init];    //品牌
        [_brandLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_brand" inTable:nil] andLabelWidth:0];
        [_brandLbl setLabelFont:mFont andColor:labelColor];
        [_brandLbl setLabelAlignment:NSTextAlignmentLeft];
        [_brandLbl setContentFont:mFont];
        [_brandLbl setContentColor:contentColor];
        [_brandLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _modelLbl = [[BaseLabelView alloc] init];  //型号
        [_modelLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_model" inTable:nil] andLabelWidth:0];
        [_modelLbl setLabelFont:mFont andColor:labelColor];
        [_modelLbl setLabelAlignment:NSTextAlignmentLeft];
        [_modelLbl setContentFont:mFont];
        [_modelLbl setContentColor:contentColor];
        [_modelLbl setContentAlignment:NSTextAlignmentLeft];
        
        
//        _serialnumberLbl = [[BaseLabelView alloc] init];  //序列号
//        [_serialnumberLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_serialnumber" inTable:nil] andLabelWidth:0];
//        [_serialnumberLbl setLabelFont:mFont andColor:labelColor];
//        [_serialnumberLbl setLabelAlignment:NSTextAlignmentLeft];
//        [_serialnumberLbl setContentFont:mFont];
//        [_serialnumberLbl setContentColor:contentColor];
//        [_serialnumberLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _countLbl = [[BaseLabelView alloc] init];  //数量
        [_countLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_count" inTable:nil] andLabelWidth:0];
        [_countLbl setLabelFont:mFont andColor:labelColor];
        [_countLbl setLabelAlignment:NSTextAlignmentLeft];
        [_countLbl setContentFont:mFont];
        [_countLbl setContentColor:contentColor];
        [_countLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _unitLbl = [[BaseLabelView alloc] init];  //单位
        [_unitLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_unit" inTable:nil] andLabelWidth:0];
        [_unitLbl setLabelFont:mFont andColor:labelColor];
        [_unitLbl setLabelAlignment:NSTextAlignmentLeft];
        [_unitLbl setContentFont:mFont];
        [_unitLbl setContentColor:contentColor];
        [_unitLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _brandLocationLbl = [[BaseLabelView alloc] init];  //铭牌位置
        [_brandLocationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_brand_location" inTable:nil] andLabelWidth:0];
        [_brandLocationLbl setLabelFont:mFont andColor:labelColor];
        [_brandLocationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_brandLocationLbl setContentFont:mFont];
        [_brandLocationLbl setContentColor:contentColor];
        [_brandLocationLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _productLocationLbl = [[BaseLabelView alloc] init];  //设备产地
        [_productLocationLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_product_location" inTable:nil] andLabelWidth:0];
        [_productLocationLbl setLabelFont:mFont andColor:labelColor];
        [_productLocationLbl setLabelAlignment:NSTextAlignmentLeft];
        [_productLocationLbl setContentFont:mFont];
        [_productLocationLbl setContentColor:contentColor];
        [_productLocationLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _exfactoryDateLbl = [[BaseLabelView alloc] init];  //出厂日期
        [_exfactoryDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_exfactorydate" inTable:nil] andLabelWidth:0];
        [_exfactoryDateLbl setLabelFont:mFont andColor:labelColor];
        [_exfactoryDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_exfactoryDateLbl setContentFont:mFont];
        [_exfactoryDateLbl setContentColor:contentColor];
        [_exfactoryDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _installDateLbl = [[BaseLabelView alloc] init];  //安装日期
        [_installDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_installdate" inTable:nil] andLabelWidth:0];
        [_installDateLbl setLabelFont:mFont andColor:labelColor];
        [_installDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_installDateLbl setContentFont:mFont];
        [_installDateLbl setContentColor:contentColor];
        [_installDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _introductionDateLbl = [[BaseLabelView alloc] init];  //启用日期
        [_introductionDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_introductiondate" inTable:nil] andLabelWidth:0];
        [_introductionDateLbl setLabelFont:mFont andColor:labelColor];
        [_introductionDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_introductionDateLbl setContentFont:mFont];
        [_introductionDateLbl setContentColor:contentColor];
        [_introductionDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _transferDateLbl = [[BaseLabelView alloc] init];  //移交日期
        [_transferDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_transfer_date" inTable:nil] andLabelWidth:0];
        [_transferDateLbl setLabelFont:mFont andColor:labelColor];
        [_transferDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_transferDateLbl setContentFont:mFont];
        [_transferDateLbl setContentColor:contentColor];
        [_transferDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _deathDateLbl = [[BaseLabelView alloc] init];  //报废日期
        [_deathDateLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_death_date" inTable:nil] andLabelWidth:0];
        [_deathDateLbl setLabelFont:mFont andColor:labelColor];
        [_deathDateLbl setLabelAlignment:NSTextAlignmentLeft];
        [_deathDateLbl setContentFont:mFont];
        [_deathDateLbl setContentColor:contentColor];
        [_deathDateLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _designLifeLbl = [[BaseLabelView alloc] init];  //设计年限
        [_designLifeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_design_life" inTable:nil] andLabelWidth:0];
        [_designLifeLbl setLabelFont:mFont andColor:labelColor];
        [_designLifeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_designLifeLbl setContentFont:mFont];
        [_designLifeLbl setContentColor:contentColor];
        [_designLifeLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _expectLifeLbl = [[BaseLabelView alloc] init];  //预期年限
        [_expectLifeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_expectLife_date" inTable:nil] andLabelWidth:0];
        [_expectLifeLbl setLabelFont:mFont andColor:labelColor];
        [_expectLifeLbl setLabelAlignment:NSTextAlignmentLeft];
        [_expectLifeLbl setContentFont:mFont];
        [_expectLifeLbl setContentColor:contentColor];
        [_expectLifeLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _weightLbl = [[BaseLabelView alloc] init];    //重量
        [_weightLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_weight" inTable:nil] andLabelWidth:0];
        [_weightLbl setLabelFont:mFont andColor:labelColor];
        [_weightLbl setLabelAlignment:NSTextAlignmentLeft];
        [_weightLbl setContentFont:mFont];
        [_weightLbl setContentColor:contentColor];
        [_weightLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _lifespanLbl = [[BaseLabelView alloc] init];  //寿命
        [_lifespanLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_lifespan" inTable:nil] andLabelWidth:0];
        [_lifespanLbl setLabelFont:mFont andColor:labelColor];
        [_lifespanLbl setLabelAlignment:NSTextAlignmentLeft];
        [_lifespanLbl setContentFont:mFont];
        [_lifespanLbl setContentColor:contentColor];
        [_lifespanLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _listLbl = [[BaseLabelView alloc] init];  //清单
        [_listLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_list" inTable:nil] andLabelWidth:0];
        [_listLbl setLabelFont:mFont andColor:labelColor];
        [_listLbl setLabelAlignment:NSTextAlignmentLeft];
        [_listLbl setContentFont:mFont];
        [_listLbl setContentColor:contentColor];
        [_listLbl setContentAlignment:NSTextAlignmentLeft];
        
        
        _descriptionLbl = [[BaseLabelView alloc] init];  //描述
        [_descriptionLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"equipment_description" inTable:nil] andLabelWidth:0];
        [_descriptionLbl setLabelFont:mFont andColor:labelColor];
        [_descriptionLbl setLabelAlignment:NSTextAlignmentLeft];
        [_descriptionLbl setContentFont:mFont];
        [_descriptionLbl setContentColor:contentColor];
        [_descriptionLbl setContentAlignment:NSTextAlignmentLeft];
        [_descriptionLbl setShowOneLine:NO];
        
        
        _photoView = [[BasePhotoView alloc] init]; //资产照片
        [_photoView setEnableAdd:NO];
        [_photoView setEditable:NO];
        [_photoView setShowType:PHOTO_SHOW_TYPE_ALL_LINES];
        [_photoView setOnMessageHandleListener:self];
        _photoView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        
        [self addSubview:_numberLbl];
        [self addSubview:_nameLbl];
        [self addSubview:_classificationLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_locationLbl];
        [self addSubview:_brandLbl];
        [self addSubview:_modelLbl];
//        [self addSubview:_serialnumberLbl];
        [self addSubview:_countLbl];
        [self addSubview:_unitLbl];
        [self addSubview:_brandLocationLbl];
        [self addSubview:_productLocationLbl];
        [self addSubview:_exfactoryDateLbl];
        [self addSubview:_installDateLbl];
        [self addSubview:_introductionDateLbl];
        [self addSubview:_transferDateLbl];
        [self addSubview:_deathDateLbl];
        [self addSubview:_designLifeLbl];
        [self addSubview:_expectLifeLbl];
        [self addSubview:_weightLbl];
        [self addSubview:_lifespanLbl];
        [self addSubview:_listLbl];
        [self addSubview:_descriptionLbl];
        [self addSubview:_photoView];
    }
}

- (void) updateViews {
    CGFloat width = self.frame.size.width;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    UIFont * mFont = [FMFont getInstance].font38;
    CGFloat originX = 0;
    CGFloat originY = padding;
    CGFloat defaultItemHeight = 26.7f;
    
    CGFloat nameHeight = [BaseLabelView calculateHeightByInfo:_name font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_name" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:_location font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_location" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    CGFloat descriptionHeight = [BaseLabelView calculateHeightByInfo:_desc font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    
    [_numberLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    if (nameHeight < defaultItemHeight) {
        nameHeight = itemHeight;
    }
    [_nameLbl setFrame:CGRectMake(originX, originY, width-padding, nameHeight)];
    originY += padding + nameHeight;
    
    [_classificationLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_statusLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    if (locationHeight < defaultItemHeight) {
        locationHeight = itemHeight;
    }
    [_locationLbl setFrame:CGRectMake(originX, originY, width-padding, locationHeight)];
    originY += padding + locationHeight;
    
    [_brandLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    if (_flexible) {
//        _serialnumberLbl.hidden = NO;
        _countLbl.hidden = NO;
        _unitLbl.hidden = NO;
        _brandLocationLbl.hidden = NO;
        _productLocationLbl.hidden = NO;
        _exfactoryDateLbl.hidden = NO;
        _installDateLbl.hidden = NO;
        _introductionDateLbl.hidden = NO;
        _transferDateLbl.hidden = NO;
        _deathDateLbl.hidden = NO;
        _designLifeLbl.hidden = NO;
        _expectLifeLbl.hidden = NO;
        _weightLbl.hidden = NO;
        _lifespanLbl.hidden = NO;
        _listLbl.hidden = NO;
        _descriptionLbl.hidden = NO;
        _photoView.hidden = NO;
        
//        [_serialnumberLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
//        originY += padding + itemHeight;
        
        [_countLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_unitLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_brandLocationLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_productLocationLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_exfactoryDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_installDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_introductionDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_transferDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_deathDateLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_designLifeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_expectLifeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_weightLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_lifespanLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        [_listLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
        originY += padding + itemHeight;
        
        if (descriptionHeight < defaultItemHeight) {
            descriptionHeight = itemHeight;
        }
        [_descriptionLbl setFrame:CGRectMake(originX, originY, width-padding, descriptionHeight)];
        originY += descriptionHeight;
        
        CGFloat photoHeight;
        if ([_photoArray count] == 0) {
            photoHeight = 0;
            _photoView.hidden = YES;
        } else {
            photoHeight = [BasePhotoView calculateHeightByCount:[_photoArray count] width:width-padding*2 addAble:NO showType:PHOTO_SHOW_TYPE_ALL_ONE_LINE];
            _photoView.hidden = NO;
            [_photoView setPhotosWithArray:_photoArray];
            [_photoView setFrame:CGRectMake(padding, originY, width-padding*2, photoHeight)];
        }
    } else {
//        _serialnumberLbl.hidden = YES;
        _countLbl.hidden = YES;
        _unitLbl.hidden = YES;
        _brandLocationLbl.hidden = YES;
        _productLocationLbl.hidden = YES;
        _exfactoryDateLbl.hidden = YES;
        _installDateLbl.hidden = YES;
        _introductionDateLbl.hidden = YES;
        _transferDateLbl.hidden = YES;
        _deathDateLbl.hidden = YES;
        _designLifeLbl.hidden = YES;
        _expectLifeLbl.hidden = YES;
        _weightLbl.hidden = YES;
        _lifespanLbl.hidden = YES;
        _listLbl.hidden = YES;
        _descriptionLbl.hidden = YES;
        _photoView.hidden = YES;
    }
}

- (void) updateInfo {
    NSString * exfactoryDate = @"";
    if (![FMUtils isNumberNullOrZero:_exfactoryDate]) {
        exfactoryDate = [FMUtils getDateTimeDescriptionBy:_exfactoryDate format:@"yyyy-MM-dd"];
    }
    
    NSString * installDate = @"";
    if (![FMUtils isNumberNullOrZero:_installDate]) {
        installDate = [FMUtils getDateTimeDescriptionBy:_installDate format:@"yyyy-MM-dd"];
    }
    
    NSString * introductionDate = @"";
    if (![FMUtils isNumberNullOrZero:_introductionDate]) {
        introductionDate = [FMUtils getDateTimeDescriptionBy:_introductionDate format:@"yyyy-MM-dd"];
    }
    
    NSString *transferDate = @"";
    if (![FMUtils isNumberNullOrZero:_transferDate]) {
        transferDate = [FMUtils getDateTimeDescriptionBy:_transferDate format:@"yyyy-MM-dd"];
    }
    
    NSString *deathDate = @"";
    if (![FMUtils isNumberNullOrZero:_deathDate]) {
        deathDate = [FMUtils getDateTimeDescriptionBy:_deathDate format:@"yyyy-MM-dd"];
    }
    
    [_numberLbl setContent:_number];
    [_nameLbl setContent:_name];
    [_classificationLbl setContent:_classification];
    [_statusLbl setContent:_status];
    [_locationLbl setContent:_location];
    [_brandLbl setContent:_brand];
    [_modelLbl setContent:_model];
//    [_serialnumberLbl setContent:_serialnumber];
    [_countLbl setContent:_count];
    [_unitLbl setContent:_unit];
    [_brandLocationLbl setContent:_brandLocation];
    [_productLocationLbl setContent:_productLocation];
    [_exfactoryDateLbl setContent:exfactoryDate];
    [_installDateLbl setContent:installDate];
    [_introductionDateLbl setContent:introductionDate];
    [_transferDateLbl setContent:transferDate];
    [_designLifeLbl setContent:deathDate];
    [_expectLifeLbl setContent:_expectLife];
    [_weightLbl setContent:_weight];
    [_lifespanLbl setContent:_lifespan];
    [_listLbl setContent:_list];
    [_descriptionLbl setContent:_desc];
    
    [self updateViews];
}


- (void) setBasicInfoWith:(AssetEquipmentDetailEntity *) entity {
    _number = @"";  //编码
    _name = @"";
    _classification = @"";
    _status = @"";
    _location = @"";
    _brand = @"";
    _model = @"";
//    _serialnumber = @"";
    _count = @"";
    _unit = @"";
    _brandLocation = @"";
    _productLocation = @"";
    _exfactoryDate = nil;  //出产日期
    _installDate = nil;       //安装日期
    _introductionDate = nil;  //启用日期
    _transferDate = nil;
    _deathDate = nil;
    _designLife = nil;
    _expectLife = nil;
    _weight = @"";
    _lifespan = @"";
    _list = @"";
    _desc = @"";
    
    if (entity) {
        if (![FMUtils isStringEmpty:entity.code]) {
            _number = entity.code;  //编码
        }
        if (![FMUtils isStringEmpty:entity.name]) {
            _name = entity.name;
        }
        if (![FMUtils isStringEmpty:entity.equipmentSystemName]) {
            _classification = entity.equipmentSystemName;
        }
        if (![FMUtils isStringEmpty:entity.status]) {
            _status = entity.status;
        }
        if (![FMUtils isStringEmpty:entity.location]) {
            _location = entity.location;
        }
        if (![FMUtils isStringEmpty:entity.brand]) {
            _brand = entity.brand;
        }
        if (![FMUtils isStringEmpty:entity.model]) {
            _model = entity.model;
        }
//        if (![FMUtils isStringEmpty:entity.serialNumber]) {
//            _serialnumber = entity.serialNumber;
//        }
        if (![FMUtils isStringEmpty:entity.otherInfo.count]) {
            _count = entity.otherInfo.count;
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.unit]) {
            _unit = entity.otherInfo.unit;
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.brandLocation]) {
            _brandLocation = entity.otherInfo.brandLocation;
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.productLocation]) {
            _productLocation = entity.otherInfo.productLocation;
        }
        if (entity.dateManufactured) {
            _exfactoryDate = entity.dateManufactured;  //出产日期
        }
        if (entity.dateInstalled) {
            _installDate = entity.dateInstalled;       //安装日期
        }
        if (entity.dateInService) {
            _introductionDate = entity.dateInService;  //启用日期
        }
        if (entity.otherInfo.transferDate) {
            _transferDate = entity.otherInfo.transferDate;
        }
        if (entity.otherInfo.deathDate) {
            _deathDate = entity.otherInfo.deathDate;
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.designLife]) {
            _designLife = entity.otherInfo.designLife;
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.expectLife]) {
            _expectLife = entity.otherInfo.expectLife;
        }
        if (![FMUtils isStringEmpty:entity.weight]) {
            _weight = entity.weight;
        }
        if (![FMUtils isStringEmpty:entity.life]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSNumber *life = [f numberFromString:entity.life];
            if (life.integerValue > 1) {
                _lifespan = [NSString stringWithFormat:@"%@ %@",entity.life,[[BaseBundle getInstance] getStringByKey:@"asset_life_span_unit" inTable:nil]] ;
            } else {
                _lifespan = [NSString stringWithFormat:@"%@ %@",entity.life,[[BaseBundle getInstance] getStringByKey:@"asset_life_span_unit" inTable:nil]] ;
            }
        }
        if (![FMUtils isStringEmpty:entity.otherInfo.list]) {
            _list = entity.otherInfo.list;
        }
        if (![FMUtils isStringEmpty:entity.eqDescription]) {
            _desc = entity.eqDescription;
        }
        
        if (!_photoArray) {
            _photoArray = [NSMutableArray new];
        } else {
            [_photoArray removeAllObjects];
        }
        
        for (NSNumber *picId in entity.pictureIds) {
            NSURL *imageUrl = [FMUtils getUrlOfImageById:picId];
            [_photoArray addObject:imageUrl];
        }
    }
}

- (void) setFlexible:(BOOL) flexible {
    _flexible = flexible;
    [self updateInfo];
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_photoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    NSLog(@"tmpNumber :%@",tmpNumber);
                    [self handleResultPosition:tmpNumber];
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)setOnMessageHandleListener:(id)handler {
    _handler = handler;
}

//向helper发送点击消息
- (void) handleResultPosition:(NSNumber *) position {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        
        [msg setValue:_photoArray forKeyPath:@"photosArray"];
        [msg setValue:position forKeyPath:@"position"];
        
        [_handler handleMessage:msg];
    }
}

+ (CGFloat) calculateHeightBybaseInfoEntity:(AssetEquipmentDetailEntity *) entity andFlexible:(BOOL)flexible andWidth:(CGFloat)width {
    CGFloat height = 0;
    CGFloat itemHeight = 17;
    CGFloat padding = [FMSize getInstance].defaultPadding;
    CGFloat defaultItemHeight = 26.7f;
    CGFloat photoHeight = 0;
    UIFont * mFont = [FMFont getInstance].font38;
    
    
    CGFloat nameHeight = [BaseLabelView calculateHeightByInfo:entity.name font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_name" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    CGFloat locationHeight = [BaseLabelView calculateHeightByInfo:entity.location font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_location" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    CGFloat descriptionHeight = [BaseLabelView calculateHeightByInfo:entity.eqDescription font:mFont desc:[[BaseBundle getInstance] getStringByKey:@"equipment_description" inTable:nil] labelFont:mFont andLabelWidth:0 andWidth:width-padding];
    
    if (nameHeight < defaultItemHeight) {
        nameHeight = itemHeight;
    }
    if (locationHeight < defaultItemHeight) {
        locationHeight = itemHeight;
    }
    if (descriptionHeight < defaultItemHeight) {
        descriptionHeight = itemHeight;
    }
    if (entity.pictureIds.count > 0) {
        photoHeight = [BasePhotoView calculateHeightByCount:[entity.pictureIds count] width:width-padding*2 addAble:NO showType:PHOTO_SHOW_TYPE_ALL_ONE_LINE];
    }
    if (flexible) {
        height = itemHeight * 19 + nameHeight + locationHeight + descriptionHeight + padding * 23;
        if (photoHeight > 0) {
            height += photoHeight - padding;
        }
    } else {
        height = nameHeight + locationHeight + itemHeight * 5 + padding * 8;
    }
    
    return height;
}

@end

