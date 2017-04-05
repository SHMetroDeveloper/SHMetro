//
//  FMMessageTableViewCell.m
//  client_ios_fm_a
//
//  Created by Master.lyn on 16/8/12.
//  Copyright © 2016年 facilityone. All rights reserved.
//

#import "FMMessageTableViewCell.h"
#import "FMUtilsPackages.h"
#import "RoundLabel.h"
#import "WorkOrderServerConfig.h"
#import "SeperatorView.h"
#import "FMTheme.h"
#import "NotificationServerConfig.h"

@interface FMMessageTableViewCell()

@property (nonatomic, strong) RoundLabel *typeLbl;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *statusLbl;  //是否已读
@property (nonatomic, strong) SeperatorView *seperator;  //分割线

@property (nonatomic, assign) CGFloat statusWidth;
@property (nonatomic, assign) CGFloat logoImgWidth;
@property (nonatomic, assign) CGFloat timeWidth;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGFloat defaultLogoImgWidth;

@property (nonatomic, assign) NotificationItemType type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSNumber * time;

@property (nonatomic, assign) BOOL isRead; //是否已读
@property (nonatomic, assign) BOOL isBroad; //是否宽屏显示分割线

@property (nonatomic, assign) BOOL showType; //是否显示类型
@property (nonatomic, assign) CGFloat paddingLeft;

@property (nonatomic, assign) BOOL isInited;

@end


@implementation FMMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuse:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _padding = 13;
        _defaultLogoImgWidth = 40;
        _timeWidth = 70;
        _statusWidth = 6;
        _paddingLeft = 13;
        
        UIFont * titleFont = [FMFont fontWithSize:16];
        UIFont * contentFont = [FMFont fontWithSize:13];
        UIFont * timeFont = [FMFont fontWithSize:13];
        UIFont * logoFont = [FMFont getInstance].msgItemFontLogo;
        
        UIColor * titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L1];
        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
        UIColor * timeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
        
        _typeLbl = [[RoundLabel alloc] init];
        [_typeLbl setFont:logoFont];
        
        
        _titleLbl = [[UILabel alloc] init];
        [_titleLbl setTextColor:titleColor];
        [_titleLbl setFont:titleFont];
        
        
        _contentLbl = [[UILabel alloc] init];
        [_contentLbl setFont:contentFont];
        [_contentLbl setTextColor:contentColor];
        _contentLbl.numberOfLines = 2;
        
        _timeLbl = [[UILabel alloc] init];
        [_timeLbl setFont:timeFont];
        [_timeLbl setTextColor:timeColor];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        
        
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_NOTICE];
        _statusLbl.clipsToBounds = YES;
        _statusLbl.layer.cornerRadius = _statusWidth/2;
        
        _logoImgWidth = _defaultLogoImgWidth;
        
        _seperator = [[SeperatorView alloc] init];
        
        [self.contentView addSubview:_typeLbl];
        [self.contentView addSubview:_titleLbl];
        [self.contentView addSubview:_contentLbl];
        [self.contentView addSubview:_timeLbl];
        [self.contentView addSubview:_statusLbl];
        [self.contentView addSubview:_seperator];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    CGFloat sepHeight = 8;
    CGFloat originX = 0;
    CGFloat originY = _padding;
    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
    CGFloat seperatorHeight = [FMSize getInstance].seperatorHeight;
    
    originX = _paddingLeft;
    [_typeLbl setFrame:CGRectMake(originX, 20, _logoImgWidth, _logoImgWidth)];
    
    originX = _paddingLeft * 2 + _logoImgWidth;
    [_titleLbl setFrame:CGRectMake(originX, originY, (width-originX-_padding-_timeWidth), itemHeight)];
    [_timeLbl setFrame:CGRectMake(width-_padding-_timeWidth, originY, _timeWidth, itemHeight)];
    originY += itemHeight + sepHeight;
    
    CGFloat contentWidth = width-originX-_padding * 2-_statusWidth;
    CGFloat contentHeight = [FMUtils heightForStringWith:_contentLbl value:_content andWidth:contentWidth];
    if(contentHeight < itemHeight) {
        contentHeight = itemHeight;
    }
    itemHeight = contentHeight;
    [_contentLbl setFrame:CGRectMake(originX, originY, contentWidth, itemHeight)];
    
    [_statusLbl setFrame:CGRectMake(width-_padding-_statusWidth, originY+(itemHeight-_statusWidth)/2, _statusWidth, _statusWidth)];
    originY += itemHeight + _padding;
    
    if (!_isBroad) {
        CGFloat padding = _paddingLeft * 2 + _logoImgWidth;
        [_seperator setFrame:CGRectMake(padding, height-seperatorHeight, width-padding-_padding, seperatorHeight)];
    } else {
        [_seperator setFrame:CGRectMake(0, height-seperatorHeight, width, seperatorHeight)];
    }
    if(_showType) {
        [_typeLbl setHidden:NO];
    } else {
        [_typeLbl setHidden:YES];
    }
    [self updateInfo];
}

