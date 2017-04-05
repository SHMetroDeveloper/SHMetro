//
//  ContractBaseInfoTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/26.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractBaseInfoTableViewCell.h"
#import "FMUtilsPackages.h"
#import "DescriptionLabelView2.h"
#import "ColorLabel.h"
#import "SeperatorView.h"
#import "ContractServerConfig.h"
#import "AttachmentButton.h"

@interface PhoneButton : UIButton
@end
@implementation PhoneButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat height = CGRectGetHeight(contentRect);
    CGFloat width = CGRectGetWidth(contentRect);
    CGFloat imageWidth = 17;
    CGFloat imageHeight = 17;
    
    CGRect newRect = CGRectMake((width-imageWidth)/2, (height - imageHeight)/2, imageWidth, imageHeight);
    return newRect;
}
@end


@interface ContractBaseInfoTableViewCell ()
@property (nonatomic, strong) UILabel *codeLbl;
@property (nonatomic, strong) ColorLabel *paymentLbl;  //收付类型
@property (nonatomic, strong) ColorLabel *statusLbl;    //合同状态
@property (nonatomic, strong) DescriptionLabelView2 *nameLbl;  //合同名称
@property (nonatomic, strong) DescriptionLabelView2 *categoryLbl;  //合同分类
@property (nonatomic, strong) DescriptionLabelView2 *moneyLbl;
@property (nonatomic, strong) DescriptionLabelView2 *payMethodLbl;
@property (nonatomic, strong) DescriptionLabelView2 *signDateLbl;
@property (nonatomic, strong) DescriptionLabelView2 *clerkLbl;
@property (nonatomic, strong) DescriptionLabelView2 *departmentLbl;
@property (nonatomic, strong) DescriptionLabelView2 *dueDateLbl;

@property (nonatomic, strong) DescriptionLabelView2 *partyALbl;
@property (nonatomic, strong) PhoneButton *partyAPhoneBtn;
@property (nonatomic, strong) DescriptionLabelView2 *partyAChargeLbl;

@property (nonatomic, strong) DescriptionLabelView2 *partyBLbl;
@property (nonatomic, strong) PhoneButton *partyBPhoneBtn;
@property (nonatomic, strong) DescriptionLabelView2 *partyBChargeLbl;

@property (nonatomic, strong) UIView *dynamicView;
@property (nonatomic, assign) NSInteger dynamicCount;

@property (nonatomic, strong) DescriptionLabelView2 *contentLbl;
@property (nonatomic, strong) DescriptionLabelView2 *attachmentLbl;
@property (nonatomic, strong) UIView *attachmentView;
@property (nonatomic, strong) NSMutableArray *attachmentArray;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) ContractDetailEntity *contractDetail;

@property (nonatomic, strong) NSString *paymentStr;
@property (nonatomic, strong) NSString *statusStr;

