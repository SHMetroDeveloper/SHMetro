//
//  LocationDetailAccuracyTableViewCell.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 9/29/16.
//  Copyright © 2016 facilityone. All rights reserved.
//

#import "LocationDetailAccuracyTableViewCell.h"
#import "FMUtilsPackages.h"
#import "FMTheme.h"
#import "SeperatorView.h"
#import "BaseBundle.h"

@interface LocationDetailAccuracyTableViewCell ()

@property (nonatomic, strong) UIImageView * editImgView;

@property (nonatomic, strong) UILabel * noticeLbl;
@property (nonatomic, strong) UILabel * accuracyLbl;

@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat sepWidth;
@property (nonatomic, assign) CGFloat imgWidth;


@property (nonatomic, assign) BOOL isInited;

@end

@implementation LocationDetailAccuracyTableViewCell

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
        
//        _paddingLeft = [FMSize getInstance].defaultPadding;
        _paddingLeft = 20;
        _sepWidth = 20;
        _imgWidth = [FMSize getInstance].imgWidthLevel3;
        
        _editImgView = [[UIImageView alloc] init];
        [_editImgView setImage:[[FMTheme getInstance] getImageByName:@"edit_normal"]];
        
        _noticeLbl = [UILabel new];
        _noticeLbl.font = [FMFont getInstance].font42;
        _noticeLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _accuracyLbl = [UILabel new];
        _accuracyLbl.font = [FMFont getInstance].font42;
        _accuracyLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L4];
        _accuracyLbl.textAlignment = NSTextAlignmentRight;
        
        _noticeLbl.text = [[BaseBundle getInstance] getStringByKey:@"attendance_setting_location_notice_pick_accuracy" inTable:nil];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_editImgView];
        [self.contentView addSubview:_noticeLbl];
        [self.contentView addSubview:_accuracyLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    CGFloat sepWidth = 20;
    
    
    CGFloat accuracyWidth = 80;
    
    
    [_noticeLbl setFrame:CGRectMake(_paddingLeft , 0, width-_paddingLeft * 2 - sepWidth-_imgWidth-accuracyWidth, height)];
    
    if (_isEditable) {
        _editImgView.hidden = NO;
        [_accuracyLbl setFrame:CGRectMake(width-_paddingLeft-_imgWidth-sepWidth-accuracyWidth, 0, accuracyWidth, height)];
        
        [_editImgView setFrame:CGRectMake(width-_paddingLeft-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    } else {
        _editImgView.hidden = YES;
        [_accuracyLbl setFrame:CGRectMake(width-_paddingLeft-accuracyWidth, 0, accuracyWidth, height)];
    }
    
    [_seperator setFrame:CGRectMake(0, height - seperatorHeight, width, seperatorHeight)];

}

- (void) updateInfo {
    [_accuracyLbl setText:[[NSString alloc] initWithFormat:@"%ld%@", _accuracy, [[BaseBundle getInstance] getStringByKey:@"meter" inTable:nil]]];
    
    [self setNeedsLayout];
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
}

- (void)setAccuracy:(NSInteger) accuracy {
    _accuracy = accuracy;
    [self updateInfo];
}

+ (CGFloat) calculateHeight {
    return 48;
}

@end

