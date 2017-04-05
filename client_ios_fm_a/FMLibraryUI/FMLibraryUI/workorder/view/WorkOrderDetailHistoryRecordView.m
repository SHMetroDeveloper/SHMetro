//
//  WorkOrderDetailHistoryRecordView.m
//  client_ios_fm_a
//
//  Created by 林江锋 on 16/4/12.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "WorkOrderDetailHistoryRecordView.h"
#import "FMFont.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"

#import "WorkOrderServerConfig.h"
#import "PhotoShowHelper.h"
#import "BasePhotoView.h"
#import "UIImageView+AFNetworking.h"


@interface WorkOrderDetailHistoryRecordView()

@property (readwrite, nonatomic, strong) UIImageView * portraitImgView;
@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * timeLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;
@property (readwrite, nonatomic, strong) BasePhotoView * photoView;

@property (readwrite, nonatomic, assign) NSInteger index; //记录序号
@property (readwrite, nonatomic, strong) NSNumber * time; //记录时间
@property (readwrite, nonatomic, strong) NSString * operater; //处理人
@property (readwrite, nonatomic, assign) NSInteger  step;   //步骤
@property (readwrite, nonatomic, strong) NSString *  content;   //内容
@property (readwrite, nonatomic, strong) NSMutableArray * photos;  //要展示的照片
@property (readwrite, nonatomic, strong) UIImage * portraitImage;        //用于展示的头像
@property (readwrite, nonatomic, strong) NSURL * portraitImageUrl;       //用于展示的头像path

@property (readwrite, nonatomic, assign) CGFloat realWidth;
@property (readwrite, nonatomic, assign) CGFloat realHeight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnMessageHandleListener> handler;
@end