@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractBaseInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _codeLbl = [UILabel new];
        _codeLbl.textColor = contentColor;
        _codeLbl.font = [FMFont getInstance].font44;
        
        _paymentLbl = [[ColorLabel alloc] init];
        
        _statusLbl = [[ColorLabel alloc] init];
        
        _nameLbl = [[DescriptionLabelView2 alloc] init];
        _nameLbl.titleLbl.font = mFont;
        _nameLbl.titleLbl.textColor = titleColor;
        _nameLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_name" inTable:nil];
        _nameLbl.contentLbl.font = mFont;
        _nameLbl.contentLbl.textColor = contentColor;
        
        _categoryLbl = [[DescriptionLabelView2 alloc] init];
        _categoryLbl.titleLbl.font = mFont;
        _categoryLbl.titleLbl.textColor = titleColor;
        _categoryLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_category" inTable:nil];
        _categoryLbl.contentLbl.font = mFont;
        _categoryLbl.contentLbl.textColor = contentColor;
        
        _moneyLbl = [[DescriptionLabelView2 alloc] init];
        _moneyLbl.titleLbl.font = mFont;
        _moneyLbl.titleLbl.textColor = titleColor;
        _moneyLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_money" inTable:nil];
        _moneyLbl.contentLbl.font = mFont;
        _moneyLbl.contentLbl.textColor = contentColor;
        
        _payMethodLbl = [[DescriptionLabelView2 alloc] init];
        _payMethodLbl.titleLbl.font = mFont;
        _payMethodLbl.titleLbl.textColor = titleColor;
        _payMethodLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_paymethod" inTable:nil];
        _payMethodLbl.contentLbl.font = mFont;
        _payMethodLbl.contentLbl.textColor = contentColor;
        
        _signDateLbl = [[DescriptionLabelView2 alloc] init];
        _signDateLbl.titleLbl.font = mFont;
        _signDateLbl.titleLbl.textColor = titleColor;
        _signDateLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_signdate" inTable:nil];
        _signDateLbl.contentLbl.font = mFont;
        _signDateLbl.contentLbl.textColor = contentColor;
        
        _clerkLbl = [[DescriptionLabelView2 alloc] init];
        _clerkLbl.titleLbl.font = mFont;
        _clerkLbl.titleLbl.textColor = titleColor;
        _clerkLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_clerk" inTable:nil];
        _clerkLbl.contentLbl.font = mFont;
        _clerkLbl.contentLbl.textColor = contentColor;
        
        _departmentLbl = [[DescriptionLabelView2 alloc] init];
        _departmentLbl.titleLbl.font = mFont;
        _departmentLbl.titleLbl.textColor = titleColor;
        _departmentLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_department" inTable:nil];
        _departmentLbl.contentLbl.font = mFont;
        _departmentLbl.contentLbl.textColor = contentColor;
        
        _dueDateLbl = [[DescriptionLabelView2 alloc] init];
        _dueDateLbl.titleLbl.font = mFont;
        _dueDateLbl.titleLbl.textColor = titleColor;
        _dueDateLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_duedate" inTable:nil];
        _dueDateLbl.contentLbl.font = mFont;
        _dueDateLbl.contentLbl.textColor = contentColor;
        
        _partyALbl = [[DescriptionLabelView2 alloc] init];
        _partyALbl.titleLbl.font = mFont;
        _partyALbl.titleLbl.textColor = titleColor;
        _partyALbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_partyA" inTable:nil];
        _partyALbl.contentLbl.font = mFont;
        _partyALbl.contentLbl.textColor = contentColor;
        
        _partyAPhoneBtn = [[PhoneButton alloc] init];
        _partyAPhoneBtn.tag = 100;
        [_partyAPhoneBtn setImage:[[FMTheme getInstance] getImageByName:@"home_phone_call"] forState:UIControlStateNormal];
        [_partyAPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _partyAChargeLbl = [[DescriptionLabelView2 alloc] init];
        _partyAChargeLbl.titleLbl.font = mFont;
        _partyAChargeLbl.titleLbl.textColor = titleColor;
        _partyAChargeLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_partyACharge" inTable:nil];
        _partyAChargeLbl.contentLbl.font = mFont;
        _partyAChargeLbl.contentLbl.textColor = contentColor;
        
        _partyBLbl = [[DescriptionLabelView2 alloc] init];
        _partyBLbl.titleLbl.font = mFont;
        _partyBLbl.titleLbl.textColor = titleColor;
        _partyBLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_partyB" inTable:nil];
        _partyBLbl.contentLbl.font = mFont;
        _partyBLbl.contentLbl.textColor = contentColor;
        
        _partyBPhoneBtn = [[PhoneButton alloc] init];
        _partyBPhoneBtn.tag = 200;
        [_partyBPhoneBtn setImage:[[FMTheme getInstance] getImageByName:@"home_phone_call"] forState:UIControlStateNormal];
        [_partyBPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _partyBChargeLbl = [[DescriptionLabelView2 alloc] init];
        _partyBChargeLbl.titleLbl.font = mFont;
        _partyBChargeLbl.titleLbl.textColor = titleColor;
        _partyBChargeLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_partyBCharge" inTable:nil];
        _partyBChargeLbl.contentLbl.font = mFont;
        _partyBChargeLbl.contentLbl.textColor = contentColor;
        
        _dynamicView = [UIView new];
        
        _contentLbl = [[DescriptionLabelView2 alloc] init];
        _contentLbl.titleLbl.font = mFont;
        _contentLbl.titleLbl.textColor = titleColor;
        [_contentLbl setTitle:[[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_content" inTable:nil]];
        _contentLbl.contentLbl.font = mFont;
        _contentLbl.contentLbl.textColor = contentColor;
        _contentLbl.contentLbl.numberOfLines = 0;
        
        _attachmentLbl = [[DescriptionLabelView2 alloc] init];
        _attachmentLbl.titleLbl.font = mFont;
        _attachmentLbl.titleLbl.textColor = titleColor;
        _attachmentLbl.titleLbl.text = [[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_attachment" inTable:nil];
        _attachmentLbl.contentLbl.font = mFont;
        _attachmentLbl.contentLbl.textColor = contentColor;
        
        _attachmentView = [UIView new];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_paymentLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_categoryLbl];
        [self.contentView addSubview:_moneyLbl];
        [self.contentView addSubview:_payMethodLbl];
        [self.contentView addSubview:_signDateLbl];
        [self.contentView addSubview:_clerkLbl];
        [self.contentView addSubview:_departmentLbl];
        [self.contentView addSubview:_dueDateLbl];
        [self.contentView addSubview:_partyALbl];
        [self.contentView addSubview:_partyAChargeLbl];
        [self.contentView addSubview:_partyAPhoneBtn];
        [self.contentView addSubview:_partyBLbl];
        [self.contentView addSubview:_partyBChargeLbl];
        [self.contentView addSubview:_partyBPhoneBtn];
        [self.contentView addSubview:_dynamicView];
        [self.contentView addSubview:_contentLbl];
        [self.contentView addSubview:_attachmentLbl];
        [self.contentView addSubview:_attachmentView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat padding = 15;
    CGFloat paddingTop = 18;
    CGFloat sepHeight = 10;
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat codeHeight = 19;
    CGFloat labelHeight = 17;
    CGFloat labelWidth = width - padding*2;
    
    CGFloat originX = padding;
    CGFloat originY = paddingTop;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, labelWidth, codeHeight)];
    
    CGSize statusSize = [ColorLabel calculateSizeByInfo:_statusStr];
    [_statusLbl setFrame:CGRectMake(width-padding-statusSize.width, originY+(labelHeight-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    CGSize paymentSize = [ColorLabel calculateSizeByInfo:_paymentStr];
    [_paymentLbl setFrame:CGRectMake(width-padding*2-statusSize.width-paymentSize.width, originY+(labelHeight-paymentSize.height)/2, paymentSize.width, paymentSize.height)];
    
    originY += codeHeight + sepHeight;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_categoryLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_moneyLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_payMethodLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_signDateLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_clerkLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_departmentLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_dueDateLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    originY += labelHeight + sepHeight;
    
    if (_isExpand) {
        _partyALbl.hidden = NO;
        _partyAChargeLbl.hidden = NO;
        _partyBLbl.hidden = NO;
        _partyBChargeLbl.hidden = NO;
        _dynamicView.hidden = NO;
        _contentLbl.hidden = NO;
        _attachmentLbl.hidden = NO;
        _attachmentView.hidden = NO;
        
        _partyAPhoneBtn.hidden = YES;
        if (![FMUtils isStringEmpty:_contractDetail.partyA.telno]) {
            _partyAPhoneBtn.hidden = NO;
        }
        
        _partyBPhoneBtn.hidden = YES;
        if (![FMUtils isStringEmpty:_contractDetail.partyB.telno]) {
            _partyBPhoneBtn.hidden = NO;
        }
        
        CGFloat phoneWidth = 30;
        [_partyALbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        originY += labelHeight + sepHeight;
        
        [_partyAChargeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        CGSize partyAChargeContentSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font38 andContent:[NSString stringWithFormat:@"%@%@",_partyAChargeLbl.titleLbl.text,_partyAChargeLbl.contentLbl.text] andMaxWidth:width-padding*2];
        [_partyAPhoneBtn setFrame:CGRectMake(padding*2+partyAChargeContentSize.width, originY-(phoneWidth-labelHeight)/2, phoneWidth, phoneWidth)];
        originY += labelHeight + sepHeight;
        
        [_partyBLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        originY += labelHeight + sepHeight;
        
        [_partyBChargeLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        CGSize partyBChargeContentSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font38 andContent:[NSString stringWithFormat:@"%@%@",_partyBChargeLbl.titleLbl.text,_partyBChargeLbl.contentLbl.text] andMaxWidth:width-padding*2];
        [_partyBPhoneBtn setFrame:CGRectMake(padding*2+partyBChargeContentSize.width, originY-(phoneWidth-labelHeight)/2, phoneWidth, phoneWidth)];
        originY += labelHeight + sepHeight;
        
        CGFloat dynamicOriginY = 0;
        if (_dynamicView.subviews.count < _dynamicCount) {
            if (_contractDetail.dynamic.text.count > 0) {
                for (ContractDynamicText *dynamicText in _contractDetail.dynamic.text) {
                    DescriptionLabelView2 *tempLabel = [[DescriptionLabelView2 alloc] initWithFrame:CGRectMake(0, dynamicOriginY, labelWidth, labelHeight)];
                    tempLabel.contentLbl.numberOfLines = 0;
                    tempLabel.titleLbl.font = [FMFont getInstance].font38;
                    tempLabel.titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
                    tempLabel.contentLbl.font = [FMFont getInstance].font38;
                    tempLabel.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];;
                    [tempLabel setTitle:[NSString stringWithFormat:@"%@：",dynamicText.name]];
                    [tempLabel setContent:dynamicText.value];
                    
                    CGFloat textHeight = [tempLabel getHeight];
                    if (textHeight <= labelHeight) {
                        textHeight = labelHeight;
                    }
                    [tempLabel setFrame:CGRectMake(0, dynamicOriginY, labelWidth, textHeight)];
                    dynamicOriginY += textHeight + sepHeight;
                    [_dynamicView addSubview:tempLabel];
                }
            }
            if (_contractDetail.dynamic.number.count > 0) {
                for (ContractDynamicNumber *dynamicNumber in _contractDetail.dynamic.number) {
                    DescriptionLabelView2 *tempLabel = [[DescriptionLabelView2 alloc] initWithFrame:CGRectMake(0, dynamicOriginY, labelWidth, labelHeight)];
                    tempLabel.titleLbl.font = [FMFont getInstance].font38;
                    tempLabel.titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
                    tempLabel.contentLbl.font = [FMFont getInstance].font38;
                    tempLabel.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];;
                    [tempLabel setTitle:[NSString stringWithFormat:@"%@：",dynamicNumber.name]];
                    [tempLabel setContent:dynamicNumber.value.stringValue];
                    dynamicOriginY += labelHeight + sepHeight;
                    [_dynamicView addSubview:tempLabel];
                }
            }
            if (_contractDetail.dynamic.option.count > 0) {
                for (ContractDynamicOption *dynamicOption in _contractDetail.dynamic.option) {
                    DescriptionLabelView2 *tempLabel = [[DescriptionLabelView2 alloc] initWithFrame:CGRectMake(0, dynamicOriginY, labelWidth, labelHeight)];
                    tempLabel.titleLbl.font = [FMFont getInstance].font38;
                    tempLabel.titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
                    tempLabel.contentLbl.font = [FMFont getInstance].font38;
                    tempLabel.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];;
                    [tempLabel setTitle:[NSString stringWithFormat:@"%@：",dynamicOption.name]];
                    [tempLabel setContent:dynamicOption.select];
                    dynamicOriginY += labelHeight + sepHeight;
                    [_dynamicView addSubview:tempLabel];
                }
            }
            if (_contractDetail.dynamic.date.count > 0) {
                for (ContractDynamicDate *dynamicDate in _contractDetail.dynamic.date) {
                    DescriptionLabelView2 *tempLabel = [[DescriptionLabelView2 alloc] initWithFrame:CGRectMake(0, dynamicOriginY, labelWidth, labelHeight)];
                    tempLabel.titleLbl.font = [FMFont getInstance].font38;
                    tempLabel.titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
                    tempLabel.contentLbl.font = [FMFont getInstance].font38;
                    tempLabel.contentLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];;
                    [tempLabel setTitle:[NSString stringWithFormat:@"%@：",dynamicDate.name]];
                    [tempLabel setContent:@""];
                    if (![FMUtils isNumberNullOrZero:dynamicDate.value]) {
                        NSString *dateStr = [FMUtils getDateTimeDescriptionBy:dynamicDate.value format:@"yyyy-MM-dd"];
                        [tempLabel setContent:dateStr];
                    }
                    dynamicOriginY += labelHeight + sepHeight;
                    [_dynamicView addSubview:tempLabel];
                }
            }
        }
        if (dynamicOriginY < _dynamicView.frame.size.height) {
            dynamicOriginY = _dynamicView.frame.size.height;
        }
        [_dynamicView setFrame:CGRectMake(originX, originY, labelWidth, dynamicOriginY)];
        originY += dynamicOriginY;
        
        CGFloat contentHeight = [_contentLbl getHeight];
        if (contentHeight <= labelHeight) {
            contentHeight = labelHeight;
        }
        [_contentLbl setFrame:CGRectMake(originX, originY, labelWidth, contentHeight)];
        originY += contentHeight + sepHeight;
        
        [_attachmentLbl setFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        CGFloat titleWidth = _attachmentLbl.titleLbl.frame.size.width;
        CGFloat attachmentOriginX = 0;
        CGFloat attachmentOriginY = 0;
        CGFloat attachmentWidth = _attachmentLbl.frame.size.width - titleWidth;
        CGFloat attachmentSepHeight = sepHeight;
        
        if (_attachmentView.subviews.count < _attachmentArray.count) {
            for (ContractAttachment *attachment in _attachmentArray) {
                AttachmentButton *attachmentbtn = [[AttachmentButton alloc] initWithFrame:CGRectMake(attachmentOriginX, attachmentOriginY, attachmentWidth, labelHeight + attachmentSepHeight)];
                [attachmentbtn setTitle:attachment.fileName forState:UIControlStateNormal];
                attachmentbtn.titleLabel.font = _attachmentLbl.titleLbl.font;
                [attachmentbtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
                attachmentbtn.tag = [attachment.fileId integerValue];
                [attachmentbtn addTarget:self action:@selector(attachmentClick:) forControlEvents:UIControlEventTouchUpInside];
                
                attachmentOriginY += labelHeight + attachmentSepHeight;
                [_attachmentView addSubview:attachmentbtn];
            }
        }
        if (attachmentOriginY < _attachmentView.frame.size.height) {
            attachmentOriginY = _attachmentView.frame.size.height;
        }
        [_attachmentView setFrame:CGRectMake(padding+titleWidth, originY, attachmentWidth, attachmentOriginY)];
        
        originY += labelHeight + paddingTop;
    } else {
        _partyALbl.hidden = YES;
        _partyAChargeLbl.hidden = YES;
        _partyBLbl.hidden = YES;
        _partyBChargeLbl.hidden = YES;
        _dynamicView.hidden = YES;
        _contentLbl.hidden = YES;
        _attachmentLbl.hidden = YES;
        _attachmentView.hidden = YES;
        
        _partyAPhoneBtn.hidden = YES;
        _partyBPhoneBtn.hidden = YES;
    }
    
    [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    
}

- (void)updateInfo {
    [_codeLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.code]) {
        [_codeLbl setText:_contractDetail.code];
    }
    
    _statusStr = [ContractServerConfig getStatusDesc:_contractDetail.status];
    UIColor *statusColor = [ContractServerConfig getStatusColor:_contractDetail.status];
    [_statusLbl setTextColor:[UIColor whiteColor] andBorderColor:statusColor andBackgroundColor:statusColor];
    [_statusLbl setContent:_statusStr];
    
    
    _paymentStr = [ContractServerConfig getPaymentDesc:_contractDetail.payment];
    UIColor *paymentColor = [ContractServerConfig getPaymentColor:_contractDetail.payment];
    [_paymentLbl setTextColor:[UIColor whiteColor] andBorderColor:paymentColor andBackgroundColor:paymentColor];
    [_paymentLbl setContent:_paymentStr];
    
    
    [_nameLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.name]) {
        [_nameLbl.contentLbl setText:_contractDetail.name];
    }
    
    [_categoryLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.type]) {
        [_categoryLbl.contentLbl setText:_contractDetail.type];
    }
    
    NSString *costStr = @"";
    if (![FMUtils isStringEmpty:_contractDetail.cost]) {
        costStr = [costStr stringByAppendingFormat:@"%@",[ContractServerConfig getCurrencyType:_contractDetail.moneyType]];
        costStr = [costStr stringByAppendingFormat:@" %@",_contractDetail.cost];
    }
    [_moneyLbl.contentLbl setText:costStr];
    
    [_payMethodLbl.contentLbl setText:@""];
    NSString *costType = [ContractServerConfig getCostTypeDesc:_contractDetail.costType];
    if (![FMUtils isStringEmpty:costType]) {
        [_payMethodLbl.contentLbl setText:costType];
    }
    
    [_signDateLbl.contentLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_contractDetail.createTime]) {
        NSString *timeStr = [FMUtils getDateTimeDescriptionBy:_contractDetail.createTime format:@"yyyy-MM-dd"];
        [_signDateLbl.contentLbl setText:timeStr];
    }
    
    [_clerkLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.contact]) {
        [_clerkLbl.contentLbl setText:_contractDetail.contact];
    }
    
    [_departmentLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.org]) {
        [_departmentLbl.contentLbl setText:_contractDetail.org];
    }
    
    NSString *dueTime = @"";
    if (![FMUtils isNumberNullOrZero:_contractDetail.startTime]) {
        dueTime = [FMUtils getDateTimeDescriptionBy:_contractDetail.startTime format:@"yyyy-MM-dd"];
    }
    if (![FMUtils isNumberNullOrZero:_contractDetail.endTime]) {
         NSString *tempStr = [FMUtils getDateTimeDescriptionBy:_contractDetail.endTime format:@"yyyy-MM-dd"];
        dueTime = [dueTime stringByAppendingFormat:@"~%@",tempStr];
    }
    [_dueDateLbl.contentLbl setText:dueTime];
    
    [_partyALbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.partyA.name]) {
        [_partyALbl.contentLbl setText:_contractDetail.partyA.name];
    }
    
    [_partyAChargeLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.partyA.contact]) {
        [_partyAChargeLbl.contentLbl setText:_contractDetail.partyA.contact];
    }
    
    [_partyBLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.partyB.name]) {
        [_partyBLbl.contentLbl setText:_contractDetail.partyB.name];
    }
    
    [_partyBChargeLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_contractDetail.partyB.contact]) {
        [_partyBChargeLbl.contentLbl setText:_contractDetail.partyB.contact];
    }
    
    [_contentLbl setContent:@""];
    if (![FMUtils isStringEmpty:_contractDetail.content]) {
        [_contentLbl setContent:_contractDetail.content];
    }
    
    [self setNeedsLayout];
}

