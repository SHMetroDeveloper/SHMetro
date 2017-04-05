//
//  PhotoItemView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/2/17.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "PhotoItemView.h"
#import "UIImageView+AFNetworking.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"


@interface PhotoItemView ()

@property (readwrite, nonatomic, strong) UIImageView * imgView;
@property (readwrite, nonatomic, strong) UILabel * descLbl;

@property (readwrite, nonatomic, strong) UIButton * deleteBtn;  //删除按钮
@property (readwrite, nonatomic, strong) UIImageView * deleteImgView;   //删除图片

@property (readwrite, nonatomic, strong) UIImageView * typeImgView;   //类型图片

@property (readwrite, nonatomic, strong) UIImage * img;
@property (readwrite, nonatomic, strong) PhotoItem * item;
@property (readwrite, nonatomic, strong) NSURL * url;

@property (readwrite, nonatomic, strong) NSString * desc;

@property (readwrite, nonatomic, assign) CGFloat audioImgWidth;
@property (readwrite, nonatomic, assign) CGFloat typeImgWidth;
@property (readwrite, nonatomic, assign) CGFloat imgWidth;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;

@property (readwrite, nonatomic, assign) BOOL editable;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;

@end

@implementation PhotoItemView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
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
    if(!_isInited) {
        _isInited = YES;
        
        _typeImgWidth = 40;
        _audioImgWidth = 60;
        _imgWidth = [FMSize getInstance].imgWidthLevel2;
        _btnWidth = 30;
        _editable = NO; //默认不可删除
        
        
        _imgView = [[UIImageView alloc] init];
        _deleteBtn = [[UIButton alloc] init];
        _deleteImgView = [[UIImageView alloc] init];
        _typeImgView = [[UIImageView alloc] init];
        
        _descLbl = [[UILabel alloc] init];
        
        _descLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.font = [FMFont getInstance].defaultFontLevel2;
        _descLbl.textAlignment = NSTextAlignmentCenter;
        _descLbl.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        [_deleteImgView setImage:[[FMTheme getInstance] getImageByName:@"delete_photo"]];
        
        [_imgView addSubview:_typeImgView];
        [_typeImgView setHidden:YES];
        
        [_descLbl setHidden:YES];
        
        [_deleteBtn addSubview:_deleteImgView];
        _deleteBtn.tag = PHOTO_ITEM_VIEW_TYPE_DELETE;
        
        [_deleteBtn addTarget:self action:@selector(onDeleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setHidden:YES];
        
        _imgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BACKGROUND];
        
        
        [self addSubview:_imgView];
        [self addSubview:_deleteBtn];
        [self addSubview:_descLbl];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    
    CGFloat contentWidth = width-_btnWidth/2;
    CGFloat contentHeight = height-_btnWidth/2;
    CGFloat originY = _btnWidth/2;
    CGFloat originX = 0;
//    if(_item && _item.origin == PHOTO_ORIGIN_AUDIO) {
//        if(contentWidth > _audioImgWidth) {
//            contentWidth = _audioImgWidth;
//        }
//        contentHeight = contentWidth;
//        originY = (height - contentHeight) / 2;
//        originX = (height - contentWidth) / 2;
//        
////        _imgView.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
//    }
    
    [_imgView setFrame:CGRectMake(originX, originY, contentWidth, contentHeight)];
    [_typeImgView setFrame:CGRectMake((contentWidth-_typeImgWidth)/2, (contentHeight-_typeImgWidth)/2, _typeImgWidth, _typeImgWidth)];
    
    [_descLbl setFrame:CGRectMake(0, _btnWidth/2, contentWidth, contentHeight)];
    
    [_deleteBtn setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, _btnWidth)];
    [_deleteImgView setFrame:CGRectMake((_btnWidth-_imgWidth)/2, (_btnWidth-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    [self updateDeleteButton];
    [self updateTypeImage];
    [self updateInfo];
    
}

- (void) updateInfo {
    if(_img) {
        [_imgView setImage:_img];
    } else {
        if(_item) {
            if([_item isLocalPhoto]) {
                [_imgView setImage:_item.image];
            } else {
                [_imgView setImageWithURL:_item.url];
            }
        } else if(_url) {
            [_imgView setImageWithURL:_url];
        }
    }
    if(_desc) {
        [_descLbl setText:_desc];
    }
}

//根据属性设置编辑状态
- (void) updateDeleteButton {
    if(_editable) {
        [_deleteBtn setHidden:NO];
    } else {
        [_deleteBtn setHidden:YES];
    }
}

//根据类型更新相应icon
- (void) updateTypeImage {
    [_typeImgView setHidden:YES];
    if(_item) {
        switch (_item.origin) {
            case PHOTO_ORIGIN_VIDEO:
                [_typeImgView setImage:[[FMTheme getInstance] getImageByName:@"video_icon"]];
                [_typeImgView setHidden:NO];
                break;
                
            default:
                break;
        }
    }
}

- (void) setEditable:(BOOL)editable {
    _editable = editable;
    [self updateDeleteButton];
}

- (void) setInfoWithImage:(UIImage *) img {
    _img = img;
    _url = nil;
    [_imgView setHidden:NO];
    [_descLbl setHidden:YES];
    [self updateInfo];
}
- (void) setInfoWithPhotoItem:(PhotoItem *) item {
    _img = nil;
    _url = nil;
    _item = item;
    [_imgView setHidden:NO];
    [_descLbl setHidden:YES];
    [self updateInfo];
}
- (void) setInfoWithUrl:(NSURL *) url {
    _url = url;
    _img = nil;
    [_imgView setHidden:NO];
    [_descLbl setHidden:YES];
    [self updateInfo];
}
- (void) setInfoWithText:(NSString *) text {
    _desc = text;
    [_imgView setHidden:YES];
    [_descLbl setHidden:NO];
    [self updateInfo];
}

- (void) onClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:nil];
    }
}


- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    if(!_listener) {
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicked:)];
        [self addGestureRecognizer:tapGesture];
    }
    _listener = listener;
    
}

- (void) onDeleteButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_deleteBtn];
    }
}

@end
