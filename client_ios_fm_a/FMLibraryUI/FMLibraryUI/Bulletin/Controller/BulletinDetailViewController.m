//
//  BulletinDetailViewController.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/11/8.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "BulletinDetailViewController.h"
#import "FMUtilsPackages.h"
#import "BulletinBusiness.h"
#import "ImageItemView.h"
//#import "UIImageView+HighlightedWebCache.h"
#import "UIImageView+AFNetworking.h"
#import "BulletinAttachmentView.h"
#import "AttachmentViewController.h"
#import "BulletinReadStateViewController.h"
#import "BaseBundle.h"

#import "YYText.h"

@interface ReadStateButton : UIButton
@end

@implementation ReadStateButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[FMFont getInstance].font38 forKey:NSFontAttributeName];
    CGSize size = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat originX = 0;
    CGFloat originY = 9;
    CGRect newRect = CGRectMake(originX, originY, size.width, size.height);
    
    return newRect;
}
@end








@interface BulletinDetailViewController ()
@property (nonatomic, strong) UIScrollView *mainContainerView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *creatorLbl;
@property (nonatomic, strong) ReadStateButton *readStateLbl;
@property (nonatomic, strong) UIImageView *themeImageView;
@property (nonatomic, strong) UILabel *contentView;
@property (nonatomic, strong) BulletinAttachmentView *attachmentView;

@property (nonatomic, strong) ImageItemView *noticeLbl;   //提示
@property (nonatomic, assign) CGFloat noticeHeight;   //提示高度

@property (nonatomic, assign) CGFloat realWidth;
@property (nonatomic, assign) CGFloat realHeight;

@property (nonatomic, strong) BulletinBusiness *business;
@property (nonatomic, strong) __block BulletinDetail *bulletinDetail;

@end

@implementation BulletinDetailViewController

- (void)initNavigation {
    [self setBackAble:YES];
    [self setTitleWith:[[BaseBundle getInstance] getStringByKey:@"function_notice" inTable:nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initLayout {
    if (!_mainContainerView) {
        CGRect mFrame = [self getContentFrame];
        _realWidth = CGRectGetWidth(mFrame);
        _realHeight = CGRectGetHeight(mFrame);
        
        _business = [BulletinBusiness getInstance];
        
        _mainContainerView = [[UIScrollView alloc] initWithFrame:mFrame];
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [FMFont setFontByPX:54];
        _titleLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L2];
        
        _creatorLbl = [UILabel new];
        _creatorLbl.font = [FMFont getInstance].font38;
        _creatorLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L10];
        
        _readStateLbl = [ReadStateButton new];
        _readStateLbl.titleLabel.font = [FMFont getInstance].font38;
        _readStateLbl.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_readStateLbl setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [_readStateLbl setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_readStateLbl addTarget:self action:@selector(gotoReadStateDetail) forControlEvents:UIControlEventTouchUpInside];
        
        _themeImageView = [[UIImageView alloc] init];
        [_themeImageView setHidden:YES];
        
        _contentView = [[UILabel alloc] init];
        _contentView.font = [FMFont getInstance].font44;
        _contentView.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _contentView.numberOfLines = 0;
        
        _attachmentView = [[BulletinAttachmentView alloc] init];
        __weak typeof(self) weakSelf = self;
        _attachmentView.actionBlock = ^(BulletinAttachment *attachment){
            NSURL *attachmentURL = [FMUtils getUrlOfAttachmentById:attachment.attachmentId];
            AttachmentViewController *attachmentVC = [[AttachmentViewController alloc] initWithAttachmentURL:attachmentURL];
            [attachmentVC setTitleByFileName:attachment.name];
            [weakSelf gotoViewController:attachmentVC];
        };
        
        [_mainContainerView addSubview:_titleLbl];
        [_mainContainerView addSubview:_creatorLbl];
        [_mainContainerView addSubview:_readStateLbl];
        [_mainContainerView addSubview:_themeImageView];
        [_mainContainerView addSubview:_contentView];
        [_mainContainerView addSubview:_attachmentView];
        [_mainContainerView addSubview:self.noticeLbl];
        
        
        [self.view addSubview:_mainContainerView];
    }
}

#pragma mark - Lazyload
- (ImageItemView *)noticeLbl {
    if (!_noticeLbl) {
        _noticeHeight = [FMSize getInstance].noticeHeight;
        _noticeLbl = [[ImageItemView alloc] initWithFrame:CGRectMake(0, (_realHeight-_noticeHeight)/2, _realWidth, _noticeHeight)];
        [_noticeLbl setInfoWithName:[[BaseBundle getInstance] getStringByKey:@"bulletin_detail_no_data" inTable:nil] andLogo:[[FMTheme getInstance]  getImageByName:@"no_data"] andHighlightLogo:[[FMTheme getInstance]  getImageByName:@"no_data"]];
        [_noticeLbl setHidden:YES];
        [_noticeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6]];
        [_noticeLbl setLogoWidth:[FMSize getInstance].noticeLogoWidth andLogoHeight:[FMSize getInstance].noticeLogoHeight];
    }
    return _noticeLbl;
}

