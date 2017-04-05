//
//  BulletinTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/4.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "BulletinConfig.h"
//#import "UIImageView+HighlightedWebCache.h"
#import "UIImageView+AFNetworking.h"
#import "BaseBundle.h"

@interface BulletinTableViewCell()
@property (nonatomic, strong) UIImageView *themeImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *creatorLbl;
@property (nonatomic, strong) UILabel *annotionLbl;
@property (nonatomic, strong) UILabel *topTagLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) CGFloat annotionWidth;

@property (nonatomic, assign) BOOL isInited;

@end

@implementation BulletinTableViewCell

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
        _annotionWidth = 6;
        
        _themeImageView = [[UIImageView alloc] initWithImage:[[FMTheme getInstance]  getImageByName:@"bulletin_list_default"]];
        
        _titleLbl = [UILabel new];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        _titleLbl.font = [FMFont getInstance].font44;
        _titleLbl.numberOfLines = 1;
        
        _creatorLbl = [UILabel new];
        _creatorLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _creatorLbl.font = [FMFont getInstance].font38;
        _creatorLbl.numberOfLines = 1;
        
        _annotionLbl = [UILabel new];
        _annotionLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_NOTICE];
        _annotionLbl.clipsToBounds = YES;
        _annotionLbl.layer.cornerRadius = _annotionWidth/2;
        
        _topTagLbl = [UILabel new];
        _topTagLbl.layer.cornerRadius = 2;
        _topTagLbl.layer.borderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME].CGColor;
        _topTagLbl.layer.masksToBounds = YES;
        _topTagLbl.layer.borderWidth = 0.4;
        _topTagLbl.font = [FMFont setFontByPX:30];
        _topTagLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BULLETIN_TYPE_TOP];
        _topTagLbl.textAlignment = NSTextAlignmentCenter;
        _topTagLbl.text = [[BaseBundle getInstance] getStringByKey:@"bulletin_top" inTable:nil];
        
        _typeLbl = [UILabel new];
        _typeLbl.layer.cornerRadius = 2;
        _typeLbl.layer.borderColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME].CGColor;
        _typeLbl.layer.borderWidth = 0.4;
        _typeLbl.layer.masksToBounds = YES;
        _typeLbl.font = [FMFont setFontByPX:30];
        _typeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_THEME];
        _typeLbl.textAlignment = NSTextAlignmentCenter;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_themeImageView];
        [self.contentView addSubview:_titleLbl];
        [self.contentView addSubview:_creatorLbl];
        [self.contentView addSubview:_annotionLbl];
        [self.contentView addSubview:_topTagLbl];
        [self.contentView addSubview:_typeLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat padding = 13;
    CGFloat paddingTop = 10;
    
    CGFloat originX = padding;
    CGFloat originY = paddingTop;
    
    CGFloat imageHeight = 66;
    CGFloat imageWidth = 88;
    
    CGFloat titleHeight = 19;
    CGFloat previewHeight = 17;
    
    CGSize topSize = [FMUtils getLabelSizeByFont:_topTagLbl.font andContent:_topTagLbl.text andMaxWidth:MAXFLOAT];
    
    CGSize typeSize = [FMUtils getLabelSizeByFont:_typeLbl.font andContent:_typeLbl.text andMaxWidth:MAXFLOAT];
    
    CGFloat tagHeight = 13 + 4; //拓宽4像素的高度
    
    [_themeImageView setFrame:CGRectMake(originX, originY, imageWidth, imageHeight)];
    originX += imageWidth + padding;
    
    if (_isShowAnnotion) {
        [_titleLbl setFrame:CGRectMake(originX, originY, width-padding*3-imageWidth - _annotionWidth, titleHeight)];
        
        _annotionLbl.hidden = NO;
        [_annotionLbl setFrame:CGRectMake(width-padding-_annotionWidth, originY+(titleHeight - _annotionWidth)/2, _annotionWidth, _annotionWidth)];
    } else {
        [_titleLbl setFrame:CGRectMake(originX, originY, width-padding*3-imageWidth, titleHeight)];
        
        _annotionLbl.hidden = YES;
    }
    originY += titleHeight + 1; //1为title与创建者信息之间的间隔
    
    [_creatorLbl setFrame:CGRectMake(originX, originY, width-padding*3-imageWidth, previewHeight)];
    
    if (_isTop) {
        [_topTagLbl setFrame:CGRectMake(originX, height-paddingTop-tagHeight, topSize.width + 4, tagHeight)];//拓宽4像素
        originX += topSize.width + paddingTop;
        
        [_typeLbl setFrame:CGRectMake(originX, height-paddingTop-tagHeight, typeSize.width + 4, tagHeight)];//拓宽4像素
    } else {
        [_typeLbl setFrame:CGRectMake(originX, height-paddingTop-tagHeight, typeSize.width + 4, tagHeight)];//拓宽4像素
    }
    
    [_seperator setFrame:CGRectMake(0, height-[FMSize getInstance].seperatorHeight, width, [FMSize getInstance].seperatorHeight)];
}

- (void) updateInfo {
    NSString *timeStr = [FMUtils getDateTimeDescriptionBy:_time format:@"yyyy-MM-dd"];
    [_creatorLbl setText:[NSString stringWithFormat:@"%@  %@",_creator,timeStr]];
    
    [_typeLbl setText:[BulletinConfig getNameOfBulletinGradeType:_type]];
    _typeLbl.textColor = [BulletinConfig getColorOfBulletinGradeType:_type];
    _typeLbl.layer.borderColor = [BulletinConfig getColorOfBulletinGradeType:_type].CGColor;

    [self setNeedsLayout];
}

#pragma mark - Setter
- (void)setIsShowAnnotion:(BOOL)isShowAnnotion {
    _isShowAnnotion = isShowAnnotion;
}

- (void)setIsTop:(BOOL)isTop {
    _isTop = isTop;
    _topTagLbl.hidden = !_isTop;
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)setThemeImageId:(NSNumber *)themeImageId {
    NSURL *imageRUL = [FMUtils getUrlOfImageById:themeImageId];
    [_themeImageView setImageWithURL:imageRUL placeholderImage:[[FMTheme getInstance]  getImageByName:@"bulletin_list_default"]];
}

- (void)setTitle:(NSString *)title {
    _title = @"";
    if (![FMUtils isStringEmpty:title]) {
        _title = [title copy];
    }
    [_titleLbl setText:_title];
}

- (void)setTime:(NSNumber *)time {
    _time = time;
}

- (void)setCreator:(NSString *)creator {
    _creator = @"";
    if (![FMUtils isStringEmpty:creator]) {
        _creator = [creator copy];
    }
    
    [self updateInfo];
}

+ (CGFloat) getHeightOfCell {
    CGFloat height = 86;
    
    return height;
}

@end

