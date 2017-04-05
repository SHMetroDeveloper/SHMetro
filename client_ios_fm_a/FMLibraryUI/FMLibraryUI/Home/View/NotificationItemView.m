//
//  MessageItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/12/11.
//  Copyright © 2015年 flynn. All rights reserved.
//

#import "NotificationItemView.h"
#import "FMSize.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "RoundLabel.h"

#import "WorkOrderServerConfig.h"

@interface NotificationItemView ()

//@property (nonatomic, strong) RoundLabel * typeLbl;
//@property (nonatomic, strong) UILabel * titleLbl;
//@property (nonatomic, strong) UILabel * contentLbl;
//@property (nonatomic, strong) UILabel * timeLbl;
//@property (nonatomic, strong) UILabel * statusLbl;  //是否已读
//
//@property (nonatomic, assign) CGFloat statusWidth;
//@property (nonatomic, assign) CGFloat logoImgWidth;
//@property (nonatomic, assign) CGFloat timeWidth;
//@property (nonatomic, assign) CGFloat padding;
//
//@property (nonatomic, assign) CGFloat defaultLogoImgWidth;
//
//@property (nonatomic, assign) NotificationItemType type;
//@property (nonatomic, assign) NSInteger status;
//@property (nonatomic, strong) NSString * title;
//@property (nonatomic, strong) NSString * content;
//@property (nonatomic, strong) NSNumber * time;
//
//@property (nonatomic, assign) BOOL isRead; //是否已读
//
//@property (nonatomic, assign) BOOL isInited;



@end

@implementation NotificationItemView