@implementation WorkOrderDetailHistoryRecordView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        _photos = [[NSMutableArray alloc] init];
    
        //头像view
        _portraitImgView = [[UIImageView alloc] init];
        _portraitImgView.clipsToBounds = YES;
        _portraitImgView.contentScaleFactor = [[UIScreen mainScreen] scale];
        _portraitImgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        //名字lbl
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _nameLbl.font = [FMFont getInstance].font38;
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        
        //时间lbl
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.textColor = [UIColor colorWithRed:0xba/255.0 green:0xba/255.0 blue:0xba/255.0 alpha:1];;
        _timeLbl.font = [FMFont fontWithSize:12];
        _timeLbl.textAlignment = NSTextAlignmentLeft;
        
        //状态lbl
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _statusLbl.font = [FMFont setFontByPX:32];
        _statusLbl.textAlignment = NSTextAlignmentRight;
        
        
        //描述信息lbl
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
        _descLbl.font = [FMFont getInstance].font38;
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.numberOfLines = 0;
        
        
        //照片显示View
        _photoView = [[BasePhotoView alloc] init];
        [_photoView setOnMessageHandleListener:self];
        [_photoView setPhotosWithArray:_photos];
        [_photoView setEditable:NO];
        [_photoView setEnableAdd:NO];
        [_photoView setShowType:PHOTO_SHOW_TYPE_SOME_ONE_LINE];
        _photoView.hidden = YES;
    
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        
        [self addSubview:_portraitImgView];
        [self addSubview:_nameLbl];
        [self addSubview:_timeLbl];
        [self addSubview:_statusLbl];
        [self addSubview:_descLbl];
        [self addSubview:_photoView];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if (width == 0 || height == 0) {
        return;
    }
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat portraitWidth = [FMSize getSizeByPixel:144];
    CGFloat originX = padding;
    CGFloat originY = [FMSize getSizeByPixel:55];
    CGFloat seperatorHeight = [FMSize getInstance].padding40;
    
    CGSize nameSize = [FMUtils getLabelSizeBy:_nameLbl andContent:_operater andMaxLabelWidth:width];
    CGSize timeSize = [FMUtils getLabelSizeBy:_timeLbl andContent:[FMUtils timeLongToDateString:_time] andMaxLabelWidth:width];
    CGSize descSize = [FMUtils getLabelSizeBy:_descLbl andContent:_content andMaxLabelWidth:width-padding-portraitWidth-[FMSize getInstance].padding40-padding];
    CGSize statusSize = [FMUtils getLabelSizeBy:_statusLbl andContent:[WorkOrderServerConfig getOrderStepDesc:_step] andMaxLabelWidth:width];
    
    //头像
    [_portraitImgView setFrame:CGRectMake(originX, originY, portraitWidth, portraitWidth)];
    _portraitImgView.layer.cornerRadius = portraitWidth/2;
    originX += portraitWidth + [FMSize getInstance].padding40;
    originY += 3;  //向下缩进3像素
    
    //名称lbl
    [_nameLbl setFrame:CGRectMake(originX, originY, nameSize.width, nameSize.height)];
    
    //状态lbl
    [_statusLbl setFrame:CGRectMake(width-padding-statusSize.width, originY+(nameSize.height-statusSize.height)/2, statusSize.width, statusSize.height)];
    
    originY += nameSize.height + (portraitWidth - nameSize.height - timeSize.height - 6);  //上下都缩进3像素
    
    //时间lbl
    [_timeLbl setFrame:CGRectMake(originX, originY, timeSize.width, timeSize.height)];
    originY += timeSize.height + padding - 5;
    
    //详情lbl
    [_descLbl setFrame:CGRectMake(originX, originY, descSize.width, descSize.height)];
    originY += descSize.height;
    
    originX = portraitWidth + [FMSize getInstance].padding40;
    //照片view
    CGFloat photoHeight;
    if ([_photos count] == 0) {
        photoHeight = 0;
        _photoView.hidden = YES;
        
        originY += seperatorHeight;
    } else {
        photoHeight = [BasePhotoView calculateHeightByCount:[_photos count] width:width-portraitWidth-[FMSize getInstance].padding40 addAble:NO showType:PHOTO_SHOW_TYPE_SOME_ONE_LINE];
        _photoView.hidden = NO;
        [_photoView setPhotosWithArray:_photos];
        [_photoView setFrame:CGRectMake(originX, originY, width-portraitWidth-[FMSize getInstance].padding40, photoHeight)];
        
        originY += photoHeight;
    }
    
    [self updateInfo];
}

- (void) updateInfo {
    if (_portraitImage) {
        [_portraitImgView setImage:_portraitImage];
    } else if (_portraitImageUrl) {
        [_portraitImgView setImageWithURL:_portraitImageUrl placeholderImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
    } else {
        [_portraitImgView setImage:[[FMTheme getInstance] getImageByName:@"user_default_head"]];
    }
    _nameLbl.text = _operater;
    _timeLbl.text = [FMUtils timeLongToDateString:_time];
    _statusLbl.text = [WorkOrderServerConfig getOrderStepDesc:_step];
    _descLbl.text = _content;
}

//设置头像图片
- (void) setPortraitImage:(UIImage *) img {
    _portraitImage = img;
    [self updateInfo];
}

//设置头像图片
- (void) setPortraitWithURL:(NSURL *) url {
    _portraitImageUrl = url;
    [self updateInfo];
}

- (void) setPortraitImageID:(NSNumber *) imgId {
    _portraitImageUrl = [FMUtils getUrlOfImageById:imgId];
    [self updateInfo];
}

- (void) setInfoWithIndex:(NSInteger) index
                     time:(NSNumber*) time
                 operater:(NSString*) operater
                     step:(NSInteger) step
                  content:(NSString *) content
                andPhotos:(NSMutableArray *) photos {
    _index = index;
    _time = time;
    
    if(![FMUtils isStringEmpty:operater]) {
        _operater = operater;
    } else {
        _operater = @"";
    }
    
    _step = step;
    if(![FMUtils isStringEmpty:content]) {
        NSString * str = [content substringWithRange:NSMakeRange(content.length-1, 1)];
        if ([str isEqualToString:@"\n"]) {
            NSMutableString * desc = [[NSMutableString alloc] initWithString:content];
            [desc deleteCharactersInRange:NSMakeRange(content.length-1, 1)];
            _content = desc;
        } else {
            _content = content;
        }
    } else {
        _content = @"";
    }
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    } else {
        [_photos removeAllObjects];
    }
    for (NSNumber * imgId in photos) {
        NSURL * imgUrl = [FMUtils getUrlOfImageById:imgId];
        [_photos addObject:imgUrl];
    }
    
    [self updateViews];
}