- (void)setExpand:(BOOL)isExpand {
    _isExpand = isExpand;
}

- (void)setContractDetail:(ContractDetailEntity *)detail {
    _contractDetail = detail;
    
    _dynamicCount = 0;
    _dynamicCount += _contractDetail.dynamic.text.count;
    _dynamicCount += _contractDetail.dynamic.number.count;
    _dynamicCount += _contractDetail.dynamic.option.count;
//    _dynamicCount += _contractDetail.dynamic.attachment.count;
    _dynamicCount += _contractDetail.dynamic.date.count;
    
    
    if (!_attachmentArray) {
        _attachmentArray = [NSMutableArray new];
    } else {
        [_attachmentArray removeAllObjects];
    }
    if (_contractDetail.attachment.count > 0) {
        [_attachmentArray addObjectsFromArray:_contractDetail.attachment];
    }
    if (_contractDetail.dynamic.attachment.count > 0) {
        [_attachmentArray addObjectsFromArray:_contractDetail.dynamic.attachment];
    }
    
    [self updateInfo];
}

- (void)attachmentClick:(UIButton *)sender {
    for (ContractAttachment *attachment in _attachmentArray) {
        if ([attachment.fileId isEqualToNumber:[NSNumber numberWithInteger:sender.tag]]) {
            _actionBlock(CONTRACT_BASEINFO_ACTION_TYPE_ATTACHMENT, attachment);
            break;
        }
    }
}

