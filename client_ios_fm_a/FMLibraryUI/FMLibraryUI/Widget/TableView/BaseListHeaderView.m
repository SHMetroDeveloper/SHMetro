//
//  BaseListHeaderView.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 15/5/4.
//  Copyright (c) 2015年 flynn. All rights reserved.
//

#import "BaseListHeaderView.h"
#import "FMTheme.h"
#import "FMUtils.h"

@interface BaseListHeaderView ()

@property (readwrite, nonatomic, strong) NSString * name;  //名称
@property (readwrite, nonatomic, strong) NSString * desc;  //说明
@property (readwrite, nonatomic, strong) UIImage * image;   //右侧图标


@property (readwrite, nonatomic, strong) UILabel * nameLbl;
@property (readwrite, nonatomic, strong) UILabel * descLbl;
@property (readwrite, nonatomic, strong) UIImageView * imgView;

@property (readwrite, nonatomic, assign) CGFloat imgWidth;

@property (readwrite, nonatomic, strong) UIFont * nameFont;
@property (readwrite, nonatomic, strong) UIFont * descFont;
@property (readwrite, nonatomic, strong) UIColor * bgColor;

@property (readwrite, nonatomic, assign) CGFloat paddingLeft;
@property (readwrite, nonatomic, assign) CGFloat paddingRight;

@property (readwrite, nonatomic, assign) BOOL isInited;

@property (readwrite, nonatomic, weak) id<OnListSectionHeaderClickListener> listener;


@end

@implementation BaseListHeaderView

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initSettings];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self initSettings];
    }
    return self;
}

- (void) initSettings {
    if(!_isInited) {
        _isInited = YES;
        if(!_nameFont) {
            _nameFont  = [UIFont fontWithName:@"Helvetica" size:14];
            
        }
        if(!_descFont) {
            _descFont  = [UIFont fontWithName:@"Helvetica" size:12];
        }
        _imgWidth = 32;
        _nameLbl = [[UILabel alloc] init];
        _descLbl = [[UILabel alloc] init];
        _imgView = [[UIImageView alloc] init];
        [self updateSubViews];
        
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_WHITE];
        _nameLbl.font = _nameFont;
        _nameLbl.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_TEXT];
        _descLbl.font = _descFont;
        
        [self addSubview:_nameLbl];
        [self addSubview:_descLbl];
        [self addSubview:_imgView];
        
        [self addTarget:self action:@selector(onHeaderClicked) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateSubViews];
}

- (void) updateSubViews {
    if(_bgColor) {
        self.backgroundColor = _bgColor;
    } else {
        self.backgroundColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L9];
    }
    if(!_nameFont) {
        _nameFont  = [UIFont fontWithName:@"Helvetica" size:14];
        _nameLbl.font = _nameFont;
    }
    _descLbl.font = _descFont;
    CGRect frame = self.frame;
    
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    _imgWidth = 32;
    
    CGFloat nameWidth = [FMUtils widthForString:_nameLbl value:_name];
    
    [_nameLbl setFrame:CGRectMake(_paddingLeft, 0, nameWidth, height)];
    if(_desc) {
        [_descLbl setFrame:CGRectMake(_paddingLeft + nameWidth, 0, width - _paddingLeft - _paddingRight - nameWidth - _imgWidth, height)];
        [_descLbl setHidden:NO];
    } else {
        [_descLbl setHidden:YES];
    }
    
    [_imgView setFrame:CGRectMake(width-_paddingRight-_imgWidth, (height-_imgWidth)/2, _imgWidth, _imgWidth)];
    
    [self updateImage];
    
    [self updateInfo];
}

- (void) setInfoWithName:(NSString*) name
                   image:(UIImage*) rightImage {
    _name = name;
    _image = rightImage;
    [self updateSubViews];
}

- (void) setInfoWithName:(NSString*) name
                    desc:(NSString *) desc
                   image:(UIImage*) rightImage {
    _name = name;
    _desc = desc;
    _image = rightImage;
    [self updateSubViews];
}

- (void) updateInfo {
    _nameLbl.text = _name;
    if(_desc) {
        _descLbl.text = [[NSString alloc] initWithFormat:@"(%@)", _desc];
    }
    [self updateImage];
}
- (void) updateImage {
    if(_image) {
        [_imgView setImage:_image];
        [_imgView setHidden:NO];
    } else {
        [_imgView setHidden:YES];
    }
    
}

- (void) setOnListSectionHeaderClickListener:(id<OnListSectionHeaderClickListener>) listener {
    _listener = listener;
}

- (void) onHeaderClicked {
    [self updateImage];
    if(_listener) {
        [_listener onListSectionHeaderClick:self];
    }
}


- (void) setFont:(UIFont*) font {
    _nameFont = font;
    _nameLbl.font = _nameFont;
    [self updateSubViews];
}

- (void) setHeaderBackgroundColor:(UIColor *) bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void) setPaddingLeft:(CGFloat) left right:(CGFloat) right {
    _paddingLeft = left;
    _paddingRight = right;
    [self updateSubViews];
}

@end