//解析从BasePhotoView发送过来的点击图片位置信息
- (void)handleMessage:(id)msg {
    if (msg) {
        NSString * strOrigin = [msg valueForKeyPath:@"msgOrigin"];
        if([strOrigin isEqualToString:NSStringFromClass([_photoView class])]) {
            NSNumber * tmpNumber = [msg valueForKeyPath:@"msgType"];
            PhotoActionType type = [tmpNumber integerValue];
            switch (type) {
                case PHOTO_ACTION_SHOW_DETAIL:
                    tmpNumber = [msg valueForKeyPath:@"result"];
                    [self handleResultPosition:tmpNumber];
                    break;
                default:
                    break;
            }
        }
    }
}

//由此View向外发送点击图片的位置信息和数组信息
- (void) setOnMessageHandleListener:(id)handler {
    _handler = handler;
}

- (void) handleResultPosition:(NSNumber *) position {
    if (_handler) {
        NSMutableDictionary * msg = [[NSMutableDictionary alloc] init];
        [msg setValue:NSStringFromClass([self class]) forKeyPath:@"msgOrigin"];
        [msg setValue:_photos forKeyPath:@"photosArray"];
        [msg setValue:position forKeyPath:@"position"];
        [_handler handleMessage:msg];
    }
}


//计算高度
+ (CGFloat) calculateHeightByInfo:(NSString *)content photoCount:(NSInteger)count andWidth:(CGFloat)width {
    CGFloat height = 0;
    CGFloat portraitWidth = [FMSize getSizeByPixel:144];
    CGFloat padding = [FMSize getInstance].padding50;
    CGFloat seperatorHeight = [FMSize getInstance].padding40;
    CGFloat nameHeight = 16.6f;
    CGFloat timeHeigth = 14.0f;
    
    
    UILabel * descLbl = [[UILabel alloc] init];
    descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    descLbl.font = [FMFont getInstance].font38;
    descLbl.numberOfLines = 0;
    descLbl.textAlignment = NSTextAlignmentLeft;
    
    
    NSString * str = [content substringWithRange:NSMakeRange(content.length-1, 1)];
    if ([str isEqualToString:@"\n"]) {
        NSMutableString * desc = [[NSMutableString alloc] initWithString:content];
        [desc deleteCharactersInRange:NSMakeRange(content.length-1, 1)];
        descLbl.text = desc;
    } else {
        descLbl.text = content;
    }
    
    CGSize descSize = [FMUtils getLabelSizeBy:descLbl andContent:descLbl.text andMaxLabelWidth:width-padding-portraitWidth-[FMSize getInstance].padding40-padding];
    CGFloat photoHeight = [BasePhotoView calculateHeightByCount:count width:width-portraitWidth-[FMSize getInstance].padding40 addAble:NO showType:PHOTO_SHOW_TYPE_SOME_ONE_LINE];
    
    if (count == 0) {
        height = [FMSize getSizeByPixel:55] + 3 + nameHeight + (portraitWidth - nameHeight - timeHeigth - 6) + timeHeigth + padding - 5 + descSize.height + seperatorHeight;
    } else {
        height = [FMSize getSizeByPixel:55] + 3 + nameHeight + (portraitWidth - nameHeight - timeHeigth - 6) + timeHeigth + padding - 5 + descSize.height + photoHeight;
    }

    return (NSInteger)height;
}



@end





