//
//  InventoryStorageInEditMaterialTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/29.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "InventoryMaterialBaseInfoTableViewCell.h"
#import "DescriptionLabelView.h"
#import "FMUtilsPackages.h"
#import "BasePhotoView.h"
#import "SeperatorView.h"
#import "AttachmentButton.h"
#import "BaseBundle.h"


@interface InventoryMaterialBaseInfoTableViewCell ()<OnMessageHandleListener>
@property (nonatomic, strong) DescriptionLabelView *codeLbl;
@property (nonatomic, strong) DescriptionLabelView *nameMaterialLbl;
@property (nonatomic, strong) DescriptionLabelView *nameWarehouseLbl;
@property (nonatomic, strong) DescriptionLabelView *brandLbl;
@property (nonatomic, strong) DescriptionLabelView *unitLbl;
@property (nonatomic, strong) DescriptionLabelView *modelLbl;
@property (nonatomic, strong) DescriptionLabelView *priceLbl;
@property (nonatomic, strong) DescriptionLabelView *minNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *totalNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *reservedNumberLbl;
@property (nonatomic, strong) DescriptionLabelView *noticeLbl;
@property (nonatomic, strong) DescriptionLabelView *photoLbl;
@property (nonatomic, strong) BasePhotoView *photoView;

@property (nonatomic, strong) DescriptionLabelView *attachmentLbl;
@property (nonatomic, strong) UIView *attachmentView;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray<InventoryMaterialDetailAttachment *> *attachmentArray;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation InventoryMaterialBaseInfoTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

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
        UIColor *descColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor *contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _codeLbl = [[DescriptionLabelView alloc] init];
        _codeLbl.descLbl.font = mFont;
        _codeLbl.descLbl.textColor = descColor;
        _codeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_code" inTable:nil];;
        _codeLbl.contentLbl.font = mFont;
        _codeLbl.contentLbl.textColor = contentColor;
        
        
        _nameMaterialLbl = [[DescriptionLabelView alloc] init];
        _nameMaterialLbl.descLbl.font = mFont;
        _nameMaterialLbl.descLbl.textColor = descColor;
        _nameMaterialLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_name" inTable:nil];;
        _nameMaterialLbl.contentLbl.font = mFont;
        _nameMaterialLbl.contentLbl.textColor = contentColor;
        
        
        _nameWarehouseLbl = [[DescriptionLabelView alloc] init];
        _nameWarehouseLbl.descLbl.font = mFont;
        _nameWarehouseLbl.descLbl.textColor = descColor;
        _nameWarehouseLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_warehouse" inTable:nil];;
        _nameWarehouseLbl.contentLbl.font = mFont;
        _nameWarehouseLbl.contentLbl.textColor = contentColor;
        
        
        _brandLbl = [[DescriptionLabelView alloc] init];
        _brandLbl.descLbl.font = mFont;
        _brandLbl.descLbl.textColor = descColor;
        _brandLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_brand" inTable:nil];;
        _brandLbl.contentLbl.font = mFont;
        _brandLbl.contentLbl.textColor = contentColor;
        
        
        _unitLbl = [[DescriptionLabelView alloc] init];
        _unitLbl.descLbl.font = mFont;
        _unitLbl.descLbl.textColor = descColor;
        _unitLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_unit" inTable:nil];;
        _unitLbl.contentLbl.font = mFont;
        _unitLbl.contentLbl.textColor = contentColor;
        
        
        _modelLbl = [[DescriptionLabelView alloc] init];
        _modelLbl.descLbl.font = mFont;
        _modelLbl.descLbl.textColor = descColor;
        _modelLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_model" inTable:nil];;
        _modelLbl.contentLbl.font = mFont;
        _modelLbl.contentLbl.textColor = contentColor;
        
        
        _priceLbl = [[DescriptionLabelView alloc] init];
        _priceLbl.descLbl.font = mFont;
        _priceLbl.descLbl.textColor = descColor;
        _priceLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_deciding_price" inTable:nil];;
        _priceLbl.contentLbl.font = mFont;
        _priceLbl.contentLbl.textColor = contentColor;
        
        
        _minNumberLbl = [[DescriptionLabelView alloc] init];
        _minNumberLbl.descLbl.font = mFont;
        _minNumberLbl.descLbl.textColor = descColor;
        _minNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_minnumber" inTable:nil];;
        _minNumberLbl.contentLbl.font = mFont;
        _minNumberLbl.contentLbl.textColor = contentColor;
        
        
        _totalNumberLbl = [[DescriptionLabelView alloc] init];
        _totalNumberLbl.descLbl.font = mFont;
        _totalNumberLbl.descLbl.textColor = descColor;
        _totalNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_dbcount" inTable:nil];;
        _totalNumberLbl.contentLbl.font = mFont;
        _totalNumberLbl.contentLbl.textColor = contentColor;
        
        
        _reservedNumberLbl = [[DescriptionLabelView alloc] init];
        _reservedNumberLbl.descLbl.font = mFont;
        _reservedNumberLbl.descLbl.textColor = descColor;
        _reservedNumberLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_reservednumber" inTable:nil];;
        _reservedNumberLbl.contentLbl.font = mFont;
        _reservedNumberLbl.contentLbl.textColor = contentColor;
        
        
        _noticeLbl = [[DescriptionLabelView alloc] init];
        _noticeLbl.descLbl.font = mFont;
        _noticeLbl.descLbl.textColor = descColor;
        _noticeLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_notice" inTable:nil];;
        _noticeLbl.contentLbl.font = mFont;
        _noticeLbl.contentLbl.textColor = contentColor;
        _noticeLbl.contentLbl.numberOfLines = 0;
        
        
        _photoLbl = [[DescriptionLabelView alloc] init];
        _photoLbl.descLbl.font = mFont;
        _photoLbl.descLbl.textColor = descColor;
        _photoLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_photo" inTable:nil];;
        _photoLbl.contentLbl.font = mFont;
        _photoLbl.contentLbl.textColor = contentColor;
        
        
        _photoView = [[BasePhotoView alloc] init];
        [_photoView setEditable:NO];
        [_photoView setEnableAdd:NO];
        [_photoView setOnMessageHandleListener:self];
        _photoView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
