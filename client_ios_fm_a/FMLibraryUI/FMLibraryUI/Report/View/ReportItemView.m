//
//  ReportItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/4/17.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "ReportItemView.h"
#import "FMUtils.h"

static NSString * const STR_UNREPORT_UPLOAD_ITEM_STATUS_WAITING = @"等待中";
static NSString * const STR_UNREPORT_UPLOAD_ITEM_STATUS_UPLOADING = @"上传中";
static NSString * const STR_UNREPORT_UPLOAD_ITEM_STATUS_SUCCESS = @"上传成功";
static NSString * const STR_UNREPORT_UPLOAD_ITEM_STATUS_FAIL = @"上传失败";

static NSInteger const UNREPORT_UPLOAD_ITEM_STATUS_WAITING = 100;
static NSInteger const UNREPORT_UPLOAD_ITEM_STATUS_UPLOADING = 200;
static NSInteger const UNREPORT_UPLOAD_ITEM_STATUS_SUCCESS = 300;
static NSInteger const UNREPORT_UPLOAD_ITEM_STATUS_FAIL = 400;

@interface ReportItemView ()
@property (readwrite, nonatomic, strong) NSString * serviceType;
@property (readwrite, nonatomic, strong) NSString * location;
@property (readwrite, nonatomic, strong) NSString * content;
@property (readwrite, nonatomic, assign) NSInteger status;


@property (readwrite, nonatomic, strong) UILabel * serviceTypeLbl;
@property (readwrite, nonatomic, strong) UILabel * contentLbl;
@property (readwrite, nonatomic, strong) UILabel * locationLbl;
@property (readwrite, nonatomic, strong) UILabel * statusLbl;

@property (readwrite, nonatomic, strong) UIButton * uploadBtn;
@property (readwrite, nonatomic, strong) UIButton * deleteBtn;
@end

@implementation ReportItemView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat orginX = 10;
        CGFloat imgWidth = 32;
        CGFloat stateWidth = 80;
        
        UIFont * msgFont = [UIFont fontWithName:@"Helvetica" size:14];
        
        
        self.serviceTypeLbl = [[UILabel alloc] init];
        self.contentLbl = [[UILabel alloc] init];
        self.locationLbl = [[UILabel alloc] init];
        self.statusLbl = [[UILabel alloc] init];
        
        self.uploadBtn = [[UIButton alloc] init];
        self.deleteBtn = [[UIButton alloc] init];
        
        [self.serviceTypeLbl setFont:msgFont];
        [self.contentLbl setFont:msgFont];
        [self.locationLbl setFont:msgFont];
        [self.statusLbl setFont:msgFont];
        
        
        
        [self.statusLbl setTextAlignment:NSTextAlignmentRight];
        
        
        CGFloat msgHeight = [FMUtils heightForStringWith:self.serviceTypeLbl value:@"测试" andWidth:stateWidth];
        CGFloat sepHeight = (height - msgHeight * 3)/4;
        

        [self.serviceTypeLbl setFrame:CGRectMake(orginX, sepHeight, width - orginX*2 - stateWidth, msgHeight)];
        [self.contentLbl setFrame:CGRectMake(orginX, sepHeight*2+msgHeight, width - orginX * 2 - stateWidth, msgHeight)];
        [self.locationLbl setFrame:CGRectMake(orginX, sepHeight*3+msgHeight*2, width - orginX * 2 - stateWidth, msgHeight)];
       
        [self.uploadBtn setFrame:CGRectMake(width-orginX-stateWidth, sepHeight, stateWidth, msgHeight*3/2)];
        [self.deleteBtn setFrame:CGRectMake(width-imgWidth-stateWidth, sepHeight*2.5+msgHeight*3/2, stateWidth, msgHeight*3/2)];
        
         [self.statusLbl setFrame:CGRectMake(orginX, sepHeight*3+msgHeight*2, stateWidth, msgHeight)];
        
        [self addSubview:self.serviceTypeLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.locationLbl];
        
        [self addSubview:self.uploadBtn];
        [self addSubview:self.deleteBtn];
        
        [self addSubview:self.statusLbl];
    }
    return self;
}

- (void) setInfoWithServiceType:(NSString*) serviceType
              content:(NSString*) content
                location:(NSString*) location
                  status:(NSInteger) status {
    self.serviceType = serviceType;
    self.content = content;
    self.location = location;
    self.status = status;
    
    [self updateInfo];
}

- (void) updateInfo {
    [self.serviceTypeLbl setText:self.serviceType];
    [self.contentLbl setText:self.content];
    [self.locationLbl setText:self.location];
    
    switch(self.status) {
        case UNREPORT_UPLOAD_ITEM_STATUS_WAITING:
            [self.statusLbl setHidden:YES];
            [self.uploadBtn setHidden:NO];
            [self.deleteBtn setHidden:NO];
            break;
        case UNREPORT_UPLOAD_ITEM_STATUS_UPLOADING:
            [self.statusLbl setHidden:NO];
            [self.uploadBtn setHidden:YES];
            [self.deleteBtn setHidden:YES];
            
            [self.statusLbl setText:STR_UNREPORT_UPLOAD_ITEM_STATUS_UPLOADING];
            break;
        case UNREPORT_UPLOAD_ITEM_STATUS_SUCCESS:
            [self.statusLbl setHidden:NO];
            [self.uploadBtn setHidden:YES];
            [self.deleteBtn setHidden:YES];
            
            [self.statusLbl setText:STR_UNREPORT_UPLOAD_ITEM_STATUS_SUCCESS];
            break;
        case UNREPORT_UPLOAD_ITEM_STATUS_FAIL:
            [self.statusLbl setHidden:NO];
            [self.uploadBtn setHidden:YES];
            [self.deleteBtn setHidden:YES];
            
            [self.statusLbl setText:STR_UNREPORT_UPLOAD_ITEM_STATUS_FAIL];
            break;
        default:
            [self.statusLbl setHidden:YES];
            [self.uploadBtn setHidden:NO];
            [self.deleteBtn setHidden:NO];
            break;
    }
    
}

@end