- (void) updateViews {
    CGFloat paddingTop = 16;
    CGFloat paddingLeft = 13;
    CGFloat padding36 = 12;
    CGFloat sepHeight28 = 9;
    CGFloat sepHeight50 = 16.5;
    CGFloat sepHeight60 = 20;
    CGFloat sepHeight78 = 26 - 6.25;
    CGFloat creatorHeight = 17;
    
    CGFloat originX = paddingLeft;
    CGFloat originY = paddingTop;
    
    CGSize titleSize = [FMUtils getLabelSizeByFont:_titleLbl.font andContent:_titleLbl.text andMaxWidth:MAXFLOAT];
    [_titleLbl setFrame:CGRectMake(originX, originY, _realWidth-paddingLeft*2, titleSize.height)];
    originY += titleSize.height + sepHeight28;
    
    [_creatorLbl setFrame:CGRectMake(originX, originY, _realWidth-paddingLeft*2, creatorHeight)];
    originY += creatorHeight;
    
    CGSize readStateSize = [FMUtils getLabelSizeByFont:[FMFont getInstance].font38 andContent:_readStateLbl.currentTitle andMaxWidth:_realWidth-paddingLeft*2];
    [_readStateLbl setFrame:CGRectMake(originX, originY, readStateSize.width, creatorHeight+sepHeight28+sepHeight50)];
    originY += creatorHeight+sepHeight28+sepHeight50;
    
    originX = padding36;
    [_themeImageView setFrame:CGRectMake(originX, originY, _realWidth-padding36*2, (_realWidth-padding36*2)/1.5)];
    originY += (_realWidth-padding36*2)/1.5 + sepHeight60;
    
    originX = paddingLeft;
    
    CGSize contentSize = [_contentView sizeThatFits:CGSizeMake(_realWidth-paddingLeft*2, MAXFLOAT)];
    [_contentView setFrame:CGRectMake(originX, originY, _realWidth-paddingLeft*2, contentSize.height)];
    originY += contentSize.height + sepHeight78;
    
    CGFloat attachmentHeight = [BulletinAttachmentView getHeightByAttachmentCount:_bulletinDetail.attachment.count];
    [_attachmentView setFrame:CGRectMake(originX, originY, _realWidth, attachmentHeight)];
    originY += attachmentHeight + sepHeight78;
    
    _mainContainerView.contentSize = CGSizeMake(_realWidth, originY);
}