//        _photoView.tag = DISPLAY_TYPE_IMAGE;
        
        
        _attachmentLbl = [[DescriptionLabelView alloc] init];
        _attachmentLbl.descLbl.font = mFont;
        _attachmentLbl.descLbl.textColor = descColor;
        _attachmentLbl.descLbl.text =  [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_attachment" inTable:nil];;
        _attachmentLbl.contentLbl.font = mFont;
        _attachmentLbl.contentLbl.textColor = contentColor;
        
        _attachmentView = [[UIView alloc] init];
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameMaterialLbl];
        [self.contentView addSubview:_nameWarehouseLbl];
        [self.contentView addSubview:_brandLbl];
        [self.contentView addSubview:_unitLbl];
        [self.contentView addSubview:_modelLbl];
        [self.contentView addSubview:_priceLbl];
        [self.contentView addSubview:_minNumberLbl];
        [self.contentView addSubview:_totalNumberLbl];
        [self.contentView addSubview:_reservedNumberLbl];
        [self.contentView addSubview:_noticeLbl];
        
        [self.contentView addSubview:_photoLbl];
        [self.contentView addSubview:_photoView];
        
        [self.contentView addSubview:_attachmentLbl];
        [self.contentView addSubview:_attachmentView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_nameMaterialLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_nameWarehouseLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_brandLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_unitLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    [_modelLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
    originY += labelHeight + sepHeight;
    
    if (_isExpand) {
        _priceLbl.hidden = NO;
        _minNumberLbl.hidden = NO;
        _totalNumberLbl.hidden = NO;
        _reservedNumberLbl.hidden = NO;
        _noticeLbl.hidden = NO;
        _photoLbl.hidden = NO;
        _photoView.hidden = NO;
        _attachmentLbl.hidden = NO;
        _attachmentView.hidden = NO;
        
        [_priceLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
        originY += labelHeight + sepHeight;
        
        [_minNumberLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
        originY += labelHeight + sepHeight;
        
        [_totalNumberLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
        originY += labelHeight + sepHeight;
        
        [_reservedNumberLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
        originY += labelHeight + sepHeight;
        
        CGSize noticeTitleSize = [FMUtils getLabelSizeByFont:_noticeLbl.descLbl.font andContent: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_notice" inTable:nil] andMaxWidth:width];
        CGSize noticeContentSize = [FMUtils getLabelSizeByFont:_noticeLbl.contentLbl.font andContent:_noticeLbl.contentLbl.text andMaxWidth:width-padding*2-noticeTitleSize.width];
        CGFloat noticeHeight = labelHeight;
        if (noticeContentSize.height > labelHeight) {
            noticeHeight = noticeContentSize.height;
        }
        [_noticeLbl setFrame:CGRectMake(originX, originY, width-padding*2, noticeHeight)];
        originY += noticeHeight + sepHeight;
        
        if (_showPhotos && _photoArray.count > 0) {
            [_photoLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
            originY += labelHeight;
            
            CGFloat photoViewHeight = 105;
            [_photoView setPhotosWithArray:_photoArray];
            [_photoView setFrame:CGRectMake(originX, originY, width-padding*2, photoViewHeight)];
            originY += photoViewHeight;
        } else {
//            [_photoLbl setFrame:CGRectZero];
//            [_photoView setFrame:CGRectZero];
            [_photoLbl setHidden:YES];
            [_photoView setHidden:YES];
        }
        
        if (_showAttachments && _attachmentArray.count > 0) {
            [_attachmentLbl setFrame:CGRectMake(originX, originY, width-padding*2, labelHeight)];
            CGSize attachmentLblTitleSize = [FMUtils getLabelSizeByFont:_attachmentLbl.descLbl.font andContent:_attachmentLbl.descLbl.text andMaxWidth:width-padding*2];
            
            
            CGFloat attachmentSepHeight = 10;
            CGFloat attachmentWidth = width-padding*2-attachmentLblTitleSize.width;
            CGFloat attachmentOriginX = 0;
            CGFloat attachmentOriginY = 0;
            
            for (InventoryMaterialDetailAttachment *attachment in _attachmentArray) {
                AttachmentButton *attachmentbtn = [[AttachmentButton alloc] initWithFrame:CGRectMake(attachmentOriginX, attachmentOriginY, attachmentWidth, labelHeight + attachmentSepHeight)];
                [attachmentbtn setTitle:attachment.fileName forState:UIControlStateNormal];
                attachmentbtn.titleLabel.font = _attachmentLbl.descLbl.font;
                [attachmentbtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
                attachmentbtn.tag = [attachment.fileId integerValue];
                [attachmentbtn addTarget:self action:@selector(attachmentClick:) forControlEvents:UIControlEventTouchUpInside];
                
                attachmentOriginY += labelHeight + attachmentSepHeight;
                [_attachmentView addSubview:attachmentbtn];
            }
            [_attachmentView setFrame:CGRectMake(padding+attachmentLblTitleSize.width, originY, attachmentWidth, attachmentOriginY)];
            
        } else {
//            [_attachmentView setFrame:CGRectZero];
//            [_attachmentLbl setFrame:CGRectZero];
            [_attachmentView setHidden:YES];
            [_attachmentLbl setHidden:YES];
        }
    } else {
        _priceLbl.hidden = YES;
        _minNumberLbl.hidden = YES;
        _totalNumberLbl.hidden = YES;
        _reservedNumberLbl.hidden = YES;
        _noticeLbl.hidden = YES;
        _photoLbl.hidden = YES;
        _photoView.hidden = YES;
        _attachmentLbl.hidden = YES;
        _attachmentView.hidden = YES;
    }
    
    [_seperator setFrame:CGRectMake(0, height - [FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
}

- (void)updateInfo {
    [_codeLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.code]) {
        [_codeLbl.contentLbl setText:_materialDetail.code];
    }
    
    [_nameMaterialLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.name]) {
        [_nameMaterialLbl.contentLbl setText:_materialDetail.name];
    }
    
    [_nameWarehouseLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.warehouseName]) {
        [_nameWarehouseLbl.contentLbl setText:_materialDetail.warehouseName];
    }
    
    [_brandLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.brand]) {
        [_brandLbl.contentLbl setText:_materialDetail.brand];
    }
    
    [_unitLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.unit]) {
        [_unitLbl.contentLbl setText:_materialDetail.unit];
    }
    
    [_modelLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.model]) {
        [_modelLbl.contentLbl setText:_materialDetail.model];
    }
    
    [_priceLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.price]) {
        [_priceLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_materialDetail.price.doubleValue]];
    }
    
    [_minNumberLbl.contentLbl setText:@""];
    if (_materialDetail.minNumber >= 0) {
        [_minNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_materialDetail.minNumber.doubleValue]];
    }
    
    [_totalNumberLbl.contentLbl setText:@""];
    if (_materialDetail.totalNumber >= 0) {
        [_totalNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_materialDetail.totalNumber.doubleValue]];
    }
    
    [_reservedNumberLbl.contentLbl setText:@""];
    if (_materialDetail.reservedNumber >= 0) {
        [_reservedNumberLbl.contentLbl setText:[NSString stringWithFormat:@"%0.2f",_materialDetail.reservedNumber.doubleValue]];
    }
    
    [_noticeLbl.contentLbl setText:@""];
    if (![FMUtils isStringEmpty:_materialDetail.desc]) {
        [_noticeLbl.contentLbl setText:_materialDetail.desc];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter
- (void)setShowPhotos:(BOOL)showPhotos {
    _showPhotos = showPhotos;
}

- (void)setShowAttachments:(BOOL)showAttachments {
    _showAttachments = showAttachments;
}

- (void)setIsExpand:(BOOL)isExpand {
    _isExpand = isExpand;
}

- (void)setMaterialDetail:(InventoryMaterialDetail *)materialDetail {
    _materialDetail = materialDetail;
    if (!_attachmentArray) {
        _attachmentArray = [NSMutableArray new];
    }
    if (!_photoArray) {
        _photoArray = [NSMutableArray new];
    } else {
        [_photoArray removeAllObjects];
    }
    
    _attachmentArray = _materialDetail.attachment;
    
    for (NSNumber *photoId in _materialDetail.pictures) {
        NSURL *url = [FMUtils getUrlOfImageById:photoId];
        [_photoArray addObject:url];
    }
    
    [self updateInfo];
}



#pragma mark - ClickEvent
- (void)attachmentClick:(UIButton *)sender {
    for (InventoryMaterialDetailAttachment *attachment in _attachmentArray) {
        if ([attachment.fileId isEqualToNumber:[NSNumber numberWithInteger:sender.tag]]) {
            _attachmentBlock(attachment);
        }
    }
}

#pragma mark - OnMessageHandleListener
- (void)handleMessage:(id)msg {
    NSString *magOrigin = [msg valueForKeyPath:@"msgOrigin"];
    if ([magOrigin isEqualToString:NSStringFromClass([BasePhotoView class])]) {
        NSNumber *result = [msg valueForKeyPath:@"result"];
        _photoBlock(result);
    }
}


+ (CGFloat)getItemHeightByExpand:(BOOL)isExpand
                     description:(NSString *)desc
                      photoCount:(NSInteger)photoCount
                 attachmentCount:(NSInteger)attachmentCount {
    CGFloat height = 0;
    CGFloat padding = 15;
    CGFloat sepHeight = 18;
    CGFloat labelHeight = 17;
    CGFloat attachmentSepHeight = 10;
    CGFloat noticeHeight = labelHeight;
    CGFloat photoViewHeight = 105;
    CGFloat width = [FMSize getInstance].screenWidth;
    UIFont *mFont = [FMFont getInstance].font38;
    
    if (!isExpand) {
        height = sepHeight * 7 + labelHeight * 6;
    } else {
        CGSize noticeTitleSize = [FMUtils getLabelSizeByFont:mFont andContent: [[BaseBundle getInstance] getStringByKey:@"inventory_material_desc_notice" inTable:nil] andMaxWidth:width];
        CGSize noticeContentSize = [FMUtils getLabelSizeByFont:mFont andContent:desc andMaxWidth:width-padding*2-noticeTitleSize.width];
        if (noticeContentSize.height > labelHeight) {
            noticeHeight = noticeContentSize.height;
        }
        height = labelHeight*10 + noticeHeight + sepHeight*12;
        
        if (photoCount > 0) {
            height += labelHeight + photoViewHeight;
        }
        if (attachmentCount > 0) {
            height += labelHeight*attachmentCount + attachmentSepHeight*attachmentCount + sepHeight-attachmentSepHeight;
        }
    }
    
    return height;
}

@end
