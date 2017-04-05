//
//  WorkOrderWriteContentItemVIew.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "WorkOrderWriteContentItemView.h"
#import "FMTheme.h"
#import "FMUtils.h"
#import "FMSize.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface WorkOrderWriteContentItemView ()

@property (readwrite, nonatomic, strong) NSString * content;    //工作内容
@property (readwrite, nonatomic, strong) NSMutableArray * photos;    //照片



@property (readwrite, nonatomic, strong) UITextView * contentTv;
@property (readwrite, nonatomic, strong) UIView * photoView;


@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@end

@implementation WorkOrderWriteContentItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIFont * msgFont = [FMFont getInstance].defaultFontLevel2;
        
        _contentTv = [[UITextView alloc] init];
        _photoView = [[UIView alloc] init];
        
        
        [_contentTv setFont:msgFont];
        [_contentTv setText:[[BaseBundle getInstance] getStringByKey:@"order_work_content_placeholder" inTable:nil]];
        [_contentTv setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
        [self initViews];
        
        [self addSubview:_contentTv];
        [self addSubview:_photoView];
    }
    return self;
}

- (void) initViews {
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat sepHeight = [FMSize getInstance].sepHeight;
    CGFloat photoHeight = 40;
    
    
    [_contentTv setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight, 100)];
    
    
    
    [_contentTv setFrame:CGRectMake(_paddingLeft, sepHeight, width - _paddingLeft - _paddingRight , height - photoHeight - sepHeight * 3)];
    [_photoView setFrame:CGRectMake(_paddingLeft, height - sepHeight - photoHeight, width - _paddingLeft - _paddingRight, photoHeight)];
}



- (void) setInfoWithContent:(NSString *) content
                  andPhotos:(NSMutableArray *) photoArray{
    
    _content = content;
    _photos = photoArray;
    [self updateInfo];
}

- (void) setPaddingLeft:(CGFloat)paddingLeft andPaddingRight:(CGFloat) paddingRight {
    _paddingLeft = paddingLeft;
    _paddingRight = paddingRight;
    
    [self initViews];
}

- (void) updateInfo {
    if(_content) {
        [_contentTv setText:_content];
        [_contentTv setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLACK]];
    } else {
        [_contentTv setText:[[BaseBundle getInstance] getStringByKey:@"order_work_content_placeholder" inTable:nil]];
        [_contentTv setTextColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L5]];
    }
    
    //显示图片
    
}

@end