- (void)phoneBtnClick:(UIButton *)secnder{
    if (secnder.tag == 100) {
        _actionBlock(CONTRACT_BASEINFO_ACTION_TYPE_PHONE, _contractDetail.partyA);
    } else if (secnder.tag == 200) {
        _actionBlock(CONTRACT_BASEINFO_ACTION_TYPE_PHONE, _contractDetail.partyB);
    }
}

+ (CGFloat)calculateHeightByExpand:(BOOL)isExpand andContractDetail:(ContractDetailEntity *)detail {
    CGFloat height = 0;
    CGFloat paddingTop = 18;
    CGFloat padding = 15;
    CGFloat sepHeight = 10;
    CGFloat codeHeight = 19;
    CGFloat labelHeight = 17;
    CGFloat width = [FMSize getInstance].screenWidth;
    
    UIFont *mFont = [FMFont getInstance].font38;
    UIColor *titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
    UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    DescriptionLabelView2 *tempLabel = [[DescriptionLabelView2 alloc] initWithFrame:CGRectMake(0, 0, width-padding*2, labelHeight)];
    tempLabel.titleLbl.font = mFont;
    tempLabel.titleLbl.textColor = titleColor;
    tempLabel.contentLbl.font = mFont;
    tempLabel.contentLbl.textColor = contentColor;
    
    height = paddingTop*2 + codeHeight +labelHeight*8 + sepHeight*8;
    
    if (isExpand) {
        height += labelHeight*4 + sepHeight*5;
        if (detail.dynamic.text.count > 0) {
            for (ContractDynamicText *dynamicText in detail.dynamic.text) {
                tempLabel.contentLbl.numberOfLines = 0;
                [tempLabel setTitle:dynamicText.name];
                [tempLabel setContent:dynamicText.value];
                CGFloat dynamicTextHeight = [tempLabel getHeight];
                if (dynamicTextHeight <= labelHeight) {
                    dynamicTextHeight = labelHeight;
                }
                height += dynamicTextHeight + sepHeight;
            }
        }
        
        if (detail.dynamic.number.count > 0) {
            height += (labelHeight + sepHeight)*detail.dynamic.number.count;
        }
        
        if (detail.dynamic.option.count > 0) {
            height += (labelHeight + sepHeight)*detail.dynamic.option.count;
        }
        
        if (detail.dynamic.date.count > 0) {
            height += (labelHeight + sepHeight)*detail.dynamic.date.count;
        }
        
        //计算合同主要内容高度
        tempLabel.contentLbl.numberOfLines = 0;
        [tempLabel setTitle:[[BaseBundle getInstance] getStringByKey:@"contract_detail_baseinfo_title_content" inTable:nil]];
        [tempLabel setContent:detail.content];
        CGFloat contentHeight = [tempLabel getHeight];
        if (contentHeight <= labelHeight) {
            contentHeight = labelHeight;
        }
        height += contentHeight + sepHeight;
        
        NSInteger attachmentCount = 0;
        if (detail.attachment.count > 0) {
            attachmentCount += detail.attachment.count;
        }
        if (detail.dynamic.attachment.count > 0) {
            attachmentCount += detail.dynamic.attachment.count;
        }
        if (attachmentCount > 0) {
            height += (labelHeight + sepHeight)*(attachmentCount-1)-sepHeight;
        }
        
        height += labelHeight;
    }
    
    return height;
}

@end

