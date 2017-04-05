//
//  BulletinReaderCollectionViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/10.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinReaderCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "FMUtilsPackages.h"

@interface BulletinReaderCollectionViewCell ()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *projectLbl;

@property (nonatomic, assign) BOOL isInited;
@end

@implementation BulletinReaderCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _paddingLeft = _paddingRight = 30;
        
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView setImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
        
        
        _nameLbl = [UILabel new];
        _nameLbl.font = [FMFont getInstance].font38;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        
        _projectLbl = [UILabel new];
        _projectLbl.font = [FMFont getInstance].font38;
        _projectLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        _projectLbl.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_projectLbl];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat paddingTop = 16;
    CGFloat originX = _paddingLeft;
    CGFloat originY = paddingTop;
    
    CGFloat imageWidth = width-_paddingLeft-_paddingRight;
    
    _avatarImageView.layer.cornerRadius = imageWidth/2;
    _avatarImageView.layer.masksToBounds = YES;
    [_avatarImageView setFrame:CGRectMake(originX, originY, imageWidth, imageWidth)];
    originY += imageWidth + 8.5;   //8.5为头像与名字之间的分割高度
    
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, originY, width-15, 17)];
    _nameLbl.center = CGPointMake(_avatarImageView.center.x, originY + (17)/2);
    originY += 17 + 2; //2为两个label之间的间隙

    CGFloat projectWidth = width - 15;

    [_projectLbl setFrame:CGRectMake(0, originY, projectWidth, 17)];
    _projectLbl.center = CGPointMake(_nameLbl.center.x, originY+(17)/2);
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    _paddingLeft = paddingLeft;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    _paddingRight = paddingRight;
}

- (void)setImageId:(NSNumber *)imageId {
    if (![FMUtils isNumberNullOrZero:imageId]) {
        NSURL *imageURL = [FMUtils getUrlOfImageById:imageId];
        [_avatarImageView setImageWithURL:imageURL placeholderImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
    } else {
        [_avatarImageView setImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
    }
}

- (void)setName:(NSString *)name {
    if (![FMUtils isStringEmpty:name]) {
        [_nameLbl setText:name];
    } else {
        [_nameLbl setText:@""];
    }
    
}

- (void)setProjectName:(NSString *)projectName {
    if (![FMUtils isStringEmpty:projectName]) {
        [_projectLbl setText:[NSString stringWithFormat:@"(%@)",projectName]];
    } else {
        [_projectLbl setText:@""];
    }
    [self setNeedsLayout];
}


@end