//- (instancetype) init {
//    self = [super init];
//    if(self) {
//        [self initViews];
//    }
//    return self;
//}
//
//- (instancetype) initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if(self) {
//        [self initViews];
//        [self updateViews];
//    }
//    return self;
//}
//
//- (void) setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self updateViews];
//}
//
//- (void) initViews {
//    if(!_isInited) {
//        _isInited = YES;
//        
//        
//        _padding = [FMSize getInstance].defaultPadding;
//        _defaultLogoImgWidth = 40;
//        _timeWidth = 70;
//        _statusWidth = 6;
//        
//        UIFont * titleFont = [FMFont fontWithSize:16];
//        UIFont * contentFont = [FMFont fontWithSize:13];
//        UIFont * timeFont = [FMFont fontWithSize:13];
//        
//        UIColor * titleColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L1];
//        UIColor * contentColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5];
//        UIColor * timeColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L6];
//        
//        UIFont * logoFont = [FMFont getInstance].msgItemFontLogo;
//        
//        _typeLbl = [[RoundLabel alloc] init];
//        _titleLbl = [[UILabel alloc] init];
//        _contentLbl = [[UILabel alloc] init];
//        _timeLbl = [[UILabel alloc] init];
//        _statusLbl = [[UILabel alloc] init];
//        
//        [_titleLbl setFont:titleFont];
//        [_contentLbl setFont:contentFont];
//        [_timeLbl setFont:timeFont];
//        
//        [_titleLbl setTextColor:titleColor];
//        [_contentLbl setTextColor:contentColor];
//        [_timeLbl setTextColor:timeColor];
//        
//        _contentLbl.numberOfLines = 2;
//        
//        _statusLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_RED_NOTICE];
//        _statusLbl.clipsToBounds = YES;
//        _statusLbl.layer.cornerRadius = _statusWidth/2;
//        
//        [_typeLbl setFont:logoFont];
//        _timeLbl.textAlignment = NSTextAlignmentRight;
//        
//        
//        [self addSubview:_typeLbl];
//        [self addSubview:_titleLbl];
//        [self addSubview:_contentLbl];
//        [self addSubview:_timeLbl];
//        [self addSubview:_statusLbl];
//    }
//}
//
//- (void) updateViews {
//    CGRect frame = self.frame;
//    CGFloat width = CGRectGetWidth(frame);
//    CGFloat height = CGRectGetHeight(frame);
//    if(width == 0 || height == 0) {
//        return;
//    }
//    CGFloat sepHeight = 8;
//    CGFloat originX = 0;
//    CGFloat originY = _padding;
//    CGFloat itemHeight = [FMSize getInstance].listItemInfoHeight;
//    CGFloat paddingLeft = 15;
//    
//    _logoImgWidth = _defaultLogoImgWidth;
////    if(_logoImgWidth > _defaultLogoImgWidth) {
////        _logoImgWidth = _defaultLogoImgWidth;
////    }
//    
//    originX = paddingLeft;
//    [_typeLbl setFrame:CGRectMake(originX, 20, _logoImgWidth, _logoImgWidth)];
//    
//    originX = paddingLeft * 2 + _logoImgWidth;
//    [_titleLbl setFrame:CGRectMake(originX, originY, (width-originX-_padding-_timeWidth), itemHeight)];
//    [_timeLbl setFrame:CGRectMake(width-_padding-_timeWidth, originY, _timeWidth, itemHeight)];
//    originY += itemHeight + sepHeight;
//    
//    CGFloat contentWidth = width-originX-_padding * 2-_statusWidth;
//    CGFloat contentHeight = [FMUtils heightForStringWith:_contentLbl value:_content andWidth:contentWidth];
//    if(contentHeight < itemHeight) {
//        contentHeight = itemHeight;
//    }
//    itemHeight = contentHeight;
//    [_contentLbl setFrame:CGRectMake(originX, originY, contentWidth, itemHeight)];
//    
//    [_statusLbl setFrame:CGRectMake(width-_padding-_statusWidth, originY+(itemHeight-_statusWidth)/2, _statusWidth, _statusWidth)];
//    originY += itemHeight + sepHeight;
//
//
//    [self updateInfo];
//}
//
//- (void) updateInfo {
//    
//    NSString * strType = @"";
//    NSString * strTypeIcon = @"";
//    UIColor * bgColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//    
//    switch (_type) {
//        case NOTIFICATION_ITEM_TYPE_UNKNOW:
//            break;
//            
//            
//        case NOTIFICATION_ITEM_TYPE_ORDER: {
//            NSMutableDictionary *tmpDic = [self getOrderStatusDescBy:_status];
//            strTypeIcon = [tmpDic valueForKeyPath:@"strTypeIcon"];
//            bgColor = [tmpDic valueForKeyPath:@"bgColor"];
//        }
//            break;
//            
//        case NOTIFICATION_ITEM_TYPE_PATROL:{
//            strTypeIcon = @"巡";
//            bgColor = [UIColor colorWithRed:164/255.0 green:191/255.0 blue:102/255.0 alpha:1];
//        }
//            break;
//            
//        case NOTIFICATION_ITEM_TYPE_MAINTENANCE:{
//            strTypeIcon = @"维";
//            bgColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//        }
//            break;
//            
//        case NOTIFICATION_ITEM_TYPE_ASSET:{
//            strTypeIcon = @"资";
//            bgColor = [UIColor colorWithRed:70.0/255.0 green:201.0/255.0 blue:159.0/255.0 alpha:1];
//        }
//            break;
//            
//        case NOTIFICATION_ITEM_TYPE_REQUIREMENT: {
//            strTypeIcon = @"需";
////            bgColor = [UIColor colorWithRed:70.0/255.0 green:201.0/255.0 blue:159.0/255.0 alpha:1];
//        }
//            break;
//            
//        case NOTIFICATION_ITEM_TYPE_INVENTORY: {
//            strTypeIcon = @"料";
//        }
//            break;
//    } ;
//    
//    
//    [_typeLbl setContent:strTypeIcon];
//    [_typeLbl setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE] andBorderColor:bgColor backgroundColor:bgColor];
//    
//    [_titleLbl setText:_title];
//    [_contentLbl setText:[[NSString alloc] initWithFormat:@"%@%@", strType, _content]];
//    [_timeLbl setText:[self getTimeDesc]];
//    if(_isRead) {
//        [_statusLbl setHidden:YES];
//    } else {
//        [_statusLbl setHidden:NO];
//    }
//}
//
//- (NSString *) getTimeDesc {
//    NSString * res;
//    res = [FMUtils getSuitableDescOfTime:_time];
//    return res;
//}
//
//- (NSMutableDictionary *) getOrderStatusDescBy:(NSInteger) status {
//    NSMutableDictionary *formDic = [[NSMutableDictionary alloc] init];
//    NSString *strTypeIcon = nil;
//    UIColor *bgColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//    
//    WorkOrderStatus orderStatus = (WorkOrderStatus)_status;
//    switch (orderStatus) {
//        case ORDER_STATUS_CREATE:   //已创建
//            strTypeIcon = @"派";
//            bgColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE];
//            //            _content = NSLocalizedString(@"chart_message_content_pai",nil);
//            break;
//            
//        case ORDER_STATUS_DISPACHED:  //已派工
//            strTypeIcon = @"工";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//            //            _content = NSLocalizedString(@"chart_message_content_gong", nil);
//            break;
//            
//        case ORDER_STATUS_PROCESS:    //处理中
//            strTypeIcon = @"工";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//            //            _content = NSLocalizedString(@"chart_message_content_gong", nil);
//            break;
//            
//        case ORDER_STATUS_STOP:   //暂停---继续工作
//            strTypeIcon = @"停";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//            //            _content = NSLocalizedString(@"chart_message_content_ting", nil);
//            break;
//            
//        case ORDER_STATUS_STOP_N:   //暂停---不继续工作
//            strTypeIcon = @"停";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//            //            _content = NSLocalizedString(@"chart_message_content_ting", nil);
//            break;
//            
//        case ORDER_STATUS_APPROVE:   //待审批
//            strTypeIcon = @"审";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_ORANGE];
//            //            _content = NSLocalizedString(@"chart_message_content_sheng", nil);
//            break;
//            
//        case ORDER_STATUS_FINISH:   //已完成
//            strTypeIcon = @"完";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
//            //            _content = NSLocalizedString(@"chart_message_content_wan", nil);
//            break;
//            
//        case ORDER_STATUS_VALIDATATION:    //已验证
//            strTypeIcon = @"验";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_GREEN];
//            //            _content = NSLocalizedString(@"chart_message_content_yan", nil);
//            break;
//            
//        case ORDER_STATUS_TERMINATE:    //已终止
//            strTypeIcon = @"终";
//            bgColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_RED];
//            //            _content = NSLocalizedString(@"chart_message_content_zhong", nil);
//            break;
//            
//        case ORDER_STATUS_CLOSE:    //已存档
//            strTypeIcon = @"存";
//            bgColor = [FMColor getInstance].mainGray;
//            //            _content = NSLocalizedString(@"chart_message_content_cun", nil);
//            break;
//    }
//    
//    [formDic setValue:strTypeIcon forKeyPath:@"strTypeIcon"];
//    [formDic setValue:bgColor forKeyPath:@"bgColor"];
//    
//    return formDic;
//}
//
//- (void) setInfoWithTitle:(NSString *)title
//                  content:(NSString *)content
//                     time:(NSNumber *)time
//                     type:(NotificationItemType)type
//                   status:(NSInteger)status
//                     read:(BOOL) isRead {
//    
//    _title = title;
//    _content = content;
//    _time = time;
//    _type = type;
//    _status = status;
//    _isRead = isRead;
//    [self updateViews];
//}
//
////根据消息内容计算所需要的高度
//+ (CGFloat) calculateHeightByContent:(NSString *) content andWidth:(CGFloat) width {
//    CGFloat height = 0;
//    CGFloat padding = [FMSize getInstance].defaultPadding;
//    CGFloat statusWidth = 6;
//    CGFloat paddingLeft = 15;
//    CGFloat logoWidth = 50;
//    CGFloat sepHeight = 8;
//    CGFloat defaultItemHeight = [FMSize getInstance].listItemInfoHeight;
//    
//    CGFloat contentWidth = width - (paddingLeft * 2  + logoWidth) - padding * 2 - statusWidth;
//    UILabel * contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 0)];
//    contentLbl.numberOfLines = 2;
//    contentLbl.font = [FMFont fontWithSize:13];
//    CGFloat contentHeight = [FMUtils heightForStringWith:contentLbl value:content andWidth:contentWidth];
//    if(contentHeight < defaultItemHeight) {
//        contentHeight = defaultItemHeight;
//    }
//    height = padding + defaultItemHeight + sepHeight + contentHeight + padding;
//    
//    return height;
//}

@end
