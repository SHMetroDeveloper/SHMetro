//
//  MyQrCodeViewController.m
//  FMLibraryUI
//
//  Created by Jonzzs on 2017/3/2.
//  Copyright © 2017年 facility. All rights reserved.
//

#import "MyQrCodeViewController.h"
#import "BaseBundle.h"
#import "SystemConfig.h"
#import "BaseDataDbHelper.h"
#import "FMColor.h"
#import "UIImageView+AFNetworking.h"
#import "UserNetRequest.h"

@interface MyQrCodeViewController ()

@property (nonatomic,strong) UIImageView *photoImageView; //用户头像
@property (nonatomic,strong) UILabel *nameLabel; //姓名
@property (nonatomic,strong) UILabel *positionLabel; //职位

@property (nonatomic,strong) UIImageView *qrcodeImageView; //二维码图片
@property (nonatomic,strong) UILabel *describeLabel; //描述文字

@end

@implementation MyQrCodeViewController


- (void) initNavigation {
    
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"user_my_qrcode" inTable:nil]];
    [self setBackAble:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库获取用户信息
    [self getUserInfoFromDB];
}


#pragma mark - 初始化视图

- (void)initLayout {
    
    CGRect contentFrame = [self getContentFrame];
    CGFloat photoHeight = [FMSize getSizeByPixel:174];
    CGFloat photoPadding = [FMSize getInstance].padding60;
    CGFloat labelHeight = [FMSize getInstance].listItemInfoHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //用户头像
    _photoImageView = [[UIImageView alloc] init];
    _photoImageView.layer.cornerRadius = photoHeight / 2;
    _photoImageView.layer.masksToBounds = YES;
    _photoImageView.image = [[FMTheme getInstance] getImageByName:@"user_default_head"];
    [self.view addSubview:_photoImageView];
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(photoHeight));
        make.height.equalTo(@(photoHeight));
        make.left.equalTo(self.view.mas_left).offset(photoPadding);
        make.top.equalTo(self.view.mas_top).offset(photoPadding + CGRectGetMinY(contentFrame));
    }];
    
    //姓名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [FMFont setFontByPX:48];
    _nameLabel.textColor = [FMColor getInstance].grayLevel2;
    [self.view addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_photoImageView.mas_right).offset(photoPadding);
        make.bottom.equalTo(_photoImageView.mas_centerY).offset(-[FMSize getSizeByPixel:14]);
        make.height.equalTo(@(labelHeight));
        make.right.equalTo(self.view.mas_right);
    }];
    
    //职位
    _positionLabel = [[UILabel alloc] init];
    _positionLabel.font = [FMFont getInstance].font38;
    _positionLabel.textColor = [FMColor getInstance].grayLevel5;
    [self.view addSubview:_positionLabel];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_nameLabel.mas_left);
        make.top.equalTo(_nameLabel.mas_bottom).offset([FMSize getSizeByPixel:28]);
        make.height.equalTo(@(labelHeight));
        make.right.equalTo(_nameLabel.mas_right);
    }];
    
    //二维码
    _qrcodeImageView = [[UIImageView alloc] init];
    _qrcodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_qrcodeImageView];
    [_qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_photoImageView.mas_bottom).offset([FMSize getSizeByPixel:108]);
        make.left.equalTo(self.view.mas_left).offset([FMSize getSizeByPixel:188]);
        make.right.equalTo(self.view.mas_right).offset(-[FMSize getSizeByPixel:188]);
        make.height.equalTo(_qrcodeImageView.mas_width);
    }];
    
    //描述文字
    _describeLabel = [[UILabel alloc] init];
    _describeLabel.text = [[BaseBundle getInstance] getStringByKey:@"my_qrcode_describe" inTable:nil];
    _describeLabel.textAlignment = NSTextAlignmentCenter;
    _describeLabel.font = [FMFont getInstance].font38;
    _describeLabel.textColor = [FMColor getInstance].grayLevel5;
    [self.view addSubview:_describeLabel];
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_qrcodeImageView.mas_bottom).offset([FMSize getSizeByPixel:68]);
        make.height.equalTo(@(labelHeight));
    }];
}


#pragma mark - 数据加载

/**
 从数据库获取用户信息
 */
- (void)getUserInfoFromDB {
    
    UserInfo *user = [[BaseDataDbHelper getInstance] queryUserById:[SystemConfig getUserId]];
    if(user) {
        
        //更新用户信息
        [_photoImageView setImageWithURL:[FMUtils getUrlOfImageById:user.pictureId] placeholderImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
        _nameLabel.text = user.name;
        _positionLabel.text = user.organizationName;
        [_qrcodeImageView setImageWithURL:[FMUtils getUrlOfImageById:user.qrcodeId] placeholderImage:[[FMTheme getInstance] getImageByName:@"default"]];
    }
}

@end