- (void) updateInfo {
    if(!_bulletinDetail) {
        [_noticeLbl setHidden:NO];
        [_themeImageView setHidden:YES];
        return;
    }
    
    [_titleLbl setText:@""];
    if (![FMUtils isStringEmpty:_bulletinDetail.title]) {
        [_titleLbl setText:_bulletinDetail.title];
    }
    
    [_creatorLbl setText:@""];
    if (![FMUtils isStringEmpty:_bulletinDetail.creator]) {
        NSString *time = @"";
        if (![FMUtils isNumberNullOrZero:_bulletinDetail.createTime]) {
            time = [FMUtils getDateTimeDescriptionBy:_bulletinDetail.createTime format:@"yyyy.MM.dd"];
        }
        [_creatorLbl setText:[NSString stringWithFormat:@"%@  %@",_bulletinDetail.creator,time]];
    }
    
    NSString *readState = [NSString stringWithFormat:[[BaseBundle getInstance] getStringByKey:@"bulletin_detail_read_state" inTable:nil],_bulletinDetail.read,_bulletinDetail.unRead];
    [_readStateLbl setTitle:readState forState:UIControlStateNormal];
    
    [_themeImageView setHidden:NO];
    if (![FMUtils isNumberNullOrZero:_bulletinDetail.imageId]) {
        NSURL *imageRUL = [FMUtils getUrlOfImageById:_bulletinDetail.imageId];
        [_themeImageView setImageWithURL:imageRUL placeholderImage:[[FMTheme getInstance]  getImageByName:@"bulletin_detail_default"]];
    } else {
        [_themeImageView setImage:[[FMTheme getInstance]  getImageByName:@"bulletin_detail_default"]];
    }
    
    [_contentView setText:@""];
    if (![FMUtils isStringEmpty:_bulletinDetail.content]) {

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 2.0f;//行间距
//        CGFloat emptylength = _contentView.font.pointSize * 2;
//        paragraphStyle.alignment = NSTextAlignmentLeft;  //对齐
//        paragraphStyle.firstLineHeadIndent = emptylength;//首行缩进
//        paragraphStyle.headIndent = 0.0f;//行首缩进
//        paragraphStyle.tailIndent = 0.0f;//行尾缩进
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[_bulletinDetail.content dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                              options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attributedString addAttributes:@{NSFontAttributeName:[FMFont getInstance].font44} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3]} range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
        
        //去尾存真(用while循环去掉尾部的所有换行符)
        while([FMUtils isStingEqualIgnoreCaseString1:[[[NSAttributedString alloc] initWithAttributedString:[attributedString attributedSubstringFromRange:NSMakeRange(attributedString.length - 1, 1)]] string] String2:@"\n"]) {
            [attributedString deleteCharactersInRange:NSMakeRange(attributedString.length - 1, 1)];
        }
        
        //去尾存真
//        NSString *strToDelete = [[[NSAttributedString alloc] initWithAttributedString:[attributedString attributedSubstringFromRange:NSMakeRange(attributedString.length - 1, 1)]] string];
//        if ([FMUtils isStingEqualIgnoreCaseString1:strToDelete String2:@"\n"]) {
//            [attributedString deleteCharactersInRange:NSMakeRange(attributedString.length - 1, 1)];
//        }
        _contentView.attributedText = attributedString;
    }
    
    [_attachmentView setAttachmentDataArray:_bulletinDetail.attachment];
    
    [self updateViews];
}

#pragma mark - NetWorking
- (void) requestData {
    BulletinDetailRequestParam *param = [[BulletinDetailRequestParam alloc] init];
    param.bulletinId = _bulletinId;
    __weak typeof(self) weakSelf = self;
    [self showLoadingDialog];
    [_business getBulletinDetailByParam:param Success:^(NSInteger key, id object) {
        if (!weakSelf.bulletinDetail) {
            weakSelf.bulletinDetail = [[BulletinDetail alloc] init];
        }
        weakSelf.bulletinDetail = object;
        if (weakSelf.dataType == BULLETIN_DATA_TYPE_UNREAD) {
            [weakSelf notifyOrderStatusChanged];
        }
        [weakSelf updateInfo];
        [weakSelf hideLoadingDialog];
    } Fail:^(NSInteger key, NSError *error) {
        [weakSelf updateInfo];
        [weakSelf hideLoadingDialog];
    }];
}

- (void) notifyOrderStatusChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FMBulletinReadStatusUpdate" object:nil];
}

- (void) gotoReadStateDetail {
    BulletinReadStateViewController *readStateVC = [[BulletinReadStateViewController alloc] init];
    readStateVC.bulletinId = _bulletinDetail.bulletinId;
    readStateVC.readCount = _bulletinDetail.read;
    readStateVC.unreadCount = _bulletinDetail.unRead;
    [self gotoViewController:readStateVC];
}

@end