- (void) updateInfo {
    
    NSString * strType = @"";
    NSString * strTypeIcon = @"";
    UIColor * bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    
    switch (_type) {
        case NOTIFICATION_ITEM_TYPE_UNKNOW:
            break;
            
            
        case NOTIFICATION_ITEM_TYPE_ORDER: {
            NSMutableDictionary *tmpDic = [self getOrderStatusDescBy:_status];
            strTypeIcon = [tmpDic valueForKeyPath:@"strTypeIcon"];
            bgColor = [tmpDic valueForKeyPath:@"bgColor"];
        }
            break;
            
        case NOTIFICATION_ITEM_TYPE_PATROL:{
            strTypeIcon = @"巡";
            bgColor = [UIColor colorWithRed:164/255.0 green:191/255.0 blue:102/255.0 alpha:1];
        }
            break;
            
        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:{
            strTypeIcon = @"维";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
        }
            break;
            
        case NOTIFICATION_ITEM_TYPE_ASSET:{
            strTypeIcon = @"资";
            bgColor = [UIColor colorWithRed:70.0/255.0 green:201.0/255.0 blue:159.0/255.0 alpha:1];
        }
            break;
            
        case NOTIFICATION_ITEM_TYPE_REQUIREMENT: {
            strTypeIcon = @"需";
//            bgColor = [UIColor colorWithRed:70.0/255.0 green:201.0/255.0 blue:159.0/255.0 alpha:1];
        }
            break;
            
        case NOTIFICATION_ITEM_TYPE_INVENTORY: {
            strTypeIcon = @"料";
        }
            break;
        case NOTIFICATION_ITEM_TYPE_CONTRACT: {
            strTypeIcon = @"合";
            bgColor = [UIColor colorWithRed:0x30/255.0 green:0xc1/255.0 blue:0xa4/255.0 alpha:1];
        }
            break;
        case NOTIFICATION_ITEM_TYPE_BULLETION: {
            strTypeIcon = @"告";
            bgColor = [UIColor colorWithRed:0xfb/255.0 green:0xaf/255.0 blue:0x41/255.0 alpha:1];
        }
            break;
    } ;
    
    
    [_typeLbl setContent:strTypeIcon];
    [_typeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:bgColor backgroundColor:bgColor];
    
    [_titleLbl setText:_title];
    [_contentLbl setText:[[NSString alloc] initWithFormat:@"%@%@", strType, _content]];
    [_timeLbl setText:[self getTimeDesc]];
    if(_isRead) {
        [_statusLbl setHidden:YES];
    } else {
        [_statusLbl setHidden:NO];
    }
}

- (NSString *) getTimeDesc {
    NSString * res;
    res = [FMUtils getSuitableDescOfTime:_time];
    return res;
}

- (NSMutableDictionary *) getOrderStatusDescBy:(NSInteger) status {
    NSMutableDictionary *formDic = [[NSMutableDictionary alloc] init];
    NSString *strTypeIcon = nil;
    UIColor *bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
    
    WorkOrderStatus orderStatus = (WorkOrderStatus)_status;
    switch (orderStatus) {
        case ORDER_STATUS_CREATE:   //已创建
            strTypeIcon = @"派";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
            break;
            
        case ORDER_STATUS_DISPACHED:  //已派工
            strTypeIcon = @"工";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
            
        case ORDER_STATUS_PROCESS:    //处理中
            strTypeIcon = @"工";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
            
        case ORDER_STATUS_STOP:   //暂停---继续工作
            strTypeIcon = @"停";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
            
        case ORDER_STATUS_STOP_N:   //暂停---不继续工作
            strTypeIcon = @"停";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
            
        case ORDER_STATUS_APPROVE:   //待审批
            strTypeIcon = @"审";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
            break;
            
        case ORDER_STATUS_FINISH:   //已完成
            strTypeIcon = @"完";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
            
        case ORDER_STATUS_VALIDATATION:    //已验证
            strTypeIcon = @"验";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
            break;
            
        case ORDER_STATUS_TERMINATE:    //已终止
            strTypeIcon = @"终";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
            break;
            
        case ORDER_STATUS_CLOSE:    //已存档
            strTypeIcon = @"存";
            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
            break;
    }
    
    [formDic setValue:strTypeIcon forKeyPath:@"strTypeIcon"];
    [formDic setValue:bgColor forKeyPath:@"bgColor"];
    
    return formDic;
}

- (void) setSeperatorBroad:(BOOL) isBroad {
    _isBroad = isBroad;
}

- (void) setShowType:(BOOL) showType paddingLeft:(CGFloat) paddingLeft{
    _showType = showType;
    _logoImgWidth = paddingLeft - _paddingLeft * 2;
}

- (void) setInfoWithTitle:(NSString *)title
                  content:(NSString *)content
                     time:(NSNumber *)time
                     type:(NotificationItemType)type
                   status:(NSInteger)status
                     read:(BOOL) isRead {
    
    _title = title;
    _content = content;
    _time = time;
    _type = type;
    _status = status;
    _isRead = isRead;
    [self setNeedsLayout];
}

//根据消息内容计算所需要的高度
+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width paddingLeft:(CGFloat) paddingLeft{
    CGFloat height = 0;
    CGFloat padding = 13;
    CGFloat statusWidth = 6;
    CGFloat sepHeight = 8;
    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
    
    CGFloat contentWidth = width - paddingLeft - padding * 2 - statusWidth;
    UILabel * contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 0)];
    contentLbl.numberOfLines = 2;
    contentLbl.font = [FMFont fontWithSize:13];
    CGFloat contentHeight = [FMUtils heightForStringWith:contentLbl value:content andWidth:contentWidth];
    if(contentHeight < defaultItemHeight) {
        contentHeight = defaultItemHeight;
    }
    height = padding + defaultItemHeight + sepHeight + contentHeight + padding;
    
    return height;
}

@end
