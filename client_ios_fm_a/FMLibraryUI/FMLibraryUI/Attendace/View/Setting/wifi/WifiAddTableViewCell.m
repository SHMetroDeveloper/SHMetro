//
//  WifiTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/28/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "WifiAddTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"

@interface WifiAddTableViewCell ()

@property (nonatomic, strong) UIImageView * checkImgView;
@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UILabel * descLbl;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat sepWidth;
@property (nonatomic, assign) CGFloat imgWidth;


@property (nonatomic, assign) BOOL isInited;

@end

@implementation WifiAddTableViewCell

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
        
        _paddingLeft = [FMSize getInstance].defaultPadding;
        _sepWidth = 20;
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        _checked = NO;
        
        _checkImgView = [[UIImageView alloc] init];
        
        _nameLbl = [UILabel new];
        _nameLbl.font = [FMFont getInstance].font42;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _descLbl = [UILabel new];
        _descLbl.font = [FMFont getInstance].font38;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_checkImgView];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat sepHeight = 6;
    CGFloat sepWidth = 20;
    
    CGFloat originY = 0;
    CGFloat paddingTop = 0;
    
    CGFloat nameHeight = [FMUtils heightForStringWith:_nameLbl value:_name andWidth:width-_paddingLeft * 2 - sepWidth-_imgWidth];
    CGFloat descHeight = [FMUtils heightForStringWith:_descLbl value:_desc andWidth:width-_paddingLeft * 2- sepWidth-_imgWidth];
    paddingTop = (height - nameHeight - descHeight - sepHeight)/2;
    
    [_checkImgView setFrame:CGRectMake(_paddingLeft, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    originY = paddingTop;
    [_nameLbl setFrame:CGRectMake(_paddingLeft + _imgWidth + sepWidth, originY, width-_paddingLeft * 2 - sepWidth-_imgWidth, nameHeight)];
    originY += nameHeight + sepHeight;
    
    [_descLbl setFrame:CGRectMake(_paddingLeft + _imgWidth + sepWidth, originY, width-_paddingLeft * 2 - sepWidth-_imgWidth, descHeight)];
    originY += descHeight;
    
    if(_isLast) {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];
    } else {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(_paddingLeft, height - seperatorHeight, width-_paddingLeft*2, seperatorHeight)];
    }
    
}

- (void) updateInfo {
    if(_checked) {
        [_checkImgView setImage:[[FMTheme getInstance] getImageByName:@"icon_checked"]];
    } else {
        [_checkImgView setImage:[[FMTheme getInstance] getImageByName:@"icon_unchecked"]];
    }
    [_nameLbl setText:_name];
    [_descLbl setText:_desc] ;
    
    [self setNeedsLayout];
}

- (void)setName:(NSString *)name {
    _name = @"";
    if (![FMUtils isStringEmpty:name]) {
        _name = name;
    }
    [self updateInfo];
}

- (void)setDesc:(NSString *)desc {
    _desc = @"";
    if (![FMUtils isStringEmpty:desc]) {
        _desc = desc;
    }
    [self updateInfo];
}

- (void) setChecked:(BOOL)checked {
    _checked = checked;
    [self updateInfo];
}

- (void) setIsLast:(BOOL)isLast {
    _isLast = isLast;
    [self setNeedsLayout];
}

+ (CGFloat) calculateHeight {
    return 70;
}

@end

