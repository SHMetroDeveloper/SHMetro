//
//  AssetCoreComponentTableViewCell.m
//  FMLibraryUI
//
//  Created by Master.lyn on 2017/3/6.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "AssetCoreComponentListTableViewCell.h"
#import "FMUtilsPackages.h"
#import "BaseLabelView.h"
#import "SeperatorView.h"

@interface AssetCoreComponentListTableViewCell ()
@property (nonatomic, strong) BaseLabelView *codeLbl;
@property (nonatomic, strong) BaseLabelView *nameLbl;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation AssetCoreComponentListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        UIFont *mFont = [FMFont getInstance].font38;
        UIColor *darkColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        UIColor *lightColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        
        _codeLbl = [[BaseLabelView alloc] init];
        [_codeLbl setLabelFont:mFont andColor:lightColor];
        [_codeLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_code" inTable:nil] andLabelWidth:0];
        [_codeLbl setContentFont:mFont];
        [_codeLbl setContentColor:darkColor];
        
        _nameLbl = [[BaseLabelView alloc] init];
        [_nameLbl setLabelFont:mFont andColor:lightColor];
        [_nameLbl setLabelText:[[BaseBundle getInstance] getStringByKey:@"asset_core_component_name" inTable:nil] andLabelWidth:0];
        [_nameLbl setContentFont:mFont];
        [_nameLbl setContentColor:darkColor];
        
        _tagImgView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance] getImageByName:@"slim_more"]];
        
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_codeLbl];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_tagImgView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat itemHeight = 17;
    CGFloat padding = 15;
    CGFloat imgWidth = [FMSize getInstance].imgWidthLevel3;
    
    CGFloat originX = 0;
    CGFloat originY = padding;
    
    [_codeLbl setFrame:CGRectMake(originX, originY, width-padding, itemHeight)];
    originY += padding + itemHeight;
    
    [_nameLbl setFrame:CGRectMake(originX, originY, width-padding-imgWidth, itemHeight)];
    
    [_tagImgView setFrame:CGRectMake(width-padding-imgWidth, originY+(itemHeight-imgWidth)/2, imgWidth, imgWidth)];
    
    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
}

- (void)updateInfo {
    [_codeLbl setContent:@""];
    if (![FMUtils isStringEmpty:_code]) {
        [_codeLbl setContent:_code];
    }
    
    [_nameLbl setContent:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl setContent:_name];
    }
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setEquipmentCode:(NSString *)code
                 andName:(NSString *)name {
    _code = code;
    _name = name;
    [self updateInfo];
}

+ (CGFloat)getItemHeight {
    CGFloat height = 0;
    CGFloat sepHeight = 15;
    CGFloat itemHeight = 17;
    
    height = sepHeight*3 + itemHeight*2;
    return height;
}

@end
