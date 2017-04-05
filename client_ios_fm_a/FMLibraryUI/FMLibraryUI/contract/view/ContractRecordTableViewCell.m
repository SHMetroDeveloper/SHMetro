//
//  ContractRecordTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/12/27.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "ContractRecordTableViewCell.h"
#import "FMUtilsPackages.h"
#import "SeperatorView.h"
#import "UIImageView+AFNetworking.h"
#import "ContractServerConfig.h"
#import "AttachmentButton.h"
#import "ContractDetailEntity.h"

@interface ContractRecordTableViewCell ()
@property (nonatomic, strong) UIImageView *portraitImgView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UILabel *statusLbl;
@property (nonatomic, strong) UIView *attachmentView;
@property (nonatomic, strong) SeperatorView *seperator;

@property (nonatomic, strong) NSNumber *imageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *attachment;
@property (nonatomic, strong) NSString *statusStr;

@property (nonatomic, assign) BOOL isGapped;
@property (nonatomic, assign) BOOL isInited;
@end

@implementation ContractRecordTableViewCell

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
        
        _portraitImgView = [[UIImageView alloc] init];
        
        _nameLbl = [UILabel new];
        _nameLbl.font = [FMFont getInstance].font38;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.numberOfLines = 1;
        
        _statusLbl = [UILabel new];
        _statusLbl.font = [FMFont setFontByPX:32];
        _statusLbl.textAlignment = NSTextAlignmentRight;
        _statusLbl.textColor = [UIColor colorWithRed:0xf5/255.0 green:0x58/255.0 blue:0x58/255.0 alpha:1];
        _statusLbl.numberOfLines = 1;
        
        _timeLbl = [UILabel new];
        _timeLbl.font = [FMFont fontWithSize:12];
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        _timeLbl.textColor = [UIColor colorWithRed:0xba/255.0 green:0xba/255.0 blue:0xba/255.0 alpha:1];
        _timeLbl.numberOfLines = 1;
        
        _descLbl = [UILabel new];
        _descLbl.numberOfLines = 0;
        _descLbl.font = [FMFont getInstance].font38;
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        
        _attachmentView = [UIView new];
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_portraitImgView];
        [self.contentView addSubview:_nameLbl];
        [self.contentView addSubview:_timeLbl];
        [self.contentView addSubview:_descLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_attachmentView];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat portraitWidth = [FMSize getSizeByPixel:144];
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    CGFloat originX = padding;
    CGFloat originY = [FMSize getSizeByPixel:55];

    //头像
    [_portraitImgView setFrame:CGRectMake(originX, originY, portraitWidth, portraitWidth)];
    _portraitImgView.layer.cornerRadius = portraitWidth/2;
    originX += portraitWidth + [FMSize getInstance].padding40;
    originY += 3;  //向下缩进3像素
    
    CGSize statusSize = [FMUtils getLabelSizeByFont:_statusLbl.font andContent:_statusLbl.text andMaxWidth:width];
    CGSize nameSize = [FMUtils getLabelSizeByFont:_nameLbl.font andContent:_nameLbl.text andMaxWidth:width-padding*3-statusSize.width-portraitWidth-[FMSize getInstance].padding40];
    nameSize.height = 17;
    CGSize timeSize = [FMUtils getLabelSizeByFont:_timeLbl.font andContent:_timeLbl.text andMaxWidth:width-padding*2-portraitWidth-[FMSize getInstance].padding40];
    timeSize.height = 14;
    CGSize descSize = [FMUtils getLabelSizeByFont:_descLbl.font andContent:_descLbl.text andMaxWidth:width-padding*2-portraitWidth-[FMSize getInstance].padding40];
    
    [_statusLbl setFrame:CGRectMake(width-statusSize.width-padding, originY+(nameSize.height-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    [_nameLbl setFrame:CGRectMake(originX, originY, nameSize.width, nameSize.height)];
    originY += nameSize.height + (portraitWidth - nameSize.height - timeSize.height - 6);  //上下都缩进3像素
    
    [_timeLbl setFrame:CGRectMake(originX, originY, timeSize.width, timeSize.height)];
    originY += timeSize.height + padding - 5;
    
    //详情lbl
    [_descLbl setFrame:CGRectMake(originX, originY, descSize.width, descSize.height)];
//    originY += descSize.height;
    CGFloat paddingBottom = [FMSize getInstance].padding40;
    originY += descSize.height + paddingBottom;
    
    CGFloat attachmentButtonHeight = 15+10;
    CGFloat attachmentOriginY = 0;
    if (_attachmentView.subviews.count < _attachment.count) {
        for (ContractAttachment *attachment in _attachment) {
            AttachmentButton *attachmenButton = [[AttachmentButton alloc] initWithFrame:CGRectMake(0, attachmentOriginY, width-originX-padding, attachmentButtonHeight)];
            [attachmenButton setTitle:attachment.fileName forState:UIControlStateNormal];
            [attachmenButton setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
            attachmenButton.titleLabel.font = [FMFont getInstance].font38;
            attachmenButton.tag = [attachment.fileId integerValue];
            [attachmenButton addTarget:self action:@selector(attachmentClick:) forControlEvents:UIControlEventTouchUpInside];
            
            attachmentOriginY += attachmentButtonHeight;
            [_attachmentView addSubview:attachmenButton];
        }
    }
    if (_attachment.count > 0) {
        _attachmentView.hidden = NO;
        if (attachmentOriginY < _attachmentView.frame.size.height) {
            attachmentOriginY = _attachmentView.frame.size.height;
        }
        [_attachmentView setFrame:CGRectMake(originX, originY, width-originX-padding, attachmentOriginY)];
        originY += attachmentOriginY;
    } else {
        _attachmentView.hidden = YES;
    }

    if (_isGapped) {
        [_seperator setDotted:YES];
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding*2, seperatorHeight)];
    } else {
        [_seperator setDotted:NO];
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
    
}

- (void)updateInfo {
    NSURL *imgURL = [FMUtils getUrlOfImageById:_imageId];
    [_portraitImgView setImageWithURL:imgURL placeholderImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
    
    [_nameLbl setText:@""];
    if (![FMUtils isStringEmpty:_name]) {
        [_nameLbl setText:_name];
    } else {
        [_nameLbl setText:[[BaseBundle getInstance] getStringByKey:@"contract_handler_system" inTable:nil]];
    }
    
    [_timeLbl setText:@""];
    if (![FMUtils isNumberNullOrZero:_time]) {
        NSString *timeStr = [FMUtils getDateTimeDescriptionBy:_time format:@"yyyy-MM-dd HH:mm"];
        [_timeLbl setText:timeStr];
    }
    
    [_descLbl setText:@""];
    if (![FMUtils isStringEmpty:_desc]) {
        [_descLbl setText:_desc];
    }
    
    UIColor *statusColor = [ContractServerConfig getOperationRecordTypeColor:_status];
    [_statusLbl setTextColor:statusColor];
    
    _statusStr = [ContractServerConfig getOperationRecordTypeDesc:_status];
    [_statusLbl setText:@""];
    if (![FMUtils isStringEmpty:_statusStr]) {
        [_statusLbl setText:[NSString stringWithFormat:@"%@",_statusStr]];
    }
    
    [self setNeedsLayout];
}

- (void)setSeperatorGapped:(BOOL)isGapped {
    _isGapped = isGapped;
}

- (void)setPortraitWithImageId:(NSNumber *) imageId {
    _imageId = imageId;
}

- (void)setInfoWithName:(NSString *)name
                   desc:(NSString *)desc
                   time:(NSNumber *)time
                 status:(NSInteger)status
             attachment:(NSMutableArray *)attachment {
    _name = name;
    _desc = desc;
    _time = time;
    _status = status;
    _attachment = attachment;
    
    [self updateInfo];
}

- (void)attachmentClick:(UIButton *)sender {
    for (ContractAttachment *attachment in _attachment) {
        if ([attachment.fileId isEqualToNumber:[NSNumber numberWithInteger:sender.tag]]) {
            _actionBlock(attachment);
            break;
        }
    }
}

+ (CGFloat)calculateHeightByDesc:(NSString *)content andAttachmentCount:(NSInteger)count {
    CGFloat height = 0;
    CGFloat realWidth = [FMSize getInstance].screenWidth;
    CGFloat portraitWidth = [FMSize getSizeByPixel:144];
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat seperatorHeight = [FMSize getInstance].padding40;
    CGFloat nameHeight = 17.0f;
    CGFloat timeHeigth = 14.0f;
    CGFloat attachmentHeight = 25;
    
    NSString *str = [content substringWithRange:NSMakeRange(content.length-1, 1)];
    if ([str isEqualToString:@"\n"]) {
        NSMutableString *desc = [[NSMutableString alloc] initWithString:content];
        [desc deleteCharactersInRange:NSMakeRange(content.length-1, 1)];
        str = desc;
    } else {
        str = content;
    }
    
    CGSize descSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font38 andContent:str andMaxWidth:realWidth-padding*2-portraitWidth-[FMSize getInstance].padding40];
    
    height = [FMSize getSizeByPixel:55] + 3 + nameHeight + (portraitWidth - nameHeight - timeHeigth - 6) + timeHeigth + padding - 5 + descSize.height + seperatorHeight;
    
    if (count > 0) {
        height += count*attachmentHeight;
    }
    return height;
}

@end
