//
//  AssetWorkOrderTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetWorkOrderTableViewCell.h"
#import "FMUtilsPackages.h"
#import "ColorLabel.h"
#import "SeperatorView.h"
#import "WorkOrderServerConfig.h"

@interface AssetWorkOrderTableViewCell ()
@property (nonatomic, strong) UILabel *codeLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) ColorLabel *statusLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation AssetWorkOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_isInited) {
        _isInited = NO;
        
        _codeLbl = [UILabel new];
        _codeLbl.font = [FMFont getInstance].font44;
        _codeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _timeLbl = [UILabel new];
        _timeLbl.font = [FMFont getInstance].font38;
        _timeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        
        _statusLbl = [[ColorLabel alloc] init];
        [_statusLbl setShowCorner:YES];
        
        
        _descLbl = [UILabel new];
        _descLbl.font = [FMFont getInstance].font38;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        
        _tagImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        
        _seperator = [[SeperatorView alloc] init];
        
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_timeLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_tagImgView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = 15;
    CGFloat sepHeight = 15;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 17;
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    
    CGFloat originX = padding;
    CGFloat originY = sepHeight;
    
    CGSize stateSize = [ColorLabel calculateSizeByInfo:[WorkOrderServerConfig getOrderStatusDesc:_status]];
    [_statusLbl setFrame:CGRectMake(width-padding-stateSize.width, originY+(codeHeight-stateSize.height)/2, stateSize.width, stateSize.height)];
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding*3-stateSize.width, codeHeight)];
    originY += codeHeight + sepHeight;
    
    [_timeLbl setFrame:CGRectMake(originX, originY, width-padding*2, itemHeight)];
    originY += itemHeight + sepHeight;
    
    [_descLbl setFrame:CGRectMake(originX, originY, width-padding*3-imgWidth, itemHeight)];
    
    [_tagImgView setFrame:CGRectMake(width-padding-imgWidth, originY+(itemHeight-imgWidth)/2, imgWidth, imgWidth)];
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    [_codeLbl setText:@""];
    if (![FMUtils isStringEmpty:_code]) {
        [_codeLbl setText:_code];
    }
    
    [_timeLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_time]) {
        NSString *timeStr = [FMUtils getDateTimeDescriptionBy:_time format:@"MM-dd hh:mm"];
        [_timeLbl setText:timeStr];
    }
    
    [_descLbl setText:@""];
    if (![FMUtils isStringEmpty:_desc]) {
        [_descLbl setText:_desc];
    }
    
    NSString *statusStr = [WorkOrderServerConfig getOrderStatusDesc:_status];
    UIColor *statusColor = [WorkOrderServerConfig getOrderStatusColor:_status];
    [_statusLbl setContent:statusStr];
    [_statusLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:statusColor andBackgroundColor:statusColor];
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setInfoWithCode:(NSString *)code
                   time:(NSNumber *)time 
                   desc:(NSString *)desc
                 status:(NSInteger)status {
    _code = code;
    _time = time;
    _desc = desc;
    _status = status;
    
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat sepHeight = 15;
    CGFloat codeHeight = 19;
    CGFloat itemHeight = 17;
    
    
    height = sepHeight*4 + codeHeight + itemHeight*2;
    return height;
}

@end

